// canon-adapter.js — derives the Shell's runtime bundle from the baked Walk Canon v1.0.
// All prose drawn here is canon-true. The only composed text (Sakshi's connective
// tissue — greeting, day-close fragments) is flagged composed:true and never stored as canon.
(function () {
  const C = window.WALK_CANON;
  const byPos = p => C.rooms.find(r => r.identity.book_position === p);
  const cap = s => (s ? s.charAt(0).toUpperCase() + s.slice(1) : s);

  const rooms = C.rooms
    .slice()
    .sort((a, b) => a.identity.book_position - b.identity.book_position)
    .map(r => ({
      pos: r.identity.book_position,
      name: r.identity.name,
      sub: r.identity.subtitle,
      verb: r.identity.verb,
      color_hex: r.identity.color_hex,
      voice: r.identity.voice,
      activation: r.identity.activation,
    }));

  const an = byPos(5);   // Anahata — Day 19 practice
  const sh = byPos(9);   // Shadow — the corridor
  const mu = byPos(2);   // Muladhara — Day 19 wake-up

  const anGate = an.gate.gate_text.split(/\n\n+/);
  // Corridor entry: the opening lines of Shadow's story thread, one breath each.
  const shLines = sh.story.story_thread.split(/\n+/).map(s => s.trim()).filter(Boolean).slice(0, 5);

  window.WALK_CANON_LITE = {
    canon_version: C.canon_version + ' · baked ' + (C.baked_from ? C.baked_from.base : ''),
    laws: C.laws,
    rooms,

    day19: {
      greeting: { text: 'Day 19. The road is quiet where you left it.', composed: true }, // Sakshi composes; never stored
      floor: {
        steps: ['Blink.', 'Breathe.', 'Press.'],
        breath: { inhale: 4, hold: 4, exhale: 4 },
        hold_ms: 1800,
        completion: { text: 'That was a full day of walking. Everything else today is extra.', canon: true },
      },
      wakeup: {
        line: { text: mu.wakeup.frequency_practice, canon: true },
        hz: (mu.wakeup.awakening && mu.wakeup.awakening[0] && mu.wakeup.awakening[0].frequency_hz) || 174,
        end_word: { text: 'Built.', canon: true },
      },
      practice: {
        room: 5,
        teaching: [
          { text: cap(an.arrival.threshold_hint) + '.', canon: true },
          { text: an.arrival.seed_message, canon: true },
        ],
        question: { text: an.arrival.core_question, canon: true },
        grace: { text: 'Three nights ago you finished a door in the Gita. It was standing in this room.', register_example: true },
        reflection: { text: anGate[2], canon: true },
      },
      corridor: {
        passages: shLines.map(t => ({ text: t, canon: true })),
        signature: { text: sh.story.signature_phrase, canon: true, unsigned: true },
      },
      close: {
        // Sakshi composes the close from what was walked — connective tissue, by design.
        fragments: {
          floor: 'one second at a kettle',
          wakeup: 'one sound in a parking lot',
          practice: 'opened the heart at night',
          corridor: 'walked the corridor in the dark',
        },
        waited: {
          corridor: 'The corridor waited. It trusts you.',
          nothing: 'Nothing was walked today. The road doesn\u2019t count. It waits.',
        },
      },
    },
  };
})();
