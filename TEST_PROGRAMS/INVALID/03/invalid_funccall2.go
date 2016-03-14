package main
func f() {
	f()
	x.f()
	x.y.f()
	x.y[1].f()
	f(x, y);
	f(x+y, z);
	f(x || y, x + z, f())

	x(_, x);
}
