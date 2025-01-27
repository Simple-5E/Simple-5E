
<img src="assets/banner.jpg" style="max-width: 100%;" />


Simple 5E is a streamlined Flutter application compatible with 5E. It offers an intuitive interface for managing character stats and spells, enhancing your tabletop roleplaying experience.


## Overview

Our goal is to provide an intentionally simple, user-friendly experience for players during their adventures. Simple 5E focuses on core functionality, offering a lightweight alternative to more complex character management apps.

<p float="left" align="center">
  <img src="readme/home.png" width="130" />
  <img src="readme/character.png" width="130" />
  <img src="readme/spell_search.png" width="130" />
  <img src="readme/spellbook.png" width="130" />
</p>

### Key Features:
- Easy character stat tracking
- Intuitive spell management
- Clean, distraction-free interface

The goal is to provide an incredibly simple and slick experience for managing characters. This app will never be fully-featured, as there are plenty of other great apps that handle that. Instead, Simple-5E is angled at beginners and casual players.

## Alternative Apps

For those seeking more comprehensive tools, consider these alternatives:

* [the DND Beyond Player App](https://www.dndbeyond.com/player-app)
* [5e Spells (Android)](https://play.google.com/store/apps/details?id=com.dungeondev.a5espells&hl=en-US)
* [5e Spells (iOS)](https://apps.apple.com/us/app/spells-list-5e/id1220380339)

## Roadmap

Our development plan is divided into short-term and long-term goals to continuously improve Simple 5E.

### Short-Term Goals 🚀

- [ ] Add character notes functionality
- [ ] Implement custom race image uploads
- [ ] Enable custom class image uploads
- [ ] Expand spell list beyond default 5E spells

### Long-Term Vision 🔮

- [ ] Implement multi-device synchronization
- [ ] Develop a web application version
- [ ] Create a desktop application
- [ ] Enhance in-app theming options

💡 Have a suggestion? Feel free to [open an issue](https://github.com/Simple-5E/Simple-5E/issues/new)!

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code

## Building and Running from Source

1. Clone the repository
```bash
git clone https://github.com/Simple-5E/Simple-5E.git
```

2. Install dependencies
```bash
make
```

3. Run the app
```bash
flutter run
```

4. Running unit tests

```bash
make test
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

**Asset Management**

Assets were generated via [Replicate](https://replicate.com/) using the recraft-v3 text-to-image model. If you feel these could be improved, please modify the asset files under the assets folder and submit a PR.

**Development Process**

This pet project utilized Large Language Models (LLMs) to bootstrap many components and widgets. Claude Sonnet was exclusively used with [Continue.dev](https://www.continue.dev/) to assist in the development process.