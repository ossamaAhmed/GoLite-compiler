/* Recursively compute Fibonacci numbers. */

package main

// Compute mth Fibonacci number.
var m int = 10

func main() {
  println(fibonacci(m))
}

func fibonacci(n int) int {
  if n < 2 {
    return n
  }

  return fibonacci(n - 1) + fibonacci(n - 2)
}
