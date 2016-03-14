package coolmath

/* A simple calculator program */
/* To use, just call /*
    compute(op, a, b)
*/

type exponent int

func main() {
  println(",------------,")
  println("| CALCULATOR |")
  println("'------------'")

  print(compute(0,1,1))
  print(compute(1,5,4))
  print(compute(2,10,22.0))
  print(compute(3, 19.11, .1))
  print(compute(4, 2,4))        /* 2^4 */
  print(compute(4, -10, 0))     /* negate -10 */
}

func compute(op int, a float64, b float64) float64 {
  switch op {
  case 0:
    return a+b
  case 1:
    return a-b
  case 2:
    return a*b
  case 3:
    return a/b
  case 4:
    return power(a,b)
  case 5:
    return -a
  default:
    println("Invalid operator")
    break
  }
  return -1
}

func power(a float64, b float64) float64 {
  var ret int = 1
  var power = exponent(b)

  for power > 0 {
    ret = ret * a
    power = power - 1
  }

  return ret
}
