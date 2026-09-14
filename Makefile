.DEFAULT_GOAL := help

.PHONY: help build clean docker-build docker-run

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build the binary into bin/myapp
	CGO_ENABLED=0 go build -o bin/myapp main.go
	chmod +x bin/myapp

clean: ## Remove the built binary
	rm -rf bin/myapp

docker-build: ## Build the Docker image (multistage build compiles inside Docker)
	docker build -t myapp .

docker-run: docker-build ## Build the Docker image and run the container
	docker run -p 8080:8080 myapp