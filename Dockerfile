FROM golang:1.27-alpine AS builder

WORKDIR /app
COPY go.mod ./
COPY main.go ./
RUN CGO_ENABLED=0 go build -o myapp main.go

FROM scratch

WORKDIR /app
COPY --from=builder /app/myapp .

EXPOSE 8080
CMD ["./myapp"]
