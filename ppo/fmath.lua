fx_abs = fmath.abs_fixedpoint
fx_atan2 = fmath.atan2
fx_sincos = fmath.sincos
fx_sqrt = fmath.sqrt

to_fx = fmath.to_fixedpoint
to_int = fmath.to_int

FX_BIG = fmath.max_fixedpoint
FX_TAU = fmath.tau()
FX_PI = FX_TAU / 2fx
FX_E = 2.2942fx

random = fmath.random_int

function fx_floor(a)
  return a // 1fx
end

function fx_ceil(a)
  return (a + 1fx) // 1fx
end

function fx_round(a)
  return (a + 0.2048fx) // 1fx
end

function fx_fraction(a)
  return a % 1fx
end

local _fx_random = fmath.random_fixedpoint
function fx_random(a, b)
  if not a then
    return _fx_random(0fx, 1fx)
  end
  if not b then
    return _fx_random(0fx, a)
  end
  return _fx_random(a, b)
end

fmath = nil