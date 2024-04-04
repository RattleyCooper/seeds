# seeds
 RNG with unique vector-based seeds for deterministic procedural generation.

## Install

`nimble install https://github.com/RattleyCooper/seeds`

## Seed RNGs with Vector Hashes

When making procedurally generated games you might want to place things in the world that you cannot determine using the height map from perlin noise. Objects like plants, enemy or animal spawn points are usually decided using something other than perlin noise, and some games result to pre-baking this information during initial world-generation, usually with a fairly limited world-size that does not expand beyond the initial world generation.

`seeds` provides a fast/deterministic way to place objects in a game world capable of expanding upon exploration. Seeds runs a hashing function on a vector and uses the result as a seed for a Random Number Generator. When you do a random number check with the seeded RNG instance it will always return the same result for the given vector.

## Example

```nim
import vmath
import seeds

# Set the seed for our game world.
# This should not change after being set.
seeds.seed = 9

let v1 = ivec2(-10, 10)
let v2 = ivec2(10, -10)
let v3 = ivec2(0, 10)
let v4 = ivec2(10, 0)

# Get a vector's hash
echo $v1.hash() # 9940
echo $v2.hash() # -9940
echo $v3.hash() # 9970
echo $v4.hash() # 30

# Saturation is the initial random number
# between 0.0 and 1.0, that a vector's
# seed will produce when used with 
# a random number generator. The
# saturation procedure does this for
# you.
echo $v1.saturation
echo $v1.saturation

assert v1.hash != v2.hash
assert v3.hash != v4.hash

# Create a Rand instance from IVec2
var r1 = v1.initRand()
var r2 = v2.initRand()
var r3 = v3.initRand()
var r4 = v4.initRand()

# Use the RNG
echo $r1.rand(1.0) # 0.4025111290151007
echo $r2.rand(1.0) # 0.9283733660063962
echo $r3.rand(1.0) # 0.8522231909071714
echo $r4.rand(1.0) # 0.1037782474596014
```

# Hash Collisions

There are hash collisions. This isn't meant to produce a unique hash for every single vector, but it does provide a pretty good distribution from my tests. I tested 1 million unique vectors and there were 1491 collisions, so roughly 0.15%. More than acceptable for this use case.
