# seeds
 RNG with unique vector-based seeds for deterministic procedural generation.

When making procedurally generated games you might want to place things in the world that you cannot determine using the height map from perlin noise. Objects like plants, enemy or animal spawn points are usually decided using another method, and some games result to pre-baking this information during initial world-generation, usually with a fairly limited world-size that does not expand beyond the initial world generation.

`seeds` provides a fast/deterministic way to place objects in a game world. Seeds creates an RNG with a seed that's unique to a vector so that when you do a random number check it will always be the same result for the vector's value (so long as you reset the RNG before rolling the number).

## Example

```nim
import vmath
import seeds

seeds.seed = 10

let v1 = ivec2(-10, 10)
let v2 = ivec2(10, -10)
let v3 = ivec2(0, 10)
let v4 = ivec2(10, 0)

echo $v1.uniqueSeed() # -59
echo $v2.uniqueSeed() # -60
echo $v3.uniqueSeed() # 31
echo $v4.uniqueSeed() # 30

var r1 = v1.initRand()
var r2 = v2.initRand()
var r3 = v3.initRand()
var r4 = v4.initRand()

echo $r1.rand(1.0) # 0.5496076515946029
echo $v1.roll(1.0) # 0.5496076515946029
echo $v1.reaches(0.54) # true
echo $v1.reaches(0.55) # false

echo $r2.rand(1.0) # 0.7737383046826343
echo $r3.rand(1.0) # 0.3358115106299164
echo $r4.rand(1.0) # 0.3330248963463649
```
