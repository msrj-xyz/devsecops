# Java API - devsecops example

Spring Boot sample application for CI/CD demos.

Run locally with Maven:

```bash
mvn spring-boot:run
```

Build and run jar:

```bash
mvn -DskipTests package
java -jar target/java-api-1.0.0.jar
```

Docker:

```bash
docker build -t devsecops-java-api .
docker run -p 8080:8080 devsecops-java-api
```
