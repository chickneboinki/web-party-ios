# Web Party iOS

Native iOS app for Web Party (screen share + remote control requests).

## What this is
- SwiftUI app with party create/join UI
- Broadcast Upload Extension skeleton (ReplayKit) for screen capture
- Ready for you to open in Xcode, sign, and build an IPA

## Requirements
- Mac with Xcode 15+
- Apple Developer account (free or paid)
- Your device registered for development / ad-hoc

## How to build an IPA

1. Clone this repo: `git clone https://github.com/chickneboinki/web-party-ios.git`
2. Open `WebParty.xcodeproj` in Xcode (you may need to generate the project file — see below)
3. Select your **Team** under Signing & Capabilities for both the main app target and the Broadcast Extension target
4. Change Bundle Identifiers if needed (must be unique to your team)
5. Connect your iPhone or choose Any iOS Device
6. **Product → Archive**
7. Organizer → **Distribute App** → Ad Hoc or Development → export the IPA

### Note on the .xcodeproj
GitHub does not store a full binary Xcode project easily. The source files are here. Easiest path:

1. Create a new iOS App project in Xcode (SwiftUI, Swift)
2. Name it WebParty
3. Add a Broadcast Upload Extension target (File → New → Target → Broadcast Upload Extension)
4. Replace the generated source files with the ones from this repo
5. Then sign and Archive as above

## Important platform limits
Even with a native app:
- Full system control (opening arbitrary apps, system volume, SpringBoard) is heavily restricted by Apple
- Screen capture is done via ReplayKit Broadcast Upload Extension
- Remote input injection has significant limitations on non-jailbroken devices

This gives you the correct native foundation. Signing and producing the IPA is on your side with your Apple Developer account.
