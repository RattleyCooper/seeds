import vmath
import random

const prime = 3
const ms = int32.high div prime^2  # 238_609_294

const maxSize* = (low: -ms, high: ms)
var seed*: int = 0

proc uniqueSeed*(v: IVec2): int {.inline.} =
  # Generate a unique integer to use as a seed for
  # a random number generator.

  if v.x < v.y:
    (v.x * prime + v.y) * prime + 1
  else:
    (v.y * prime + v.x) * prime

proc initRand*(v: IVec2): Rand =
  # Initialize a RNG with vector-based seed.

  initRand(seed + v.uniqueSeed)

template roll*[T](r: var Rand, h: T): T =
  r.rand(h)

template roll*[T](v: IVec2, h: T): T =
  var r = v.initRand()
  r.rand(h)

proc reaches*(r: var Rand, target: range[0.0 .. 1.0]): bool {.inline.} =
  # Check if a roll reaches the target value.

  r.roll(1.0) >= target

proc reaches*(v: IVec2, target: range[0.0 .. 1.0]): bool {.inline.} =
  # Check if a roll reaches the target value.

  v.roll(1.0) >= target

if isMainModule:
  seeds.seed = 9

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
