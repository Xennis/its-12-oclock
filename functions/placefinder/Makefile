GCP_REGION = europe-west1

deploy:
	gcloud functions deploy PlaceFinder \
		--runtime go111 \
		--trigger-http \
		--region $(GCP_REGION)
