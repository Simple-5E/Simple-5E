# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

This is a Flutter app for D&D 5E character management. Use the Makefile for most operations:

- `make` or `make all` - Clean, install dependencies, build, and test
- `make install-deps` - Install Flutter dependencies
- `make test` - Run unit and widget tests
- `make analyze` - Run static analysis
- `make format` - Format Dart code
- `make quality` - Run format, analyze, and coverage tests
- `make mocks` - Generate mock objects for testing
- `make run-dev` - Run app in debug mode
- `make build-android` - Build release APK

For single test files: `flutter test test/path/to/test_file.dart`

## Architecture Overview

**State Management**: Riverpod throughout the application
- Uses `StateNotifierProvider` for complex state (character creation, data management)
- `FutureProvider` for async operations (database queries)
- `StateProvider` for simple state (theme, navigation)

**Data Layer**: Repository pattern with SQLite database
- Each domain has its own repository (CharacterRepository, SpellRepository, etc.)
- Database initialization handled in `DatabaseInitializer.instance`
- Asset-based content loaded from JSON files (races, spells, classes)

**Feature Organization**: Feature-based folder structure under `lib/features/`
- `create_character/` - Multi-step character creation flow
- `home/` - Main app navigation and character sheet
- `spellbook/` - Spell management and selection
- `manage_data/` - Custom content creation (races, classes, spells)

**Models**: Immutable data classes in `lib/models/`
- Core D&D entities: Character, Race, CharacterClass, Spell, SpellSlot, Note
- JSON serialization for asset-loaded data

**Providers**: Riverpod providers in `lib/providers/`
- Character state management and CRUD operations
- Custom content providers for user-created races/classes/spells
- Theme management

## Key Dependencies

- `flutter_riverpod` - State management
- `sqflite` - Local SQLite database
- `shared_preferences` - Settings storage
- `mockito` + `build_runner` - Testing framework

## Testing Patterns

- Widget tests for UI components using `WidgetTester`
- Mock repositories using Mockito for isolated testing
- Test files mirror lib/ structure
- Use `flutter test --coverage` for coverage reports

## Asset Structure

- `assets/races/` - Race JSON definitions and portrait images
- `assets/classes/` - Class portrait images  
- `assets/spells.json` - Complete spell database
- All images use WebP format for optimization

## Code Patterns

- Use single quotes for strings (enforced by linter)
- Immutable models with copyWith methods
- Repository singletons accessed via `Repository.instance`
- Providers defined in separate files and exported through `providers.dart`
- Feature-specific widgets kept within feature folders