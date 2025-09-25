---
ai.include_by_default: false  
ai.profiles: [architecture]
ai.weight: 0.3
---

# Code Organization and Architecture Patterns

## File Structure
```
lib/
├── models/          # Data models (CalendarEvent, etc.)
├── providers/       # State management (EventProvider)
├── screens/         # Full-screen UI components
├── services/        # External integrations (calendar import)
├── theme/           # App theme and styling
├── widgets/         # Reusable UI components
└── main.dart        # App entry point
```

## State Management
- **Provider pattern** for global state
- **StatefulWidget** for local state  
- **Consumer<EventProvider>** for reactive UI updates
- **Avoid calling Provider in initState**

## Data Architecture
- **CalendarEvent:** Core event data structure
- **Priority levels:** 1 (high), 2 (medium), 3 (low)
- **Time zones:** Handle local time conversion properly
- **Filtering:** By time (past/current/future), search terms, priority

## Error Handling Patterns
- **Graceful fallbacks** for missing assets/data
- **User-friendly error messages**
- **errorBuilder** for image loading failures
- **Try-catch blocks** for service operations

## Security Best Practices
- **Local storage only** - no external data transmission
- **Never commit secrets** or API keys
- **Use environment variables** for external API integration
- **Privacy-first approach** - see `agent_assets/privacy-policy.md`

## Navigation Structure
- **Tab-based navigation:** All Events, My Agenda, Import, Fun, Insights
- **Material 3 navigation bar**
- **Contextual actions:** Search, filter, sort

## Key Architecture Files
- **Theme:** `lib/theme/app_theme.dart`
- **Main Provider:** `lib/providers/event_provider.dart`
- **Entry Point:** `lib/main.dart`
- **Screens:** `lib/screens/` (5 tabs all working)

## Common Architecture Pitfalls
- **Hot reload limitations:** Restart after theme/provider changes
- **State management:** Don't call Provider in initState
- **Screen overflow:** Use Expanded, Flexible for responsive layouts
- **Asset loading:** Always provide errorBuilder for images
