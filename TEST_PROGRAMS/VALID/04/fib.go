package fib

func main() {
	var n int;
    var f1 = 0;
    var f2 = 1;
    var t int;

    n := 100;

    println(f1);
    for n := 0 ; n < 100; n++ {
        println(f2);

        t := f1 + f2;
        f1 := f2;
        f2 := t;
    }
}
