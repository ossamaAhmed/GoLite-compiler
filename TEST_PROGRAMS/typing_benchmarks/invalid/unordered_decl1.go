package main

func even(x int) bool {
	if x == 0 {
		return true
	} else {
		return odd(x - 1)
	}
}

func odd(x int) bool {
	if x == 0 {
		return false
	} else {
		return even(x - 1)
	}
}
