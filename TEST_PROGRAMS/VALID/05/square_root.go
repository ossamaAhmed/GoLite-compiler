/* Compute the square root of a number. */

package main

func main() {
  var (
    k = 10
    x, z float64 = 36, 1
  )

  for i := 0; i < k; i++ {
    z -= (z * z - x) / (2 * z)
  }

  println(z)
}
