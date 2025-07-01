#!/bin/bash

set -e

echo "Building Docker image for pubspec.lock generation..."
docker build --platform linux/amd64 -f Dockerfile.pubspec -t flutter-pubspec-gen .

echo "Running container to generate pubspec.lock..."
CONTAINER_ID=$(docker run -d flutter-pubspec-gen sleep 10)

echo "Copying pubspec.lock from container..."
docker cp "$CONTAINER_ID:/app/pubspec.lock" ./pubspec.lock

echo "Cleaning up container..."
docker rm "$CONTAINER_ID"

echo "pubspec.lock generated successfully!"
ls -la pubspec.lock