import vmath
import random

var seed*: int = 0
var prime* = 3
var expander* = 997

let ms = int32.high div prime^2  # 238_609_294
let maxSize* = (low: -ms, high: ms)

proc hash*(v: IVec2): int {.inline.} =
  # Generate a hash integer to use as a seed for
  # a random number generator.

  (prime * v.x) + (expander * v.y)

proc initRand*(v: IVec2): Rand =
  # Initialize a RNG with vector-based seed.

  initRand(seed + v.hash)

proc roll*[T](r: var Rand, h: T): T =
  r.rand(h)

proc saturation*(v: IVec2): float =
  # Saturation is a vector's first random number
  # between 0.0 and 1.0, using the vector's hash
  # as the seed value.
  # 
  # Example:
  #   var v = ivec2(10, 15)
  #   echo $v.saturation

  var r = v.initRand()
  r.rand(1.0)


if isMainModule:
  seed = 9
  let v1 = ivec2(-10, 10)
  let v2 = ivec2(10, -10)
  let v3 = ivec2(0, 10)
  let v4 = ivec2(10, 0)

  echo $v1.hash() # 9940
  echo $v2.hash() # -9940
  echo $v3.hash() # 9970
  echo $v4.hash() # 30

  assert v1.hash != v2.hash
  assert v3.hash != v4.hash

  var r1 = v1.initRand()
  var r2 = v2.initRand()
  var r3 = v3.initRand()
  var r4 = v4.initRand()

  echo $r1.rand(1.0) # 0.4025111290151007
  echo $r2.rand(1.0) # 0.9283733660063962
  echo $r3.rand(1.0) # 0.8522231909071714
  echo $r4.rand(1.0) # 0.1037782474596014

  let t1 = ivec2(-9999, -4983)
  let t2 = ivec2(-4983, -9999)
  assert t1.hash != t2.hash

  proc countCollisions() =
    var l: seq[int]
    var collisions: seq[int]
    block top:
      for x in -500..500:
        for y in -500..500:
          if x == y: continue

          var v1 = ivec2(x.int32, y.int32)
          var v2 = ivec2(y.int32, x.int32)
          let h1 = v1.hash
          let h2 = v2.hash

          if l.contains(h1):
            collisions.add h1

          if h1 != h2:
            l.add h1
          else:
            collisions.add h1

    echo $collisions.len
  
  countCollisions()
