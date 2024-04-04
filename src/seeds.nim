import vmath
import random


const prime = 3
const ws = int32.high div prime^2  # 238_609_294

const maxWorldSize* = (low: -ws, high: ws)


proc uniqueSeed*(v: IVec2): int =
  # Generate a unique integer to use as a seed for
  # a random number generator.

  if v.x < v.y:
    (v.x * prime + v.y) * prime + 1
  else:
    (v.y * prime + v.x) * prime

proc initRand*(v: IVec2): Rand =
  # Initialize a RNG with vector-based seed.

  initRand(v.uniqueSeed)

proc passes*(r: var Rand, target: range[0.0 .. 1.0]): bool =
  # Check if a roll passes the target value.

  r.rand(1.0) >= target

