FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src

RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

ARG JAR_FILE=target/eureka-server-*.jar

COPY --from=build /app/${JAR_FILE} app.jar

EXPOSE 8761

ENTRYPOINT ["java", "-jar", "app.jar"]