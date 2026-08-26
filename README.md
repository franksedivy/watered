# Watered
Watered is an iOS hydration tracker built as a learning project in Swift and SwiftUI. I am guided by Codex, but I actively write and understand the code myself. The point is not to let Codex build the app for me, but to use Codex as a tutor: guiding, explaining, checking documentation, and helping keep tests aligned with the latest code.

The current focus is the core model layer: representing drinks, calculating intake, and keeping the code clean before building out the UI.

TLDR; Hydration tracker, learning project, model-first SwiftUI app.

## Current Status
Watered has a working core hydration model and an early Today screen UI.
Sample data only.
No persistence / HealthKit / Watch yet.

## Getting Started
1. Simply open the project in Xcode, no special setup required yet.
2. Use the main Watered app scheme to build and run the app.
3. Tests run as part of the Test build for now.

## Project Principles
Model-first, small commits, tests, clean separation of concerns.

## Documentation
Link to Wiki:
- [Architecture Overview](https://github.com/franksedivy/watered/wiki/Architecture-Overview)
- [Decision Log](https://github.com/franksedivy/watered/wiki/Decision-Log)
- [Hydration Model](https://github.com/franksedivy/watered/wiki/Hydration-Model)
- [Research Notes](https://github.com/franksedivy/watered/wiki/Research-Notes)
- [Testing Approach](https://github.com/franksedivy/watered/wiki/Testing-Approach)
You can also read about the overall progress in my [Design Engineer's diary](https://github.com/franksedivy/watered/wiki/Design-Engineer's-Diary).

## Current Milestones & Releases
- `0.1` [Core Model](https://github.com/franksedivy/watered/releases/tag/0.1_Core-model)
- `0.2` Basic Today UI
- `0.3` Add Drink Flow
