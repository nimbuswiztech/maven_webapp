FROM maven:3.8.8-eclipse-temurin-8 AS build

WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -B

FROM tomcat:9.0-jre8-temurin

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /build/target/demo.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
