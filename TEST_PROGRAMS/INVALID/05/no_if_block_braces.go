/* No braces around if-block */

package main

var num int = 0

func main() {
  // Error: no braces after if condition
  if num > 0
    println("Positive")
}
