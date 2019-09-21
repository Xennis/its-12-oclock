package placefinder

import (
	"testing"

	"googlemaps.github.io/maps"
)

func TestDistance(t *testing.T) {
	tests := []struct {
		name string
		a    maps.LatLng
		b    maps.LatLng
		want int
	}{
		{
			name: "empty",
		},
		{
			name: "zero",
			a:    maps.LatLng{Lat: 0, Lng: 0},
			b:    maps.LatLng{Lat: 0, Lng: 0},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := distance(tt.a, tt.b); got != tt.want {
				t.Errorf("distance() = %d, want %d", got, tt.want)
			}
		})
	}
}
