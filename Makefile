# Flutter Makefile

.PHONY: clean build test coverage analyze format install-deps upgrade-deps run-dev run-prod build-android build-ios build-web publish-android publish-ios mocks

APP_NAME = simple5e
BUILD_NUMBER = $(shell date +%s)

ANDROID_BUILD_DIR = build/app/outputs/flutter-apk
IOS_BUILD_DIR = build/ios/ipa

ANDROID_BUNDLE_NAME = $(APP_NAME)-$(BUILD_NUMBER).apk
IOS_BUNDLE_NAME = $(APP_NAME)-$(BUILD_NUMBER).ipa

all: clean install-deps build test

clean:
	@echo "Cleaning..."
	@flutter clean
	@rm -rf build/
	@rm -rf .dart_tool/

install-deps:
	@echo "Installing dependencies..."
	@flutter pub get

mocks:
	@echo "Generating mocks..."
	@flutter pub run build_runner build --delete-conflicting-outputs

upgrade-deps:
	@echo "Upgrading dependencies..."
	@flutter pub upgrade

icons:
	@echo "Generating icons..."
	@flutter pub run flutter_launcher_icons:main

test:
	@echo "Running tests..."
	@flutter test

coverage:
	@echo "Running tests with coverage..."
	@flutter test --coverage

analyze:
	@echo "Running static analysis..."
	@flutter analyze

format:
	@echo "Formatting code..."
	@dart format lib test

run-dev:
	@echo "Running in debug mode..."
	@flutter run --debug

run-prod:
	@echo "Running in release mode..."
	@flutter run --release

build-android-debug:
	@echo "Building Android APK..."
	@flutter build apk --debug
	@echo "APK built at $(ANDROID_BUILD_DIR)/app-debug.apk"

build-android:
	@echo "Building Android APK..."
	@flutter build apk --release
	@echo "APK built at $(ANDROID_BUILD_DIR)/app-release.apk"

android-version:
	cd android && ./gradlew androidGitVersion

build-android-bundle:
	@echo "Building Android App Bundle..."
	@flutter build appbundle --release
	@echo "Bundle built at build/app/outputs/bundle/release/app-release.aab"

build-ios:
	@echo "Building iOS..."
	@flutter build ios --release --no-codesign
	@echo "iOS build completed"

build-web:
	@echo "Building Web..."
	@flutter build web --release
	@echo "Web build completed"

publish-android: build-android
	@echo "Preparing Android release..."
	@mkdir -p releases/android
	@cp $(ANDROID_BUILD_DIR)/app-release.apk releases/android/$(ANDROID_BUNDLE_NAME)
	@echo "Android release prepared at releases/android/$(ANDROID_BUNDLE_NAME)"

publish-ios: build-ios
	@echo "Preparing iOS release..."
	@mkdir -p releases/ios
	@cd ios && xcodebuild -workspace Runner.xcworkspace -scheme Runner -sdk iphoneos -configuration Release archive -archivePath build/Runner.xcarchive
	@cd ios && xcodebuild -exportArchive -archivePath build/Runner.xcarchive -exportOptionsPlist exportOptions.plist -exportPath build/ios/ipa
	@cp $(IOS_BUILD_DIR)/$(APP_NAME).ipa releases/ios/$(IOS_BUNDLE_NAME)
	@echo "iOS release prepared at releases/ios/$(IOS_BUNDLE_NAME)"

docs:
	@echo "Generating documentation..."
	@dart doc .

quality: format analyze coverage

setup-device:
	@echo "Setting up device..."
	@flutter doctor
	@flutter devices

watch-tests:
	@echo "Watching tests..."
	@flutter test --watch

local-ci:
	@echo "Running CI checks locally..."
	@act -P ubuntu-latest=ghcr.io/catthehacker/ubuntu:act-latest -j build-and-test

bump-version:
	@current=$$(git describe --tags --abbrev=0 2>/dev/null || echo "0.0.0") && \
	major=$$(echo $$current | cut -d. -f1) && \
	minor=$$(echo $$current | cut -d. -f2) && \
	patch=$$(echo $$current | cut -d. -f3) && \
	patch=$$((patch + 1)) && \
	new_tag="$$major.$$minor.$$patch" && \
	git tag -a $$new_tag -m "release_added" && \
	echo "Created new tag: $$new_tag"

.PHONY: act-debug 
act-debug:
	act -P ubuntu-latest=ghcr.io/catthehacker/ubuntu:full-latest -j build-and-test
		-s KEY_JKS="$(KEY_JKS)" \
		-s KEY_PASSWORD="$(KEY_PASSWORD)" \
		-s STORE_PASSWORD="$(STORE_PASSWORD)" \
		-s SERVICE_ACCOUNT_JSON="$(SERVICE_ACCOUNT_JSON)"

help:
	@echo "Available targets:"
	@echo "  clean                - Clean build directories"
	@echo "  install-deps         - Install dependencies"
	@echo "  upgrade-deps         - Upgrade dependencies"
	@echo "  test                 - Run tests"
	@echo "  coverage             - Run tests with coverage"
	@echo "  analyze              - Run static analysis"
	@echo "  format               - Format code"
	@echo "  run-dev              - Run app in debug mode"
	@echo "  run-prod             - Run app in release mode"
	@echo "  build-android        - Build Android APK"
	@echo "  build-android-bundle - Build Android App Bundle"
	@echo "  build-ios            - Build iOS app"
	@echo "  build-web            - Build web app"
	@echo "  publish-android      - Prepare Android release"
	@echo "  publish-ios          - Prepare iOS release"
	@echo "  docs                 - Generate documentation"
	@echo "  quality              - Run all quality checks"
	@echo "  setup-device         - Setup new device"
	@echo "  watch-tests          - Watch tests"