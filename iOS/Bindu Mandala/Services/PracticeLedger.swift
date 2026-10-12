import Foundation
import SwiftData

/// Hands Wave 5's practice to the one ledger (R17), the way `MarginNoteStore`
/// hands his notes: each record carries its own "handed over" stamp, so a
/// sitting drawn offline, a letter sealed before her base row was reachable,
/// or a watch answered with no network, is simply handed over on a later sweep.
///
/// Once handed to `AirtableService.logActivity`, an event is safe: a failed
/// POST is queued in the activity queue, which never drops an item. So the
/// stamp is written *before* the await (on the main actor, with nothing in
/// between), which is what keeps two overlapping sweeps from handing the same
/// event over twice. When sync is off (tests, UI tests) nothing is handed over
/// and nothing is stamped, so the next real launch still sends it.
@MainActor
enum PracticeLedger {

    static func flush(context: ModelContext,
                      strokes strokeStore: PortraitStrokeStore? = nil,
                      river riverStore: CorrespondenceStore? = nil,
                      wagers wagerStore: WagerStore? = nil) async {
        guard !AppRuntime.syncDisabled else { return }
        let strokes = strokeStore ?? PortraitStrokeStore.shared
        let river = riverStore ?? CorrespondenceStore.shared
        let wagers = wagerStore ?? WagerStore.shared

        let shaktis = (try? context.fetch(FetchDescriptor<Shakti>())) ?? []
        var byPosition: [Int: Shakti] = [:]
        for s in shaktis {
            if let kp = s.khadgamalaPosition { byPosition[kp] = s }
        }
        func record(_ kp: Int) -> (id: String, name: String)? {
            guard let s = byPosition[kp], let id = s.airtableRecordId, !id.isEmpty else { return nil }
            return (id, s.name)
        }

        var pending: [PendingActivity] = []

        for session in strokes.unledgered() {
            strokes.markLedgered(session.id)
            pending.append(ActivityLedger.portraitDrawn(ring: session.ring,
                                                        at: session.endedAt ?? session.startedAt))
        }

        for letter in river.unledgeredSeals() {
            guard let r = record(letter.khadgamalaPosition) else { continue }
            river.markSealLedgered(letter.id)
            let opensOn = letter.opening.map { opening -> String in
                let day = DateFormatter.localizedString(from: letter.addressedTo,
                                                        dateStyle: .medium, timeStyle: .none)
                return "\(opening.words) · \(day)"
            }
            pending.append(ActivityLedger.letterSealed(shaktiRecordId: r.id, name: r.name,
                                                       forward: letter.direction == .forward,
                                                       opensOn: opensOn, body: letter.body,
                                                       at: letter.writtenAt,
                                                       to: ActivityLedger.recipientWords(letter.recipient),
                                                       moment: letter.direction == .back ? letter.addressedTo : nil))
        }

        // Wave 6 · light sent back, and the name kept in Bindu memory.
        for light in river.unledgeredLights() {
            guard let r = record(light.khadgamalaPosition) else { continue }
            river.markLightLedgered(light.id)
            pending.append(ActivityLedger.lightSentBack(shaktiRecordId: r.id, name: r.name,
                                                        moment: light.moment, words: light.words,
                                                        at: light.sentAt))
        }
        let memory = BinduMemory.shared
        if let point = record(KhadgamalaMap.total) {
            for kept in memory.unledgered() {
                memory.markLedgered(kept.id)
                pending.append(ActivityLedger.nameKept(pointRecordId: point.id, name: kept.name,
                                                       at: kept.keptAt))
            }
        }

        for letter in river.unledgeredOpenings() {
            guard let r = record(letter.khadgamalaPosition), let opened = letter.openedAt else { continue }
            river.markOpenLedgered(letter.id)
            pending.append(ActivityLedger.letterOpened(shaktiRecordId: r.id, name: r.name, at: opened))
        }

        for wager in wagers.unledgered() {
            guard let r = record(wager.khadgamalaPosition), let at = wager.resolvedAt else { continue }
            wagers.markLedgered(wager.id)
            pending.append(ActivityLedger.wagerResolved(shaktiRecordId: r.id, name: r.name,
                                                        appeared: wager.appeared ?? false, at: at))
        }

        for item in pending {
            await AirtableService.shared.logActivity(item)
        }
    }
}
