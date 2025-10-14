.PHONY: build test docker run clean

build:
	mvn -DskipTests package

test:
	mvn test

docker:
	docker build -t devsecops-java-api .

run:
	java -jar target/java-api-1.0.0.jar

clean:
	mvn clean
