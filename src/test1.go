package main;

type point3d struct{
    x,y,z int;
}

func main() {
    var a = 5

    var p point3d
    p.y = 2

    var c int
    c = a + p.y

    println(c)
    // p.z = 3;
}
