# Flutter Makefile

# Variables
APP_NAME = simple5e
BUILD_NUMBER = $(shell date +%s)
ANDROID_BUILD_DIR = build/app/outputs/flutter-apk
IOS_BUILD_DIR = build/ios/ipa
ANDROID_BUNDLE_NAME = $(APP_NAME)-$(BUILD_NUMBER).apk
IOS_BUNDLE_NAME = $(APP_NAME)-$(BUILD_NUMBER).ipa

# Main targets
.PHONY: all clean setup test build publish

all: clean install-deps build test

# Development setup
.PHONY: install-deps upgrade-deps generate-pubspec-lock mocks icons setup-device
install-deps:
	@echo "📦 Installing dependencies..."
	@flutter pub get --enforce-lockfile

upgrade-deps:
	@echo "⬆️  Upgrading dependencies..."
	@flutter pub upgrade

generate-pubspec-lock:
	@echo "🔒 Generating fresh pubspec.lock..."
	@docker build -f Dockerfile.pubspec -t simple5e-pubspec-gen .
	@docker run --rm -v $(PWD):/output simple5e-pubspec-gen sh -c "cp pubspec.lock /output/"
	@echo "✅ Fresh pubspec.lock generated"

mocks:
	@echo "🤖 Generating mocks..."
	@flutter pub run build_runner build --delete-conflicting-outputs

icons:
	@echo "🎨 Generating icons..."
	@flutter pub run flutter_launcher_icons:main

setup-device:
	@echo "🔧 Setting up device..."
	@flutter doctor
	@flutter devices

# Cleaning
clean:
	@echo "🧹 Cleaning..."
	@flutter clean
	@rm -rf build/
	@rm -rf .dart_tool/

# Testing and quality
.PHONY: test coverage analyze format quality watch-tests
test:
	@echo "🧪 Running tests..."
	@flutter test

coverage:
	@echo "📊 Running tests with coverage..."
	@flutter test --coverage

analyze:
	@echo "🔍 Running static analysis..."
	@flutter analyze

format:
	@echo "✨ Formatting code..."
	@dart format lib test

quality: format analyze coverage

watch-tests:
	@echo "👀 Watching tests..."
	@flutter test --watch

# Building
.PHONY: build-android build-android-debug build-android-bundle build-ios build-web
build-android:
	@echo "📱 Building Android APK..."
	@flutter build apk --release
	@echo "✅ APK built at $(ANDROID_BUILD_DIR)/app-release.apk"

build-android-debug:
	@echo "🐛 Building Android Debug APK..."
	@flutter build apk --debug
	@echo "✅ Debug APK built at $(ANDROID_BUILD_DIR)/app-debug.apk"

build-android-bundle:
	@echo "📦 Building Android App Bundle..."
	@flutter build appbundle --release
	@echo "✅ Bundle built at build/app/outputs/bundle/release/app-release.aab"

build-ios:
	@echo "🍎 Building iOS..."
	@flutter build ios --release --no-codesign
	@echo "✅ iOS build completed"

build-web:
	@echo "🌐 Building Web..."
	@flutter build web --release
	@echo "✅ Web build completed"

# Running
.PHONY: run-dev run-prod
run-dev:
	@echo "🚀 Running in debug mode..."
	@flutter run --debug

run-prod:
	@echo "🚀 Running in release mode..."
	@flutter run --release

# Publishing
.PHONY: publish-android publish-ios
publish-android: build-android
	@echo "📤 Preparing Android release..."
	@mkdir -p releases/android
	@cp $(ANDROID_BUILD_DIR)/app-release.apk releases/android/$(ANDROID_BUNDLE_NAME)
	@echo "✅ Android release prepared at releases/android/$(ANDROID_BUNDLE_NAME)"

publish-ios: build-ios
	@echo "📤 Preparing iOS release..."
	@mkdir -p releases/ios
	@cd ios && xcodebuild -workspace Runner.xcworkspace -scheme Runner -sdk iphoneos -configuration Release archive -archivePath build/Runner.xcarchive
	@cd ios && xcodebuild -exportArchive -archivePath build/Runner.xcarchive -exportOptionsPlist exportOptions.plist -exportPath build/ios/ipa
	@cp $(IOS_BUILD_DIR)/$(APP_NAME).ipa releases/ios/$(IOS_BUNDLE_NAME)
	@echo "✅ iOS release prepared at releases/ios/$(IOS_BUNDLE_NAME)"

# Version management
.PHONY: bump-version
bump-version:
	@current=$$(git describe --tags --abbrev=0 2>/dev/null || echo "0.0.0") && \
	major=$$(echo $$current | cut -d. -f1) && \
	minor=$$(echo $$current | cut -d. -f2) && \
	patch=$$(echo $$current | cut -d. -f3) && \
	patch=$$((patch + 1)) && \
	new_tag="$$major.$$minor.$$patch" && \
	git tag -a $$new_tag -m "Release $$new_tag" && \
	echo "🏷️  Created new tag: $$new_tag"

# Documentation
.PHONY: docs
docs:
	@echo "📚 Generating documentation..."
	@dart doc .

# CI/CD
.PHONY: local-ci act-debug
local-ci:
	@echo "🔄 Running CI checks locally..."
	@act --container-architecture linux/amd64 -P self-hosted=ghcr.io/catthehacker/ubuntu:act-latest -j build-and-test

act-debug:
	@act -P self-hosted=ghcr.io/catthehacker/ubuntu:full-latest -j build-and-test \
		-s KEY_JKS="$(KEY_JKS)" \
		-s KEY_PASSWORD="$(KEY_PASSWORD)" \
		-s STORE_PASSWORD="$(STORE_PASSWORD)" \
		-s SERVICE_ACCOUNT_JSON="$(SERVICE_ACCOUNT_JSON)"

# Help
.PHONY: help
help:
	@echo "📋 Available targets:"
	@echo "Development:"
	@echo "  install-deps         - Install dependencies"
	@echo "  upgrade-deps         - Upgrade dependencies"
	@echo "  generate-pubspec-lock - Generate fresh pubspec.lock using Docker"
	@echo "  mocks               - Generate mocks"
	@echo "  icons               - Generate app icons"
	@echo "Quality:"
	@echo "  test                - Run tests"
	@echo "  coverage            - Run tests with coverage"
	@echo "  analyze             - Run static analysis"
	@echo "  format              - Format code"
	@echo "  quality             - Run all quality checks"
	@echo "Building:"
	@echo "  build-android       - Build Android APK"
	@echo "  build-ios           - Build iOS app"
	@echo "  build-web           - Build web app"
	@echo "Running:"
	@echo "  run-dev             - Run app in debug mode"
	@echo "  run-prod            - Run app in release mode"
	@echo "Publishing:"
	@echo "  publish-android     - Prepare Android release"
	@echo "  publish-ios         - Prepare iOS release"
