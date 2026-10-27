---
paths: ["skills/**", "roles/**", "resources/**"]
---

# Editing skills, roles, and resources

- After editing a `SKILL.md`, run `scripts/validate-skill.sh <file>`.
- After changing a skill's `description:`, run `scripts/catalog.sh` and commit the regenerated `CATALOG.md`.
- After editing a `RESOURCE.md`, run `scripts/validate-resource.sh`.
- Quote any `description:` that contains `: `; the validator rejects it unquoted.
