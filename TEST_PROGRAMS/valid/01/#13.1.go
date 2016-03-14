package main

// this tests for allowing slices/array of struct inside func declaration

func main (x,y [2][][3]struct {
	x,y,z int
}, z float64) {
  ;
}
