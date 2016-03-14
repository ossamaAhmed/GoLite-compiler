/* Dangling top-level expression. */

package main

var x, y int = 0x40, 1

y / x

func main() {

}
