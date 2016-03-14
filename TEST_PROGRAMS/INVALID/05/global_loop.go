/* Not allowed to have statements on the top level that don't start with var or
 * func. This tests the for loop on the top level. */

package main;

// Error: Top-level for loop
for i := 0; i < 10; i++ {
	sum += 1
}

func main() {
	// Do nothing
}
