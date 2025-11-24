import vmath
import random
when defined(debug):
  import pixie
  import timeouts

const seedPrime = 3
var seed*: int = 3
var primex* = 73856093
var primey* = 19349663

proc hash*(x: int, y: int): int {.inline.} =
  # Generate a hash integer to use as a seed for
  # a random number generator.

  let h1 = primex * x
  let h2 = primey * y
  (h1 xor (h2 shl 16)) or 1

proc hash*(d: (int, int)): int {.inline.} =
  # Generate a hash integer to use as a seed for
  # a random number generator.

  let h1 = primex * d[0]
  let h2 = primey * d[1]
  (h1 xor (h2 shl 16)) or 1

proc hash*(v: IVec2): int {.inline.} =
  # Generate a hash integer to use as a seed for
  # a random number generator.

  hash(v.x, v.y)

proc initRand*[T: IVec2 or UVec2](v: T): Rand =
  # Initialize a RNG with vector-based seed.

  initRand((seed * seedPrime) + v.hash)

proc roll*[T](r: var Rand, h: T): T =
  # Same as rand
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
  when defined(debug):
    var clock = newClock()

  seed = 9
  let v1 = ivec2(-10, 10)
  let v2 = ivec2(10, -10)
  let v3 = ivec2(0, 10)
  let v4 = ivec2(10, 0)

  echo $v1.hash()
  echo $v2.hash()
  echo $v3.hash()
  echo $v4.hash()

  assert v1.hash != v2.hash
  assert v3.hash != v4.hash

  var r1 = v1.initRand()
  var r2 = v2.initRand()
  var r3 = v3.initRand()
  var r4 = v4.initRand()

  echo $r1.rand(1.0)
  echo $r2.rand(1.0)
  echo $r3.rand(1.0)
  echo $r4.rand(1.0)

  let t1 = ivec2(-9999, -4983)
  let t2 = ivec2(-4983, -9999)
  assert t1.hash != t2.hash

  when defined(debug):
    let (w, h) = (1000, 1000)
    let scale = 8f32
    let (ix, iy) = (w*scale.int, h*scale.int)

    let img = newImage(ix, iy)
    let c = newContext(img)
    let c2 = newContext(img)
    c.fillStyle = rgba(255, 0, 0, 255)
    c2.fillStyle = rgba(0, 0, 0, 255)
    
    proc countCollisions() =
      var l: seq[int]
      var collisions: seq[int]
      var checks: int
      clock.run every(seconds=3):
        echo "Check: ", $checks
        echo "Collisions: ", $collisions.len

      block top:
        for x in (0 - w div 2)..(w div 2):
          for y in (0 - h div 2)..(h div 2):
            var v = ivec2(x.int32, y.int32)
            
            if v.saturation > 0.98:
              c.fillRect(rect(x.float32 * scale, y.float32 * scale, scale, scale))
            else:
              c2.fillRect(rect(x.float32 * scale, y.float32 * scale, scale, scale))
            checks += 1
            var v1 = ivec2(x.int32, y.int32)
            let h1 = v1.hash

            if l.contains(h1):
              collisions.add h1
            else:
              l.add h1
            
          clock.tick()

      echo $collisions.len
    
    countCollisions()

    img.writeFile("../examples/saturation.png")
