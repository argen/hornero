# Jeff Patton — distilled

> *User Story Mapping: Discover the Whole Story, Build the Right Product* (2014). O'Reilly. The canonical technique for replacing flat backlogs with a two-dimensional map of the user's journey — activities across the top, story details below — that preserves narrative context across discovery, planning, and delivery.

## Why it matters for AI-coding

AI tools that help manage or generate backlogs default to flat lists sorted by some combination of priority score, effort estimate, and recency. A flat list loses the thread of why stories exist — what user activity they belong to, what alternative stories were deprioritized, what sequence of steps a user takes through the product. Patton's story map is the structural antidote: a two-dimensional artifact that keeps the customer journey visible even as the engineering team works horizontally through individual stories.

As AI-assisted development compresses delivery speed, the backlog grows faster than teams can reflect on it. Story maps impose a customer-journey constraint that forces coherence — you can't add a story without placing it in the map, which requires knowing what activity it belongs to and what user step it extends.

## Key concepts the role pulls from

- **The story map structure.** Two axes: the horizontal (user activities — the narrative backbone of what the user does in order) and the vertical (story depth — variations, exceptions, and details below each activity step). The top row of each activity column is the "walking skeleton" — the minimum set of stories that lets a user complete the activity at all. Everything below is detail added in subsequent releases.
- **The walking skeleton / minimal viable narrative.** The first horizontal slice through the map is the minimum viable product — not the minimum set of features, but the minimum narrative: can a user accomplish the whole journey, even poorly? This reframes MVP from "how little can we ship?" to "what's the thinnest complete story we can tell?" Powers the PRD's "what does a working version look like?" success criterion.
- **Activities vs. tasks vs. stories.** Patton's hierarchy: Activities are the big-motion goals (e.g. "plan a trip"); Tasks are the steps within an activity (e.g. "search destinations"); Stories are the specific implementations of a task step (e.g. "filter by price range"). Flat backlogs collapse all three into the same list, losing the hierarchy. The map preserves it.
- **Releases as horizontal slices, not vertical stacks.** A release is a horizontal slice through the map: the minimum set of stories (one per activity column) that produces a coherent user experience. A vertical stack (all stories for one activity) ships a deep feature but leaves adjacent activities empty — users can't complete any journey. Horizontal releases keep the product whole.
- **Shared understanding as the artifact.** Patton argues the map is not the point; the conversation that builds the map is. The physical act of placing story cards creates shared understanding that neither a written PRD nor a ticket queue produces. This is why the `prd` skill recommends collaborative discovery sessions before writing — the map-building conversation is the discovery.

## What to actually read (1-hour budget)

- **Chapters 1-4** — the core story-mapping technique: why flat backlogs fail, the two-dimensional map, the walking-skeleton concept, and the first story-mapping session walkthrough. ~80 pages. Everything else in the book is application of these four chapters.
- **Chapter 12** — "Story Mapping in Practice" — the worked example from a real product session. The most immediately replicable chapter for running your own session.
- Patton maintains a blog and has conference talk recordings (Agile Alliance, ProductTank) that cover the core technique in 30-45 minutes; the talks are often more accessible than the book for first encounter.

## What to skip

- Chapters on estimation and velocity are Agile-process context that predates the current landscape. Patton is a thoughtful practitioner, but his estimation advice is bound to a 2012 development-process context.
- The appendices on facilitation logistics are useful for a first in-person mapping session but not load-bearing for understanding the technique.

## How this anchors role skills

- [`prd`](../../skills/prd/SKILL.md) — story-map vocabulary ("activity," "walking skeleton," "horizontal release slice") informs how the PRD's scope section is structured. A PRD that scopes to a walking skeleton is Patton-compliant; one that scopes to "all stories for feature X" may be a vertical-stack release and should be flagged.
- [`discovery-interview-prep`](../../skills/discovery-interview-prep/SKILL.md) — the OST (Torres) and the story map (Patton) are complementary artifacts: the OST captures opportunities and solution hypotheses organized by outcome; the story map captures user activities and story details organized by user journey. Together they cover the "why" (OST) and the "how the user experiences it" (story map).
- [`cross-functional-orchestration`](../../skills/cross-functional-orchestration/SKILL.md) — when the PM is orchestrating a release decision, the story map is the artifact that makes "what's in / what's out" visible across functions. A horizontal slice decision is legible to designers, engineers, and QA in a way a priority-sorted ticket list is not.

## Cross-role connection

Patton's story map and the designer role's user-journey mapping are close cousins — both trace the user's experience horizontally through time. The designer's journey map captures the emotional arc; Patton's story map captures the task decomposition. In a collaborative session, the two artifacts complement each other: the journey map identifies pain points and delight moments; the story map translates them into the product's work breakdown.
