import Foundation

// MARK: - Upgrade U1 · B · his recordings
//
// `waves/upgrade/worlds/sound.md` §1.9 (S64) and `waves/register/audio-on-github.md`
// (ruling 12: the songs are his own recordings on aistrangegame/aistrangegame.com,
// served at https://aistrangegame.com/<path>). 58 paths, 40 unique recordings
// (`b/` duplicates `bindu/` for 18 songs). Every byte count and sha256 below was
// computed on 13 Oct 2026 from the file served at that path; `gitBlob` is the
// git object id prefix the register lists, and every one matched.
//
// U1 bundles no audio: a recording absent from the app bundle streams from
// aistrangegame.com into an on-device cache and is verified against its sha256
// on first download (`RecordingStore`).

/// One recording at one path — a row of the register's recordings table.
struct Recording: Equatable {
    /// Path on aistrangegame.com, e.g. `bindu/kingdom.mp3`.
    let path: String
    let bytes: Int
    /// Lower-case hex SHA-256 of the file's bytes.
    let sha256: String
    /// The git blob id prefix the register lists (8 hex).
    let gitBlob: String
}

/// The catalogue of his recordings and where each is used — `sound.md` §1.9, §4.
enum Recordings {

    /// Where they are served.
    static let base = URL(string: "https://aistrangegame.com/")!

    /// Where a bundled copy lives inside the app (`Audio/Songs/<path>`), when
    /// a later wave bundles them.
    static let bundleSubdirectory = "Audio/Songs"

    static let all: [Recording] = [
        Recording(path: "b/arise.mp3", bytes: 4543313, sha256: "9adbaf9673c7f3e385d66c750ae805204cc3caba08f22edb828525ef93216470", gitBlob: "eade0428"),
        Recording(path: "b/bindu-dances-reach.mp3", bytes: 5984267, sha256: "e9a64408c0d8acc112e22d1741fa83d5d5c907eb8bbb2e9d608546c106421070", gitBlob: "84df242a"),
        Recording(path: "b/dream.mp3", bytes: 4961300, sha256: "fe621e6413157b1a1ee5c21ddb21e3f6c2e76c0be0199fb17789a693b3ef92ee", gitBlob: "c2d4d6a6"),
        Recording(path: "b/enough.mp3", bytes: 2929949, sha256: "0fdb56f2ce708c2329d19d827a4623be0ea34596ca0b8a97cea03573218e8ca0", gitBlob: "708d3f3c"),
        Recording(path: "b/fade.mp3", bytes: 3794334, sha256: "0c9f960cb2bb97eb40cd286e4c44dbfd76b3eea0cb83b10040fb5833a488b673", gitBlob: "9e187015"),
        Recording(path: "b/glow.mp3", bytes: 4119592, sha256: "0a726d2f00bc618ed90c8a6fed9fb30134058849c6e0f80535b9856aabef505b", gitBlob: "ac4bb6b4"),
        Recording(path: "b/howl.mp3", bytes: 4974069, sha256: "22f60db38dc4373dbda30fb09977e85a928246799b307d0cc0418834596a9b0b", gitBlob: "20160be7"),
        Recording(path: "b/light.mp3", bytes: 6430021, sha256: "e35ce777f11a0c7948469cdb6b224f786145291cc1e24c6be941db9c5e7ce53d", gitBlob: "5d5e09a2"),
        Recording(path: "b/lose.mp3", bytes: 5803082, sha256: "709ebead5f52a90f3ecfe98dd02d478197601f0e3bdc751193cd6951d61a0523", gitBlob: "5cd75afa"),
        Recording(path: "b/melt.mp3", bytes: 6938468, sha256: "3f732645a7f124f1702430b8936a9e1ff657ca8ff22a5733c3d4fb946aa3c812", gitBlob: "f2812fe3"),
        Recording(path: "b/move.mp3", bytes: 4833835, sha256: "55de70ad785f9dc5097fd1e972ddb3b755749ceef648c34e30e1d033f01efa5b", gitBlob: "e955dff2"),
        Recording(path: "b/release.mp3", bytes: 6583725, sha256: "c64f106f8e06710c34c25cb60df3da0c7aba085c58e6e5dddec35f2310a7d883", gitBlob: "abdf90fb"),
        Recording(path: "b/remember.mp3", bytes: 2600292, sha256: "046525943b8f2911059b0bf97632c7add3d28b5a3e59f53408c08bb03b913ca1", gitBlob: "c49dba81"),
        Recording(path: "b/rise.mp3", bytes: 13045479, sha256: "b20ce29a9101b61ae37f7c01b69b7e36908a59e197070e0e19545262a828bc2b", gitBlob: "b1ad53a1"),
        Recording(path: "b/search.mp3", bytes: 3468880, sha256: "bb68e453fcaf9b21c6314470dc8dbb9c301e7d5acb7def80625edcf2d741438a", gitBlob: "1fd94f80"),
        Recording(path: "b/stay.mp3", bytes: 5834429, sha256: "a8178041f6f6274308ebd0ca7a208d19be075e5cbd6b8315022445ff29312a6e", gitBlob: "be453218"),
        Recording(path: "b/still.mp3", bytes: 12093741, sha256: "8cc65ce85c63bab75194f1dbdef58d87a8f1780559abe489061017be7dd5d9aa", gitBlob: "7dbb702d"),
        Recording(path: "b/wild.mp3", bytes: 4747944, sha256: "c3593a30539df9500139070fba8959526f88ed163a88aa6ff937a7a3be0b95d5", gitBlob: "01c101c0"),
        Recording(path: "bindu/ache.mp3", bytes: 4016306, sha256: "652d48f762066adf83cbc3a8ab9ea6ebf95164e8236541e751e748f514964dd2", gitBlob: "85ac2506"),
        Recording(path: "bindu/before.mp3", bytes: 5641959, sha256: "c929ec2109f00dc008db5fa9bf6592108fea4a493460808c819bab04735f1803", gitBlob: "280ad2a5"),
        Recording(path: "bindu/believe.mp3", bytes: 6024391, sha256: "5af64af69ce7579ba318a99f3ae6d30dd148d87699e53c562dcb8fa0c7824cd8", gitBlob: "488b06fb"),
        Recording(path: "bindu/crash.mp3", bytes: 5112195, sha256: "893fea15295c2d24fbd7126758b99c4098ac9d0d38defd2eef31591c3bb35914", gitBlob: "ba6b7afe"),
        Recording(path: "bindu/cross.mp3", bytes: 5523467, sha256: "23a49878e73cdde265b0f4475b7e4f5c2783f6e262a47395616c50d36d36c2ac", gitBlob: "3d76f92c"),
        Recording(path: "bindu/dream.mp3", bytes: 4961300, sha256: "fe621e6413157b1a1ee5c21ddb21e3f6c2e76c0be0199fb17789a693b3ef92ee", gitBlob: "c2d4d6a6"),
        Recording(path: "bindu/earn.mp3", bytes: 3861657, sha256: "70f455a9688e5f103bba77b985c832097fee805c6cc086c8380398d322a399b1", gitBlob: "ad3e2845"),
        Recording(path: "bindu/enough.mp3", bytes: 2929949, sha256: "0fdb56f2ce708c2329d19d827a4623be0ea34596ca0b8a97cea03573218e8ca0", gitBlob: "708d3f3c"),
        Recording(path: "bindu/fade.mp3", bytes: 3794334, sha256: "0c9f960cb2bb97eb40cd286e4c44dbfd76b3eea0cb83b10040fb5833a488b673", gitBlob: "9e187015"),
        Recording(path: "bindu/glow.mp3", bytes: 4119592, sha256: "0a726d2f00bc618ed90c8a6fed9fb30134058849c6e0f80535b9856aabef505b", gitBlob: "ac4bb6b4"),
        Recording(path: "bindu/ground.mp3", bytes: 4899036, sha256: "4c2367d9da0bd7dfaca482a2d6aa02b1876af05e349c3a7e51ad956bc6936ff8", gitBlob: "91f20f33"),
        Recording(path: "bindu/howl.mp3", bytes: 4974069, sha256: "22f60db38dc4373dbda30fb09977e85a928246799b307d0cc0418834596a9b0b", gitBlob: "20160be7"),
        Recording(path: "bindu/in_shadow.mp3", bytes: 18723663, sha256: "21c4db4f072720b8e6205ea5b742623e17372ae53075dc080a5ebf1fadc20f01", gitBlob: "db31d5c7"),
        Recording(path: "bindu/kingdom.mp3", bytes: 12610298, sha256: "04503b9fd5691ff0d2cdea81ad5a12826ab98c40cfc179cf97287a5d57ff9815", gitBlob: "d2fd8589"),
        Recording(path: "bindu/levelup.mp3", bytes: 10093815, sha256: "e6291aa630f4bf81d321c83dc9f2b55bcfa383033c77594deaf853579e0eed05", gitBlob: "b626dfe5"),
        Recording(path: "bindu/light.mp3", bytes: 6430021, sha256: "e35ce777f11a0c7948469cdb6b224f786145291cc1e24c6be941db9c5e7ce53d", gitBlob: "5d5e09a2"),
        Recording(path: "bindu/lose.mp3", bytes: 5803082, sha256: "709ebead5f52a90f3ecfe98dd02d478197601f0e3bdc751193cd6951d61a0523", gitBlob: "5cd75afa"),
        Recording(path: "bindu/melt.mp3", bytes: 6938468, sha256: "3f732645a7f124f1702430b8936a9e1ff657ca8ff22a5733c3d4fb946aa3c812", gitBlob: "f2812fe3"),
        Recording(path: "bindu/move.mp3", bytes: 4833835, sha256: "55de70ad785f9dc5097fd1e972ddb3b755749ceef648c34e30e1d033f01efa5b", gitBlob: "e955dff2"),
        Recording(path: "bindu/numb.mp3", bytes: 6315291, sha256: "e97258a8ae2101e68dd79876d83d4b1d37a672a70cd52c1ba5446bb3431d2606", gitBlob: "d185c766"),
        Recording(path: "bindu/play.mp3", bytes: 4766125, sha256: "9250fe64d43b94c20568912096fff3a8e7f9a62b94a30ac2c06ddfc60d900c8f", gitBlob: "ae3ee246"),
        Recording(path: "bindu/purity.mp3", bytes: 8169358, sha256: "588efe3ba06a6c736c44c4c334f16b26017b7ac65ebf34bcd910716d289201e4", gitBlob: "2078bd62"),
        Recording(path: "bindu/release.mp3", bytes: 6583725, sha256: "c64f106f8e06710c34c25cb60df3da0c7aba085c58e6e5dddec35f2310a7d883", gitBlob: "abdf90fb"),
        Recording(path: "bindu/remember.mp3", bytes: 2600292, sha256: "046525943b8f2911059b0bf97632c7add3d28b5a3e59f53408c08bb03b913ca1", gitBlob: "c49dba81"),
        Recording(path: "bindu/rise.mp3", bytes: 13045479, sha256: "b20ce29a9101b61ae37f7c01b69b7e36908a59e197070e0e19545262a828bc2b", gitBlob: "b1ad53a1"),
        Recording(path: "bindu/search.mp3", bytes: 3468880, sha256: "bb68e453fcaf9b21c6314470dc8dbb9c301e7d5acb7def80625edcf2d741438a", gitBlob: "1fd94f80"),
        Recording(path: "bindu/stay.mp3", bytes: 5834429, sha256: "a8178041f6f6274308ebd0ca7a208d19be075e5cbd6b8315022445ff29312a6e", gitBlob: "be453218"),
        Recording(path: "bindu/still.mp3", bytes: 12093741, sha256: "8cc65ce85c63bab75194f1dbdef58d87a8f1780559abe489061017be7dd5d9aa", gitBlob: "7dbb702d"),
        Recording(path: "bindu/trace.mp3", bytes: 5611239, sha256: "39f268b7308de1463bd819b3c3570b372263dd12825cbe64e8124753ff8d5b7f", gitBlob: "0ef6c68f"),
        Recording(path: "bindu/wild.mp3", bytes: 4747944, sha256: "c3593a30539df9500139070fba8959526f88ed163a88aa6ff937a7a3be0b95d5", gitBlob: "01c101c0"),
        Recording(path: "tree-of-life/aatma.mp3", bytes: 4543313, sha256: "9adbaf9673c7f3e385d66c750ae805204cc3caba08f22edb828525ef93216470", gitBlob: "eade0428"),
        Recording(path: "tree-of-life/ajna.mp3", bytes: 7574811, sha256: "4a8a1140bfa25e5061b0c0f3831364b3cef1513afce2c3ec709412835c378684", gitBlob: "59ccff7e"),
        Recording(path: "tree-of-life/anahata.mp3", bytes: 5984267, sha256: "e9a64408c0d8acc112e22d1741fa83d5d5c907eb8bbb2e9d608546c106421070", gitBlob: "84df242a"),
        Recording(path: "tree-of-life/manipura.mp3", bytes: 3293447, sha256: "9faa2d41877de105283619f567547d9c86e530f4da0826edb7a963137499a471", gitBlob: "0c3592ac"),
        Recording(path: "tree-of-life/maya-chakra-ending.mp3", bytes: 2431603, sha256: "118b2784cea63b9d53ef079613b1167b218ab9e3f74082e71b7fe281039dabc9", gitBlob: "4d2b3a22"),
        Recording(path: "tree-of-life/maya.mp3", bytes: 4423817, sha256: "1ec9ec31060721a51bad1e4e790235554054c535924d36003aea5d6ad5996431", gitBlob: "ae4e78d8"),
        Recording(path: "tree-of-life/muladhara.mp3", bytes: 4842612, sha256: "b9f8f33f836b6b58db01d952357eb5ea7fe09cf855f1373ca97b484c09b5ff1d", gitBlob: "6b554b3f"),
        Recording(path: "tree-of-life/sahasrara.mp3", bytes: 4773648, sha256: "1a5c44eba553ba3bee49501330fa26ef33e16498a297282643eb86f871ab561c", gitBlob: "7b91df09"),
        Recording(path: "tree-of-life/svadhisthana.mp3", bytes: 6213100, sha256: "db473ee17bc1de153c1f41044b4c5d4da3c36c37518054b3dbfa377239741e4e", gitBlob: "1d6c2b81"),
        Recording(path: "tree-of-life/vishuddha.mp3", bytes: 6299617, sha256: "7132933d04f0cb89a896a2499062d82d0237b493a2ada64851c93616c28a7a1d", gitBlob: "e20d26d0"),
    ]

    /// The recording at `path`.
    static func recording(_ path: String) -> Recording? { all.first { $0.path == path } }

    /// Its URL on aistrangegame.com.
    static func remoteURL(_ path: String) -> URL {
        URL(string: path, relativeTo: base)?.absoluteURL ?? base.appendingPathComponent(path)
    }

    /// The unique recordings (by sha256), one row each — the `bindu/` or
    /// `tree-of-life/` path preferred over its `b/` twin.
    static var unique: [Recording] {
        var seen: [String: Recording] = [:]
        var order: [String] = []
        for r in all {
            if let kept = seen[r.sha256] {
                if kept.path.hasPrefix("b/") && !r.path.hasPrefix("b/") { seen[r.sha256] = r }
            } else {
                seen[r.sha256] = r
                order.append(r.sha256)
            }
        }
        return order.compactMap { seen[$0] }
    }

    // MARK: Where each is used (sound.md §4 "Bundled assets")

    /// The dance of a 33 room (S56): rooms 2–8, 30, 31 their Tree-of-Life
    /// song; room 9 (Shadow) `bindu/in_shadow.mp3`. Other rooms dance songless.
    static func dance(room: Int) -> String? {
        switch room {
        case 2: return "tree-of-life/muladhara.mp3"
        case 3: return "tree-of-life/svadhisthana.mp3"
        case 4: return "tree-of-life/manipura.mp3"
        case 5: return "tree-of-life/anahata.mp3"
        case 6: return "tree-of-life/vishuddha.mp3"
        case 7: return "tree-of-life/ajna.mp3"
        case 8: return "tree-of-life/sahasrara.mp3"
        case 9: return "bindu/in_shadow.mp3"
        case 30: return "tree-of-life/maya.mp3"
        case 31: return aatma
        default: return nil
        }
    }

    /// Chase Hughes' *Aatma* — room 31's dance (his ruling).
    static let aatma = "tree-of-life/aatma.mp3"
    /// Room 30's ending loop (S51).
    static let mayaEnding = "tree-of-life/maya-chakra-ending.mp3"
    /// Beneath's bed (S65).
    static let kingdom = "bindu/kingdom.mp3"
    /// The threshold song — Gates of Release, the Veil's lifting (S66).
    static let cross = "bindu/cross.mp3"
    /// Room 2's second dance (S67).
    static let before = "bindu/before.mp3"
    /// Lalitā's dance (his ruling).
    static let lalitaDance = "bindu/play.mp3"
    /// Room 18's Axis triptych, the two on the site: Thunderclouds, Fade Away.
    static let axisTriptych = ["bindu/play.mp3", "bindu/fade.mp3"]
    /// The Relationship Field's family songs (S68).
    static let family = ["bindu/purity.mp3", "bindu/levelup.mp3", "bindu/glow.mp3", "bindu/play.mp3"]
}
