# AGENTS.md

## Setup commands

Always use `bundle` and `rake` commands, not any third-party packaging tools.

- Install dependencies for all subprojects: `rake bundle`
- Run unit and client tests: `rake test:client`
- Run YAML API tests: `rake test:yaml`
- See all available test tasks: `rake -T`

## Testing

**`rake test:client` must pass before you commit code.**

Integration tests require Elasticsearch running on `localhost:9200`. They are skipped automatically if no server is available, so a failing integration test in CI always means a real failure.

## Project Structure

This repo contains two subprojects, each with its own `Gemfile` and `Rakefile`:

- **elasticsearch/** - main gem (client, transport, DSL)
- **elasticsearch-api/** - generated API layer and YAML test runner

Top-level `Rakefile` and `rake_tasks/` orchestrate tasks across all subprojects.

## Development Workflow

1. Run `rake bundle` to install dependencies in all subprojects.
2. Make changes to files in the relevant subproject.
3. Run `rake test:client` to verify unit tests pass.
4. If your change touches API behaviour, also run `rake test:yaml`.

## Maintainer conventions

Distilled from the past year of commits, PRs, and issue replies by the previous maintainer (Fernando Briano, @picandocodigo).

### Generated API code

- Files under `elasticsearch-api/lib/elasticsearch/api/actions/` are generated from the [Elasticsearch specification](https://github.com/elastic/elasticsearch-specification). Do not hand-edit them; fix the generator or the spec instead.
- Regenerate in a dedicated commit that names the spec commit, e.g. `[API] Generates <spec-sha>`.
- Call out notable API changes in separate commits: new endpoints, new parameters, HTTP method changes, removals, and stability promotions (experimental/technical preview → stable).
- Use "technical preview", not "experimental", in docs and CHANGELOG.
- Every new endpoint gets a unit spec in `elasticsearch-api/spec/unit/actions/` that asserts the HTTP method, path, params, and `endpoint`/`defined_params` passed to `perform_request`. Copy an existing spec as the template.

### Bug fixes

- Link the issue in the commit/PR body (`Fixes #NNN`).
- Prefer the smallest fix (e.g. a safe-navigation operator) plus regression specs covering the failing input.
- Header handling (`Content-Type`, `Accept`, `compatible-with`, `Elastic-Api-Version`) is fragile. Never override a header the user set explicitly, never send duplicates, and never send `compatible-with` together with `Elastic-Api-Version` (Serverless rejects that). Test both Faraday and Manticore/JRuby paths.
- Some fixes live in [elastic-transport-ruby](https://github.com/elastic/elastic-transport-ruby); reference the transport PR when one is needed.

### Releases and supported versions

- Bug fixes are backported and released as patches for every currently supported minor branch (e.g. `9.2`, `9.3`, `9.4`), not only `main`. Branches past their [end of life](https://www.elastic.co/support/eol) stop getting fixes and CI runs.
- A release updates `CHANGELOG.md` and `docs/release-notes/index.md` and bumps `version.rb`. After cutting a minor branch, bump `main` to the next minor version right away.
- Follow up on the issue when the fix ships, naming the released versions.

### Code quality

- Tests run with `--warnings`. Do not introduce Ruby warnings; fix any you find.
- Follow RuboCop style.
- New runtime dependencies must be declared in the gemspec (e.g. `base64` stopped being a default gem).
- Add a temporary skip for flaky upstream breakage (e.g. a single JRuby version) and revert the skip after the upstream fix.
- CI tests the supported Ruby versions (including JRuby). Remove a version once it reaches end of life.

### Commit messages

Prefix commit messages with the area of change: `[API]`, `[Gem]`, `[Tests]`, `[Test Runner]`, `[CI]`, `[Automation]`, `[DOCS]`. Release-branch-only changes add the branch, e.g. `[9.4][API] ...`.

## Adding new agent instructions

If a specific action you learned to do better will be useful to other agents doing the same task in the future, but may not be needed for all agent-related tasks, create or update skills in `.github/skills/`.

If you learned something that will be useful to any contributor to this project, update `AGENTS.md`.
