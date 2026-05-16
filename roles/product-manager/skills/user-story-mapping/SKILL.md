---
name: user-story-mapping
description: Use when a team needs to convert a discovery insight or product hypothesis into a release-shaped plan — Patton's two-dimensional story map with a narrative spine, walking skeleton, and release slices — that connects PM altitude to delivery sequencing.
intent: |
  Builds a story map that preserves the user's narrative while giving
  engineering a sequenced release plan. The map is the conversation, not
  the artifact — it forces the team to agree on the backbone before slicing
  scope, which is what prevents accidental MVP over-engineering.
  Distinct from a flat backlog: a backlog is a queue; a map is a topology.
type: workflow
theme: delivery
best_for:
  - A new product or major feature where the team disagrees on scope before the first sprint
  - A discovery insight that needs to become a release plan without losing the user thread
  - A roadmap conversation where "MVP" means different things to different stakeholders
scenarios:
  - "We have user research on mobile checkout friction — turn it into a map before we write stories"
  - "Engineering wants to know what the walking skeleton for the onboarding rewrite looks like"
  - "PM and design have a narrative but the backlog keeps growing — draw release lines before the sprint"
estimated_time: "1–3 hour workshop (initial map); 30 minutes (solo PM draft for alignment)"
---

# User story mapping

> v0 draft. Jeff Patton (*User Story Mapping*, 2014) is the primary source for every structural concept in this skill — the backbone, the walking skeleton, the release-slice discipline, and the map-as-conversation framing. Teresa Torres (*Continuous Discovery Habits*) anchors the discovery-to-delivery handoff. See `roles/product-manager/sources.md`.

## Purpose

Produce a two-dimensional story map: a narrative spine of user activities running left-to-right across the top, with stories of decreasing necessity stacked vertically beneath each activity. Horizontal cuts through the vertical stack define release boundaries.

The map solves a specific problem: flat backlogs lose the user story. When you rank 80 tickets by priority, you can no longer see whether Release 1 delivers a coherent user experience or a random assortment of isolated features. The map restores the story.

The primary output is shared understanding, not a document. Run it with the full team — PM, design, engineering — in a room (or a shared whiteboard). The act of building the map is the alignment. The artifact is evidence of the conversation.

**When to use story mapping vs. adjacent tools:**
- Use story mapping (not an OKR or PRD) when the team needs to align on the *user journey* before scoping a release. The map is the bridge from discovery evidence to sprint backlog.
- Use a PRD (not a story map) when the scope is agreed and the team needs a detailed specification. The PRD operationalises individual stories from the map; it does not replace the map.
- Use an opportunity-solution tree (Torres) when the team is still deciding *which* user problem to solve. The OST precedes the story map; the map assumes the opportunity is chosen.
- Use story mapping (not a Gantt chart) when dependencies are cross-functional and the user journey is the sequencing logic. Gantt charts encode time; story maps encode user narrative — they are not interchangeable.

## Key Concepts

### The two-dimensional structure (Patton)

Patton's map has exactly two axes, and conflating them is the most common structural error:

**Horizontal axis — the narrative spine.** User activities, ordered left-to-right by the sequence in which a user experiences them when accomplishing their goal. Activities are coarse-grained behaviors ("Schedule an appointment," "Make a payment") not features or system actions. Each activity contains one or more user steps — the concrete actions inside that activity.

**Vertical axis — necessity.** Stories beneath each activity are ordered top-to-bottom from most essential to least. The top row is not "the most important features" in the abstract — it is the minimum set of stories that, running left-to-right across the spine, delivers a *working, end-to-end experience*.

The structure looks like:

```
[Activity 1]   [Activity 2]   [Activity 3]   [Activity 4]
     |               |               |               |
  [Step A]        [Step A]        [Step A]        [Step A]
  [Step B]        [Step B]        [Step B]        [Step B]
     |               |               |               |
  story (must)    story (must)    story (must)    story (must)   ← Release 1
  story (should)  story (should)  story (should)  story (should) ← Release 2
  story (could)   story (could)   story (could)   story (could)  ← Later
```

### The walking skeleton (Patton)

The walking skeleton is the Release 1 horizontal slice: the thinnest possible end-to-end experience that still lets a real user accomplish their goal. Not the prettiest. Not the most complete. The one that *works*, top-to-bottom, with no gaps.

The test: can a new user arrive at Activity 1 and, using only the stories above the Release 1 line, reach the end of Activity N with their goal met? If the answer is no, the walking skeleton is not done. If the answer is yes but it includes 40% of all stories, the skeleton is too fat.

Walking skeleton discipline is the antidote to scope inflation. Teams that skip it end up with Release 1 plans that include every "should" story because no one drew the line.

### Grain levels and why they matter

Patton distinguishes three levels of granularity on the vertical axis, and mixing them is a persistent workshop failure:

- **Activities** (backbone level) — coarse-grained user behaviors, measurable in hours or days. "Complete a purchase." If you can describe an activity in one sentence and it takes a real user less than 60 seconds, it is a step, not an activity.
- **Steps** (spine level) — the concrete actions within an activity. "Enter payment details." Steps are observable — you could watch someone perform them. 2–5 steps per activity is the typical range.
- **Stories** (body of the map) — the system-supported interactions that enable each step. This is where the engineering work lives. A story should be deliverable in one sprint; if it can't be, it is still an epic.

The common error: writing activities at step granularity (20+ backbone items for a single user goal). The map becomes impossible to slice. The fix is to elevate: group fine-grained activities into coarser parent activities until you have 3–7 items across the top.

### Map-then-slice discipline

The sequence matters: **map the full journey first, then draw release lines**. The failure mode is slicing activity-by-activity as you go, which produces release plans that are complete vertically (all stories for Activity 1) but broken horizontally (the user can't get from Activity 1 to Activity 3 in Release 1).

Map the whole spine. Identify all the steps. Write stories at multiple necessity levels. Only then draw a horizontal line to define Release 1.

### Now / Next / Later framing

Once the map is drawn, release slices translate naturally into a now/next/later roadmap: Release 1 is "now" (walking skeleton), Release 2 is "next" (core feature completion), later releases are "later" (enhancements and edge-case coverage). This framing communicates roadmap intent to stakeholders without committing to dates.

The now/next/later language is deliberately non-committal about time. A date-based roadmap ("Q2 / Q3 / Q4") invites date negotiation. A position-based roadmap ("now / next / later") invites conversation about ordering and discovery signals. When a later-row story is pulled forward because of new evidence, the story map is the artifact that makes the re-prioritisation legible — the team can see what it is displacing.

### Story map as conversation, not artifact

Patton is explicit: the map is a vehicle for conversation. A story map produced by one PM in Jira and then presented to the team is not a story map — it is a backlog dressed up as a map. The value is in the process of building it together, not in the resulting cards.

Torres (*Continuous Discovery Habits*) extends this: the discovery-to-delivery handoff is where the user's opportunity gets lost. The story map is the bridge. When PM and design have done discovery work and engineering hasn't been in the room, the story-mapping session is how that knowledge transfers — not a PRD handoff, not a ticket dump.

A corollary: if engineering is surprised by activity ordering decisions during implementation, the map was not built together. The surprise is a signal that the workshop did not happen, or happened without sufficient engineering participation. Run the workshop again — don't patch the backlog.

## Application

Five phases; full-team workshop is 90–180 minutes. Solo PM draft for alignment purposes is 30 minutes (skip to Phase 3 if the spine is already agreed).

### Phase 1 — Frame the slice (10–15 minutes)

Before touching the board, name two things:

1. **The user and their goal** — one sentence. "A first-time buyer on the mobile app wants to complete a purchase without creating an account." This is the narrative the map will tell. All activities, steps, and stories must serve this narrative. If a card can't be traced to this sentence, it doesn't belong in this map.

2. **The release horizon** — are you mapping for a single release, a quarter, or the full product vision? Announce this scope before mapping starts. Mapping without a horizon produces maps too large to slice.

Quality check: if "the user" has no specific goal, the scope is too broad. Narrow it. "All users of the app" is not a user for story-mapping purposes; "a returning buyer who abandoned their cart yesterday" is. The specificity of the user sentence is a direct predictor of how useful the resulting map will be.

### Phase 2 — Map the spine (20–30 minutes)

Write the backbone: 3–7 activities the user performs, in sequence, to accomplish the goal. Put them left-to-right across the top of the board.

Rules:
- Activities are user behaviors, not system capabilities. "Browse products" not "Product catalog page."
- 3–7 activities is the practical range. Fewer means the grain is too coarse to decompose. More means you're mixing activity-level and step-level concepts.
- Under each activity, write 2–5 steps — the concrete user actions within that activity.

With the team: have everyone write activities on sticky notes independently first, then cluster and sequence together. Disagreements about activity order reveal assumptions about the user journey worth surfacing.

Spine quality checks before moving to Phase 3:
- Can you read the backbone left-to-right and hear a coherent user story? If not, the sequence is wrong.
- Does every activity name a *user* action (verb phrase, user subject) rather than a system capability? "Browse catalog" yes; "Catalog system" no.
- Are any two adjacent activities really the same activity at different granularities? Merge them.
- If the team can't agree on an activity's position in the sequence, that disagreement is product-vision work — surface it explicitly rather than placing the card arbitrarily.

### Phase 3 — Decompose vertically (30–45 minutes)

Under each step, write stories at multiple necessity levels. Use the language of necessity, not importance:

- **Must have**: a user cannot complete this step without this story.
- **Should have**: makes the step significantly better but the step works without it.
- **Could have**: enhancement; the step is fine without it.

Place stories physically: musts near the top, coulds near the bottom. Don't enforce a rigid row structure yet — you'll draw lines in Phase 4.

The right level of granularity: a story should be deliverable in one sprint by one pair. If a card is too large to estimate, it is still an epic — break it. If a card is so small it can't stand alone, merge it.

### Phase 4 — Draw release slices (20–30 minutes)

This is the load-bearing step. Draw a horizontal line across the map to define Release 1.

The Release 1 line must satisfy the walking-skeleton test: every activity above the line must have at least one story above the line; taken together, those stories must deliver an end-to-end working experience.

Forcing questions:
- "If we only shipped everything above this line, could a user actually do the thing?"
- "Is anything above this line a 'nice to have' that we're including out of habit?"

Draw subsequent lines for Release 2 and "later" if the team needs that alignment. Don't over-specify releases beyond the second — stories in "later" will change.

### Phase 5 — Walking-skeleton-first delivery check (10–15 minutes)

Before leaving the session, confirm:

1. Does engineering know which stories constitute the walking skeleton? (The top row across all activities in Release 1.)
2. Is the walking skeleton implementable end-to-end in one sprint, or does it need to be broken into setup + first working slice?
3. Are there any technical dependencies that cut across activities — stories that must be done before others, regardless of their horizontal position?

Name those dependencies explicitly. They are not visible on the map unless you mark them.

**When the walking skeleton spans more than one sprint**, draw a vertical line inside Release 1 to mark "Sprint 1 end state." This is not a new release boundary — it is a delivery checkpoint. The team should be able to demo an end-to-end path (even if incomplete) at that checkpoint. Continuous demo-ability is what keeps the walking skeleton honest.

**Handoff from map to backlog.** After the session: photograph the physical map before anyone leaves the room. Then: stories above the Release 1 line go directly to the sprint backlog, ordered by the walking-skeleton dependency chain. Stories in Release 2 and later go to the product backlog as rough items — not fully groomed, not estimated. The map provides their sequencing context; estimation happens when they near the sprint horizon. Importing all map stories into the backlog at full detail at workshop time is a common over-investment; the later stories will change before they are relevant.

## Examples

### Example 1 — Mobile checkout MVP (worked story map)

**Context.** A product team building a mobile commerce app has discovered through research that guest checkout is the highest-friction part of the purchase flow. They want to map a walking-skeleton MVP before sprint 1.

**User and goal.** "A mobile shopper wants to complete a purchase for a single item without creating an account."

**Spine (activities and steps):**

```
[Find item]      [Review item]   [Enter details]  [Confirm order]
     |                |                |                |
  Search bar       See photos       Shipping addr    Order summary
  Filter results   Read reviews     Payment method   Confirmation email
  Browse category  Check stock      Apply coupon
```

**Stories with necessity levels:**

```
[Find item]         [Review item]   [Enter details]   [Confirm order]
  Search (must)       Photos (must)   Address (must)    Summary (must)
  Filter (should)     Reviews(could)  Card entry(must)  Email (must)
  Browse (could)      Zoom (could)    Coupon (could)    Receipt PDF(could)
```

**Release 1 line drawn after the "must" row:**

```
─── Release 1 (walking skeleton) ──────────────────────────────────────
  Search           Photos          Address           Summary
                                   Card entry        Confirmation email
─── Release 2 ─────────────────────────────────────────────────────────
  Filter results   Reviews         Coupon            Receipt PDF
─── Later ─────────────────────────────────────────────────────────────
  Browse category  Zoom            Saved addresses   Order tracking
```

**Walking-skeleton test.** A user can search, find an item, view photos, enter shipping and payment, and receive a confirmation email. They cannot filter, read reviews, apply a coupon, or browse by category. The experience is minimal but complete — the user accomplishes the goal.

**What makes this map good.** The Release 1 line runs horizontally across all four activities. Engineering can see that search, photos, address entry, card entry, and confirmation email are the walking skeleton — not all five activities at full fidelity. The team has a single artifact that answers both "what's the user doing" (the spine) and "what are we building first" (the slice).

---

### Counter-example — Flat backlog mislabelled as a story map

```
Priority | Story
---------|----------------------------------------------
  High   | As a shopper, I can search for products
  High   | As a shopper, I can filter by category
  High   | As a shopper, I can view product photos
  High   | As a shopper, I can read reviews
  Medium | As a shopper, I can enter a shipping address
  Medium | As a shopper, I can apply a coupon
  Low    | As a shopper, I can save my payment method
```

**What's wrong.** This is a priority-ranked backlog, not a story map. There is no backbone — no left-to-right user journey. There is no walking-skeleton test — you cannot look at the "High" items and ask "do these stories together deliver a working end-to-end experience?" (Answer: no — there is no order placement or confirmation story in the high tier.) The horizontal axis is missing entirely; priority is a single-dimensional ranking, not a narrative sequence. Calling this a story map does not make it one.

The team will ship search and filtering before they can accept a payment. That is not an MVP; it is a half-built experience.

## Common Pitfalls

### Pitfall 1 — Activities are features, not user behaviors

**Symptom.** The backbone reads: "Dashboard," "Settings," "Reports," "Notifications."

**Consequence.** The team has mapped the product's information architecture, not the user's journey. There is no narrative to slice — every activity is independent, so release lines become arbitrary. The walking skeleton has no meaning because there is no story to complete.

**Fix.** Restate each activity as what the user is *trying to do*: "Monitor project health," "Configure alert preferences," "Share progress with stakeholders," "Respond to blockers." Now the backbone tells a story, and release 1 can be the minimum story arc that delivers value.

### Pitfall 2 — Slicing vertically instead of horizontally

**Symptom.** Release 1 is "all stories for the Find Item activity." Release 2 is "all stories for the Review Item activity."

**Consequence.** Release 1 is a search feature with no path to purchase. Real users cannot use it to accomplish their goal. This is Patton's "walking skeleton" failure — the skeleton walks sideways (one activity, full depth) instead of end-to-end (all activities, minimum depth).

**Fix.** Apply the walking-skeleton test before finalizing Release 1. Draw the horizontal line. Check that every activity has at least one story above the line and that those stories together deliver a complete user experience.

### Pitfall 3 — Map built by PM in isolation

**Symptom.** PM creates the map in a planning tool, exports it, and presents it to engineering and design in a review meeting.

**Consequence.** Torres (*Continuous Discovery Habits*) calls this a handoff — the opposite of continuous discovery. Engineering hasn't heard the user research behind the activity ordering. Design hasn't negotiated which stories are "must" vs. "could." The map may be structurally sound but the team has no ownership of it, and the first sprint will surface every disagreement the mapping session should have surfaced.

**Fix.** Run the map as a workshop. PM provides the user sentence and the horizon (Phase 1); the full team builds the spine and writes stories together. The conversation is the work.

### Pitfall 4 — Walking skeleton too fat

**Symptom.** Release 1 contains 60–70% of all stories. The team justified each inclusion as "necessary for a coherent experience."

**Consequence.** The map's entire value is in forcing hard choices about minimum viable experience. A fat walking skeleton means no hard choices were made. The team will miss the release target, cut scope under pressure without a principled map to guide cuts, and end up with an incoherent partial experience anyway.

**Fix.** Knapp et al. (*Sprint*) recommend time-boxing scope decisions. Apply the same pressure here: draw the walking-skeleton line in 15 minutes. If the team debates every card, the debate is about product vision, not release scope — escalate that conversation explicitly rather than resolving it by including everything.

### Pitfall 5 — Map never updated after sprint 1

**Symptom.** The story map is produced once, the backlog is loaded, and the map is never touched again. Three sprints later the map and the backlog have diverged.

**Consequence.** The map loses its value as a planning tool. Teams stop trusting it. The backlog becomes a flat priority list again, and the user narrative is lost.

**Fix.** The map is a living artifact. Update it when discovery reveals a missing activity, when engineering uncovers a dependency that changes the walking skeleton, or when a story is delivered and can be marked. A 15-minute map review at the end of each sprint is sufficient to keep it current.

### Pitfall 6 — Confusing the map with the backlog

**Symptom.** The team treats every card in the "Later" row as formally committed scope. Stakeholders read the full map as the product roadmap and ask why items in the bottom row aren't scheduled.

**Consequence.** Cagan (*Inspired*) warns against output commitments that outrun evidence. Stories in the lower rows of a story map are hypotheses about user needs, not commitments. Treating them as commitments produces a build trap: the team ships the full map regardless of what they learn from earlier releases.

**Fix.** Name the distinction explicitly when presenting the map. Release 1 stories are commitments. Stories in later rows are current hypotheses — they will change as the team learns. The map is the current best understanding, not a contract.

## References

- **Jeff Patton** — *User Story Mapping: Discover the Whole Story, Build the Right Product* (2014, O'Reilly). The canonical source for every structural concept in this skill: the two-dimensional map, the narrative spine, the walking skeleton, release slices, and the "map is a conversation" framing. Chapters 1–5 are load-bearing. This skill is a re-expression of Patton's framework in Hornero's voice; all structural credit belongs to Patton.
- **Jeff Patton** — ["It's Not Just Standing Up"](https://www.jpattonassociates.com) and related blog articles (jpattonassociates.com). Patton's articles on story map facilitation and the distinction between the spine and the slice informed the Phase 2 and Phase 4 guidance in Application.
- **Teresa Torres** — *Continuous Discovery Habits: Discover Products that Create Customer Value and Business Value* (2021, Product Talk Press). The discovery-to-delivery handoff framing in Key Concepts traces directly to Torres. The story map is positioned here as the bridge between opportunity and delivery, not as a planning tool that exists independently of discovery.
- **Marty Cagan** — *Inspired: How to Create Tech Products Customers Love* (2017, 2nd ed., Wiley). Pitfall 6 (output commitments outrunning evidence) is grounded in Cagan's build-trap diagnosis and the outcome-vs-output discipline from *Inspired* and *Empowered*.
- **Jake Knapp, John Zeratsky, Braden Kowitz** — *Sprint: How to Solve Big Problems and Test New Ideas in Just Five Days* (2016, Simon & Schuster). Time-boxing discipline applied in Pitfall 4 — forcing walking-skeleton decisions within a fixed window rather than debating indefinitely.
- **Related Hornero skills:**
  - [`prd`](../prd/SKILL.md) — stories from the walking skeleton become the input to the PRD for the first release. The map scopes the PRD; the PRD operationalises individual stories from the map.
  - [`bet-portfolio`](../bet-portfolio/SKILL.md) — story maps are bet-level artifacts. The map for a given bet makes its scope and walking skeleton visible at portfolio review.
  - [`prioritization-advisor`](../prioritization-advisor/SKILL.md) — when the vertical stacking (must/should/could) is contested, prioritization-advisor runs the scoring. The map provides the structure; prioritization-advisor resolves the disputes.
  - [`opportunity-solution-tree`](../opportunity-solution-tree/SKILL.md) — the OST is the discovery artifact that identifies which opportunity to map. Run OST before story mapping when the team disagrees on which user problem to address.
  - [`workshop-facilitation`](../workshop-facilitation/SKILL.md) — story mapping is a facilitated workshop. For facilitation protocol — how to run the session, handle divergence, and converge on the spine — see workshop-facilitation.

*Synthesis cue: adapted from Dean Peters' [Product-Manager-Skills](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/user-story-mapping) (CC BY-NC-SA 4.0). Hornero's re-synthesis is MIT.*
