package placefinder

import (
	"log"
	"net/http"
	"strings"

	firebase "firebase.google.com/go"
)

func authorize(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		tokenSplit := strings.Split(r.Header.Get("Authorization"), "Bearer")
		if len(tokenSplit) != 2 {
			w.WriteHeader(http.StatusForbidden)
			return
		}
		token := strings.TrimSpace(tokenSplit[1])
		app, err := firebase.NewApp(ctx, &firebase.Config{})
		if err != nil {
			log.Fatalf("failed to create firebase app: %s", err)
		}
		client, err := app.Auth(ctx)
		if err != nil {
			log.Fatalf("failed to create firebase client: %s", err)
		}
		_, err = client.VerifyIDToken(ctx, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			return
		}
		next.ServeHTTP(w, r)
	}
}
