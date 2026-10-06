# Polyhydra packaging overlay (fork-only)

This folder and `Directory.Build.targets` exist only on the fork's `polyhydra/publish`
branch. `master` mirrors upstream (Yoyoyopo5/TwitchySharp) exactly.

The overlay is inert unless `-p:PolyhydraPackaging=true` is passed, so normal
builds are identical to upstream.

| File | Purpose |
| --- | --- |
| `Polyhydra.Packaging.targets` | `PolyhydraGames.` package ID prefix, version, license/attribution metadata |
| `packages.txt` | The 8 projects that get published |
| `pack.sh <version> <out>` | Pack all of them with the overlay |
| `verify-packages.py <out> <version>` | Check IDs, version, and that internal deps use the prefixed IDs |

## Release

1. Sync upstream: `git fetch upstream && git switch master && git merge --ff-only upstream/master && git push origin master`, then merge `master` into `polyhydra/publish`.
2. Tag and push: `git tag v0.1.0-preview.N && git push origin v0.1.0-preview.N`.
3. `.github/workflows/polyhydra-publish.yml` tests and packs on GitHub-hosted runners, then the
   `nuget-twitchysharp-publish` runner on sky-catchy pushes to nuget.org with Trusted Publishing.
