package placefinder

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"math"
	"net/http"
	"os"

	"googlemaps.github.io/maps"
)

const (
	envMapsAPIKey      = "MAPS_API_KEY"
	earthRadiusInMeter = 6378100.0
)

type place struct {
	Distance int         `json:"distance"`
	Location maps.LatLng `json:"location"`
	Name     string      `json:"name"`
	PlaceID  string      `json:"place_id"`
	Rating   float32     `json:"rating"`
}

type app struct {
	MapsAPIKey string
}

func distance(a *maps.LatLng, b *maps.LatLng) int {
	// haversin(θ) function
	hsin := func(theta float64) float64 {
		return math.Pow(math.Sin(theta/2), 2)
	}
	degress := func(v float64) float64 {
		return v * math.Pi / 180
	}

	lat1 := degress(a.Lat)
	lng1 := degress(a.Lng)
	lat2 := degress(b.Lat)
	lng2 := degress(b.Lng)
	h := hsin(lat2-lat1) + math.Cos(lat1)*math.Cos(lat2)*hsin(lng2-lng1)
	d := 2 * earthRadiusInMeter * math.Asin(math.Sqrt(h))
	return int(math.RoundToEven(d))
}

func (a *app) nearbySearch(ctx context.Context, location *maps.LatLng) ([]*place, error) {
	c, err := maps.NewClient(maps.WithAPIKey(a.MapsAPIKey))
	if err != nil {
		return nil, fmt.Errorf("create client: %s", err)
	}
	resp, err := c.NearbySearch(ctx, &maps.NearbySearchRequest{
		Location: location,
		OpenNow:  true,
		RankBy:   maps.RankByDistance,
		Type:     maps.PlaceTypeRestaurant,
	})
	if err != nil {
		return nil, fmt.Errorf("nearby search: %s", err)
	}
	res := make([]*place, len(resp.Results))
	for i := range resp.Results {
		p := &resp.Results[i]
		res[i] = &place{
			Distance: distance(location, &p.Geometry.Location),
			Location: p.Geometry.Location,
			Name:     p.Name,
			PlaceID:  p.PlaceID,
			Rating:   p.Rating,
		}
	}
	return res, nil
}

type response struct {
	Results []*place `json:"results"`
}

func newApp(getenv func(string) string) (*app, error) {
	mapsAPIKey := getenv(envMapsAPIKey)
	if mapsAPIKey == "" {
		return nil, fmt.Errorf("env %s not set", envMapsAPIKey)
	}
	return &app{MapsAPIKey: mapsAPIKey}, nil
}

func parseRequest(r *http.Request) (*maps.LatLng, error) {
	// NOTE: The returned errors are returned to the caller. Keep them generic!
	if r.Method != http.MethodPost {
		log.Printf("invalid method %s", r.Method)
		return nil, errors.New("invalid method")
	}
	var location maps.LatLng
	if err := json.NewDecoder(r.Body).Decode(&location); err != nil {
		log.Printf("invalid body: %s", err)
		return nil, errors.New("invalid body")
	}
	return &location, nil
}

// PlaceFinder finds restaurant places.
func PlaceFinder(w http.ResponseWriter, r *http.Request) {
	location, err := parseRequest(r)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(fmt.Sprintf(`{"error": "%s"}`, err)))
		return
	}
	app, err := newApp(os.Getenv)
	if err != nil {
		log.Fatalf("failed to create app: %s", err)
	}
	places, err := app.nearbySearch(r.Context(), location)
	if err != nil {
		log.Fatalf("failed to find places: %s", err)
	}
	resp, err := json.Marshal(response{places})
	if err != nil {
		log.Fatalf("failed to marshal: %s", err)
	}
	w.WriteHeader(http.StatusOK)
	w.Write(resp)
}
