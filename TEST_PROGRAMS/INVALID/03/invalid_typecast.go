package main
func f() {
	x = int(x);
	x = num(x);
	x = float64(10 * 20 / x);
	x = bool(x || y);
	x = int(-x);
	x = []int(x);
	x = [3]num(x);
	x, y = int(x, y)
}
