package main

func main() {
	// A struct with four anonymous fields of type T1, *T2, P.T3 and *P.T4
	struct {
		T1        // field name is T1
		*T2       // field name is T2
		P.T3      // field name is T3
		*P.T4     // field name is T4
		x, y int  // field names are x and y
	}
}
