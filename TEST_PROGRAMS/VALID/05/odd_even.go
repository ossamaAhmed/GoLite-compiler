/* Check if a number is odd or even, printing "odd" or "even", respectively. */

package main

func main() {
  turn := 10

  for i := 1; i <= turn; i++ {
    if i % 2 == 0 {
      println("even")
      continue
    }

    println("odd")
  }
}
