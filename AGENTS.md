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

## Adding new agent instructions

If a specific action you learned to do better will be useful to other agents doing the same task in the future, but may not be needed for all agent-related tasks, create or update skills in `.github/skills/`.

If you learned something that will be useful to any contributor to this project, update `AGENTS.md`.
