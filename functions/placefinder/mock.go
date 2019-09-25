package placefinder

import (
	"encoding/json"
	"log"
	"net/http"

	"googlemaps.github.io/maps"
)

// PlaceFinderMock returns a static list of places instead of doing a request to the Google Maps API.
func PlaceFinderMock(w http.ResponseWriter, r *http.Request) {
	places := []*place{
		{
			Distance: 5,
			Location: maps.LatLng{Lat: 53.5699641, Lng: 9.9437931},
			Name:     "Tim Burrito's",
			PlaceID:  "KhIJ181I6GmPsUcRadihR8bA6Qt",
			Rating:   4.9,
		},
		{
			Distance: 21,
			Location: maps.LatLng{Lat: 53.5699651, Lng: 9.9437929},
			Name:     "Frau Max",
			PlaceID:  "KhIJ181I6GmPsUcRadihR8bA6Qt",
			Rating:   4.3,
		},
	}
	resp, err := json.Marshal(response{places})
	if err != nil {
		log.Fatalf("failed to marshal: %s", err)
	}
	w.WriteHeader(http.StatusOK)
	w.Write(resp)
}
