# Little Lemon — iOS Capstone Project

A self-contained SwiftUI restaurant app built for the Meta iOS Developer Capstone peer-review checklist.

## What's included

- Three-page onboarding with **Next**, validation, and persistent profile details.
- Home screen with **header, hero, search, menu breakdown, and food menu list**.
- Online menu data from Meta's public JSON endpoint, with **offline bundled menu** and local cache.
- Search and selectable categories that really filter the dish list.
- Profile editing saved automatically using **SwiftUI `@AppStorage` / `UserDefaults`**.
- Confirmation-based **Log out** that clears all user profile fields and returns to onboarding.
- Native stack navigation, dish details, and Back button.
- **Wireframe_Home.jpg** (submission asset), **Wireframe_Home.svg** (editable vector), design preview and checklist.

## Open the app

1. Use a **Mac with Xcode** (iOS 16+ deployment target).
2. Unzip the project. Open `LittleLemon.xcodeproj` in Xcode.
3. Choose an iPhone Simulator; set a personal Development Team under Signing & Capabilities if required for a device.
4. Press **Run** (⌘R). On first launch, the 3-page onboarding appears.
5. Complete name and email, browse the menu, test category chips and search, open Profile, edit and Save, restart, and Log out.

**No CocoaPods, external Swift packages, API keys, or paid services are required.** Internet connectivity improves dish photos and refreshes the menu; bundled data works offline.

## Project layout

- `LittleLemon/App`: app entry point.
- `LittleLemon/Views`: onboarding, home, profile, and dish details.
- `LittleLemon/Models`: JSON model and filter logic.
- `LittleLemon/Services`: online/offline menu loader and cache.
- `LittleLemon/Shared`: reusable colors and UI.
- `LittleLemon/Resources/menu.json`: offline menu data.
- `LittleLemon/Assets.xcassets`: original app icon and locally generated food image.

## Wireframe

`Wireframe_Home.jpg` can be submitted directly as the wireframe JPG. If a Figma-authored export is explicitly required, import the included `Wireframe_Home.svg` into Figma and export the frame as JPG.

## Important quality note

Source code and file structure have been created and statically checked in a Linux environment. **Xcode itself is not available here, so an actual iOS Simulator build and runtime verification are still required before claiming that all checks passed.**

## Attribution / demo

The restaurant name is used for an educational course demo. Menu feed: `https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json`. The hero food artwork and icon were generated for this project. This is not an official Little Lemon app.

## One-command publication (GitHub CLI)

You can publish this entire folder with `PUBLISH_GITHUB_WINDOWS.ps1` (Windows PowerShell) or `PUBLISH_GITHUB_MAC.sh` (macOS). **You must sign in to your own GitHub account**; the script creates a public repo and then prints the real Coursera submission URL.
