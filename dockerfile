# Development
FROM golang:1.20 as dev
WORKDIR /app
ENV NODE_ENV dev
COPY . .
RUN go build -o app . && ls -lh app
EXPOSE 8000
CMD ["./app"]

# Production build
FROM golang:1.20 as build
WORKDIR /app
ENV NODE_ENV production
COPY . . 
RUN go build -o app . && ls -lh app
EXPOSE 8000
CMD ["./app"]

# Final production image
FROM debian:bookworm-slim
WORKDIR /app
COPY --from=build /app/app /app/app
EXPOSE 8000
CMD ["./app"]
