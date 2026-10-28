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
3. `.github/workflows/polyhydra-publish.yml` tests and packs on the validation runner, then the
   `nuget-twitchysharp-publish` runner on sky-catchy pushes to nuget.org with Trusted Publishing.

## Runner split

| Runner labels | Used by | Notes |
| --- | --- | --- |
| `self-hosted, Linux, X64, nuget-twitchysharp` | `package` job in `polyhydra-publish.yml`, `semgrep.yml` | Validation: checkout, tests, pack, verify, semgrep. Same-repository PRs only; fork PRs are skipped with no GitHub-hosted fallback. |
| `self-hosted, nuget-twitchysharp-publish` | `publish-nuget-org` job (v* tags only) | Never checks out or runs repository code; receives finished packages via cache; OIDC Trusted Publishing. |

The `nuget-twitchysharp` validation runner is not registered yet (separate approval-gated step);
until it exists these jobs queue. `eng/test_workflows.py` (`python3 -I eng/test_workflows.py`)
asserts no hosted labels remain, validation jobs carry the fork gate, and the publish job keeps its own label.

`semgrep.yml` runs `p/default` + `p/security-audit` at ERROR severity (baseline = PR base commit) and uploads SARIF.
