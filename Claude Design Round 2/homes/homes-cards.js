// homes-cards.js — the Śakti cards, rings 3–9. Every field real, from the base.
// Compact tuple form: [pos, name, dev, quality, tattva, location, seat, phrase]
// `seat` is the etymological root pair used by the rite's third beat.

const C = (pos, name, dev, quality, tattva, loc, roots, phrase) =>
  ({ pos, name, dev, quality, tattva, loc, roots, phrase });

// RING 3 — the Anaṅgas. Bodiless: effect without form.
export const R3 = [
  C(45, 'Anaṅga-Kusumā', 'अनङ्गकुसुमा', 'Subtle Beauty', 'Puṣpa — the flower, first arrow', 'Heart / olfactory threshold', ['Anaṅga', 'Kusuma'], 'Thank you for the beauty that doesn\u2019t need to be held.'),
  C(46, 'Anaṅga-Mekhalā', 'अनङ्गमेखला', 'Encircling Intimacy', 'Āliṅgana — subtle embrace', 'Waist / encircling field', ['Anaṅga', 'Mekhalā'], 'Thank you for the holding that doesn\u2019t grasp.'),
  C(47, 'Anaṅga-Madanā', 'अनङ्गमदना', 'Subtle Intoxication', 'Mada-rasa — intoxication-essence', 'Behind the eyes / soft palate', ['Anaṅga', 'Madana'], 'Thank you for the alteration that doesn\u2019t dull.'),
  C(48, 'Anaṅga-Madanāturā', 'अनङ्गमदनातुरा', 'Pure Longing', 'Virahāgni — separation-fire', 'Throat / sternum', ['Anaṅga', 'Madanāturā'], 'Thank you for the longing that is its own answer.'),
  C(49, 'Anaṅga-Rekhā', 'अनङ्गरेखा', 'Suggested Form', 'Sūkṣmākṛti — subtle outline', 'Eyes / spine inclining', ['Anaṅga', 'Rekhā'], 'Thank you for the line that suggests without saying.'),
  C(50, 'Anaṅga-Veginī', 'अनङ्गवेगिनी', 'Subtle Velocity', 'Vega — subtle impulse', 'Heart / first reflexes', ['Anaṅga', 'Vegin'], 'Thank you for the velocity that crosses distance without measuring it.'),
  C(51, 'Anaṅga-Aṅkuśā', 'अनङ्गाङ्कुशा', 'Subtle Hook', 'Smaraṇa — subtle remembering', 'Heart hook / between the eyes', ['Anaṅga', 'Aṅkuśa'], 'Thank you for the hook that returns me.'),
  C(52, 'Anaṅga-Mālinī', 'अनङ्गमालिनी', 'Subtle Adornment', 'Saundarya — innate beauty', 'Whole field / perceptual atmosphere', ['Anaṅga', 'Mālinī'], 'Thank you for the adornment that needs no adorning.'),
];

// RING 4 — Sampradāya, the lineage. Cosmic scale: one mind becomes all creation.
export const R4 = [
  C(53, 'Sarva-Saṅkṣobhiṇī', 'सर्वसंक्षोभिणी', 'Cosmic Stirring', 'Kṣobha — cosmic agitation', 'Whole field beginning to move', ['Sarva', 'Saṅkṣobhiṇī'], 'Thank you for the stirring that has become a goddess.'),
  C(54, 'Sarva-Vidrāviṇī', 'सर्वविद्राविणी', 'Cosmic Flow', 'Dravatā — fluidity itself', 'Joints, lymph, all fluids', ['Sarva', 'Vidrāviṇī'], 'Thank you for the flow that makes life possible.'),
  C(55, 'Sarva-Ākarṣiṇī', 'सर्वाकर्षिणी', 'Universal Magnetism', 'Ākarṣaṇa — universal attraction', 'Heart / centre of gravity', ['Sarva', 'Ākarṣiṇī'], 'Thank you for the attraction that births the sixteen daughters.'),
  C(56, 'Sarva-Āhlādinī', 'सर्वाह्लादिनी', 'Cosmic Joy', 'Ānanda — substrate-bliss', 'Face / chest', ['Sarva', 'Āhlāda'], 'Thank you for the joy that has no reason.'),
  C(57, 'Sarva-Sammohinī', 'सर्वसम्मोहिनी', 'Divine Bewilderment', 'Moha — sacred bewilderment', 'Forehead / behind the eyes', ['Sarva', 'Sammohanī'], 'Thank you for the bewilderment that breaks the trance.'),
  C(58, 'Sarva-Sthambhinī', 'सर्वस्तम्भिनी', 'Cosmic Stillness', 'Stambha — the cosmic pillar', 'Diaphragm / breath turn', ['Sarva', 'Sthambhinī'], 'Thank you for the stillness that holds movement.'),
  C(59, 'Sarva-Jṛmbhinī', 'सर्वजृम्भिणी', 'Cosmic Expansion', 'Vikāsa — expansion', 'Whole body extending', ['Sarva', 'Jṛmbha'], 'Thank you for the expansion that comes from the depths.'),
  C(60, 'Sarva-Vaśaṅkarī', 'सर्ववशंकरी', 'Cosmic Yielding', 'Vaśya — cosmic resonance', 'Heart-field / radiance from chest', ['Sarva', 'Vaśaṅkarī'], 'Thank you for the influence that needs no force.'),
  C(61, 'Sarva-Rañjinī', 'सर्वरञ्जिनी', 'Cosmic Colouring', 'Rañjana — aesthetic charge', 'Eyes / ears / aesthetic field', ['Sarva', 'Rañj'], 'Thank you for the colouring that makes life vivid.'),
  C(62, 'Sarva-Onmādinī', 'सर्वोन्मादिनी', 'Cosmic Intoxication', 'Unmāda — divine intoxication', 'Third eye / aesthetic field', ['Sarva', 'Onmādinī'], 'Thank you for the intoxication that doesn\u2019t intoxicate.'),
  C(63, 'Sarvārthasādhikā', 'सर्वार्थसाधिका', 'Cosmic Fulfilment', 'Sādhana-siddhi — accomplishment-fruit', 'Solar plexus / centre of action', ['Sarva', 'Artha', 'Sādhikā'], 'Thank you for the accomplishment that comes without striving.'),
  C(64, 'Sarva-Sampatpūraṇī', 'सर्वसम्पत्पूरणी', 'Cosmic Abundance', 'Pūrṇatā — fullness', 'Belly / abundance-field', ['Sarva', 'Sampat', 'Pūraṇī'], 'Thank you for the abundance that is the field itself.'),
  C(65, 'Sarva-Mantramayī', 'सर्वमन्त्रमयी', 'Cosmic Mantra', 'Mantra-svarūpa — mantric form of reality', 'Throat / breath-rhythm', ['Sarva', 'Mantra', 'Mayī'], 'Thank you for the mantric quality of being itself.'),
  C(66, 'Sarva-Dvandvakṣayaṅkarī', 'सर्वद्वन्द्वक्षयंकरी', 'Cosmic Non-Duality', 'Advaita — non-duality', 'Heart / non-dual point', ['Sarva', 'Dvandva', 'Kṣaya'], 'Thank you for the dissolving of duality.'),
];

// RING 5 — Kulottīrṇa, beyond the clan. The givers: every one bestows.
export const R5 = [
  C(67, 'Sarva-Siddhipradā', 'सर्वसिद्धिप्रदा', 'All-Attainment', 'Siddhi-mātrā — attainment-substrate', 'Hands / capacity-centre', ['Sarva', 'Siddhi', 'Pradā'], 'Thank you for the attainments that ripen with practice.'),
  C(68, 'Sarva-Sampatpradā', 'सर्वसम्पत्प्रदा', 'All-Abundance', 'Sampat-mātrā — abundance-substrate', 'Belly / abundance-centre', ['Sarva', 'Sampat', 'Pradā'], 'Thank you for the abundance in both house and heart.'),
  C(69, 'Sarva-Priyaṅkarī', 'सर्वप्रियंकरी', 'All-Love', 'Priyatā — innate dearness', 'Heart', ['Sarva', 'Priya', 'Kāriṇī'], 'Thank you for the love that makes everything dear.'),
  C(70, 'Sarva-Maṅgalakāriṇī', 'सर्वमङ्गलकारिणी', 'All-Auspiciousness', 'Maṅgala — auspicious essence', 'Crown / morning-light field', ['Sarva', 'Maṅgala', 'Kāriṇī'], 'Thank you for the auspiciousness that arrives in the ordinary.'),
  C(71, 'Sarva-Kāmapradā', 'सर्वकामप्रदा', 'Desire-Fulfilling', 'Kāma-pūrti — desire-fulfilment', 'Heart / desire-centre', ['Sarva', 'Kāma', 'Pradā'], 'Thank you for the fulfilment of the heart\u2019s truest wish.'),
  C(72, 'Sarva-Duḥkhavimocanī', 'सर्वदुःखविमोचनी', 'Sorrow-Liberation', 'Duḥkha-vimukti — liberation-from-sorrow', 'Heart / chest', ['Sarva', 'Duḥkha', 'Vimocanī'], 'Thank you for the freedom from sorrow that doesn\u2019t deny it.'),
  C(73, 'Sarva-Mṛtyupraśamani', 'सर्वमृत्युप्रशमनी', 'Death-Pacification', 'Amṛtatva — deathlessness recognised', 'Whole body / cellular level', ['Sarva', 'Mṛtyu', 'Praśamani'], 'Thank you for the peace with death that lets life be fully lived.'),
  C(74, 'Sarva-Vighnanivāriṇī', 'सर्वविघ्ननिवारिणी', 'Obstacle-Removal', 'Vighna-laya — obstacle-dissolution', 'Wherever the block was held', ['Sarva', 'Vighna', 'Nivāriṇī'], 'Thank you for clearing the path of what only seemed to block it.'),
  C(75, 'Sarvāṅgasundarī', 'सर्वाङ्गसुन्दरी', 'Complete Beauty', 'Sarvasundaratā — universal beauty', 'Whole body', ['Sarva', 'Aṅga', 'Sundarī'], 'Thank you for the beauty that includes every part.'),
  C(76, 'Sarva-Saubhāgyadāyinī', 'सर्वसौभाग्यदायिनी', 'All-Good-Fortune', 'Saubhāgya-svarūpa — good-fortune nature', 'Heart / good-fortune field', ['Sarva', 'Saubhāgya', 'Dāyinī'], 'Thank you for the fortune that I recognise as already given.'),
];

// RING 6 — Nigarbha, inside the womb. The revealers: each shows what was always true.
export const R6 = [
  C(77, 'Sarvajñā', 'सर्वज्ञा', 'All-Knowing', 'Sarvajñatva — omniscient awareness', 'Third eye / direct-seeing point', ['Sarva', 'Jñā'], 'Thank you for the knowing that goes to the essence.'),
  C(78, 'Sarvaśakti', 'सर्वशक्ति', 'All-Power', 'Sarvasāmarthya — universal capacity', 'Whole body / spine', ['Sarva', 'Śakti'], 'Thank you for the power that needs no conditions.'),
  C(79, 'Sarvaiśvaryapradāyinī', 'सर्वैश्वर्यप्रदायिनी', 'All-Sovereignty', 'Aiśvarya — innate sovereignty', 'Crown / spine', ['Sarva', 'Aiśvarya', 'Pradāyinī'], 'Thank you for the sovereignty that I recognise as my own.'),
  C(80, 'Sarvajñānamayī', 'सर्वज्ञानमयी', 'All-Knowledge', 'Jñāna — substrate-knowledge', 'Whole field / awareness-substrate', ['Sarva', 'Jñāna', 'Mayī'], 'Thank you for the knowledge that is the field of being.'),
  C(81, 'Sarvavyādhivināśinī', 'सर्वव्याधिविनाशिनी', 'All-Healing', 'Ārogya — innate wholeness', 'Wherever healing is needed', ['Sarva', 'Vyādhi', 'Vināśinī'], 'Thank you for the healing that comes through recognition.'),
  C(82, 'Sarvādhārasvarūpā', 'सर्वाधारस्वरूपा', 'Universal Support', 'Ādhāra-svarūpa — substrate-form', 'Mūlādhāra / soles of the feet', ['Sarva', 'Ādhāra', 'Svarūpā'], 'Thank you for the support that is the ground I\u2019m standing on.'),
  C(83, 'Sarvapāpaharā', 'सर्वपापहरा', 'Error-Dissolution', 'Nirdoṣa — essentially faultless', 'Shoulders / heart', ['Sarva', 'Pāpa', 'Harā'], 'Thank you for the recognition that dissolves what only seemed like sin.'),
  C(84, 'Sarvānandamayī', 'सर्वानन्दमयी', 'All-Bliss', 'Ānanda — substrate-bliss', 'Whole body / substrate-recognition', ['Sarva', 'Ānanda', 'Mayī'], 'Thank you for the bliss that is the texture of being.'),
  C(85, 'Sarvarakṣāsvarūpiṇī', 'सर्वरक्षास्वरूपिणी', 'Universal Protection', 'Rakṣaṇa — innate protection', 'Whole body / held-field', ['Sarva', 'Rakṣā', 'Svarūpiṇī'], 'Thank you for being the protection rather than the protector.'),
  C(86, 'Sarvepsitaphalapradā', 'सर्वेप्सितफलप्रदा', 'Fruit-of-Desire', 'Phala-prāpti — fruit-attainment', 'Hands receiving / heart receiving', ['Sarva', 'Ipsita', 'Phala'], 'Thank you for the fruit of what I have longed for.'),
];

// RING 7 — the eight Vāsinīs (speech) and the four Weapons.
export const R7 = [
  C(87, 'Vasinī', 'वशिनी', 'Inner-Speech-Origin', 'Para-Vāc — supreme speech', 'Heart-throat axis', ['Vaśin'], 'Thank you for the speech-source where the word is heard before said.'),
  C(88, 'Kāmeśī', 'कामेशी', 'Desire-Speech', 'Kāma-vāc — desire-speech', 'Throat, desire-charged', ['Kāma', 'Īśī'], 'Thank you for the speech that carries desire purely.'),
  C(89, 'Modinī', 'मोदिनी', 'Joyful-Speech', 'Moda-vāc — joy-speech', 'Mouth / palate, smiling', ['Moda'], 'Thank you for the speech that arrives with joy.'),
  C(90, 'Vimalā', 'विमला', 'Pure-Speech', 'Vimalatā — essential purity', 'Throat, clear', ['Vi', 'Mala'], 'Thank you for the speech that does not distort.'),
  C(91, 'Aruṇā', 'अरुणा', 'Dawn-Speech', 'Uṣā — dawn-presence', 'Throat, luminous', ['Aruṇa'], 'Thank you for the speech that breaks dawn within.'),
  C(92, 'Jayinī', 'जयिनी', 'Triumphant-Speech', 'Jaya — innate triumph', 'Throat / chest, resonant', ['Ji'], 'Thank you for the speech that wins by being true.'),
  C(93, 'Sarveśī', 'सर्वेशी', 'All-Governing-Speech', 'Sarveśatva — universal lordship in speech', 'Throat / breath-rhythm', ['Sarva', 'Īśī'], 'Thank you for the speech that holds all together.'),
  C(94, 'Kaulinī', 'कौलिनी', 'Lineage-Speech', 'Kula-saṃtati — lineage-continuity', 'Whole throat-mouth field', ['Kula'], 'Thank you for the speech that carries the lineage forward.'),
  C(95, 'Bāṇinī', 'बाणिनी', 'Five-Arrow-Śakti', 'Pañcabāṇa — the five arrows', 'The five sense-gates', ['Bāṇa'], 'Thank you for the arrows that pierce through five doors.'),
  C(96, 'Cāpinī', 'चापिनी', 'Sugarcane-Bow', 'Cāpa — cosmic bow-tension', 'Spine / drawn-back posture', ['Cāpa'], 'Thank you for the bow that holds tension into release.'),
  C(97, 'Pāśinī', 'पाशिनी', 'Binding-Love', 'Pāśa — devotional binding', 'Heart, looped', ['Pāśa'], 'Thank you for the noose of love that holds without binding.'),
  C(98, 'Aṅkuśinī', 'अङ्कुशिनी', 'Directing-Goad', 'Aṅkuśa — cosmic directing', 'Third eye / inward-turning point', ['Aṅkuśa'], 'Thank you for the goad that turns me toward the source.'),
];

// RING 8 — the Primordial Triad. Icchā, Kriyā, Jñāna at the source.
export const R8 = [
  C(99, 'Kāmeśvarī', 'कामेश्वरी', 'Will-to-Create', 'Icchā at the source', 'Third eye / point-of-origin', ['Kāma', 'Īśvarī'], 'Thank you for the will that initiates creation.'),
  C(100, 'Vajreśī', 'वज्रेशी', 'Lightning-Action', 'Kriyā at the source', 'Heart / hands', ['Vajra', 'Īśī'], 'Thank you for the lightning that becomes action.'),
  C(101, 'Bhagamālinī', 'भगमालिनी', 'Manifestation-Garland', 'Jñāna at the source', 'Belly / yoni / point-of-manifestation', ['Bhaga', 'Mālinī'], 'Thank you for the manifestation garlanded with knowing.'),
];

// RING 9 — the Bindu.
export const R9 = [
  C(102, 'Mahātripurasundarī', 'महात्रिपुरसुन्दरी', 'The Source-Beauty', 'Para-Bindu — the supreme point', 'The point at which all locations converge', ['Mahā', 'Tri', 'Pura', 'Sundarī'], 'Thank you for being. Thank you for being everything. Thank you for being me.'),
];


// RING 1 — Trailokyamohana. Three families: the Siddhis, the Mātṛkās, the Mudrās.
export const R1 = [
  C(1, 'Aṇimā', 'अणिमा', 'Smallness', 'Aṇu — the atomic', 'Bindu point at crown / single point of attention', ['Aṇu', 'imā'], 'Thank you for the smallness that contains all.'),
  C(2, 'Mahimā', 'महिमा', 'Vastness', 'Mahat — the vast', 'Periphery / horizon of attention', ['Mahā', 'imā'], 'Thank you for the vastness that holds all.'),
  C(3, 'Laghimā', 'लघिमा', 'Lightness', 'Vāyu — air, movement', 'Solar plexus rising upward', ['Laghu', 'imā'], 'Thank you for the lightness that lets me move.'),
  C(4, 'Garimā', 'गरिमा', 'Weightedness', 'Pṛthvī — earth', 'Mūlādhāra / sit-bones / soles', ['Guru', 'imā'], 'Thank you for the weight that holds me here.'),
  C(5, 'Īśitva', 'ईशित्व', 'Sovereignty', 'Īśvara-tattva — the lord-principle', 'Crown and spine alignment', ['Īśa', 'tva'], 'Thank you for the sovereignty that knows itself.'),
  C(6, 'Vaśitva', 'वशित्व', 'Mastery', 'Saṃyama — integration', 'Throat / lungs', ['Vaśa', 'tva'], 'Thank you for the mastery that comes from being mastered.'),
  C(7, 'Prākāmya', 'प्राकाम्य', 'Irresistible Will', 'Saṅkalpa — resolute intention', 'Solar plexus / hands', ['Pra', 'kāma', 'ya'], 'Thank you for the will that flows.'),
  C(8, 'Bhukti', 'भुक्ति', 'Enjoyment', 'Rasa — essential taste', 'Mouth / belly / whole body', ['Bhuj', 'ti'], 'Thank you for the enjoyment that includes everything.'),
  C(9, 'Icchā', 'इच्छा', 'Willingness', 'Icchā-śakti — will-power, first of the three', 'Heart / first impulse', ['Iṣ', 'icchā'], 'Thank you for the willing that begins everything.'),
  C(10, 'Prāpti', 'प्राप्ति', 'Reach', 'Pūrṇatā — fullness in arrival', 'Hands / lips / point of contact', ['Pra-āp', 'ti'], 'Thank you for the reach that meets its object.'),
  C(11, 'Brāhmī', 'ब्राह्मी', 'Creation', 'Vāc — speech, sacred utterance', 'Throat, the vowel-source', ['Brahma', 'ī'], 'Thank you for the speech that begins.'),
  C(12, 'Māheśvarī', 'माहेश्वरी', 'Witness', 'Ākāśa — space, sky', 'Throat, back / soft palate', ['Mahā', 'Īśvarī'], 'Thank you for the throat that holds sound.'),
  C(13, 'Kaumārī', 'कौमारी', 'Fierce Youth', 'Tejas — light, the fire-seed', 'Eyes / face / palate', ['Kumāra', 'ī'], 'Thank you for the fierce youth that protects.'),
  C(14, 'Vaiṣṇavī', 'वैष्णवी', 'Preservation', 'Sthiti — the sustenance principle', 'Heart centre / retroflex region', ['Viṣṇu', 'ī'], 'Thank you for the holding that sustains.'),
  C(15, 'Vārāhī', 'वाराही', 'Dissolution', 'Bhūmi — the earth principle', 'Belly / sacrum', ['Varāha', 'ī'], 'Thank you for the dissolving that integrates.'),
  C(16, 'Indrāṇī', 'इन्द्राणी', 'Heart-Sovereignty', 'Indriya — the senses unified', 'Heart / chest / lips', ['Indra', 'āṇī'], 'Thank you for the sovereignty of the heart.'),
  C(17, 'Cāmuṇḍā', 'चामुण्डा', 'Liberation', 'Pralaya — final dissolution', 'Whole body / cremation-ground awareness', ['Caṇḍa', 'Muṇḍa'], 'Thank you for the fierce liberation that consumes illusion.'),
  C(18, 'Mahālakṣmī', 'महालक्ष्मी', 'Wholeness', 'Pūrṇa — fullness', 'Whole body unified', ['Mahā', 'Lakṣmī'], 'Thank you for the wholeness that is all of them.'),
  C(19, 'Sarva-Saṅkṣobhiṇī', 'सर्वसंक्षोभिणी', 'Stirring', 'Kṣobha — agitation', 'Whole field stirring', ['Sarva', 'Saṅkṣobha'], 'Thank you for the stirring that begins the path.'),
  C(20, 'Sarva-Vidrāviṇī', 'सर्वविद्राविणी', 'Melting', 'Apaḥ — the water principle', 'Joints / fluid systems', ['Sarva', 'Vidrāvaṇa'], 'Thank you for the melting that lets all flow.'),
  C(21, 'Sarva-Ākarṣiṇī', 'सर्वाकर्षिणी', 'Magnetism', 'Karṣaṇa — drawing-toward', 'Heart / centre of attention', ['Sarva', 'Ākarṣaṇa'], 'Thank you for the attraction that draws all home.'),
  C(22, 'Sarva-Vaśaṅkarī', 'सर्ववशंकरी', 'Yielding', 'Vaśya — yielding', 'Heart-centre / breath turning points', ['Sarva', 'Vaśaṅkāra'], 'Thank you for the yielding that needs no force.'),
  C(23, 'Sarva-Onmādinī', 'सर्वोन्मादिनी', 'Intoxication', 'Mada — divine intoxication', 'Third eye / behind the eyes', ['Sarva', 'Unmāda'], 'Thank you for the intoxication that brings clarity.'),
  C(24, 'Sarva-Mahāṅkuśā', 'सर्वमहाङ्कुशा', 'Direction', 'Aṅkuśa — the directing force', 'Navel hook / third eye', ['Sarva', 'Mahā-Aṅkuśa'], 'Thank you for the goading that keeps me on the path.'),
  C(25, 'Sarva-Khecarī', 'सर्वखेचरी', 'Freedom', 'Khe — sky, the void of consciousness', 'Tongue / soft palate / crown', ['Sarva', 'Khe', 'Carī'], 'Thank you for the sky-walking freedom.'),
  C(26, 'Sarva-Bīja', 'सर्वबीज', 'Potential', 'Bīja — the seed principle', 'Hands at heart / single point of attention', ['Sarva', 'Bīja'], 'Thank you for the seed that holds everything.'),
  C(27, 'Sarva-Yoni', 'सर्वयोनि', 'Source', 'Yoni — the source-aperture', 'Lower belly / pelvic floor', ['Sarva', 'Yoni'], 'Thank you for the womb that births all.'),
  C(28, 'Sarva-Trikhaṇḍā', 'सर्वत्रिखण्डा', 'Trinity-as-Unity', 'Tri-eka — three-as-one', 'Crown opening to beyond', ['Sarva', 'Tri', 'Khaṇḍa'], 'Thank you for the three that becomes one.'),
];

// RING 2 — the home ring. Each Karṣiṇī carries her own tattva, and several are
// deliberately CROSSED: the faculty she draws and the organ she is given do not
// match. That counterpoint is her mechanism, not an error in the base.
export const R2 = [
  C(29, 'Kāmākarṣiṇī', 'कामाकर्षिणी', 'Kāma', 'Pṛthivī — earth', 'Pelvic basin, gut, chest leaning forward', ['Kāma', 'ākarṣiṇī'], 'Thank you for the desire that moves me toward life.'),
  C(30, 'Buddhyākarṣiṇī', 'बुद्ध्याकर्षिणी', 'Buddhi', 'Ap / jala — water', 'Forehead, eyes', ['Buddhi', 'ākarṣiṇī'], 'Thank you for the knowing that recognises.'),
  C(31, 'Ahaṅkārākarṣiṇī', 'अहंकाराकर्षिणी', 'Ahaṅkāra', 'Tejas / agni — fire', 'Solar plexus, shoulders', ['Ahaṅkāra', 'ākarṣiṇī'], 'Thank you for the I that says I.'),
  C(32, 'Śabdākarṣiṇī', 'शब्दाकर्षिणी', 'Śabda', 'Vāyu — air', 'Ears, back of skull', ['Śabda', 'ākarṣiṇī'], 'Thank you for the sound that becomes meaning.'),
  C(33, 'Sparśākarṣiṇī', 'स्पर्शाकर्षिणी', 'Sparśa', 'Ākāśa — ether', 'Everywhere skin meets world — palms, lips, soles', ['Sparśa', 'ākarṣiṇī'], 'Thank you for the touch that says I am here.'),
  C(34, 'Rūpākarṣiṇī', 'रूपाकर्षिणी', 'Rūpa', 'Śrotra — the ear', 'Eyes, front of face', ['Rūpa', 'ākarṣiṇī'], 'Thank you for the form that becomes seen.'),
  C(35, 'Rasākarṣiṇī', 'रसाकर्षिणी', 'Rasa', 'Tvak — the skin', 'Tongue, throat', ['Rasa', 'ākarṣiṇī'], 'Thank you for the taste that becomes savour.'),
  C(36, 'Gandhākarṣiṇī', 'गन्धाकर्षिणी', 'Gandha', 'Cakṣus — the eye', 'Bridge of the nose', ['Gandha', 'ākarṣiṇī'], 'Thank you for the scent that becomes memory.'),
  C(37, 'Cittākarṣiṇī', 'चित्ताकर्षिणी', 'Citta', 'Jihvā — the tongue', 'Behind the heart', ['Citta', 'ākarṣiṇī'], 'Thank you for the mind that holds all this.'),
  C(38, 'Dhairyākarṣiṇī', 'धैर्याकर्षिणी', 'Dhairya', 'Ghrāṇa — the nose', 'Back-body, spine', ['Dhairya', 'ākarṣiṇī'], 'Thank you for the courage to hold ground.'),
  C(39, 'Smṛtyākarṣiṇī', 'स्मृत्याकर्षिणी', 'Smṛti', 'Vāk — speech', 'Eyes turning inward', ['Smṛti', 'ākarṣiṇī'], 'Thank you for the memory that returns me to myself.'),
  C(40, 'Nāmākarṣiṇī', 'नामाकर्षिणी', 'Nāma', 'Pāṇi — the hand', 'Throat, whole body settling', ['Nāma', 'ākarṣiṇī'], 'Thank you for the name that lets me be called.'),
  C(41, 'Bījākarṣiṇī', 'बीजाकर्षिणी', 'Bīja', 'Pāda — the foot', 'Deep belly', ['Bīja', 'ākarṣiṇī'], 'Thank you for the seed that becomes everything.'),
  C(42, 'Ātmākarṣiṇī', 'आत्माकर्षिणी', 'Ātman', 'Pāyu — release, elimination. Self-recognition comes through letting go.', 'The body\u2019s centre', ['Ātmā', 'ākarṣiṇī'], 'Thank you for the Self that witnesses.'),
  C(43, 'Amṛtākarṣiṇī', 'अमृताकर्षिणी', 'Amṛta', 'Upastha — generation. The procreative power and the nectar of immortality are both fluids of continuance.', 'Soft palate, crown', ['Amṛta', 'ākarṣiṇī'], 'Thank you for the deathless that remains.'),
  C(44, 'Śarīrākarṣiṇī', 'शरीराकर्षिणी', 'Śarīra', 'Manas — mind. THE KEY PAIRING: body and mind at the exact same point.', 'Whole body, ground', ['Śarīra', 'ākarṣiṇī'], 'Thank you for the body that holds the soul.'),
];

// Ring 1's three families, and Ring 2's clusters — they share corridors.
export const R1_FAMILY = (pos) => (pos <= 10 ? 'siddhi' : pos <= 18 ? 'matrka' : 'mudra');
export const R2_CLUSTER = (pos) =>
  pos <= 31 ? 'instrument' : pos <= 36 ? 'tanmatra' : pos === 37 ? 'citta' : pos <= 41 ? 'stability' : 'self';

// Her bīja syllable, from the cards. Rings 1–2 name theirs per-Śakti.
export const SYLLABLE = {
  11: 'Aṃ', 12: 'Kaṃ', 13: 'Caṃ', 14: 'Ṭaṃ', 15: 'Taṃ', 16: 'Paṃ', 17: 'Yaṃ', 18: 'Aim',
  29: 'aṃ', 30: 'āṃ', 31: 'iṃ', 32: 'īṃ', 33: 'uṃ', 34: 'ūṃ', 35: 'ṛṃ', 36: 'ṝṃ',
  37: 'ḷṃ', 38: 'ḹṃ', 39: 'eṃ', 40: 'aiṃ', 41: 'oṃ', 42: 'auṃ', 43: 'aṃ', 44: 'aḥ',
};

// THE CROSSING — Ring 2's deliberate counterpoint. Her quality names one faculty;
// her tattva gives a different organ. The room presents one and answers in the other.
export const CROSSED = {
  34: ['form', 'ear'], 35: ['taste', 'skin'], 36: ['scent', 'eye'],
  37: ['mind', 'tongue'], 38: ['courage', 'nose'], 39: ['memory', 'speech'],
  40: ['name', 'hand'], 41: ['seed', 'foot'], 42: ['self', 'release'],
  43: ['deathless', 'generation'], 44: ['body', 'mind'],
};


// ── HER ATTRIBUTE ──────────────────────────────────────────────────────────
// The brief: "Iconography — her form, posture, attribute and colour. Every
// colour word, every held object, every posture is a design instruction."
//
// So her held object becomes the room's one ACTOR: a shape performing the single
// action it exists to perform. A noose is not a figure — it is a loop that
// draws the vast into the tiny. Aniconic, and hers alone.
//
// Read from the Iconography line of each card. Nothing invented; where a card
// names a gesture rather than an object, the gesture is the actor.
export const ATTRIBUTE = {
  1: 'noose', 2: 'goad', 3: 'veil', 4: 'palm', 5: 'sceptre', 6: 'noose', 7: 'bow',
  8: 'cup', 9: 'lotus', 10: 'hook', 11: 'rosary', 12: 'trident', 13: 'spear',
  14: 'discus', 15: 'plough', 16: 'vajra', 17: 'skullcup', 18: 'lotus',
  19: 'seal', 20: 'seal', 21: 'hand', 22: 'palm', 23: 'seal', 24: 'goad',
  25: 'seal', 26: 'seed', 27: 'triangle', 28: 'triad',
  29: 'noose', 30: 'flame', 31: 'hand', 32: 'ear', 33: 'palm', 34: 'mirror',
  35: 'cup', 36: 'lotus', 37: 'gaze', 38: 'spine', 39: 'gaze', 40: 'syllable',
  41: 'seed', 42: 'gaze', 43: 'drop', 44: 'palm',
  45: 'flower', 46: 'belt', 47: 'gaze', 48: 'hand', 49: 'line', 50: 'streamer',
  51: 'hook', 52: 'garland',
  53: 'churn', 54: 'molten', 55: 'hand', 56: 'pour', 57: 'veil', 58: 'palm',
  59: 'stretch', 60: 'palm', 61: 'brush', 62: 'cup', 63: 'gem', 64: 'grain',
  65: 'syllable', 66: 'triangle',
  67: 'boon', 68: 'grain', 69: 'flower', 70: 'lamp', 71: 'fruit', 72: 'chain',
  73: 'drop', 74: 'goad', 75: 'radiance', 76: 'boon',
  77: 'flame', 78: 'radiance', 79: 'sceptre', 80: 'radiance', 81: 'herb',
  82: 'ground', 83: 'cleanse', 84: 'radiance', 85: 'shield', 86: 'fruit',
  87: 'rosary', 88: 'bow', 89: 'cup', 90: 'water', 91: 'noose', 92: 'banner',
  93: 'sceptre', 94: 'skullcup', 95: 'arrows', 96: 'bow', 97: 'noose', 98: 'goad',
  99: 'radiance', 100: 'vajra', 101: 'garland', 102: 'arrows',
};

// The colour word her card gives her attribute, where it gives one — it tints
// her actor without touching her āvaraṇa's light.
export const ATTR_TINT = {
  1: 0xf2ecd8, 4: 0xb8263c, 7: 0xff7a3c, 13: 0xffb45c, 15: 0x6a5f78,
  17: 0xd8d2c4, 18: 0xffd76a, 29: 0xff6a7c, 45: 0xffb0c4, 62: 0xff8ab0,
  91: 0xff7a5c, 92: 0xffd76a, 99: 0xfff6e2, 100: 0xff4a5c, 101: 0xffd76a,
};

export const CARDS = {};
// A name key that survives the difference between the cards and the app's data:
// 'Anaṅga-Kusumā' and 'Anaṅgakusumā' must reach the same card. Diacritics are
// preserved — they are meaning, not noise.
export const nameKey = (s) => String(s || '').toLowerCase().replace(/[\s\-·.'’()]/g, '');
[[1, R1], [2, R2], [3, R3], [4, R4], [5, R5], [6, R6], [7, R7], [8, R8], [9, R9]].forEach(([ring, list]) => {
  list.forEach((c) => {
    c.ring = ring;
    CARDS[c.pos] = c;
    CARDS[nameKey(c.name)] = c;
    // several cards carry a '(Devī)' qualifier in the base; index the bare stem too
    CARDS[nameKey(c.name.replace(/\(dev[īi]\)/i, ''))] = c;
  });
});

// where each ring begins in the khaḍgamālā, outward-in
export const RING_START = { 1: 1, 2: 29, 3: 45, 4: 53, 5: 67, 6: 77, 7: 87, 8: 99, 9: 102 };
export const globalPos = (ring, indexWithinRing) => (RING_START[ring] || 1) + indexWithinRing;

// Her card, from whatever the app happens to hold: a name, a global position, or
// a ring plus an index. Returns null rather than guessing.
export function findCard(shakti, ring, indexWithinRing) {
  if (!shakti) return null;
  // Her POSITION is authoritative, because names collide across rings —
  // Kāmeśvarī is both a Ring 7 Vāsinī and the Ring 8 Icchā-śakti, and the
  // Ring 4 Devīs repeat Ring 1 Mudrā names. Position can never be ambiguous.
  if (ring != null && indexWithinRing != null) {
    const byPos = CARDS[globalPos(ring, indexWithinRing)];
    if (byPos && byPos.ring === ring) return byPos;
  }
  const byName = CARDS[nameKey(shakti.name)] || CARDS[nameKey(shakti.short)];
  // a name match from another ring is a collision, not a match
  if (byName && (ring == null || byName.ring === ring)) return byName;
  return null;
}

// Her bīja, where the cards name one.
export const BIJA = {
  87: 'Aṃ', 88: 'Kaṃ', 89: 'Caṃ', 90: 'Ṭaṃ', 91: 'Taṃ', 92: 'Paṃ', 93: 'Yaṃ', 94: 'Śaṃ',
  99: 'Aim', 100: 'Klīm', 101: 'Sauḥ', 102: 'Hrīm',
};

// Where the body feels her — normalised, feet 1 → crown 0. Read from `loc`.
const ZONES = [
  [/soles|feet|mūlādhāra/i, 0.94], [/belly|navel|yoni|abundance/i, 0.66],
  [/solar plexus/i, 0.6], [/waist/i, 0.68], [/diaphragm/i, 0.56],
  [/sternum|chest|heart/i, 0.46], [/throat|palate|mouth/i, 0.34],
  [/behind the eyes|eyes|face/i, 0.26], [/forehead|third eye|between the eyes/i, 0.2],
  [/crown|above/i, 0.1], [/spine|whole body|whole field|cellular|totality|converge/i, 0.5],
];
export function bodyAltitude(card) {
  const s = String(card.loc || '');
  for (const [re, v] of ZONES) if (re.test(s)) return v;
  return 0.5;
}
