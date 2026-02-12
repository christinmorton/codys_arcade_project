# Codys Arcade Project Plan

## Team & Vision

**Team Size:** 3
**Engine:** Godot 4.x (GDScript)
**Art Pipeline:** Low-poly Blender models → 2D pixel/sprite assets
**Project Type:** Arcade hub with a collection of mini-games
**Cadence:** 1 new mini-game every 1–2 weeks (after pipeline is established)

### What We're Building

A retro-style arcade cabinet launcher that hosts a growing collection of small, self-contained mini-games. Each game is simple, fun, and teaches us something new. The arcade itself is the portfolio piece  every game we add makes it better.

### Why This Works

- **Small scope per game**  each mini-game has a clear finish line
- **Progressive learning**  each game introduces one new concept
- **Parallel work**  team members can work on different parts simultaneously
- **Portfolio-ready**  even early games are shippable and demonstrable
- **Low risk**  if a game idea doesn't work, we scrap it and move on

---

## Roles & Responsibilities

Decide early who takes the lead on what. Everyone should learn everything, but having a point person keeps things moving.

| Role | Lead | Backup | Notes |
|------|------|--------|-------|
| Project Management / GDD | | | Keeps scope in check, writes game briefs |
| Godot Development | | | Core gameplay, scenes, scripting |
| Blender Modeling & Rendering | | | Models, sprite sheet renders, animations |
| UI / UX / Menus | | | Arcade hub, in-game HUD, menus |
| Audio / SFX | | | Sound effects, music (can use free assets early on) |

> **Fill this in together.** Roles can rotate per game to keep learning balanced.

---

## The Pipeline (How Assets Go From Idea to Game)

This is the most important thing to establish. Once this works, everything else is content.

```
1. CONCEPT       →  One-page game brief (see template below)
2. ASSET LIST    →  What models/sprites/sounds do we need?
3. BLENDER       →  Model low-poly assets
4. RENDER        →  Orthographic camera → sprite sheet export
5. GODOT         →  Import sprites, build scenes, add logic
6. PLAYTEST      →  Does it work? Is it fun?
7. POLISH        →  Juice it (screen shake, particles, sound)
8. SHIP IT       →  Merge to main, add to arcade hub
```

### Blender → 2D Sprite Workflow (Key Steps)

1. **Model low-poly**  keep it simple; 100–500 triangles per object is fine
2. **Set up orthographic camera**  no perspective distortion
3. **Light with 2–3 point lights**  consistent look across all assets
4. **Render animation frames**  e.g., 8 frames of a walk cycle
5. **Use transparent background**  render as PNG sequence
6. **Assemble sprite sheet**  use a tool or script to combine frames into a grid
7. **Import to Godot**  set up AnimatedSprite2D or AtlasTexture

> **Tools to explore:** Blender's built-in render-to-spritesheet addons, TexturePacker (free tier), or a simple Python/ImageMagick script.

---

## Repo Structure

```
Codys-arcade/
├── README.md
├── PROJECT_PLAN.md              ← this document
├── docs/
│   ├── game-briefs/             ← one-page briefs per game
│   │   ├── 00-pipeline-test.md
│   │   ├── 01-reaction-clicker.md
│   │   └── ...
│   ├── skill-tracker.md         ← what we've learned per game
│   └── style-guide.md           ← art/color/UI consistency rules
├── blender/
│   ├── models/                  ← .blend source files
│   ├── renders/                 ← rendered PNG sequences
│   └── sprite-sheets/           ← assembled sprite sheets
├── godot/
│   └── Codys-arcade/           ← Godot project root
│       ├── project.godot
│       ├── hub/                 ← arcade launcher/menu
│       ├── games/
│       │   ├── game_00/         ← pipeline test
│       │   ├── game_01/         ← first real game
│       │   └── ...
│       ├── shared/              ← reusable components
│       │   ├── ui/
│       │   ├── audio/
│       │   └── scripts/
│       └── assets/
│           ├── sprites/
│           ├── audio/
│           └── fonts/
└── .gitignore
```

---

## Game Brief Template

Copy this for each new mini-game. Save as `docs/game-briefs/XX-game-name.md`.

```markdown
# Game XX: [Game Name]

## Overview
**One sentence:** [What does the player do?]
**Genre:** [e.g., reaction, puzzle, shooter, rhythm, platformer]
**Target dev time:** [1 week / 2 weeks]
**New skill focus:** [What are we learning with this game?]

## Core Mechanic
- [Describe the single core thing the player does repeatedly]

## Win / Lose Conditions
- **Win:** [What earns points or triggers victory?]
- **Lose:** [What ends the game? Timer? Lives? Health?]

## Controls
- [List every input the player uses. Keep it minimal.]

## Asset List

### Sprites Needed (from Blender)
| Asset | Poly Count | Animations | Frames | Owner |
|-------|-----------|------------|--------|-------|
| e.g., Player ship | ~200 | idle, thrust, explode | 4, 6, 8 | [Name] |

### UI Elements
- [ ] Score display
- [ ] Start screen
- [ ] Game over screen
- [ ] [Other]

### Audio
- [ ] Background music (or silence)
- [ ] [List SFX: jump, hit, score, etc.]

## Task Breakdown

| Task | Owner | Status |
|------|-------|--------|
| Write game brief | | ⬜ |
| Model assets in Blender | | ⬜ |
| Render sprite sheets | | ⬜ |
| Build Godot scene | | ⬜ |
| Implement core mechanic | | ⬜ |
| Add UI (score, menus) | | ⬜ |
| Add audio/SFX | | ⬜ |
| Playtest & fix bugs | | ⬜ |
| Polish & juice | | ⬜ |
| Merge to main | | ⬜ |

## Notes / Ideas
- [Anything else  stretch goals, references, inspiration]
```

---

## Skill Progression Roadmap

Each game introduces **one primary new concept**. Don't try to learn everything at once.

### Phase 0: Setup (Week 0)

**Goal:** Everyone has tools installed and the pipeline works end-to-end.

- [ ] Install Godot 4.x
- [ ] Install Blender 3.x+
- [ ] Set up GitHub accounts and clone repo
- [ ] Everyone completes a "hello world" in Godot (a sprite that moves with arrow keys)
- [ ] Everyone models a simple object in Blender (a cube with color/material)
- [ ] Render that object to a PNG with transparent background
- [ ] Import that PNG into Godot and display it on screen

> **This is Game 00  the pipeline test.** It doesn't need to be fun. It needs to *work*.

### Phase 1: Foundations (Games 01–03)

| Game | Concept Focus | Example Idea |
|------|--------------|--------------|
| 01 | Input + collision detection | **Reaction Clicker**  targets appear, click them before they disappear. Score based on speed. |
| 02 | Movement + physics | **Dodge Ball**  player moves to avoid falling objects. Survive as long as possible. |
| 03 | Sprite animation + game states | **Whack-a-Mole**  animated characters pop up, player whacks them. Intro/play/gameover states. |

### Phase 2: Mechanics (Games 04–06)

| Game | Concept Focus | Example Idea |
|------|--------------|--------------|
| 04 | Spawning + difficulty curves | **Asteroid Swarm**  endless waves that get harder. Introduces spawn timers and difficulty scaling. |
| 05 | Simple AI / enemy behavior | **Chase & Escape**  enemies that pursue the player using basic pathfinding or steering. |
| 06 | Scoring systems + persistence | **High Score Breaker**  any genre, but with persistent local high scores and a leaderboard screen. |

### Phase 3: Polish & Complexity (Games 07–10)

| Game | Concept Focus | Example Idea |
|------|--------------|--------------|
| 07 | Particle effects + screen shake | **Brick Breaker**  classic breakout clone with satisfying destruction effects. |
| 08 | Sound design + music sync | **Rhythm Tap**  simple rhythm game. Teaches audio timing and beat detection. |
| 09 | Tilemaps + level design | **Maze Runner**  procedural or hand-built maze. Introduces tile-based design. |
| 10 | Multiplayer (local) | **Pong Deluxe**  2-player local game. Introduces input splitting and multiplayer logic. |

> **These are suggestions, not requirements.** Swap in whatever excites the team. The skill focus column is what matters.

---

## Git Workflow (Keep It Simple)

Since you're all learning, start with the simplest possible workflow:

### Branch Strategy

```
main              ← always working, playable arcade
├── game-XX-name  ← one branch per game in development
├── feature/...   ← for hub/shared improvements
└── fix/...       ← for bug fixes
```

### Rules

1. **Never push directly to `main`.** Always use a branch + pull request.
2. **One game = one branch.** Create it when you start, merge when it's done.
3. **Pull before you push.** Always `git pull` before starting work.
4. **Commit often with clear messages.** e.g., `game-01: add player movement` not `stuff`
5. **If something breaks, ask for help.** Git mistakes are fixable. Don't panic.

### Commit Message Format

```
[area]: short description

Examples:
game-01: add player sprite and movement
hub: create arcade cabinet selection screen
blender: render game-02 enemy sprite sheet
docs: add game-03 brief
fix: correct collision bounds on game-01 targets
```

---

## Weekly Rhythm

A suggested schedule to keep momentum without burning out:

| Day | Activity |
|-----|----------|
| **Day 1 (Planning)** | Write game brief together. Agree on scope. Assign tasks. |
| **Days 2–3** | Asset creation (Blender) + scene setup (Godot) in parallel |
| **Days 4–5** | Core mechanic implementation + asset integration |
| **Day 6** | Playtest, bug fixes, polish |
| **Day 7** | Merge to main, retro: what did we learn? What was hard? |

> For 2-week games, double the middle phase. The planning and retro days stay the same.

---

## Tools & Resources

### Required
- **Godot 4.x**  [godotengine.org](https://godotengine.org/)
- **Blender 3.x+**  [blender.org](https://www.blender.org/)
- **Git + GitHub**  version control and collaboration
- **A text editor**  for docs and notes (VS Code works great)

### Recommended Learning
- **Godot:** GDQuest (YouTube), official Godot docs "Your First 2D Game" tutorial
- **Blender low-poly:** Imphenzia (YouTube)  specifically his "Low Poly Animals in 10 Minutes" style videos
- **Blender to sprite sheets:** search "Blender orthographic render sprite sheet" tutorials
- **Git basics:** GitHub's own guides at [docs.github.com](https://docs.github.com)

### Free Asset Sources (When You Need a Placeholder)
- **Audio:** freesound.org, kenney.nl
- **Fonts:** fontsquirrel.com, Google Fonts
- **Sprites (temporary):** kenney.nl (excellent free game assets)

> **Rule: Placeholders are fine early on.** Replace with custom assets when you can. Don't let asset creation block gameplay development.

---

## Definition of Done (Per Game)

A mini-game is "done" when:

- [ ] It has a start screen and a game-over screen
- [ ] The core mechanic works and is responsive
- [ ] There is a scoring or win/lose condition
- [ ] It uses at least one custom Blender-rendered asset
- [ ] It has at least basic sound effects
- [ ] It can be launched from the arcade hub
- [ ] It has been playtested by all 3 team members
- [ ] The game brief is filled out and in the docs folder
- [ ] The branch is merged to main

---

## First Steps (Do This Today)

1. **Everyone:** Install Godot and Blender if you haven't already
2. **Everyone:** Create a GitHub account and share your username
3. **Repo owner:** Create the repo with this structure and invite the team
4. **Together:** Complete Phase 0 (pipeline test) before starting any real game
5. **Together:** Pick your first real mini-game idea and write the brief

---

*Last updated: February 2025*
*Let's build some games.* 🎮
