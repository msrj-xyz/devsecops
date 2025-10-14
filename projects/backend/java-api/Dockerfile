FROM maven:3.9.4-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -q -DskipTests package

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=builder /app/target/java-api-1.0.0.jar ./java-api.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/java-api.jar"]
