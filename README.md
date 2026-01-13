# Aesthetic Optimizer

iOS facial analysis app with streak-based retention.

## Quick Start

1. **Read the spec:** [`PROJECT_SPEC.md`](PROJECT_SPEC.md) - single source of truth
2. **Setup guide:** [`SETUP_GUIDE.md`](SETUP_GUIDE.md) - how to compile on Mac

## Project Structure

```
Looksmaxxing_App/
├── README.md           ← You are here
├── PROJECT_SPEC.md     ← Full specification
├── SETUP_GUIDE.md      ← Compilation instructions
├── LooksmaxxingApp/    ← iOS source code (complete)
└── 99_ARCHIVE/         ← Historical research & planning docs
```

## Status

**MVP Built** → Ready for testing

- All code complete
- Needs Mac + Xcode to compile
- Test for 7-14 days
- Kill if Day 7 retention <10% or conversion <2%

## What This Is

- AI facial analysis (on-device, mocked heuristics)
- Rating 1-10 with strengths/weaknesses
- Daily streak system (3 micro-tasks)
- $14.99/month subscription
- Local-only data storage

## What This Is Not

- Not a real AI model (using Vision framework)
- Not connected to cloud
- Not monetized yet (RevenueCat simulated)
- Not validated (testing phase)

---

Last updated: January 12, 2026
