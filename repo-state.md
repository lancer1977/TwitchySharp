# Repo State

Last reviewed: 2026-07-03

## Status

TwitchySharp is an active .NET 8 client library for Twitch authentication and Helix APIs. It has API, helper, and NUnit test projects.

## Validation

- `./scripts/validate.sh`
- GitHub Actions runs the same script on `ubuntu-latest` with .NET 8.
- Existing Azure Pipelines config remains available for package publishing.

## Steward Notes

- Documentation spine restored.
- Validation entrypoint added.
- Default validation should remain free of live Twitch credentials.
