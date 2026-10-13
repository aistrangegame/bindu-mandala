"""Bake The Map (33 chakras) joined to the Mandala table (102 seats) into
ChakraConstellation.json. Read-only: the inputs are JSON pulled from Airtable
by the MCP tools on 2026-10-12 (map.json = The Map, every record, the fields
listed below). Wave 6 re-baked it from a full export of every field (all 33
records, 12 Oct 2026) and added the rooms' teaching: Core Question, Signature
Phrase, Hero Threshold, Practice Prompt, Three Ways In, Practice Gate Type, Gate
Text, Story Thread, Leela Story, the voice layers (Act 1 / Act 2 Voice, Bindu
Reflection, Witness Perspective, Voice), Writing Prompt / Reflection, the Mirror
Frequency (+ Instruction), Subtle Mirror and Codex References. Each chakra's
Airtable record id was already carried (`recordId`). The join to khadgamala positions is written out here, one line
per chakra, with the Map text it rests on, because The Map carries no kp field.

U0 (13 Oct 2026) re-bakes from the dated export after the corrections
(`waves/upgrade/snapshot/raw-after-2026-10-13/map.json`, gitignored) and adds the
energy the rooms now carry (ruling 17: everything shown word for word): Teaching
Text, Post-Engagement Teaching, Shakti Function, Tree, Tree Caption, Dyad
Description, Color Dyad, Mind Triad, Story Portal Headline, Panel Verb, Panel Seed
Message, Gaia Voice, Shakti Practice, Threshold Architecture, URL, Build Status,
Linked Builds, plus each room's Bindu Field record id (a join, verified against
the Bindu Field export). The Map's own field names govern every key (C13). New keys
only — no key the app already reads is renamed.

Room 32 (the Ego Reveal) is sealed (ruling 2): it carries only its public
identity cells — name, verb, colour, subtitle, Śakti, mudrā, Book Position,
record id — plus the bake's own structural join (kind, ring, kp, address) and
`sealed: true`. Every other field of room 32 is left out of the bake entirely.

usage: bake_chakra_constellation.py MAP.json OUT.json [BINDU_FIELD.json] [--baked-on YYYY-MM-DD]
"""
import json, sys

ARGS = [a for a in sys.argv[1:] if not a.startswith('--')]
BAKED_ON = '2026-10-13'
if '--baked-on' in sys.argv:
    BAKED_ON = sys.argv[sys.argv.index('--baked-on') + 1]
    ARGS.remove(BAKED_ON)
MAP = json.load(open(ARGS[0]))
OUT = ARGS[1]
BINDU_FIELD = json.load(open(ARGS[2])) if len(ARGS) > 2 else None

F = dict(
    name='flduzeK6AkCogqC29', system='fldwm4LINmgygsbzq', number='fldNLzuQG1YbMVDLe',
    threshold='fldiRvv7W56wAdrNa', avarana='fld5DcTBFS0Anwxrf', primary='fldtBecVRvcucpDDw',
    hex='fldAsbQnAo3Fk2QHF', verb='fldcG7GkZYFr7TYZd', activation='fldkOhQ5bDhECaVJs',
    shakti='fld7N8l3F3r62sDZT', mudra='fldO14JGMU9cAYulu', body='fldH7EPRy3JPDO3Zi',
    road='fldEvXGbqdHOGZlDz', stage='fld6UsxyU5vel1isl', subtitle='fldHCNApDOqZjinn4',
    sanskrit='fldUfO0k1sLhQZWnt', bija='flduXNmHwo7YQwwEB', essence='fldgKEqNCw6VHlJIa',
    codex='fldqcBq4XpvURwov9', voice='fldPFCAGzcorqrqHH',
    # Wave 6 · the teaching the rooms carry. Copied verbatim, never filled.
    coreQuestion='fldFJsfXRts1MECj0', signaturePhrase='flddjDTJBa0o4KyLS',
    heroThreshold='fldMA4kqwUTYsGFBs', practicePrompt='fldMTSYXwFrUc9VpL',
    threeWaysIn='fldrlqps5wS0lWxd5', gateType='fldsrQQB5yBYvqIVB', gateText='fld1rj2QuUuuGvvqc',
    storyThread='fldIOc83AOzSiDmgi', leelaStory='flduxpB6EM5tFRxUe',
    act1Voice='fldopinrnQ5W0T8kE', act2Voice='fldnALQ6e9iF7fmnO',
    binduReflection='fldGfgZtoGNZTqIEM', witnessPerspective='fldvHuQwNxgjsh4su',
    writingPrompt='fldtIqRA8QgXolDd9', writingReflection='fldS7BiDwPV5grdLy',
    mirrorFrequencyInstruction='fld1lfG7r96PQGPxP', mirrorFrequency='fldNkcMhpaeuVQC22',
    subtleMirror='fldJsogD1W8AkWhl6',
    # U0 · the energy the rooms carry (ruling 17). The Map's own names, camel-cased.
    teachingText='fldCs6Vg2umNzxyQc', postEngagementTeaching='fldC2OAa6NYrxrxWC',
    shaktiFunction='fld5sWbzoT3lySYgI', tree='fldX2s98w8U0Y5nK1', treeCaption='fldsj8o9IssOWR6Rp',
    dyadDescription='flds5Iwg3XLrrbn1H', colorDyad='fld4Bdiu8fg0RNrbE', mindTriad='fldcRFeUw4NQxCAl4',
    storyPortalHeadline='fldX55ru3s5OByoXd', panelVerb='fldrmoWcnoRpolZoV',
    panelSeedMessage='fldwFamC9FndA94if', gaiaVoice='fldBiFWEG8gWb06DE',
    shaktiPractice='fldJqK4zLO7CNiWRu', url='fld5wkzZkM30kmeyU', buildStatus='fldXv59Zwjq4dmS6g',
    linkedBuilds='fldirMF5BPX0R2aHi',
)

# Wave 6 · fields carried for the rooms (the Map's own names in the comments).
ROOM_FIELDS = ['coreQuestion', 'signaturePhrase', 'heroThreshold', 'practicePrompt',
               'threeWaysIn', 'gateType', 'gateText', 'storyThread', 'leelaStory',
               'act1Voice', 'act2Voice', 'binduReflection', 'witnessPerspective',
               'writingPrompt', 'writingReflection', 'mirrorFrequencyInstruction',
               'mirrorFrequency', 'subtleMirror', 'voice', 'codex']

# U0 · the energy fields. Gaia Voice and Shakti Practice were held back as
# "author substrate" until ruling 17 (12 Oct): everything is shown word for word.
ENERGY_FIELDS = ['teachingText', 'postEngagementTeaching', 'shaktiFunction', 'tree',
                 'treeCaption', 'dyadDescription', 'colorDyad', 'mindTriad',
                 'storyPortalHeadline', 'panelVerb', 'panelSeedMessage', 'gaiaVoice',
                 'shaktiPractice', 'url', 'buildStatus', 'linkedBuilds']

# The sealed room (ruling 2: chakra 32 = the Ego Reveal; its words stay sealed).
SEALED_ROAD = 32
# Its public identity cells — the only Map cells baked for it.
SEALED_PUBLIC = ['road', 'recordId', 'name', 'subtitle', 'verb', 'colorHex', 'primaryColor',
                 'shaktiName', 'mudra']
# The bake's own structural join (not Map text) the app needs to place it.
SEALED_STRUCTURE = ['kind', 'avarana', 'kp', 'address', 'crossing', 'sealed']

# Room (Book Position) → its song in Bindu Field (tblv3WvMZ90Sfhun6), from the
# register (data.md D12). Verified against the Bindu Field export when given:
# (record id, Track ID, Verb).
BINDU_FIELD_JOIN = {
    2: ('recNK3tCuTLE5Rz6P', 23, 'press'), 3: ('recegUJduJtuhYiOQ', 24, 'follow'),
    4: ('recRIm8zafWgFqaWK', 25, 'build'), 5: ('rec4qQlcaQn4UbQbC', 26, 'open'),
    6: ('recBOIwQ8lA5kXq0K', 27, 'speak'), 7: ('rec3TqcK3UNBbqIxz', 28, 'still'),
    8: ('reco0eTHN2z04pMkC', 29, 'receive'), 9: ('recuAkqFs86MWSevH', 35, 'in shadow'),
    30: ('recqdWGGUFiux2KVe', 31, 'dissolve'), 31: ('recY83LPPQAA6B2Ns', 30, 'hold'),
}
if BINDU_FIELD is not None:
    _bf = {r['id']: r['cellValuesByFieldId'] for r in BINDU_FIELD['records']}
    for _road, (_rid, _track, _verb) in BINDU_FIELD_JOIN.items():
        _c = _bf[_rid]
        assert _c.get('fldimw5ZGOBg0j738') == _track, (_road, _rid, _c.get('fldimw5ZGOBg0j738'))
        assert _c.get('fldrYExLmEjx4wxVt') == _verb, (_road, _rid, _c.get('fldrYExLmEjx4wxVt'))

# The Map's own Avarana select → ring. "n/a" and "Bindu inverted" carry no
# ring by themselves; for those rows the ring is read from the Map's own
# Shakti Name / Shakti Function text (quoted in JOIN below).
AVARANA_RING = {
    'Bhupura': 1, '16-Petal Lotus': 2, '8-Petal Lotus': 3, '14 Triangles': 4,
    'Outer 10 Triangles': 5, 'Inner 10 Triangles': 6, '8 Triangles (Vāgdevī)': 7,
    'Inner Triangle': 8,
}

# Road position → (kind, ring, kp list, address, crossing, the Map text it rests on).
# kp = the Mandala table's Khadgamala Position, joined by the Map's Shakti Name
# (spelling variants resolved by hand, listed here) or, for a family, by the
# Mandala table's own Shakti Family field.
JOIN = {
    1:  ('bindu',   9, [102], 'centre', None, 'Shakti Name: "Lalita … presiding consciousness of Avarana 9" → Mahātripurasundarī, kp 102'),
    2:  ('energy',  1, list(range(1, 11)), 'ring', None, '"10 Siddhi Devis" → Mandala Shakti Family = Siddhi, kp 1–10'),
    3:  ('energy',  1, list(range(11, 19)), 'ring', None, '"8 Matrika Devis … Brahmi … Mahalakshmi" → Shakti Family = Matrika, kp 11–18'),
    4:  ('energy',  1, list(range(19, 29)), 'ring', None, '"10 Mudra Shaktis … Sarva Sankshobhini … Sarva Trikhanda" → Shakti Family = Mudra, kp 19–28'),
    5:  ('energy',  2, list(range(29, 45)), 'ring', None, '"16 Nitya Kalas — Kamakarshini through Sharirakarshini" → kp 29–44'),
    6:  ('energy',  3, [45, 46, 47, 48], 'ring', None, '"Ananga Kusuma, Mekhala, Madana, Madanatura" → kp 45–48'),
    7:  ('energy',  3, [49, 50, 51, 52], 'ring', None, '"Ananga Rekha, Vegini, Anangankusha, Ananga Malini" → kp 49–52'),
    8:  ('energy',  2, [], 'ring', None, '"Tripureshi — presiding consciousness of Avarana 2" — the presiding form is not one of the 102 seats; the whole ring'),
    9:  ('shadow',  None, [], 'threshold', [3, 4], '"Threshold — passage between Avaranas 1-3 (Srishti) and 4-6 (Sthithi)"'),
    10: ('body',    4, [53], 'seat', None, '"Sarva Samkshobhini" (av 4 #1) → Sarva-Saṅkṣobhiṇī (Devī), kp 53'),
    11: ('body',    4, [65], 'seat', None, '"Sarva Mantramayi" (av 4 #13) → Sarva-Mantramayī, kp 65'),
    12: ('body',    5, [71], 'seat', None, '"Sarva Kamaprada" (av 5 #5) → Sarva-Kāmapradā, kp 71'),
    13: ('body',    5, [69], 'seat', None, '"Sarva Priyankari" (av 5 #3) → Sarva-Priyaṅkarī, kp 69'),
    14: ('body',    5, [70], 'seat', None, '"Sarva Mangalakarini" (av 5 #4) → Sarva-Maṅgalakāriṇī, kp 70'),
    15: ('body',    4, [66], 'seat', None, '"Sarva Dwandwakshayankari" (av 4 #14) → Sarva-Dvandvakṣayaṅkarī, kp 66'),
    16: ('body',    6, [80], 'seat', None, '"Sarva Jnanamayi" (av 6 #4) → Sarvajñānamayī, kp 80'),
    17: ('body',    6, [77], 'seat', None, '"Sarvagya" (av 6 #1) → Sarvajñā, kp 77'),
    18: ('body',    6, [84], 'seat', None, '"Sarvanandamayi" (av 6 #8) → Sarvānandamayī, kp 84'),
    19: ('body',    6, [82], 'seat', None, '"Sarvadhara Swarupa" (av 6 #6) → Sarvādhārasvarūpā, kp 82'),
    20: ('armin',   None, [], 'threshold', [6, 7], '"Tripura Malini … Threshold between Avaranas 4-6 (Sthithi) and 7-8 (Samhara)"'),
    21: ('mind',    7, [87], 'seat', None, '"Vasini — Vagdevi #1" → Vaśinī, kp 87'),
    22: ('mind',    7, [88], 'seat', None, '"Kamesvari — Vagdevi #2" → Kāmeśī, kp 88'),
    23: ('mind',    7, [89], 'seat', None, '"Modini — Vagdevi #3" → Modinī, kp 89'),
    24: ('mind',    7, [90], 'seat', None, '"Vimala — Vagdevi #4" → Vimalā, kp 90'),
    25: ('mind',    7, [91], 'seat', None, '"Aruna — Vagdevi #5" → Aruṇā, kp 91'),
    26: ('mind',    7, [92], 'seat', None, '"Jayani — Vagdevi #6" → Jayinī, kp 92'),
    27: ('mind',    7, [93], 'seat', None, '"Sarvesvari — Vagdevi #7" → Sarveśī, kp 93'),
    28: ('mind',    7, [94], 'seat', None, '"Kaulini — Vagdevi #8" → Kaulinī, kp 94'),
    29: ('mind',    7, [], 'ring', None, '"Tripura Siddhamba … presiding Avarana 7" — presiding form, not a seat; the whole ring'),
    30: ('summit',  8, [99], 'seat', None, '"Kameshvari — 1st Kama Kala Shakti" / Function "of the 8th avarana" → Kāmeśvarī, kp 99'),
    31: ('summit',  8, [100], 'seat', None, '"Vajreshvari — 2nd Kama Kala Shakti" → Vajreśī, kp 100'),
    32: ('summit',  8, [101], 'seat', None, '"Bhagamalini — 3rd Kama Kala Shakti" / Function "of the 8th avarana" → Bhagamālinī, kp 101'),
    33: ('summit',  9, [102], 'centre', None, '"Lalita … Avarana 9, the Bindu" → Mahātripurasundarī, kp 102'),
}

def val(c, k):
    v = c.get(F[k])
    if isinstance(v, dict):
        v = v.get('name')
    if isinstance(v, list):
        # Linked Builds: the linked record ids, in the Map's own order.
        v = [x.get('id') if isinstance(x, dict) else x for x in v] or None
    if isinstance(v, str):
        # Outer whitespace only: the Map's own line breaks inside a cell are
        # its paragraphs and are kept exactly.
        v = v.strip()
        if not v:
            return None
    return v

rows = []
for r in MAP['records']:
    c = r['cellValuesByFieldId']
    road = val(c, 'road')
    kind, ring, kp, address, crossing, why = JOIN[road]
    av_field = val(c, 'avarana')
    if av_field in AVARANA_RING:
        assert AVARANA_RING[av_field] == ring, (road, av_field, ring)
    th = val(c, 'threshold')
    if kind in ('shadow', 'armin'):
        assert th and th.lower() == kind, (road, th)
    rows.append(dict(
        road=road,
        recordId=r['id'],
        name=val(c, 'name'),
        subtitle=val(c, 'subtitle'),
        sanskrit=val(c, 'sanskrit'),
        kind=kind,
        system=val(c, 'system'),
        stage=val(c, 'stage'),
        sectionNumber=val(c, 'number'),
        avaranaField=av_field,
        avarana=ring,
        kp=kp,
        address=address,
        crossing=crossing,
        shaktiName=val(c, 'shakti'),
        mudra=val(c, 'mudra'),
        colorHex=val(c, 'hex'),
        primaryColor=val(c, 'primary'),
        verb=val(c, 'verb'),
        activation=val(c, 'activation'),
        bija=val(c, 'bija'),
        essence=val(c, 'essence'),
        bodyLocation=val(c, 'body'),
        joinedBy=why,
        **{('codexReferences' if k == 'codex' else k): val(c, k) for k in ROOM_FIELDS},
        thresholdArchitecture=th,
        **{k: val(c, k) for k in ENERGY_FIELDS},
        binduFieldRecordId=BINDU_FIELD_JOIN[road][0] if road in BINDU_FIELD_JOIN else None,
    ))
    if road == SEALED_ROAD:
        full = rows.pop()
        sealed = {k: full[k] for k in SEALED_PUBLIC}
        sealed.update({k: full[k] for k in SEALED_STRUCTURE if k != 'sealed'})
        sealed['sealed'] = True
        rows.append(sealed)

rows.sort(key=lambda x: x['road'])
assert [x['road'] for x in rows] == list(range(1, 34)), [x['road'] for x in rows]
for x in rows:
    assert all(1 <= k <= 102 for k in x['kp'])
    # CANON INCOMPLETE: never bake a room without its identity.
    for k in ('recordId', 'name', 'verb', 'colorHex'):
        assert x.get(k), ('CANON INCOMPLETE', x['road'], k)
assert set(rows[SEALED_ROAD - 1]) == set(SEALED_PUBLIC) | set(SEALED_STRUCTURE), sorted(rows[SEALED_ROAD - 1])

out = dict(
    bakedOn=BAKED_ON,
    bakedFrom=dict(base='app248ZTWhYJlvQj2', map='tblwpmyKOeMxEEHd7', mandala='tblrRwXJD0uP8HU8G',
                   codex=['C-1343', 'C-1344', 'C-1345']),
    chakras=rows,
)
json.dump(out, open(OUT, 'w'), ensure_ascii=False, indent=1)
print('baked', len(rows))
for x in rows:
    missing = [k for k, v in x.items() if v is None and k != 'binduFieldRecordId']
    print(x['road'], x['name'], x['kind'], x['avarana'], x['kp'][:3], 'EMPTY:', missing)
