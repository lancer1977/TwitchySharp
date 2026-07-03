# Agent Notes

## Scope

TwitchySharp is a .NET 8 Twitch API client library with NUnit coverage. Keep routine maintenance focused on the API/helper/test projects unless a task explicitly targets packaging or Azure Pipelines publishing.

## Validation

Run:

```bash
./scripts/validate.sh
```

This runs `dotnet test TwitchySharp.sln --configuration Release`.

## Conventions

- Preserve nullable annotations.
- Keep Twitch request/response models strongly typed.
- Do not change publish credentials or pipeline secrets during stewardship work.
