# Security Policy

## Reporting a vulnerability

Please **do not** open a public GitHub issue for security reports.

Use GitHub's private vulnerability reporting:

1. Go to the repository's [**Security** tab](https://github.com/argen/hornero/security).
2. Click **Report a vulnerability**.
3. Describe the issue, the affected files or skills, and a reproduction if you have one.

You should expect an acknowledgement within a few days. Once a fix is ready, the advisory is published alongside the patch release.

## Scope

Hornero ships prompts, skills, hooks, and shell scripts — not a running service. The kinds of issues that are in scope:

- Shell scripts under `scripts/`, `hooks/`, or `install.sh` that execute attacker-controlled input unsafely, write outside the workspace, or escalate privileges.
- Skills, role files, or commands that, when invoked through the documented dispatcher, exfiltrate secrets, overwrite unrelated files, or coerce the host agent into destructive actions.
- Supply-chain risks in the install path (`install.sh`, plugin manifests, hook configuration).

Out of scope:

- Prompt-injection by content the user themselves paste into the conversation — Hornero is a methodology layer and cannot defend against arbitrary text the operator chooses to feed the model.
- General "the LLM said something wrong" outputs.

## Supported versions

Only the latest `main` is supported. Tagged releases are fixed forward — there are no backports.
