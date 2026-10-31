"""Contract tests for the TwitchySharp runner split (validation vs publish)."""

import re
import unittest
from pathlib import Path

import yaml

WORKFLOWS = Path(__file__).parents[1] / ".github/workflows"
HOSTED = re.compile(r"\b(?:ubuntu|windows|macos)-[\w.]+\b", re.IGNORECASE)
VALIDATION = ["self-hosted", "Linux", "X64", "nuget-twitchysharp"]
PUBLISH = ["self-hosted", "nuget-twitchysharp-publish"]
GATE = "github.event.pull_request.head.repo.full_name == github.repository"


def load(name):
    return yaml.safe_load((WORKFLOWS / name).read_text(encoding="utf-8"))


class RunnerSplit(unittest.TestCase):
    def test_no_hosted_labels(self):
        for wf in WORKFLOWS.glob("*.y*ml"):
            for line in wf.read_text(encoding="utf-8").splitlines():
                if line.strip().startswith("runs-on:"):
                    self.assertIsNone(HOSTED.search(line), f"{wf.name}: {line}")

    def test_validation_jobs(self):
        for name in ("polyhydra-publish.yml", "semgrep.yml"):
            for job, spec in load(name)["jobs"].items():
                if job == "publish-nuget-org":
                    continue
                self.assertEqual(VALIDATION, spec["runs-on"], f"{name}:{job}")
                self.assertIn(GATE, spec.get("if", ""), f"{name}:{job} lacks fork gate")

    def test_publish_job_unchanged(self):
        spec = load("polyhydra-publish.yml")["jobs"]["publish-nuget-org"]
        self.assertEqual(PUBLISH, spec["runs-on"])
        self.assertEqual("write", spec["permissions"]["id-token"])
        self.assertIn("refs/tags/v", spec["if"])
        self.assertNotIn("actions/checkout", str(spec["steps"]))

    def test_semgrep_triggers(self):
        wf = yaml.safe_load((WORKFLOWS / "semgrep.yml").read_text())
        on = wf.get("on", wf.get(True))
        self.assertEqual(["polyhydra/publish"], on["pull_request"]["branches"])
        self.assertEqual(["polyhydra/publish"], on["push"]["branches"])


if __name__ == "__main__":
    unittest.main()
