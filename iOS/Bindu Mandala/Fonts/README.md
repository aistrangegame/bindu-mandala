# Cormorant Garamond — required fonts

Download from https://fonts.google.com/specimen/Cormorant+Garamond and drop the
following two files into this folder:

- `CormorantGaramond-Light.ttf`
- `CormorantGaramond-LightItalic.ttf`

They are already registered in `../Info.plist` under `UIAppFonts`. Xcode 16+
synchronized folder groups will pick them up automatically — no project edit
needed.

Until the files are present, SwiftUI's `.custom(...)` calls silently fall back
to the system serif; the app still runs, the typography just isn't right.
