import SwiftUI

// U2 merge · the two parts' registrations, joined to the spine's hooks
// (`SpineWorlds.registerAll()` calls these once before the root first draws).
// Part A gives Home (`HomeWorldBuilder`); Part C gives every other world
// (`WorldBuilders.registerHostedWorlds`).

extension SpineWorlds {
    static func registerHome() {
        HomeWorldBuilder.register()
    }

    static func registerHostedWorlds() {
        WorldBuilders.registerHostedWorlds()
    }
}
