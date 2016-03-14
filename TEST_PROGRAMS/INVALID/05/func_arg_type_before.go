/* Type for function argument appears before argument variable. */

package main

func main()  {
  foo(10)
}

// Error: argument type appears before argument itself
func foo(int num) {
  println(num)
}
