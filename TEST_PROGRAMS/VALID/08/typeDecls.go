package main

type alias1 int
type struct1 struct {
	foo, bar int
	so, dark, the, con, of, man float64
}
type dog struct1

func main() {
	var jake dog
	print(jake.foo)
	println(jake.bar) 
}
