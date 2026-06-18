# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Project

Tourvi — a Ruby on Rails 8 application.

- **Ruby:** 3.3.5
- **Rails:** ~> 8.1.3
- **Database:** PostgreSQL
- **Frontend:** Hotwire (Turbo + Stimulus), import maps, Tailwind CSS
- **Auth:** Devise
- **Background jobs / cache / cable:** Solid Queue, Solid Cache, Solid Cable
- **Deploy:** Kamal (Docker)

## Common commands

- `bin/rails server` — run the app locally
- `bin/rails test` — run unit/integration tests
- `bin/rails test:system` — run browser/system tests
- `bin/rubocop` — lint (use `-a` to autocorrect)
- `bin/rails db:migrate` — run migrations
- `bin/brakeman` / `bin/bundler-audit` — security scans

CI (`.github/workflows/ci.yml`) runs: rubocop lint, the test suite, system tests,
and the brakeman / bundler-audit / importmap security scans. Keep all green.

## My rules

### General
- Always ask clarifying questions when needed.
- Don't overengineer — do only what's asked, unless there's a compelling reason
  (easier testing, fixing existing bugs, or simplifying the overall architecture).
- Always suggest the simplest possible approach first. Other options may be
  presented if clearly labeled with their advantages/disadvantages vs. the simplest.
- If I give feedback of an architectural, UI, or personal-style nature, remember it
  for future sessions. Feedback specific to the problem at hand does not need to be
  remembered.

### Rails
- Prefer Minitest over RSpec.
- Controllers must follow REST: only the canonical 7 actions, no more. If a
  non-RESTful action seems necessary, identify the "missing resource" first, create
  a controller for it, and use the proper RESTful actions there.
- Match the style and coding conventions already present in the codebase.

### UI
- Use Tailwind, with a minimalist but modern approach.
- Make new HTML mobile-responsive where possible, unless it severely overcomplicates
  the code.
- No inline styles — use Tailwind classes only.

### Testing
- Write a system test for every new user-facing feature.

### Tooling & docs
- Prefer documentation from Context7 before trusting anything on the internet.
- When adding new issues to Linear, mark them as "To Do".

### Workflow
- Run `bin/rubocop -a` before every commit.
- Never push directly to main.

### Things to avoid
- Don't add new gems without asking first.

### Git & safety
- Use the rebase strategy whenever possible to avoid merge conflicts.
- Never commit any code without my explicit consent.
- Never push any code to GitHub.
