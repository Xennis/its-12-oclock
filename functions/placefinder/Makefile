GCP_REGION = europe-west1

deploy:
	gcloud functions deploy PlaceFinder \
		--runtime go111 \
		--trigger-http \
		--region $(GCP_REGION)

deployMock:
	gcloud functions deploy PlaceFinderMock \
		--runtime go111 \
		--trigger-http \
		--region $(GCP_REGION)
