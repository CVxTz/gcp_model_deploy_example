flake_errors:
	poetry run flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics

flake_line:
	poetry run flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics

run_app:
	poetry run uvicorn --app-dir ner_app app:app --host 0.0.0.0 --port 8080 --workers 2

VERSION := $(shell grep -m 1 version pyproject.toml | tr -s ' ' | tr -d '"' | tr -d "'" | cut -d' ' -f3)
APP_NAME := ner_app

build_docker:
	docker build . -t ner_app:latest -t ${APP_NAME}:${VERSION}

run_docker:
	docker run -p 5000:5000 -i -t ${APP_NAME}:${VERSION}

PROJECT_ID := $(shell gcloud config get-value project)
HOSTNAME := eu.gcr.io
GCR_TAG := ${HOSTNAME}/${PROJECT_ID}/${IMAGE}:${VERSION}

run_grc_build:
	echo "${GCR_TAG}"
	gcloud builds submit --tag ${GCR_TAG} -q

cloud_run_deploy:
	gcloud run deploy ner-app --image=${GCR_TAG} --max-instances=2 --min-instances=0 --port=5000 --allow-unauthenticated --region=europe-west1 --memory=2Gi -q

