fx_abs = fmath.abs_fixedpoint
fx_atan2 = fmath.atan2
fx_sincos = fmath.sincos
fx_sqrt = fmath.sqrt

to_fx = fmath.to_fixedpoint
to_int = fmath.to_int

FX_MIN = -fmath.max_fixedpoint()
FX_MAX = fmath.max_fixedpoint()
FX_TAU = fmath.tau()
FX_PI = FX_TAU / 2fx
FX_E = 2.2942fx

random = fmath.random_int

local r = fmath.random_fixedpoint
function fx_random(a, b)
  return not a and r(0fx, 1fx) or not b and r(0fx, a) or r(a, b)
end

function fx_sin(a)
  local sin = fx_sincos(a)
  return sin
end

function fx_cos(a)
  local _, cos = fx_sincos(a)
  return cos
end

function abs(a)
  return a > 0 and a or -a
end