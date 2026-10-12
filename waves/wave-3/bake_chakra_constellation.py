"""Bake The Map (33 chakras) joined to the Mandala table (102 seats) into
ChakraConstellation.json. Read-only: the inputs are JSON pulled from Airtable
by the MCP tools on 2026-10-12 (map.json = The Map, every record, the fields
listed below). The join to khadgamala positions is written out here, one line
per chakra, with the Map text it rests on, because The Map carries no kp field.
"""
import json, sys

MAP = json.load(open(sys.argv[1]))
OUT = sys.argv[2]

F = dict(
    name='flduzeK6AkCogqC29', system='fldwm4LINmgygsbzq', number='fldNLzuQG1YbMVDLe',
    threshold='fldiRvv7W56wAdrNa', avarana='fld5DcTBFS0Anwxrf', primary='fldtBecVRvcucpDDw',
    hex='fldAsbQnAo3Fk2QHF', verb='fldcG7GkZYFr7TYZd', activation='fldkOhQ5bDhECaVJs',
    shakti='fld7N8l3F3r62sDZT', mudra='fldO14JGMU9cAYulu', body='fldH7EPRy3JPDO3Zi',
    road='fldEvXGbqdHOGZlDz', stage='fld6UsxyU5vel1isl', subtitle='fldHCNApDOqZjinn4',
    sanskrit='fldUfO0k1sLhQZWnt', bija='flduXNmHwo7YQwwEB', essence='fldgKEqNCw6VHlJIa',
    codex='fldqcBq4XpvURwov9', voice='fldPFCAGzcorqrqHH',
)

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
    if isinstance(v, str):
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
    ))

rows.sort(key=lambda x: x['road'])
assert [x['road'] for x in rows] == list(range(1, 34)), [x['road'] for x in rows]
for x in rows:
    assert all(1 <= k <= 102 for k in x['kp'])

out = dict(
    bakedOn='2026-10-12',
    bakedFrom=dict(base='app248ZTWhYJlvQj2', map='tblwpmyKOeMxEEHd7', mandala='tblrRwXJD0uP8HU8G',
                   codex=['C-1343', 'C-1344', 'C-1345']),
    chakras=rows,
)
json.dump(out, open(OUT, 'w'), ensure_ascii=False, indent=1)
print('baked', len(rows))
for x in rows:
    missing = [k for k, v in x.items() if v is None]
    print(x['road'], x['name'], x['kind'], x['avarana'], x['kp'][:3], 'EMPTY:', missing)
