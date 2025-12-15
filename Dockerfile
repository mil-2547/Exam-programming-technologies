FROM alpine:latest
WORKDIR /app
COPY ./build/bin/crow_app .
CMD ["./crow_app"]