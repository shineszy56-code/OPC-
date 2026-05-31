# OPC Assistant Workspace

This repository contains the OPC assistant prototype workspace.

The product architecture document is kept in:

- `OPC助手 技术选型与框架设计文档 v2.0.md`

## Projects

- `stream-project-management/` - Flutter app for local-first project and task management.
- `cloudflare-edge/` - Cloudflare Worker relay for temporary share, sync, file, log, and KB APIs.
- `web-collaboration/` - static browser collaboration client prototype.
- `stream-project-management-rn-backup/` - archived React Native / Expo backup prototype.

## Required Toolchain

The current local setup uses:

- Flutter 3.44.0 / Dart 3.12.0
- Node 26 / npm 11
- OpenJDK 26
- Android SDK 36
- CocoaPods 1.16
- Wrangler 4.95
- GitHub CLI 2.93

After opening a new shell, load the configured paths:

```sh
source ~/.zshrc
```

## Flutter App

```sh
cd stream-project-management
flutter pub get
dart analyze
flutter test
flutter build apk --debug
```

Current known state:

- Android and Chrome toolchains are installed.
- Android debug APK builds successfully.
- Full Xcode is still required for iOS/macOS builds.
- `flutter test` passes, but service/repository tests that need the native `sqflite_sqlcipher` plugin are currently skipped.
- `dart analyze` still reports existing lint and cleanup issues that should be triaged before feature work.

Install Xcode manually from the App Store or Apple Developer, then run:

```sh
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

## Cloudflare Worker

```sh
cd cloudflare-edge
npm install
npm run dev
```

Before deploy, log in and configure Cloudflare resources:

```sh
wrangler login
wrangler kv namespace create AI_OPC_SHARE
wrangler kv namespace create AI_OPC_SYNC
wrangler r2 bucket create opc-files
wrangler r2 bucket create opc-kb
```

Then fill the generated IDs in `cloudflare-edge/wrangler.toml`.

Local secret examples are documented in:

- `cloudflare-edge/.dev.vars.example`
- `stream-project-management/.env.example`

## React Native Backup

```sh
cd stream-project-management-rn-backup
npm install
npm run start
```

This directory is retained as a backup prototype, not the primary implementation.

## Git

The repository tracks `main` on:

```text
git@github.com:shineszy56-code/OPC-.git
```

Large generated directories are intentionally ignored, including `node_modules/`, Flutter `build/`, `.dart_tool/`, local env files, and local assistant settings.
