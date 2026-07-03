# TwitchySharp

TwitchySharp is a .NET 8 Twitch API client library. It contains typed request and response models for Twitch authentication and Helix APIs, helper utilities for Twitch-specific serialization, and NUnit tests for the client surface.

## Repository Layout

- `TwitchySharp.Api/` - main Twitch API client library.
- `TwitchySharp.Helpers/` - shared helper types and JSON converters.
- `TwitchySharp.Test/` - NUnit test project.
- `.pipelines/TwitchySharp.yml` - existing Azure Pipelines package/publish workflow.
- `TwitchySharp.sln` - solution entrypoint.

## Requirements

- .NET SDK 8.x

## Validation

Run the repository validation entrypoint:

```bash
./scripts/validate.sh
```

The script restores, builds, and tests `TwitchySharp.sln` in Release configuration.

## Work In Progress

### Authentication API Models
- [X] Authentication Url Generators
- [X] Get App Access Tokens
- [X] Get User Access Tokens
- [X] Validate User Access Tokens
- [X] Refresh User Access Tokens
- [X] OIDC
- [X] User Info
- [X] Device Code Flow
- [X] Revoke User Access Token
- [X] Scopes

### Helix API Models
- [X] Ads
- [X] Analytics
- [X] Bits
- [X] Channels
- [X] Channel Points
- [X] Charity
- [X] Chat
- [X] Clips
- [X] Conduits
- [X] CCLs
- [X] Entitlements
- [X] Extensions
- [X] EventSub
- [X] Games
- [X] Goals
- [X] Guest Star
- [X] Hype Train
- [X] Moderation
- [X] Polls
- [X] Predictions
- [X] Raids
- [X] Schedule
- [X] Search
- [X] Streams
- [X] Subscriptions
- [X] Teams
- [X] Users
- [X] Videos
- [X] Whispers

### API Integration Tests
- [ ] Authentication
- [ ] Ads
- [ ] Analytics
- [ ] Bits
- [ ] Channels
- [ ] Channel Points
- [ ] Charity
- [ ] Chat
- [ ] Clips
- [ ] Conduits
- [ ] CCLs
- [ ] Entitlements
- [ ] Extensions
- [ ] EventSub
- [ ] Games
- [ ] Goals
- [ ] Guest Star
- [ ] Hype Train
- [ ] Moderation
- [ ] Polls
- [ ] Predictions
- [ ] Raids
- [ ] Schedule
- [ ] Search
- [ ] Streams
- [ ] Subscriptions
- [ ] Teams
- [ ] Users
- [ ] Videos
- [ ] Whispers

### API Misc
- [ ] Change duration to use TimeSpan with converters

### EventSub
- [ ] Notification Models
- [ ] Websockets Handler
- [ ] Webhooks Handler

### Not Planned (Obsolete)
- PubSub
- IRC Chatbots
- Tags API
