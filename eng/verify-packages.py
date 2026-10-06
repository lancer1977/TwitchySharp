"""Check packed .nupkg files: exact expected IDs, one version, PolyhydraGames-only internal deps."""
import re
import sys
import zipfile
from pathlib import Path

out, version = Path(sys.argv[1]), sys.argv[2]
root = Path(__file__).resolve().parent.parent
expected = {"PolyhydraGames." + Path(p).stem for p in (root / "eng/packages.txt").read_text().split()}

found = {}
for nupkg in out.glob("*.nupkg"):
    with zipfile.ZipFile(nupkg) as z:
        nuspec = next(n for n in z.namelist() if n.endswith(".nuspec"))
        xml = z.read(nuspec).decode()
    pid = re.search(r"<id>([^<]+)</id>", xml).group(1)
    ver = re.search(r"<version>([^<]+)</version>", xml).group(1)
    deps = re.findall(r'<dependency id="([^"]+)" version="([^"]+)"', xml)
    found[pid] = (ver, deps)

errors = []
if set(found) != expected:
    errors.append(f"package set mismatch: missing={sorted(expected - set(found))} extra={sorted(set(found) - expected)}")
for pid, (ver, deps) in found.items():
    if ver != version:
        errors.append(f"{pid}: version {ver} != {version}")
    for dep, dver in deps:
        if dep.startswith("TwitchySharp."):
            errors.append(f"{pid}: depends on un-prefixed {dep}")
        if dep.startswith("PolyhydraGames.TwitchySharp.") and dver.strip("[]()") .split(",")[0] != version:
            errors.append(f"{pid}: internal dep {dep} {dver} not pinned to {version}")

for pid in sorted(found):
    ver, deps = found[pid]
    print(f"{pid} {ver}  deps: {', '.join(f'{d} {v}' for d, v in deps) or '-'}")
if errors:
    print("\n".join("ERROR: " + e for e in errors))
    sys.exit(1)
print(f"OK: {len(found)} packages")
