# Development
FROM golang:1.20 as dev
WORKDIR /app
ENV NODE_ENV dev
COPY . .
RUN go build -o app . && ls -lh app
RUN DD_AGENT_MAJOR_VERSION=7 \
    DD_API_KEY=${{ secrets.DD_API_KEY }} \
    DD_AGENT_VERSION=latest \
    bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"
EXPOSE 8000
CMD ["./app"]


# Production build
FROM golang:1.20 as build
WORKDIR /app
ENV NODE_ENV production
COPY . . 
RUN go build -o app . && ls -lh app
RUN DD_AGENT_MAJOR_VERSION=7 \
    DD_API_KEY=${DD_API_KEY} \
    DD_AGENT_VERSION=latest \
    bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"
EXPOSE 8000
CMD ["./app"]


# Final production image
FROM gcr.io/distroless/base-debian10
WORKDIR /app
COPY --from=build /app/app /app/app
COPY --from=build /etc/datadog-agent /etc/datadog-agent
COPY --from=build /opt/datadog-agent /opt/datadog-agent
COPY --from=build /var/log/datadog /var/log/datadog
EXPOSE 8000
CMD ["./app"]
