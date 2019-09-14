package placefinder

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"

	"googlemaps.github.io/maps"
)

const (
	envMapsAPIKey = "MAPS_API_KEY"
)

type place struct {
	PlaceID string `json:"place_id"`
	Name    string `json:"name"`
}

type app struct {
	MapsAPIKey string
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
			PlaceID: p.PlaceID,
			Name:    p.Name,
		}
	}
	return res, nil
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
		return nil, errors.New("invalid method")
	}
	if r.Header.Get("Content-Type") != "application/json" {
		return nil, errors.New("invalid content type")
	}
	var location maps.LatLng
	if err := json.NewDecoder(r.Body).Decode(&location); err != nil {
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
		log.Printf("failed to create app: %s", err)
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"error": "internal server error"}`))
		return
	}
	places, err := app.nearbySearch(r.Context(), location)
	if err != nil {
		log.Printf("failed to find places: %s", err)
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"error": "internal server error"}`))
		return
	}
	resp, err := json.Marshal(places)
	if err != nil {
		log.Printf("failed to marshal: %s", err)
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"error": "internal server error"}`))
		return
	}
	w.WriteHeader(http.StatusOK)
	w.Write(resp)
}
