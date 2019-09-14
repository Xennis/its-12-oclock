package placefinder

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"mime"
	"net/http"
	"os"
	"strings"

	"googlemaps.github.io/maps"
)

const (
	envMapsAPIKey = "MAPS_API_KEY"
)

type place struct {
	Name    string `json:"name"`
	PlaceID string `json:"place_id"`
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

func hasContentType(r *http.Request, mimetype string) bool {
	ct := r.Header.Get("Content-type")
	if ct == "" {
		return mimetype == "application/octet-stream"
	}
	for _, v := range strings.Split(ct, ",") {
		t, _, err := mime.ParseMediaType(v)
		if err != nil {
			log.Printf("parse media type: %s", err)
			break
		}
		if t == mimetype {
			return true
		}
	}
	return false
}

func parseRequest(r *http.Request) (*maps.LatLng, error) {
	// NOTE: The returned errors are returned to the caller. Keep them generic!
	if r.Method != http.MethodPost {
		log.Printf("invalid method %s", r.Method)
		return nil, errors.New("invalid method")
	}
	if hasContentType(r, "application/json") != true {
		return nil, errors.New("invalid content type")
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
	resp, err := json.Marshal(response{places})
	if err != nil {
		log.Printf("failed to marshal: %s", err)
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"error": "internal server error"}`))
		return
	}
	w.WriteHeader(http.StatusOK)
	w.Write(resp)
}
