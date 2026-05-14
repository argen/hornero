# Erika Hall — distilled

> *Just Enough Research* (2013; revised 2019); *Conversational Design* (2018). The practitioner's argument that research is a discipline, not a deliverable — and that the discipline begins with asking the right question.

## Why it matters for AI-coding

AI tools hallucinate research findings. Ask a model to describe your users and it will generate plausible, demographically coherent personas, typical pain points, and likely use cases — synthesised from training data, presented with confidence, unanchored to the actual humans who will use the product. Hall's *Just Enough Research* is the methodology's corrective: research is not the generation of plausible-sounding user facts; it is the *disciplined collection of specific evidence* that tests a specific assumption. The methodology invokes Hall whenever a design decision is justified with "users want X" — the test is: what method was used, who was actually observed or interviewed, and what assumption is this evidence meant to disconfirm? If the answer is "we discussed it in the design meeting," the claim is not research, it is a hypothesis.

## Key concepts the role pulls from

- **"Just enough" is a discipline, not laziness.** Hall's title is sometimes misread as "you don't have to do much research." The actual argument is the opposite: do the minimum research required to make a defensible decision, and no more — but also no less. The failure mode Hall addresses is not too much research but *the wrong research* or *performed research*: activities that look like research (user surveys, analytics pulls) but that don't actually test the decision in question.
- **Research questions vs. research methods.** Most teams start with a method ("let's do user interviews") rather than with a question ("do users understand what this feature does?"). Hall argues for starting with the question, then choosing the method that most efficiently answers it. The methodology applies this by insisting that any research recommendation name the specific assumption it is designed to test.
- **Evaluative vs. generative research.** Evaluative research tests something that exists (a prototype, a design, a product): "does this work?" Generative research explores a space to discover what to build: "what is the problem?" The two require different methods. Conflating them — running a usability test when you need ethnographic fieldwork, or interviewing users about a hypothetical when you should observe behaviour with a prototype — is the most common research method error.
- **The assumption audit.** Before running research, list every assumption the design rests on. Each assumption is a potential falsifying question. Research that doesn't test an assumption doesn't change a decision. Hall's framework turns the assumption list into the research agenda.
- **Conversational Design's contribution: interactions as conversations.** From *Conversational Design*: every UI is a conversation — a turn-by-turn exchange where the system says something and the user responds. Good conversational design is coherent (each turn follows logically), cooperative (the system gives the user what they need when they need it), and honest (the system doesn't hide or mislead). AI-generated copy frequently fails the cooperative principle — it gives users information they didn't ask for while withholding what they actually need.

## What to actually read (1-hour budget)

- *Just Enough Research* **chapters 1-4** — why to do research; how to frame the right question; evaluative vs. generative. ~80 pages. The conceptual backbone.
- *Just Enough Research* **chapter 6** — "Evaluative Research" — the usability study and expert review methods in Hall's voice. ~25 pages. Most immediately applicable to the methodology's review skills.
- *Conversational Design* **chapters 1-3** — the conversational metaphor; the cooperative principle; what makes copy feel like it's talking *with* the user rather than *at* them. ~50 pages. Short and readable; worth finishing the book.

## What to skip

- *Just Enough Research* chapters on large-scale quantitative research (surveys, analytics) — valuable in the right context but less load-bearing for the small-product, AI-assisted design contexts the methodology addresses. Read when you need them.
- The 2019 revision's additions are mostly updates to reflect contemporary digital-research methods; the 2013 core is the argument.

## How this anchors role skills

- [`design-review`](../../roles/designer/skills/design-review/SKILL.md) — the visual-coherence step's "does it have a point of view?" question is partly a Hall question: is there a specific user need this is responding to, or is this a plausible-generic design with no research grounding?
- [`heuristic-review`](../../roles/designer/skills/heuristic-review/SKILL.md) — Hall's evaluative-research framing distinguishes expert review (what the skill is) from user testing (what the skill recommends at the end). Understanding the distinction prevents conflating them.
- [`accessibility-audit`](../../roles/designer/skills/accessibility-audit/SKILL.md) — Hall's insistence on observing real behaviour rather than imagining representative users is the same discipline behind "test with real screen-reader users, not just automated tools."

## Cross-role connection

Hall's research discipline is a structural sibling of the product-manager's discovery-interview-prep skill: both are about going to talk to actual humans with a structured intention — specific questions, specific assumptions to test, specific evidence to collect — rather than "getting user feedback" in an unstructured way. Where discovery-interview-prep focuses on framing the conversation and capturing jobs-to-be-done signals, Hall's framework focuses on ensuring the conversation tests an assumption that can actually change a design decision. In practice, a well-run discovery interview produces both JTBD framing and Hall-style research evidence; the disciplines reinforce each other when the designer and PM share the same interview.
