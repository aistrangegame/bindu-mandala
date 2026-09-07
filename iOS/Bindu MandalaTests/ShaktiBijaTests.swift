import XCTest
@testable import Bindu_Mandala

/// `Shakti.bijaSyllable` is the one parse of the bīja field. Every surface that
/// prints a syllable — the Rite footer, Detail, the Recognition ghost, the
/// Significance card, the Mandala's deepest zoom — delegates here, so the
/// Type-2 description ("Kaṃ — governs K-row …") never leaks into a syllable.
final class ShaktiBijaTests: XCTestCase {

    private func shakti(bija: String) -> Shakti {
        Shakti(position: 1, name: "Test", shortName: "", phonetic: "",
               quality: "", qualityDescription: "", somatic: "", somaticPoetry: "",
               bija: bija, bodilyLocation: "", tattva: "", recognitionPhrase: "",
               cluster: .inner, status: .mapped)
    }

    func testTypeOneSyllableIsWhole() {
        XCTAssertEqual(shakti(bija: "aṁ").bijaSyllable, "aṁ")
    }

    func testTypeTwoCutsBeforeDescription() {
        let s = shakti(bija: "Kaṃ — governs K-row of the Sanskrit alphabet — the first sounds")
        XCTAssertEqual(s.bijaSyllable, "Kaṃ")
    }

    func testEmptyIsNil() {
        XCTAssertNil(shakti(bija: "").bijaSyllable)
    }

    func testWhitespaceOnlyIsNil() {
        XCTAssertNil(shakti(bija: "  \n ").bijaSyllable)
    }

    /// C8 — the Rite footer carries the syllable only.
    func testRiteFooterCarriesSyllableOnly() {
        let s = shakti(bija: "Kaṃ — governs K-row …")
        s.ringNumber = 1
        s.khadgamalaPosition = 5
        XCTAssertEqual(RiteContent(shakti: s).bija, "Kaṃ")
    }
}
