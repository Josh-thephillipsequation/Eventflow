---
ai.include_by_default: false  
ai.profiles: [design]
ai.weight: 0.3
---

# UI/UX and Material 3 Design

## Material 3 Principles
- **Always use Material 3** (`useMaterial3: true`)
- **Theme colors** from `lib/theme/app_theme.dart`
- **Semantic color roles:** `primary`, `secondary`, `surface`, `onSurface`
- **Prefer Cards over Containers** for elevated surfaces
- **Proper elevation** and surface tints

## Typography & Spacing
- **Google Fonts** (Roboto) for consistency
- **Material 3 typography**: `headlineMedium`, `bodyLarge`, `labelSmall`
- **Consistent spacing** using multiples of 8px: `8, 16, 24, 32`
- **Text contrast** using theme's `onSurface`, `onPrimary` colors

## EventFlow UX Patterns
- **Smart defaults:** Show upcoming events, collapse past events
- **Visual hierarchy:** Color-coded day headers (today/past/future)
- **Time-aware filtering:** Upcoming/all/past with device timezone
- **Day-grouped views:** Clear visual day separation
- **Interactive analytics:** Tap-to-explore topic clouds, heatmaps
- **Expandable content:** "More" buttons with popup details
- **Speaker integration:** Person icons when available

## Component Design Standards
- **Consistent EventCard** across all screens
- **Chips for metadata:** Priority, duration, selection status
- **Responsive layouts:** Handle overflow, different screen sizes
- **Accessibility:** Semantic labels, color contrast
- **Loading states:** Graceful empty states with helpful messaging

## Branding
- **Company:** thephillipsequation llc
- **App Name:** EventFlow
- **Logo:** `assets/images/tpe-logo.png`
- **Colors:** Material 3 theme with brand integration

## Common Design Pitfalls
- **Color scheme:** Use colorScheme properties, not deprecated colors
- **Components:** Prefer Material 3 over custom implementations
- **Theming:** Apply theme consistently across screens
- **Asset loading:** Always provide errorBuilder for images
- **Screen overflow:** Use Expanded, Flexible for responsive layouts
