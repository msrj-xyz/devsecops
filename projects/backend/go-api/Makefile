.PHONY: build test docker run clean

build:
	go build -o go-api

test:
	go test ./...

docker:
	docker build -t devsecops-go-api .

run:
	PORT=8080 ./go-api

clean:
	-rm -f go-api
