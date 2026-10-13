#!/usr/bin/env python3
"""
bake_walk_canon.py — Walk Canon v1.0 generator for the Bindu Chakras App.

One-command regeneration: reads all 33 rooms from The Map (Airtable) through
the canonical field contract and emits walk-canon.json — the content bundle
the app ships with. Content corrections flow Airtable → re-bake → app,
never through code edits.

Usage:
    AIRTABLE_API_KEY=pat... python3 bake_walk_canon.py [-o walk-canon.json]

Requires: requests (pip install requests)
Base: ASG (app248ZTWhYJlvQj2) · Table: The Map (tblwpmyKOeMxEEHd7)
Contract source of truth: references/delta-map-v2.md §4
"""
import argparse
import json
import os
import sys
import urllib.request

BASE_ID = "app248ZTWhYJlvQj2"
MAP_TABLE = "tblwpmyKOeMxEEHd7"
BUILDS_TABLE = "tbl5PR84YTy4anzAD"

# ── Walk Canon v1.0 field contract (Delta Map §4) ──────────────────────────
IDENTITY = {
    "name": "flduzeK6AkCogqC29",
    "subtitle": "fldHCNApDOqZjinn4",
    "sanskrit": "fldUfO0k1sLhQZWnt",
    "book_position": "fldEvXGbqdHOGZlDz",
    "verb": "fldcG7GkZYFr7TYZd",
    "panel_verb": "fldrmoWcnoRpolZoV",
    "color_hex": "fldAsbQnAo3Fk2QHF",
    "primary_color": "fldtBecVRvcucpDDw",
    "voice": "fldPFCAGzcorqrqHH",
    "system": "fldwm4LINmgygsbzq",
    "tree": "fldX2s98w8U0Y5nK1",
    "activation": "fldkOhQ5bDhECaVJs",  # Stillness/Movement/Visualization/Recognition
}
ARRIVAL = {
    "threshold_hint": "fldX55ru3s5OByoXd",
    "core_question": "fldFJsfXRts1MECj0",
    "seed_message": "fldMA4kqwUTYsGFBs",
    "panel_seed_message": "fldwFamC9FndA94if",
}
STORY = {
    "story_thread": "fldopinrnQ5W0T8kE",
    "after_story": "fldGfgZtoGNZTqIEM",
    "signature_phrase": "flddjDTJBa0o4KyLS",
    "interlude": "fldnALQ6e9iF7fmnO",
}
PRACTICE = {
    "teaching": "fldCs6Vg2umNzxyQc",
    "practice": "fldMTSYXwFrUc9VpL",
    "go_deeper": "fldrlqps5wS0lWxd5",
    "writing_prompt": "fldtIqRA8QgXolDd9",
    "post_writing": "fldS7BiDwPV5grdLy",
    "bindu_reflection": "fldC2OAa6NYrxrxWC",
}
WAKEUP = {
    "frequency_practice": "fld1lfG7r96PQGPxP",
    "frequency_practice_alt": "fldNkcMhpaeuVQC22",
    "bija": "flduXNmHwo7YQwwEB",
}
GATE = {
    "gate_interaction": "fld1rj2QuUuuGvvqc",
    "gate_type": "fldsrQQB5yBYvqIVB",
    "gate_text": "flduxpB6EM5tFRxUe",
}
DEPTH = {
    "shakti": "fld7N8l3F3r62sDZT",
    "avarana": "fld5DcTBFS0Anwxrf",
    "avarana_detail": "fld5sWbzoT3lySYgI",
    "mudra": "fldO14JGMU9cAYulu",
    "subtle_mirror": "fldJsogD1W8AkWhl6",
    "body_location": "fldH7EPRy3JPDO3Zi",
    "tree_note": "fldsj8o9IssOWR6Rp",
    "leela_story": "fldIOc83AOzSiDmgi",
    "witness_perspective": "fldvHuQwNxgjsh4su",
}
# Author-substrate: fetched for build-side staging only; the app NEVER
# surfaces these verbatim. Kept in a separate top-level key so the render
# layer can enforce the rule mechanically.
AUTHOR_SUBSTRATE = {
    "gaia_voice": "fldBiFWEG8gWb06DE",
    "app_build_note": "fldJqK4zLO7CNiWRu",
}
# Excluded from canon entirely (quarantined field): fld0peL6gvkB9JeRe

# Builds table — awakening sounds + songs (dance inherits chakra's Bindu Song)
BUILDS_FIELDS = {
    "name": "fldHY8IdJFsQnacO9",
    "type": "fldfqcNqjHpREGMOK",
    "artist": "fldYCPso4ncf4RUG0",
    "song": "fldZKnXsQiYMK66fb",
    "frequency_hz": "fld8FXhw0TvNDfNv4",
    "sound_description": "fldK89ruhpk1tX1Wq",
    "score_status": "fld1cljga3OPm2TnS",
    "link_to_map": "fldM4nWUoNM0x8lIc",
    "url": "fld5iwRuSlVozZQtu",
}

MOMENT_GROUPS = {
    "identity": IDENTITY, "arrival": ARRIVAL, "story": STORY,
    "practice": PRACTICE, "wakeup": WAKEUP, "gate": GATE, "depth": DEPTH,
    "author_substrate": AUTHOR_SUBSTRATE,
}


def api_get(path, api_key, params=None):
    import urllib.parse
    url = f"https://api.airtable.com/v0/{path}"
    if params:
        url += "?" + urllib.parse.urlencode(params, doseq=True)
    req = urllib.request.Request(url, headers={"Authorization": f"Bearer {api_key}"})
    with urllib.request.urlopen(req) as r:
        return json.load(r)


def fetch_all(table, api_key):
    records, offset = [], None
    while True:
        params = {"returnFieldsByFieldId": "true", "pageSize": 100}
        if offset:
            params["offset"] = offset
        data = api_get(f"{BASE_ID}/{table}", api_key, params)
        records += data.get("records", [])
        offset = data.get("offset")
        if not offset:
            return records


def sel(v):
    """Flatten Airtable select objects to plain names."""
    if isinstance(v, dict) and "name" in v:
        return v["name"]
    if isinstance(v, list):
        return [sel(x) for x in v]
    return v


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("-o", "--out", default="walk-canon.json")
    args = ap.parse_args()

    api_key = os.environ.get("AIRTABLE_API_KEY")
    if not api_key:
        sys.exit("Set AIRTABLE_API_KEY (Airtable personal access token).")

    print("Reading The Map …")
    map_records = fetch_all(MAP_TABLE, api_key)
    print(f"  {len(map_records)} records")

    print("Reading The Builds …")
    build_records = fetch_all(BUILDS_TABLE, api_key)
    print(f"  {len(build_records)} records")

    # Index builds by linked map record for song/awakening inheritance
    builds_by_room, songs_by_room, awakenings_by_room = {}, {}, {}
    for b in build_records:
        f = b.get("fields", {})
        row = {k: sel(f.get(fid)) for k, fid in BUILDS_FIELDS.items()}
        links = f.get(BUILDS_FIELDS["link_to_map"]) or []
        link_ids = [l["id"] if isinstance(l, dict) else l for l in links]
        for rid in link_ids:
            builds_by_room.setdefault(rid, []).append(row)
            if row.get("type") == "Bindu Song":
                songs_by_room.setdefault(rid, []).append(row)
            if row.get("type") == "Awakening Sound":
                awakenings_by_room.setdefault(rid, []).append(row)

    rooms = []
    for rec in map_records:
        f = rec.get("fields", {})
        room = {"record_id": rec["id"]}
        for group, fields in MOMENT_GROUPS.items():
            room[group] = {k: sel(f.get(fid)) for k, fid in fields.items()}
        rid = rec["id"]
        # Dance inherits the chakra's Bindu Song (confirmed with Ashrey, Jul 6 2026)
        room["dance"] = {"inherited_songs": songs_by_room.get(rid, [])}
        room["wakeup"]["awakening"] = awakenings_by_room.get(rid, [])
        rooms.append(room)

    rooms.sort(key=lambda r: r["identity"].get("book_position") or 999)

    # ── Validation: canon must be complete before it ships ──
    errors = []
    if len(rooms) != 33:
        errors.append(f"Expected 33 rooms, got {len(rooms)}")
    positions = [r["identity"].get("book_position") for r in rooms]
    if positions != list(range(1, 34)):
        errors.append(f"Book positions not 1..33: {positions}")
    REQUIRED = [("identity", "name"), ("identity", "verb"), ("identity", "color_hex"),
                ("identity", "voice"), ("identity", "activation"),
                ("arrival", "threshold_hint"), ("arrival", "core_question"),
                ("story", "story_thread"), ("story", "signature_phrase"),
                ("practice", "teaching"), ("practice", "practice"),
                ("gate", "gate_type"), ("gate", "gate_text")]
    for r in rooms:
        pos, name = r["identity"].get("book_position"), r["identity"].get("name")
        for grp, key in REQUIRED:
            if not r[grp].get(key):
                errors.append(f"Room {pos} ({name}): missing {grp}.{key}")
    if errors:
        print("\nCANON INCOMPLETE — refusing to bake:")
        for e in errors:
            print("  ✗", e)
        sys.exit(1)

    canon = {
        "canon_version": "1.0",
        "baked_from": {"base": BASE_ID, "map_table": MAP_TABLE, "builds_table": BUILDS_TABLE},
        "laws": {
            "author_substrate_never_surfaced_verbatim": True,
            "quarantined_fields": ["fld0peL6gvkB9JeRe"],
            "dance_inherits_bindu_song": True,
            "reveal_held_in_build": True,
        },
        "rooms": rooms,
    }
    with open(args.out, "w") as fp:
        json.dump(canon, fp, ensure_ascii=False, indent=2)
    print(f"\n✓ Walk Canon v1.0 baked → {args.out}  ({len(rooms)} rooms, all required fields present)")


if __name__ == "__main__":
    main()
