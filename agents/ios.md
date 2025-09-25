---
ai.include_by_default: false  
ai.profiles: [ios]
ai.weight: 0.3
---

# iOS-Specific Development

## Bundle IDs & Provisioning
- **Test:** `com.joshua.eventflow`
- **Production:** `com.thephillipsequation.eventflow`
- **Provisioning:** Free accounts require weekly re-installation

## Code Signing
- **Development certificates** for testing
- **Release certificates** for App Store
- **Team ID:** Linked to thephillipsequation llc

## iOS Build Commands
```bash
# PREFERRED: Deploy to iPhone for testing
flutter run --release -d "00008140-0002248A0E12801C"

# iOS release build
flutter build ios --release

# iOS debug build (CI)
flutter build ios --no-codesign --debug
```

## Device Deployment
- **Target device:** iPhone with ID `00008140-0002248A0E12801C`
- **Wireless deployment** preferred for testing
- **Human-in-the-loop testing** required for each feature

## App Store Preparation
- **App icons:** Generated with `flutter pub run flutter_launcher_icons`
- **Splash screens:** `flutter pub run flutter_native_splash:create`
- **Native splash coordination** with Flutter splash

## iOS-Specific Considerations
- **Hot reload limitations:** Restart after theme/provider changes
- **Asset optimization:** Prefer WebP, compress images
- **Permissions:** Calendar access requires user consent
- **Local storage only:** No external data transmission

## Common iOS Pitfalls
- **Code signing errors:** Check certificates and provisioning profiles
- **Asset loading failures:** Always use errorBuilder for images
- **Bundle ID conflicts:** Use correct ID for test vs production
- **Splash screen timing:** Coordinate native and Flutter splash screens
