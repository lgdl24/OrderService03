FROM eclipse-temurin:25-jdk

WORKDIR /app

COPY target/OrderService03-0.0.1-SNAPSHOT.jar app.jar

CMD ["java", "-jar", "app.jar"]