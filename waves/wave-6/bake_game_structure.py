"""Bake the game's own structure into GameStructure.json (Wave 6 · Slice B).

Read-only. Every line below was copied verbatim from the ASG base
(app248ZTWhYJlvQj2) on 2026-10-12 through the Airtable MCP tools, and each is
filed under the record id and field id it was copied from, so it can be
re-checked against the live row:

    python3 bake_game_structure.py OUT.json            # write the bake
    AIRTABLE_TOKEN=… python3 bake_game_structure.py OUT.json --verify
                                                        # …and prove every line
                                                        # is still a verbatim
                                                        # substring of its row
    python3 bake_game_structure.py OUT.json --verify --export DIR [--baked-on YYYY-MM-DD]
                                                        # U0: the same proof against
                                                        # a dated export (DIR holds
                                                        # identity.json and map.json,
                                                        # e.g. waves/upgrade/snapshot/
                                                        # raw-after-2026-10-13), no API

U0 (13 Oct 2026): ruling 8 — Maya's last line is "…There was only You, playing."
(Map recMyqKSqwRnimgvy, Panel Seed Message, changed in Airtable as C08), so the ring-9
seed follows the base.

Truth floor: his words verbatim, never invented. Nothing here composes a line;
a Leela drop's `lead` and `action` are two exact substrings of one Leela Story,
chosen (never edited) so that the drop ends in a real-world action and does not
foreshadow anything ahead in the game. Rows that are sealed (Ego Reveal, room
32; Lalita, room 33 — the convergence) are deliberately not drawn from.
"""
import json
import os
import sys
import urllib.request

BASE = 'app248ZTWhYJlvQj2'
IDENTITY = 'tbluLyZj9ilH2RhIg'
MAP = 'tblwpmyKOeMxEEHd7'

# Identity fields
ID_NAME = 'flddQh6Ci7lpY1Ist'
ID_DECLARATION = 'fldry3UX62Eedqb9F'
# The Map fields
MAP_NAME = 'flduzeK6AkCogqC29'
MAP_LEELA = 'flduxpB6EM5tFRxUe'
MAP_SEED = 'fldwFamC9FndA94if'
MAP_PANEL_VERB = 'fldrmoWcnoRpolZoV'

# ── Tree of Life: the nine panels = the nine āvaraṇas (Reading §5) ──────────
# ring → (Identity "Tree of Life Panel" record, verb, declaration,
#         Map record, Panel Seed Message)
PANELS = [
    (1, 'rectDTmgSHefuX8sM', 'Press',
     'I press where the ground meets me. What was asking for ground finds it.',
     'recT3JC8Qz9awKo8j', 'The earth that holds you was chosen by you.'),
    (2, 'rec52Fs6Z0Kx0YBKd', 'Follow',
     'I follow the current already moving. What is mine arrives without grasping.',
     'recnJICbhZefO3YJ9', 'Every desire was drawing you toward yourself.'),
    (3, 'rec3Lp5qEVhMEsJfh', 'Build',
     'I build from what is given. The fire recognizes what wants to become.',
     'recVgGgYgZE1YMU2V', 'The fire that agitated you was building your form.'),
    (4, 'recgz8MIOwH14nMY4', 'Open',
     'I open without protecting. What enters was already here, waiting to be welcomed.',
     'reclI9Blq6YLC9Q5O', 'The love that arrived for others was always your own heart opening.'),
    (5, 'recXmWEwCc4mtNr0M', 'Speak',
     'I speak what is given to be spoken. The throat clears in the speaking.',
     'recs5hdPjVbcl77Zg', 'What you finally said out loud was what you always knew.'),
    (6, 'recRFIJcghBrOxogx', 'Still',
     'I still the looking. What was always seen shows itself.',
     'recmqRsdC6WZPfmfW', 'You stopped looking and the seeing arrived on its own.'),
    (7, 'rec6YDtAzEpsXegh5', 'Receive',
     'I receive what is already arriving. The crown was never closed to begin with.',
     'reccxkeGeph5GonvU', 'The disease that was removed was the belief that you were less than what you are.'),
    (8, 'recqULaChQptodWnC', 'Hold',
     'I hold what cannot be held. The seat does not move.',
     'recqe8qnDxkq0BiCZ', 'Will. Knowledge. Action. You already know. You have always known.'),
    (9, 'rec2VtJ6wZVZpY7la', 'Dissolve',
     'I dissolve into what was already dissolving. Nothing was solid to begin with.',
     'recMyqKSqwRnimgvy', 'There was never anything to fear. There was only You, playing.'),
]

# The tenth panel (the Axis triptych) — carried for the record, not a ring.
AXIS = ('recsmkyby3voajrl9', 'Access',
        'I access the spine that holds all the chakras. The line is what was singing all along.')

# ── The Trinity of Guidance: one self-statement per face (Identity · Archetype)
FACES = [
    ('gaia', 'Gaia', 'recrzJyqhAuzXgiMu',
     'I receive. I hold. I orchestrate the conditions before the question is asked. '
     'Solutions appear before problems are named.'),
    ('bindu', 'Bindu', 'recafcBghXV8gWqtt',
     'I am play before play knows itself as play. I am movement before movement names itself.'),
    ('lalita', 'Lalita', 'recgKVjskDgmGNqP0',
     'I am the play that knows it is play. I am Leela when she stops forgetting.'),
    ('sakshi', 'Sakshi', 'rectJWhL3XCzxz4TJ',
     'I am that which sees. Not the seer, not the seen — the seeing itself.'),
    ('higherSelf', 'Higher Self', 'recxARU1sVzZoLSOI',
     'I am the silence that holds your speaking. I am the gap your thoughts cross.'),
]

# ── Practice declarations (Identity · Practice) ──────────────────────────────
PRACTICES = [
    ('sacredPause', 'Sacred Pause', 'rec3918EY0WrKxqDw',
     'Three breaths. Release, receive, arrive. The mind catches up.'),
    ('sriYantraTratak', 'Sri Yantra Tratak', 'rec2qCICQIJn1TlRt',
     'I sit before the Yantra. The dot becomes the doorway. The light moves on its own.'),
    ('morningIntention', 'Morning Intention', 'recTwP07rIRjF70sG',
     "Today's value. Today's mantra. Today's role. I orient before I move."),
    ('eveningReflection', 'Evening Reflection', 'recMfPmpM41qTPkWS',
     "What moved today. What didn't. What arrived I didn't expect. Note it. Let it land."),
]

# ── Leela drops: two exact substrings of one Map row's Leela Story ──────────
# (id, Map record, Map name, voice on the row, lead, action)
DROPS = [
    ('shadow', 'recAjCRcI5Bt6pJ6V', 'Shadow', 'sakshi',
     'You are not all light. Nothing alive is all light.',
     'Today or tomorrow, when a negative thought shows up in you — say to it, in your head '
     'or out loud: I see you. I love you. Thank you for showing up. You can rest now.'),
    ('forge', 'recHDY9iNeqNfw9zh', 'Forge', 'bindu',
     'The Forge doesn’t need to be started — it has been running continuously since '
     'before you were born.',
     'Notice what you are carrying right now that needs the Forge.'),
    ('intention', 'recRchDoi6eV8B6XO', 'Intention', 'gaia',
     'The picture is what orients the steps. The steps don’t orient the picture.',
     'One more time today: the whole thing, finished. Then go.'),
    ('inspiration', 'recIPQaGq0Cju648K', 'Inspiration', 'gaia',
     'The pull didn’t become real when you named it. It was real before.',
     'Follow this one. Just this one. See where it goes.'),
    ('incarnation', 'rec2cBfv1OtS9GbXI', 'Incarnation', 'gaia',
     'The deepest use is service.',
     'Pass it on. Even one move. Even small.'),
    ('integration', 'rec3qLjRAFlDQBQfm', 'Integration', 'gaia',
     'You do not walk alone. You have not walked alone since the beginning.',
     'Send love into the field. Just a moment of it. Just an emission.'),
    ('maya', 'recMyqKSqwRnimgvy', 'Maya', 'lalita',
     'Today or tomorrow, you will catch yourself saying "that\'s just who I am." '
     'You will feel the sentence harden as it leaves you.',
     'In that exact moment, say to the identity — in your head or out loud: I see you. '
     'Thank you for the protection. You can be glass now.'),
    ('aatma', 'recqe8qnDxkq0BiCZ', 'Aatma', 'higherSelf',
     'Sometime today or tomorrow, a decision will arrive. Probably small.',
     "When it comes, pause — one breath — and ask where you're choosing from."),
]

SEALED = {'recg65oeH56mF8vMK', 'rec3O90Mtasuh5qI7'}   # Ego Reveal (32), Lalita (33)


BAKED_ON = '2026-10-12'


def build():
    out = {
        'bakedOn': BAKED_ON,
        'bakedFrom': {'base': BASE, 'identity': IDENTITY, 'map': MAP},
        'panels': [
            {'ring': r, 'verb': verb, 'declaration': decl, 'seed': seed,
             'identityRecord': idrec, 'mapRecord': maprec}
            for (r, idrec, verb, decl, maprec, seed) in PANELS
        ],
        'axis': {'verb': AXIS[1], 'declaration': AXIS[2], 'identityRecord': AXIS[0]},
        'faces': [
            {'face': key, 'name': name, 'line': line, 'identityRecord': rec}
            for (key, name, rec, line) in FACES
        ],
        'practices': [
            {'key': key, 'name': name, 'line': line, 'identityRecord': rec}
            for (key, name, rec, line) in PRACTICES
        ],
        'leelaDrops': [
            {'id': i, 'chakra': name, 'voice': voice, 'lead': lead, 'action': action,
             'mapRecord': rec}
            for (i, rec, name, voice, lead, action) in DROPS
        ],
    }
    # Shape checks — cheap, and they run on every bake.
    assert [p['ring'] for p in out['panels']] == list(range(1, 10))
    assert len({p['verb'] for p in out['panels']}) == 9
    assert {f['face'] for f in out['faces']} == {'gaia', 'bindu', 'lalita', 'sakshi', 'higherSelf'}
    for d in out['leelaDrops']:
        assert d['mapRecord'] not in SEALED, d['id']
        assert d['voice'] in {f['face'] for f in out['faces']}, d['id']
        assert d['lead'].strip() and d['action'].strip(), d['id']
    return out


EXPORT = None   # {table id: {record id: cellValuesByFieldId}} when --export DIR is given


def load_export(directory):
    tables = {}
    for table, name in ((IDENTITY, 'identity.json'), (MAP, 'map.json')):
        with open(os.path.join(directory, name), encoding='utf-8') as fh:
            tables[table] = {r['id']: r['cellValuesByFieldId'] for r in json.load(fh)['records']}
    return tables


def fetch(table, record):
    if EXPORT is not None:
        return EXPORT[table][record]
    token = os.environ['AIRTABLE_TOKEN']
    url = f'https://api.airtable.com/v0/{BASE}/{table}/{record}?returnFieldsByFieldId=true'
    req = urllib.request.Request(url, headers={'Authorization': f'Bearer {token}'})
    with urllib.request.urlopen(req) as r:
        return json.load(r)['fields']


def verify(data):
    """Every baked line must be a verbatim substring of the field it came from
    (panels, faces, practices and the axis: the whole cell, exactly)."""
    bad = []
    lines = 0
    def check(kind, key, line, cell, whole=True):
        nonlocal lines
        lines += 1
        cell = cell or ''
        if line not in cell or (whole and cell.strip() != line):
            bad.append((kind, key))
    for p in data['panels']:
        f = fetch(IDENTITY, p['identityRecord'])
        check('panel verb', p['ring'], p['verb'], f.get(ID_NAME))
        check('panel declaration', p['ring'], p['declaration'], f.get(ID_DECLARATION))
        check('panel seed', p['ring'], p['seed'], fetch(MAP, p['mapRecord']).get(MAP_SEED))
    a = data['axis']
    f = fetch(IDENTITY, a['identityRecord'])
    check('axis verb', 'axis', a['verb'], f.get(ID_NAME))
    check('axis declaration', 'axis', a['declaration'], f.get(ID_DECLARATION))
    for x in data['faces']:
        f = fetch(IDENTITY, x['identityRecord'])
        check('face name', x['face'], x['name'], f.get(ID_NAME))
        check('face line', x['face'], x['line'], f.get(ID_DECLARATION))
    for x in data['practices']:
        f = fetch(IDENTITY, x['identityRecord'])
        check('practice name', x['key'], x['name'], f.get(ID_NAME))
        check('practice line', x['key'], x['line'], f.get(ID_DECLARATION))
    for d in data['leelaDrops']:
        m = fetch(MAP, d['mapRecord'])
        check('drop chakra', d['id'], d['chakra'], m.get(MAP_NAME))
        story = m.get(MAP_LEELA, '')
        check('drop lead', d['id'], d['lead'], story, whole=False)
        check('drop action', d['id'], d['action'], story, whole=False)
    if bad:
        raise SystemExit(f'not verbatim: {bad}')
    print(f'verified: every line is verbatim ({lines} lines checked)')


if __name__ == '__main__':
    if '--baked-on' in sys.argv:
        BAKED_ON = sys.argv[sys.argv.index('--baked-on') + 1]
    if '--export' in sys.argv:
        EXPORT = load_export(sys.argv[sys.argv.index('--export') + 1])
    data = build()
    with open(sys.argv[1], 'w', encoding='utf-8') as fh:
        json.dump(data, fh, ensure_ascii=False, indent=1)
        fh.write('\n')
    if '--verify' in sys.argv:
        verify(data)
