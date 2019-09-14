# PlaceFinder Google Cloud function

### Request

```sh
curl "https://europe-west1-${GCP_PROJECT}.cloudfunctions.net/PlaceFinder" \
    --request POST \
    --header 'Content-Type: application/json' \
    --data '{"lat":53.5599,"lng":9.9638}'
```

### Deploy

Run `make deploy`.

### Setup

* Enable the Google APIs `cloudfunctions.googleapis.com` and `places-backend.googleapis.com`.
* Deploy the function including the parameter `--set-env-vars MAPS_API_KEY=<API-KEY-HERE>`.
