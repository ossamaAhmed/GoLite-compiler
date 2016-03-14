/* Not allowed to have statements on the top level that don't start with var or
 * func. This tests the for decrementation on the top level. */

package main;

var i = 1
i-- // Error: Top-level decrement statement

func main() {
	// Do nothing
}
