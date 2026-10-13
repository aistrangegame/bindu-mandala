import SwiftUI
import SwiftData

// MARK: - U2 · B · what the shell does that is not drawn
//
// The retired `RootView` carried the app's launch work, the gift's landing and
// two global presenters. They live here now, called by `SpineRoot`, so nothing
// that ran under the five rooms stops running under the fifteen worlds:
//
// | RootView did | now |
// |---|---|
// | `.task` seed · backfill · summons hour · prime summons & gifts · sync · reschedule | `bootstrap(context:router:)` (same calls, same order) |
// | `landOnGift()` → a Detail cover | `landAnyGift(router:)` → `Router.giftOpened` (Home, her card — §2 J #72) |
// | `.leelaDrops()` overlay | `considerLeela` → `Router.leelaDropped` → `LeelaDropPlace` (§2 J #74) |
// | (nothing) | `worldCrossed` — one `World Crossed` ledger row per crossing between worlds (§2 H #64) |
// | (nothing) | `arrived(at:)` — the world sounds its voice and threshold (§2 H #62, sound.md S09) |

@MainActor
enum SpineServices {

    // MARK: Launch

    /// Everything `RootView`'s launch `.task` did, in its order. Quiet in the
    /// unit-test host, exactly as before.
    static func bootstrap(context: ModelContext, router: Router) async {
        guard !AppRuntime.isUnitTesting else { return }
        ShaktiBootstrap.seedIfNeeded(context: context)
        ShaktiBootstrap.seedDescentIfNeeded(context: context)
        RecognitionMigrator.backfillIfNeeded(context: context)
        DailySummons.migrateDefaultHourIfNeeded()
        primeSummons(context: context)          // name mornings from seeded (16) data
        landAnyGift(router: router)             // a gift that opened the app
        await AirtableService.shared.sync(context: context)
        primeSummons(context: context)          // refresh with the full 102
        await DailySummons.reschedule()         // upcoming mornings now named
        await EnergyGift.reschedule()           // Wave 5 · the random gift
        landAnyGift(router: router)
    }

    /// A gift that opened the app (or was tapped while it was open) lands at
    /// Home with her card already open — the notification was the first tap
    /// (§2 J #72). Taken exactly once.
    static func landAnyGift(router: Router) {
        guard let kp = GiftRouter.shared.take() else { return }
        router.giftOpened(kp: kp)
    }

    /// Build the morning-greeting map (khaḍgamālā position → title + line)
    /// and the gift's words from the local store — `RootView.primeSummons`,
    /// unchanged.
    static func primeSummons(context: ModelContext) {
        let shaktis = (try? context.fetch(FetchDescriptor<Shakti>())) ?? []
        var map: [Int: (title: String, body: String)] = [:]
        for s in shaktis {
            guard let kp = s.khadgamalaPosition else { continue }
            let quality = s.quality.trimmingCharacters(in: .whitespacesAndNewlines)
            let body = quality.isEmpty ? DailySummons.wordlessBody : quality
            map[kp] = (title: s.name, body: body)
        }
        DailySummons.greetingProvider = { map[$0] }

        // Wave 5 · the gift speaks only her own authored words: her
        // Appreciation Phrase, else her Function. A seat holding neither is
        // passed over by `EnergyGift.reschedule`.
        var gifts: [Int: (title: String, body: String)] = [:]
        for s in shaktis {
            guard let kp = s.khadgamalaPosition else { continue }
            let phrase = (s.appreciationPhrase ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let function = (s.shaktiFunction ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let words = phrase.isEmpty ? function : phrase
            if !words.isEmpty { gifts[kp] = (title: s.name, body: words) }
        }
        EnergyGift.giftProvider = { gifts[$0] }
    }

    // MARK: Every crossing

    /// The world mounted: it sounds its voice, its bed crossfading over 2.6 s,
    /// its threshold pitch once (sound.md S09, S22 — the U1 mixer). Before the
    /// first touch the mixer holds silence, and this only sets the scene.
    static func arrived(at address: Address) {
        SoundMixer.shared.enter(address.world, ring: address.ringNumber ?? 1)
    }

    /// One `World Crossed` row per crossing between worlds (§2 H #64; §4 data
    /// contract). Linked to her Mandala row when a kp thread is carried in,
    /// and to The Map when a chakra is. No count in any word.
    static func worldCrossed(from: Address, to: Address, context: ModelContext) {
        guard from.world != to.world else { return }
        var mandalaLink = ""
        if let kp = to.kp {
            let all = (try? context.fetch(FetchDescriptor<Shakti>())) ?? []
            mandalaLink = all.first { $0.khadgamalaPosition == kp }?.airtableRecordId ?? ""
        }
        var mapLink: String? = nil
        if let road = to.chakra {
            mapLink = ChakraConstellation.all.first { $0.road == road }?.mapRecordId
        }
        let item = ActivityLedger.worldCrossed(from: from.world, to: to.world,
                                               mandalaLink: mandalaLink, mapRecordId: mapLink, at: Date())
        Task { await AirtableService.shared.logActivity(item) }
    }

    // MARK: Leela drops (§2 J #74)

    /// A breath after he arrives at Home, rarely and unannounced, a drop may
    /// come — presented as a place in A Strange Game. His own limits govern
    /// (`LeelaDrops.draw`: never within three days, then by chance, once a
    /// practice day at most). Never in the test host or a snapshot walk.
    static func considerLeela(router: Router, active: Bool) async {
        guard active, router.mounted.world == .home,
              !AppRuntime.isUnitTesting, !SnapshotSource.isActive else { return }
        try? await Task.sleep(for: .seconds(leelaSettleSeconds))
        guard !Task.isCancelled, router.mounted.world == .home,
              router.menuFace == nil, router.place == nil, router.inFlight == nil else { return }
        if let d = LeelaDrops.draw() {
            Haptics.soft()
            router.leelaDropped(id: d.id)
        }
    }

    /// He answered the drop — carried into the day, or held in silence. Both
    /// are the same act; the one row grades nothing.
    static func answerLeela(_ d: LeelaDrop, carried: Bool) {
        ThreePools.noteBeing(.leelaAnswered(d.id, carried: carried))
        let item = ActivityLedger.leelaDrop(chakra: d.chakra, carried: carried, at: Date())
        Task { await AirtableService.shared.logActivity(item) }
    }

    /// The drop's settle, kept from the retired presenter: "a breath after he
    /// arrives, so a drop never lands on the opening itself" (9 s, §2 J #74).
    static let leelaSettleSeconds: Double = 9
}
