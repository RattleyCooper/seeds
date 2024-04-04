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

seeds.seed = 10

let v1 = ivec2(-10, 10)
let v2 = ivec2(10, -10)
let v3 = ivec2(0, 10)
let v4 = ivec2(10, 0)

# Get the unique seed int for the vector
echo $v1.hash() # -59
echo $v2.hash() # -60
echo $v3.hash() # 31
echo $v4.hash() # 30

# Get Rand instances from vectors
var r1 = v1.initRand()
var r2 = v2.initRand()
var r3 = v3.initRand()
var r4 = v4.initRand()

# Get random numbers, roll, and reaches
# available for IVec2 and Rand.
echo $r1.rand(1.0) # 0.5496076515946029
echo $v1.roll(1.0) # 0.5496076515946029
echo $v1.reaches(0.54) # true
echo $v1.reaches(0.55) # false

echo $r2.rand(1.0) # 0.7737383046826343
echo $r3.rand(1.0) # 0.3358115106299164
echo $r4.rand(1.0) # 0.3330248963463649
```
