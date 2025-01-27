# Simple 5E - D&D 5E Character Manager

A Flutter application for managing Dungeons & Dragons 5th Edition characters. This app provides an intuitive interface for tracking character stats, spells, and other important character information.

## Features

- Character Sheet Management
  - Basic character information
  - Ability scores and modifiers
  - HP and temporary HP tracking
  - Custom stat tracking
  - Character image support

- Spellbook Management
  - Spell browsing and filtering
  - Add/remove spells from character spellbooks
  - Spell details including casting time, range, and components
  - Search functionality
  - Class-based spell filtering

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository
```bash
git clone https://github.com/scott-the-programmer/titan.git
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

### Database Setup

The app uses SQLite for local storage. The database will be automatically initialized on first run.

## Testing

Run the tests using:
```bash
flutter test
```

## Project Structure

```
lib/
├── data/           # Data layer (repositories, database)
├── features/       # Feature-based modules
│   ├── home/       # Character sheet
│   ├── spellbook/  # Spell management
│   └── stats/      # Detailed statistics
├── models/         # Data models
└── providers/      # State management
```

## Built With

- [Flutter](https://flutter.dev/) - UI framework
- [Riverpod](https://riverpod.dev/) - State management
- [SQLite](https://www.sqlite.org/) - Local database
- [Material Design](https://material.io/) - Design system

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- D&D 5E SRD for spell data
- Flutter community for various packages and inspiration
