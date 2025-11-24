# 🌱 seeds

Deterministic vector-based RNG seeding for procedural generation.

`seeds` is a tiny Nim module that lets you turn 2D coordinates into stable random seeds.  
Use it to place objects, enemies, trees, loot, structures, and more in infinite worlds **without pre-baked maps** or global RNG state.

## ✨ Why Use Vector-Based Seeds?

Many procedural games rely on noise maps (Perlin/Simplex/etc.) to generate terrain.  
But terrain noise doesn’t magically decide:

- where plants should grow,
- where enemies spawn,
- what loot a tile drops,
- what weather a region has,
- or how rare structures should appear.

Developers often resort to **pre-baked world data**, limiting world size and preventing worlds from expanding as the player explores.

`seeds` solves that by generating **deterministic RNG from world coordinates**, letting you:

✔️ Save only player-made changes  
✔️ Generate everything else on demand  
✔️ Expand the game world forever

---

## 📦 Install

```bash
nimble install https://github.com/RattleyCooper/seeds
```

## 🧬 Usage Example

```nim
import vmath
import seeds

# Set the world seed (only do this once)
seeds.seed = 9

let v = ivec2(10, 15)

# Get a unique hash for the vector
echo v.hash()

# Get a consistent value between 0.0 and 1.0 for this location
echo v.saturation

# Create a deterministic RNG for this position
var r = v.initRand()

# Roll deterministic random values
echo r.rand(1.0)
```

## 🌲 Use Cases

You can use vector-seeded RNG to procedurally decide:

* Tree type	determined by local saturation threshold
* Animal/Enemy spawns	determined by seeded range rolls
* Weather events determined by time + tile seed
* Loot rarity determined by compound RNG rolls
* Structure placement determined by seeded checks with sparse outcomes

Combine this with noise maps to create complex worlds without storing anything.

## 🎯 Collision Testing

This library uses 64-bit multiplication combined with bit-shifting and XOR.
It’s not a “perfect hash”, but it performs exceptionally well.

*Real test results:*

* 178,000,000 vector hashes tested

* Symmetry swaps checked (x,y) vs (y,x)

* 0 collisions found

* Stopped only due to system RAM exhaustion and results being more than good enough to continue testing 😅

This is far beyond what most game worlds will ever require.

> In other words: more than safe enough for procedural games.

## ️⚠️ Limitations

* Hash collisions are mathematically possible (just extremely unlikely).
