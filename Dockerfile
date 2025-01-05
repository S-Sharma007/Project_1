
FROM openjdk:17

# Add the JAR file to the container
ADD jarstaging/com/valaxy/demo-workshop/2.1.4/demo-workshop-2.1.4.jar ttrend.jar


# Set the entry point to run the JAR
ENTRYPOINT ["java", "-jar", "ttrend.jar"]
