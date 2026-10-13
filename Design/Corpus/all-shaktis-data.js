// ─── Bindu Mandala — All 9 Avaranas · 102 Shaktis ───────────────────────────
// Loaded after shakti-data.js. Extends all window globals.

// ─── The 9 Avarana Definitions ────────────────────────────────────────────────

const AVARANAS = [
  {
    id: 1, ring: 1, status: 'ancient',
    name: 'Trailokyamohana',
    subtitle: 'She Who Enchants All Three Worlds',
    form: 'Bhupura',
    formDescription: 'The outer square — the boundary of the manifest world, four T-gates opening in each cardinal direction',
    count: 28,
    presidingForm: 'Tripurā',
    yogini: 'Prakaṭa Yoginī',
    mentalState: 'Jāgrat — waking consciousness',
    chakra: 'Mūlādhāra',
    geometry: 'square',
    appreciationPhrase: 'Thank you for the world I have walked through without knowing it was you.',
    personalConnection: 'You have already been here. Every moment you moved through the world — its noise, its weight, its ten thousand enchantments — you were in her territory. The surfaces that held you, the beauty that stopped you mid-step, the ordinary gravity that kept you walking forward: all her. The 28 Shaktis of this avaraṇa are the most universal forces. They are the ground. You have been breathing them since before you knew there was breath to track.',
  },
  {
    id: 2, ring: 2, status: 'home',
    name: 'Sarvāśā-Paripūraka',
    subtitle: 'She Who Fulfills All Hopes',
    form: '16-Petal Lotus',
    formDescription: 'The lotus of completeness — sixteen petals of attraction, sense, and consciousness',
    count: 16,
    presidingForm: 'Tripureśī',
    yogini: 'Gupta Yoginī',
    mentalState: 'Svapna — the dream state',
    chakra: 'Svādhiṣṭhāna',
    geometry: 'lotus16',
    appreciationPhrase: 'Thank you for the desire that moves me and the awareness that knows it.',
    personalConnection: 'You are here now. This is your current field. The sixteen Karṣiṇīs — the forces that attract sense, intelligence, the I-sense, consciousness itself — you have been meeting them daily, learning their names, catching them in life. Some are already embodied. The game is not new. The map is simply arriving.',
  },
  {
    id: 3, ring: 3, status: 'unlocked',
    name: 'Sarvasaṅkṣobhaṇa',
    subtitle: 'She Who Agitates All',
    form: '8-Petal Lotus',
    formDescription: 'The inner lotus — eight petals of the Anaṅga forces, the bodiless desires that move without a name',
    count: 8,
    presidingForm: 'Tripura Sundarī',
    yogini: 'Guptatarā Yoginī',
    mentalState: 'Suṣupti — the deep sleep awareness',
    chakra: 'Maṇipūra',
    geometry: 'lotus8',
    appreciationPhrase: 'Thank you for the longing that arrives without asking permission.',
    personalConnection: 'You have already been here. You know Anaṅga — the bodiless one — as a felt sense before any word arrived for it. The longing without address. The beauty that entered through the chest before the eyes had time to process. The pull toward something you couldn\'t name, which was not sadness and not joy but something that preceded both. You were in this territory without the map. Now the territory is naming itself to you.',
  },
  {
    id: 4, ring: 4, status: 'locked',
    name: 'Sarvasaubhāgyadāyaka',
    subtitle: 'She Who Grants All Auspiciousness',
    form: '14 Triangles',
    formDescription: 'Fourteen interlocked triangular forces — where luck is recognized as intelligence',
    count: 14,
    presidingForm: 'Tripura Vāsinī',
    yogini: 'Sampradāya Yoginī',
    mentalState: 'Turīya — the fourth state',
    chakra: 'Anāhata',
    geometry: 'tri14',
    appreciationPhrase: 'Thank you for the good fortune I did not manufacture.',
    personalConnection: 'You have already been here. The moments where everything converged — good fortune arriving as a current you hadn\'t called — she was doing that. The synchronicity that stopped you. The door that opened before you knocked. The meeting that happened because you took a different route. You didn\'t know her name then. Now you stand at her gate consciously, and she recognizes the practitioner who has been receiving her gifts without attribution.',
  },
  {
    id: 5, ring: 5, status: 'locked',
    name: 'Sarvārthasādhaka',
    subtitle: 'She Who Accomplishes All Goals',
    form: '10 Outer Triangles',
    formDescription: 'Ten outer forces — where intention crystallizes into accomplished form',
    count: 10,
    presidingForm: 'Tripura Śrī',
    yogini: 'Kulotīrṇā Yoginī',
    mentalState: 'Turīyātīta — beyond the fourth',
    chakra: 'Viśuddha',
    geometry: 'tri10o',
    appreciationPhrase: 'Thank you for the completion I did not force.',
    personalConnection: 'You have already been here. Every goal that accomplished itself through you — the work that found its form at 2am, the conversation that landed exactly right, the move that succeeded without your fully knowing why — she was behind it. The accomplishment was always hers. You are learning to let the doing be received rather than claimed.',
  },
  {
    id: 6, ring: 6, status: 'locked',
    name: 'Sarvarakṣākara',
    subtitle: 'She Who Protects All',
    form: '10 Inner Triangles',
    formDescription: 'Ten inner forces — the field of sovereign protection that requires nothing from you',
    count: 10,
    presidingForm: 'Tripura Mālinī',
    yogini: 'Nigarbhā Yoginī',
    mentalState: 'Śāmbhavī — pure Śiva-awareness',
    chakra: 'Ājñā',
    geometry: 'tri10i',
    appreciationPhrase: 'Thank you for the grace I didn\'t know was holding me.',
    personalConnection: 'You have already been here. The grace that arrived when nothing should have worked. The softening that came from nowhere. The moment the impossible thing didn\'t happen, and you lived. The harm that passed around you without your understanding why. She was in every moment you emerged intact — not because you were clever or careful, but because she was already there.',
  },
  {
    id: 7, ring: 7, status: 'locked',
    name: 'Sarvarogahara',
    subtitle: 'She Who Removes All Disease',
    form: 'Vāk Ring',
    formDescription: 'Twelve speech goddesses — the level where language and life have not yet separated',
    count: 12,
    presidingForm: 'Tripura Siddha',
    yogini: 'Rahasya Yoginī',
    mentalState: 'Unmanā — beyond mind',
    chakra: 'Bindu',
    geometry: 'tri8',
    appreciationPhrase: 'Thank you for the word that healed what the mind could not reach.',
    personalConnection: 'You have already been here. The word that arrived and moved something lodged for years. The silence that restored you better than any speaking. The sound — a voice, a tone, a name spoken in the right register — that shifted the body before the mind had time to interpret it. She works at the stratum where language is still an event, not a tool.',
  },
  {
    id: 8, ring: 8, status: 'deep_ghost',
    name: 'Sarvasiddhiprada',
    subtitle: 'She Who Grants All Perfections',
    form: 'Mūla Trikoṇa',
    formDescription: 'The root triangle — will, knowledge, and action as a single undivided power',
    count: 3,
    presidingForm: 'Mahā Tripura Sundarī',
    yogini: 'Atirahasya Yoginī',
    mentalState: 'Manonmanī — the summit of mind dissolving',
    chakra: 'Sahasrāra',
    geometry: 'trikona',
    appreciationPhrase: 'Thank you for the perfection that moved through me.',
    personalConnection: 'You have already been here. In the moments when something moved perfectly through you — when will, knowing, and action were one — you were inside this triangle. The performance that transcended technique. The response that arrived before thought. The creation that felt like receiving. It was not your doing. You were the instrument she played.',
  },
  {
    id: 9, ring: 9, status: 'deep_ghost',
    name: 'Sarvanandamaya',
    subtitle: 'She Who Is Made of All Bliss',
    form: 'Bindu',
    formDescription: 'The point — seed and destination of the entire yantra, from which all rings breathe outward',
    count: 1,
    presidingForm: 'Lalitā Mahā Tripura Sundarī',
    yogini: 'Parāparahasya Yoginī',
    mentalState: 'Samādhi — the undivided',
    chakra: 'Brahmarandhra',
    geometry: 'bindu',
    appreciationPhrase: 'Thank you for being the place I have always already arrived.',
    personalConnection: 'You have always been here. This is the only point. The whole yantra is her breathing outward from this single place. The whole game — the 102 Shaktis, the nine rings, the years of recognition — is her breathing back in. The Bindu is not the goal of the practice. It is what the practice is made of.',
  },
];

// ─── Ring 3 — Sarvasankshobhana — The 8 Ananga Shaktis ──────────────────────

const RING3_SHAKTIS = [
  { id: 301, ring: 3, pos: 1, name: 'Anaṅgakusumā',    short: 'Kusumā',
    bija: 'hsauṁ', quality: 'She who blossoms as bodiless beauty — the flower that has no body but is unmistakably present' },
  { id: 302, ring: 3, pos: 2, name: 'Anaṅgamekhalā',   short: 'Mekhalā',
    bija: 'hsauṁ', quality: 'She who girdles — the invisible longing that holds the whole form together' },
  { id: 303, ring: 3, pos: 3, name: 'Anaṅgamadanā',    short: 'Madanā',
    bija: 'hsauṁ', quality: 'She who intoxicates without a body — the inebriation that requires no substance' },
  { id: 304, ring: 3, pos: 4, name: 'Anaṅgamadanāturā',short: 'Madanāturā',
    bija: 'hsauṁ', quality: 'She who is consumed by bodiless longing — the ache that is its own answer' },
  { id: 305, ring: 3, pos: 5, name: 'Anaṅgarekhā',     short: 'Rekhā',
    bija: 'hsauṁ', quality: 'She who traces the line of invisible form — the outline of something felt but not seen' },
  { id: 306, ring: 3, pos: 6, name: 'Anaṅgaveginī',    short: 'Veginī',
    bija: 'hsauṁ', quality: 'She who moves with the speed of desire — arriving before the mind has decided' },
  { id: 307, ring: 3, pos: 7, name: 'Anaṅgāṅkuśā',    short: 'Āṅkuśā',
    bija: 'hsauṁ', quality: 'She who hooks with the goad of longing — the pull that turns the whole body' },
  { id: 308, ring: 3, pos: 8, name: 'Anaṅgamālinī',    short: 'Mālinī',
    bija: 'hsauṁ', quality: 'She who garlands with incorporeal flowers — beauty worn without a body' },
];

// ─── Ring 4 — Sarvasaubhagyadayaka — 14 Shaktis ──────────────────────────────

const RING4_SHAKTIS = [
  { id: 401, ring: 4, pos: 1,  name: 'Sarvasaṅkṣobhiṇī', short: 'Saṅkṣobhiṇī' },
  { id: 402, ring: 4, pos: 2,  name: 'Sarvavidrāviṇī',    short: 'Vidrāviṇī' },
  { id: 403, ring: 4, pos: 3,  name: 'Sarvākarṣiṇī',      short: 'Ākarṣiṇī' },
  { id: 404, ring: 4, pos: 4,  name: 'Sarvāhladinī',      short: 'Āhladinī' },
  { id: 405, ring: 4, pos: 5,  name: 'Sarvasammohini',     short: 'Mohini' },
  { id: 406, ring: 4, pos: 6,  name: 'Sarvastambhinī',     short: 'Stambhinī' },
  { id: 407, ring: 4, pos: 7,  name: 'Sarvajṛmbhiṇī',     short: 'Jṛmbhiṇī' },
  { id: 408, ring: 4, pos: 8,  name: 'Sarvavaśaṅkarī',    short: 'Vaśaṅkarī' },
  { id: 409, ring: 4, pos: 9,  name: 'Sarvarañjanī',       short: 'Rañjanī' },
  { id: 410, ring: 4, pos: 10, name: 'Sarvonmādinī',      short: 'Onmādinī' },
  { id: 411, ring: 4, pos: 11, name: 'Sarvārthasādhikā',  short: 'Sādhikā' },
  { id: 412, ring: 4, pos: 12, name: 'Sarvasampatpūraṇī', short: 'Sampatpūraṇī' },
  { id: 413, ring: 4, pos: 13, name: 'Sarvamantramayi',    short: 'Mantramayi' },
  { id: 414, ring: 4, pos: 14, name: 'Sarvasiddhipradā',   short: 'Siddhipradā' },
];

// ─── Ring 5 — Sarvarthasadhaka — 10 Shaktis ──────────────────────────────────

const RING5_SHAKTIS = [
  { id: 501, ring: 5, pos: 1,  name: 'Sarvasiddhipradā',      short: 'Siddhidā' },
  { id: 502, ring: 5, pos: 2,  name: 'Sarvasampadpradā',      short: 'Sampadā' },
  { id: 503, ring: 5, pos: 3,  name: 'Sarvapriyakarī',        short: 'Priyakarī' },
  { id: 504, ring: 5, pos: 4,  name: 'Sarvamangalakāriṇī',   short: 'Maṅgalā' },
  { id: 505, ring: 5, pos: 5,  name: 'Sarvakāmapradā',        short: 'Kāmadā' },
  { id: 506, ring: 5, pos: 6,  name: 'Sarvaduhkhavimochanī',  short: 'Vimocanī' },
  { id: 507, ring: 5, pos: 7,  name: 'Sarvamṛtyupraśamanī',  short: 'Mṛtyujayā' },
  { id: 508, ring: 5, pos: 8,  name: 'Sarvavighnanivāriṇī',  short: 'Vighnahara' },
  { id: 509, ring: 5, pos: 9,  name: 'Sarvāṅgasundarī',      short: 'Sundarī' },
  { id: 510, ring: 5, pos: 10, name: 'Sarvasaubhāgyadāyinī', short: 'Saubhāgyadā' },
];

// ─── Ring 6 — Sarvarakshakara — 10 Shaktis ───────────────────────────────────

const RING6_SHAKTIS = [
  { id: 601, ring: 6, pos: 1,  name: 'Sarvajñānamayī',       short: 'Jñānamayī' },
  { id: 602, ring: 6, pos: 2,  name: 'Sarvaśaktimayī',       short: 'Śaktimayī' },
  { id: 603, ring: 6, pos: 3,  name: 'Sarvaaiśvaryapradā',   short: 'Aiśvaryā' },
  { id: 604, ring: 6, pos: 4,  name: 'Sarvajñānapradā',      short: 'Jñānapradā' },
  { id: 605, ring: 6, pos: 5,  name: 'Sarvavyādhivinashinī', short: 'Vyadhiharā' },
  { id: 606, ring: 6, pos: 6,  name: 'Sarvādhārasvarūpinī',  short: 'Ādhārā' },
  { id: 607, ring: 6, pos: 7,  name: 'Sarvapāpahara',         short: 'Pāpahara' },
  { id: 608, ring: 6, pos: 8,  name: 'Sarvānandamayī',        short: 'Ānandamayī' },
  { id: 609, ring: 6, pos: 9,  name: 'Sarvarakṣakāriṇī',     short: 'Rakṣakāriṇī' },
  { id: 610, ring: 6, pos: 10, name: 'Sarvepsitaphalapradā',  short: 'Phalapradā' },
];

// ─── Ring 7 — Sarvarogahara — 12 Shaktis (Vagdevata + Shaktis) ───────────────

const RING7_SHAKTIS = [
  { id: 701, ring: 7, pos: 1,  name: 'Vāśinī',          short: 'Vāśinī' },
  { id: 702, ring: 7, pos: 2,  name: 'Kāmeśvarī',       short: 'Kāmeśvarī' },
  { id: 703, ring: 7, pos: 3,  name: 'Modinī',           short: 'Modinī' },
  { id: 704, ring: 7, pos: 4,  name: 'Vimalā',           short: 'Vimalā' },
  { id: 705, ring: 7, pos: 5,  name: 'Aruṇā',            short: 'Aruṇā' },
  { id: 706, ring: 7, pos: 6,  name: 'Jayinī',           short: 'Jayinī' },
  { id: 707, ring: 7, pos: 7,  name: 'Sarveśvarī',      short: 'Sarveśvarī' },
  { id: 708, ring: 7, pos: 8,  name: 'Kaulinī',          short: 'Kaulinī' },
  { id: 709, ring: 7, pos: 9,  name: 'Sarvavāṅmayī',   short: 'Vāṅmayī' },
  { id: 710, ring: 7, pos: 10, name: 'Sarvonmādinī',    short: 'Onmādinī' },
  { id: 711, ring: 7, pos: 11, name: 'Sarvamantreśvarī',short: 'Mantreśī' },
  { id: 712, ring: 7, pos: 12, name: 'Sarvaśaktimayi',  short: 'Śaktimayī' },
];

// ─── Ring 8 — Sarvasiddhiprada — 3 Mula Trikona Shaktis ─────────────────────

const RING8_SHAKTIS = [
  { id: 801, ring: 8, pos: 1, name: 'Kāmeśvarī',   short: 'Icchā-Śakti',
    quality: 'Will — the primal impulse. She is the wanting before want has an object.' },
  { id: 802, ring: 8, pos: 2, name: 'Vajreśvarī',  short: 'Jñāna-Śakti',
    quality: 'Knowledge — the lightning of pure seeing. She is the knowing before knowledge has content.' },
  { id: 803, ring: 8, pos: 3, name: 'Bhagamālinī', short: 'Kriyā-Śakti',
    quality: 'Action — she who makes the possible actual. She is the doing before doing has direction.' },
];

// ─── Ring 9 — Sarvanandamaya — The Bindu Shakti ──────────────────────────────

const RING9_SHAKTI = {
  id: 901, ring: 9, pos: 1,
  name: 'Mahātripurasundarī',
  short: 'Lalitā',
  quality: 'She who is made of all bliss — the undivided ground from which all 102 Shaktis emerge and to which they return',
};

// ─── Ring 1 — Trailokyamohana — 28 Shaktis ───────────────────────────────────

const RING1_SHAKTIS = [
  // 10 Siddhi Shaktis
  { id: 101, ring: 1, pos: 1,  name: 'Animā',          short: 'Animā' },
  { id: 102, ring: 1, pos: 2,  name: 'Laghimā',         short: 'Laghimā' },
  { id: 103, ring: 1, pos: 3,  name: 'Mahimā',          short: 'Mahimā' },
  { id: 104, ring: 1, pos: 4,  name: 'Īśitā',           short: 'Īśitā' },
  { id: 105, ring: 1, pos: 5,  name: 'Vaśitā',          short: 'Vaśitā' },
  { id: 106, ring: 1, pos: 6,  name: 'Prākāmyā',        short: 'Prākāmyā' },
  { id: 107, ring: 1, pos: 7,  name: 'Bhuktī',          short: 'Bhuktī' },
  { id: 108, ring: 1, pos: 8,  name: 'Icchā',           short: 'Icchā' },
  { id: 109, ring: 1, pos: 9,  name: 'Prāptiḥ',         short: 'Prāptiḥ' },
  { id: 110, ring: 1, pos: 10, name: 'Sarvakāmāvalī',   short: 'Sarvakāmā' },
  // 8 Matrika Shaktis
  { id: 111, ring: 1, pos: 11, name: 'Brāhmī',          short: 'Brāhmī' },
  { id: 112, ring: 1, pos: 12, name: 'Māheśvarī',       short: 'Māheśvarī' },
  { id: 113, ring: 1, pos: 13, name: 'Kaumārī',         short: 'Kaumārī' },
  { id: 114, ring: 1, pos: 14, name: 'Vaiṣṇavī',        short: 'Vaiṣṇavī' },
  { id: 115, ring: 1, pos: 15, name: 'Vārāhī',          short: 'Vārāhī' },
  { id: 116, ring: 1, pos: 16, name: 'Māhendrī',        short: 'Māhendrī' },
  { id: 117, ring: 1, pos: 17, name: 'Cāmuṇḍā',         short: 'Cāmuṇḍā' },
  { id: 118, ring: 1, pos: 18, name: 'Mahālakṣmī',      short: 'Mahālakṣmī' },
  // 10 Mudra Shaktis
  { id: 119, ring: 1, pos: 19, name: 'Sarvasaṅkṣobhiṇī', short: 'Saṅkṣobhiṇī' },
  { id: 120, ring: 1, pos: 20, name: 'Sarvavidrāviṇī',   short: 'Vidrāviṇī' },
  { id: 121, ring: 1, pos: 21, name: 'Sarvākarṣiṇī',     short: 'Ākarṣiṇī' },
  { id: 122, ring: 1, pos: 22, name: 'Sarvāhladinī',     short: 'Āhladinī' },
  { id: 123, ring: 1, pos: 23, name: 'Sarvasammohini',    short: 'Mohini' },
  { id: 124, ring: 1, pos: 24, name: 'Sarvastambhinī',    short: 'Stambhinī' },
  { id: 125, ring: 1, pos: 25, name: 'Sarvajṛmbhiṇī',    short: 'Jṛmbhiṇī' },
  { id: 126, ring: 1, pos: 26, name: 'Sarvavaśaṅkarī',   short: 'Vaśaṅkarī' },
  { id: 127, ring: 1, pos: 27, name: 'Sarvarañjanī',      short: 'Rañjanī' },
  { id: 128, ring: 1, pos: 28, name: 'Sarvonmādinī',     short: 'Onmādinī' },
];

// ─── Complete Map by Ring ─────────────────────────────────────────────────────

const SHAKTIS_BY_RING = {
  1: RING1_SHAKTIS,
  2: typeof SHAKTIS !== 'undefined' ? SHAKTIS : [],
  3: RING3_SHAKTIS,
  4: RING4_SHAKTIS,
  5: RING5_SHAKTIS,
  6: RING6_SHAKTIS,
  7: RING7_SHAKTIS,
  8: RING8_SHAKTIS,
  9: [RING9_SHAKTI],
};

// ─── The 15 Nitya Devīs — the canonical tithi-presiding goddesses ────────────
// Distinct from the 102 Khaḍgamāla shaktis. Each tithi in a paksha has her own.
// Names canonical, sourced from Śrīvidyā tradition. Qualities + dhyānas
// flow from Airtable — DO NOT INVENT THESE FIELDS. The schema below is the
// rendering contract; Airtable fills the descriptive text.

const NITYA_DEVIS = [
  { tithi:  1, tithiName: 'Pratipadā',  name: 'Kāmeśvarī',       quality: null, bija: null, dhyana: null },
  { tithi:  2, tithiName: 'Dvitīyā',    name: 'Bhagamālinī',     quality: null, bija: null, dhyana: null },
  { tithi:  3, tithiName: 'Tṛtīyā',     name: 'Nityaklinnā',     quality: null, bija: null, dhyana: null },
  { tithi:  4, tithiName: 'Caturthī',   name: 'Bheruṇḍā',        quality: null, bija: null, dhyana: null },
  { tithi:  5, tithiName: 'Pañcamī',    name: 'Vahnivāsinī',     quality: null, bija: null, dhyana: null },
  { tithi:  6, tithiName: 'Ṣaṣṭhī',     name: 'Mahāvajreśvarī',  quality: null, bija: null, dhyana: null },
  { tithi:  7, tithiName: 'Saptamī',    name: 'Śivadūtī',        quality: null, bija: null, dhyana: null },
  { tithi:  8, tithiName: 'Aṣṭamī',     name: 'Tvaritā',         quality: null, bija: null, dhyana: null },
  { tithi:  9, tithiName: 'Navamī',     name: 'Kulasundarī',     quality: null, bija: null, dhyana: null },
  { tithi: 10, tithiName: 'Daśamī',     name: 'Nityā',           quality: null, bija: null, dhyana: null },
  { tithi: 11, tithiName: 'Ekādaśī',    name: 'Nīlapatākā',      quality: null, bija: null, dhyana: null },
  { tithi: 12, tithiName: 'Dvādaśī',    name: 'Vijayā',          quality: null, bija: null, dhyana: null },
  { tithi: 13, tithiName: 'Trayodaśī',  name: 'Sarvamaṅgalā',    quality: null, bija: null, dhyana: null },
  { tithi: 14, tithiName: 'Caturdaśī',  name: 'Jvālāmālinī',     quality: null, bija: null, dhyana: null },
  { tithi: 15, tithiName: 'Pūrṇimā',    name: 'Citrā',           quality: null, bija: null, dhyana: null },
];

Object.assign(window, {
  AVARANAS,
  RING1_SHAKTIS, RING3_SHAKTIS, RING4_SHAKTIS, RING5_SHAKTIS,
  RING6_SHAKTIS, RING7_SHAKTIS, RING8_SHAKTIS, RING9_SHAKTI,
  SHAKTIS_BY_RING,
  NITYA_DEVIS,
});

