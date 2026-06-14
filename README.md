# OpenChat

A local-first ChatGPT alternative powered by **OpenRouter**. Bring your own
OpenRouter API key — every conversation, message, and artifact stays on your
device. No backend, no account, no telemetry.

🌐 **Live (web):** https://test.pascalparent.ca/chat/
📱 **Android APK:** https://test.pascalparent.ca/chat/openchat.apk

## Features

- 🔑 Bring-your-own OpenRouter key, stored with `flutter_secure_storage`
- 💬 Streaming chat (token-by-token) with markdown, code highlighting & tables
- 🧠 In-chat model selector with search; per-message model label
- 🧩 Artifacts panel (code / markdown / html / json / table / document)
- 🗂️ Conversations: create, rename, duplicate, archive, delete, search
- 🎨 Custom dark design system (no default Material look)
- 📱 Responsive — sidebar on desktop, drawer + sheets on mobile
- 🛠️ Extensible tools system (web search / image / pdf stubs)
- ⚙️ Settings: theme, temperature/top-p/max-tokens, data export/import/wipe
- 📦 Single Flutter codebase: Android, iOS, Web

## Architecture

Clean architecture with strict layering:

```
lib/
├── domain/        # models, repository interfaces, use cases
├── data/          # local (Hive) + remote (OpenRouter) + repository impls
├── services/      # OpenRouter API client, SSE parser, secure storage
├── artifacts/     # artifact parser, types, renderers, panel
├── tools/         # Tool interface, registry, executor, definitions
├── presentation/  # screens, widgets, providers (Riverpod), themes
└── utils/
```

- **State:** Riverpod · **Routing:** GoRouter · **Storage:** Hive +
  Flutter Secure Storage · **Models:** Freezed / json_serializable

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run            # mobile / desktop
flutter run -d chrome  # web
```

On first launch, paste your [OpenRouter API key](https://openrouter.ai/keys).

## Build & deploy

```bash
# Web (served under /chat/)
flutter build web --release --base-href /chat/ --pwa-strategy=none

# Android
flutter build apk --release
```

`deploy.sh` builds the web bundle, copies it (and the APK if present) to the
server, and cache-busts the entrypoint scripts so new deploys are picked up
immediately.

## License

Personal project — all rights reserved unless stated otherwise.
