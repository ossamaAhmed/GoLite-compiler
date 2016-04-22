package main

var count int = 0

func towers(num int, from rune, to rune, aux rune) {
	if num == 1 {
		count++
		return
	}
	towers(num-1, from, aux, to)
	count++
	towers(num-1, aux, to, from)
}

func main() {
	towers(30, 'A', 'C', 'B')
	print("\nNumber of moves : ", count, "\n")
}
