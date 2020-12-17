FROM openjdk:8-jdk-alpine as exploder
WORKDIR /workspace/app

ARG JAR_FILE
COPY ${JAR_FILE} app.jar

RUN mkdir contents && (cd contents; jar -xf ../app.jar)

# Main Container
FROM gcr.io/distroless/java:8

ARG LAYERS=/workspace/app/contents

COPY --from=exploder ${LAYERS}/BOOT-INF/lib /app/lib
COPY --from=exploder ${LAYERS}/META-INF /app/META-INF
COPY --from=exploder ${LAYERS}/org /app/org
COPY --from=exploder ${LAYERS}/BOOT-INF/classes /app

ENTRYPOINT ["java", "-cp","app:app/lib/*", "org.springframework.boot.loader.JarLauncher"]