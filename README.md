# EventFlow

> **36 Hours, One AI Agent, Full iOS App**

A comprehensive conference agenda management app built in 36 hours using [Amp AI](https://ampcode.com). Features smart filtering, interactive analytics, AI-powered content generators, and Material 3 design throughout.

## 🎥 **Live Demo**

**[▶️ View Interactive Demo & Features](https://josh-thephillipsequation.github.io/Eventflow/)**

See EventFlow in action with the complete UX demo featuring smart day grouping, interactive analytics, AI generators, and conference bingo!

## ✨ **Key Features**

- **🎯 Smart Event Management** - ICS import, timezone intelligence, speaker extraction
- **📊 Interactive Analytics** - Topic clouds, schedule heatmaps, tap-to-explore insights  
- **🎮 AI-Powered Fun** - Talk proposals, product generators, interactive bingo
- **💎 Professional Polish** - Material 3 design, expandable cards, proper accessibility

## 🚀 **Quick Start**

```bash
# Clone and run
git clone https://github.com/Josh-thephillipsequation/Eventflow.git
cd Eventflow
flutter pub get
flutter run
```

### 📱 **Deploy to iPhone**

For wireless testing on your iPhone:

```bash
# 1. List all connected devices to find your device ID
flutter devices

# Example output:
# iPhone (mobile) • 00008140-0002248A0E12801C • ios • iOS 17.6.1 (21G93)
#                   ^^^^^^^^^^^^^^^^^^^^^^^^
#                   This is your device ID

# 2. Deploy to iPhone using your device ID
flutter run --release -d "YOUR-DEVICE-ID"

# Or run with hot reload for development
flutter run -d "YOUR-DEVICE-ID"
```

**Tip:** Save your device ID for quick deployments:
```bash
export IPHONE_ID="YOUR-DEVICE-ID"
flutter run --release -d "$IPHONE_ID"
```

**First-Time Setup:** You may need to open Xcode and trust the developer certificate on your device:

```bash
open ios/Runner.xcworkspace
```

Then use Xcode's "Product > Run" to deploy initially.

## 🤖 **The Amp Story**

Built using [Amp](https://ampcode.com), Sourcegraph's AI coding agent. When I said "add speaker data from ICS files," Amp updated the data model, parsing logic, UI components, and search functionality across multiple screens. When I mentioned timezone issues, it fixed time display throughout the entire app.

The key difference is Amp's ability to understand how changes propagate through a codebase and maintain design patterns without constant specification.

## 🏗️ **Architecture**

- **Flutter/Dart** with Material 3 design system
- **Provider pattern** for state management  
- **Service layer** for calendar parsing and data handling
- **Comprehensive testing** with CI/CD pipeline
- **Privacy-first** - all data stays local

## 🧪 **Development**

EventFlow includes enterprise-grade development practices:

- **17+ comprehensive tests** (unit, widget, integration)
- **GitHub Actions CI/CD** with automated testing and reporting
- **Agent feedback loops** for automated issue resolution
- **Human-in-the-loop testing** on real devices

See [AGENTS.md](AGENTS.md) for development guidelines and [agent_assets/backlog.md](agent_assets/backlog.md) for project roadmap.

## 📱 **Status**

**App Store Ready** - Waiting for Apple Developer Account approval for publication. Currently runs perfectly via Xcode deployment with weekly re-installation for free developer accounts.

---

**Built by [thephillipsequation llc](https://thephillipsequation.com) • Powered by [Flutter](https://flutter.dev) & [Amp AI](https://ampcode.com)**
