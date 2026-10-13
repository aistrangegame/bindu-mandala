"""Prove ChakraConstellation.json equals The Map export it was baked from, byte for byte.

usage: verify_chakra_constellation.py BAKE.json MAP.json SCHEMA.json

Independent of the bake script: every baked key is named here by the Map field
it comes from (the Map's own field name, looked up in the schema export), and
every baked string must equal that cell exactly (a select gives its choice name,
Linked Builds gives its record ids; an empty cell is baked as null, never filled).
Structural keys the bake joins itself (kind, avarana, kp, address, crossing,
joinedBy, binduFieldRecordId, sealed) are not Map cells and are listed apart.

Room 32 (sealed, ruling 2) must carry exactly its public identity cells plus the
structure, and no other cell of room 32 — of any length >= 12 — may appear
anywhere in the bake as a substring.

Exits non-zero on the first class of failure, after printing every failure.
"""
import json, sys

BAKE = json.load(open(sys.argv[1]))
MAP = json.load(open(sys.argv[2]))
SCHEMA = json.load(open(sys.argv[3]))['tblwpmyKOeMxEEHd7']
FIELD_ID = {f['name']: f['id'] for f in SCHEMA['fields']}

# bake key → The Map field name
KEY_TO_FIELD = {
    'road': 'Book Position', 'name': 'Name', 'subtitle': 'Chakra Subtitle', 'sanskrit': 'Sanskrit',
    'system': 'System', 'stage': 'Walker Journey Stage', 'sectionNumber': 'Number',
    'avaranaField': 'Avarana', 'shaktiName': 'Shakti Name', 'mudra': 'Shakti Mudra',
    'colorHex': 'Color Hex', 'primaryColor': 'Primary Color', 'verb': 'Verb',
    'activation': 'Activation Mode', 'bija': 'Bija Mantra', 'essence': 'Essence Line',
    'bodyLocation': 'Body Location', 'coreQuestion': 'Core Question',
    'signaturePhrase': 'Signature Phrase', 'heroThreshold': 'Hero Threshold',
    'practicePrompt': 'Practice Prompt', 'threeWaysIn': 'Three Ways In',
    'gateType': 'Practice Gate Type', 'gateText': 'Gate Text', 'storyThread': 'Story Thread',
    'leelaStory': 'Leela Story', 'act1Voice': 'Act 1 Voice', 'act2Voice': 'Act 2 Voice',
    'binduReflection': 'Bindu Reflection', 'witnessPerspective': 'Witness Perspective',
    'writingPrompt': 'Writing Prompt', 'writingReflection': 'Writing Reflection',
    'mirrorFrequencyInstruction': 'Mirror Frequency Instruction',
    'mirrorFrequency': 'Mirror Frequency', 'subtleMirror': 'Subtle Mirror', 'voice': 'Voice',
    'codexReferences': 'Codex References', 'thresholdArchitecture': 'Threshold Architecture',
    'teachingText': 'Teaching Text', 'postEngagementTeaching': 'Post-Engagement Teaching',
    'shaktiFunction': 'Shakti Function', 'tree': 'Tree', 'treeCaption': 'Tree Caption',
    'dyadDescription': 'Dyad Description', 'colorDyad': 'Color Dyad', 'mindTriad': 'Mind Triad',
    'storyPortalHeadline': 'Story Portal Headline', 'panelVerb': 'Panel Verb',
    'panelSeedMessage': 'Panel Seed Message', 'gaiaVoice': 'Gaia Voice',
    'shaktiPractice': 'Shakti Practice', 'url': 'URL', 'buildStatus': 'Build Status',
    'linkedBuilds': 'Linked Builds',
}
STRUCTURAL = {'recordId', 'kind', 'avarana', 'kp', 'address', 'crossing', 'joinedBy',
              'binduFieldRecordId', 'sealed'}
SEALED_ROAD = 32
SEALED_KEYS = {'road', 'recordId', 'name', 'subtitle', 'verb', 'colorHex', 'primaryColor',
               'shaktiName', 'mudra', 'kind', 'avarana', 'kp', 'address', 'crossing', 'sealed'}

def cell(c, fid):
    v = c.get(fid)
    if isinstance(v, dict):
        v = v.get('name')
    if isinstance(v, list):
        v = [x.get('id') if isinstance(x, dict) else x for x in v] or None
    if v == '':
        v = None
    return v

fails = []
by_road = {r['cellValuesByFieldId'][FIELD_ID['Book Position']]: r for r in MAP['records']}
checked = strings = 0
for ch in BAKE['chakras']:
    road = ch['road']
    rec = by_road[road]
    if ch['recordId'] != rec['id']:
        fails.append((road, 'recordId', ch['recordId'], rec['id']))
    c = rec['cellValuesByFieldId']
    for k, v in ch.items():
        if k in STRUCTURAL:
            continue
        if k not in KEY_TO_FIELD:
            fails.append((road, k, 'unknown key', None))
            continue
        want = cell(c, FIELD_ID[KEY_TO_FIELD[k]])
        checked += 1
        if isinstance(v, str):
            strings += 1
        if v != want or type(v) is not type(want):
            fails.append((road, k, repr(v)[:80], repr(want)[:80]))
    # every non-sealed room carries every Map key (null where empty)
    if road != SEALED_ROAD:
        missing = set(KEY_TO_FIELD) - set(ch)
        if missing:
            fails.append((road, 'missing keys', sorted(missing), None))

# the seal
sealed = [x for x in BAKE['chakras'] if x['road'] == SEALED_ROAD]
assert len(sealed) == 1
if set(sealed[0]) != SEALED_KEYS:
    fails.append((SEALED_ROAD, 'sealed key set', sorted(set(sealed[0]) ^ SEALED_KEYS), None))
if sealed[0].get('sealed') is not True:
    fails.append((SEALED_ROAD, 'sealed flag', sealed[0].get('sealed'), True))
public_ids = {FIELD_ID[KEY_TO_FIELD[k]] for k in SEALED_KEYS if k in KEY_TO_FIELD}
blob = json.dumps(BAKE, ensure_ascii=False)
c32 = by_road[SEALED_ROAD]['cellValuesByFieldId']
public_vals = {cell(c32, fid) for fid in public_ids}
leaks = 0
for fid, v in c32.items():
    if fid in public_ids or not isinstance(v, str) or len(v.strip()) < 12:
        continue
    if v.strip() in public_vals:
        continue
    # whole cell, and every line of it that is long enough to be its own text
    pieces = [v.strip()] + [ln.strip() for ln in v.split('\n') if len(ln.strip()) >= 24]
    for p in pieces:
        if p in blob:
            leaks += 1
            name = [n for n, i in FIELD_ID.items() if i == fid][0]
            fails.append((SEALED_ROAD, 'LEAK of sealed field', name, len(p)))
            break

print(f'rooms {len(BAKE["chakras"])} · Map cells compared {checked} · strings {strings} · '
      f'room-32 cells scanned for leaks {sum(1 for v in c32.values() if isinstance(v, str))} · leaks {leaks}')
if fails:
    for f in fails:
        print('FAIL', *f)
    sys.exit(1)
print('PASS — every baked Map cell equals its export cell byte for byte; room 32 sealed')
