package main
type astruct struct{
    y int;
}
type z struct{
    a astruct;
    b astruct;
}
func main() {
    var p z;
    p.a.y, p.b.y = 5, 6;
}
