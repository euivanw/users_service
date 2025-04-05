# Changelog

This document serves as a comprehensive record of any substantial modifications
made to this project.

We adhere to the format prescribed in the Keep a Changelog
guide (https://keepachangelog.com/en/1.1.0/) to meticulously document these
changes. Additionally, this project conforms to the Semantic Versioning
guidelines outlined in the Semantic Versioning
specification (https://semver.org/spec/v2.0.0.html). Furthermore, we incorporate
the principles established in the Conventional Commits
guide (https://www.conventionalcommits.org/en/v1.0.0/) when committing changes
to the project.

## [Unreleased]

## [v1.0.2] - 2025-04-05

### Fixed

- Fixed environment variable DB_USERNAME.

## [1.0.1] - 2025-04-05

### Added

- Create a Git Tag on GitHub when a new version is released.
- Added Docker compose and Kubernetes deployment example files.

### Fixed

- Fixed the update_version GitHub Action.
- Fixed the [Unreleased] section related to the version 1.0.0 in the changelog.
- Fixed the way to look for environment variables.
- Fixed the generation of Docker image.

## [1.0.0] - 2025-04-05

### Added

- Ability to generate database migrations.
- Ability to create a users table into the database.
- Ability to create, update, delete, read and list users.

### Dependencies

- `args`: 2.7.0
- `dart_either`: 2.0.0
- `logging`: 1.3.0
- `postgres`: 3.5.4
- `sdk`: 3.7.1
- `shelf`: 1.4.2
- `shelf_router`: 1.1.4
- `uuid`: 4.5.1

### Dev Dependencies:

- `http`: 1.3.0
- `lints`: 5.1.1
- `test`: 1.25.15
