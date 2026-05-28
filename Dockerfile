FROM eclipse-temurin:17-jdk-jammy AS base
# sets the working  directory for any RUN, CMD, ENTRYPOINT, COPY, ADD commands
WORKDIR /app
#The pom.xml (Project Object Model) file is the core configuration file for Maven projects.
# mvnw allows to run the Maven project without having Maven installed and present on the path
COPY pom.xml mvnw ./
#The .mvn directory contains configuration files related to the Maven Wrapper.
COPY .mvn/ .mvn
# src should be copied so we can run commands against the java code
COPY src/ ./src
# RUN will execute any commands to create a new layer on top of the current image.
# The added layer is used in the next step in the Dockerfile
# here a build artifact of app is created (packaged in a jar file)
# the mvnw (Maven Wrapper) script enables you to run Maven commands without requiring users to install Maven globally on their machines.
RUN ./mvnw package -Dmaven.test.skip.test
FROM eclipse-temurin:17-jre-jammy AS final
COPY --from=base /app/target/spring-petclinic-*.jar /spring-petclinic.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/spring-petclinic.jar"]