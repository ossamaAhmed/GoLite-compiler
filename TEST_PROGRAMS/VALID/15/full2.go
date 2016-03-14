package main

var x int
var xx = 1
var xy, xyx, xyxx int = 1,2,3
var xyy, xyyyx, xyyyxx = 1,2,3
var xyyy, xyyyyx, xyyyyxx int
var (
    abc, def, ghi int = 1,2,3
    hkj, lmn, opq = 1,2,3
    rst, uvw, xyz int
)
var y bool
var z rune = 'c'
var a string
var b = ""

type (
    num int
    point struct {
        x, y float64
        z struct {
            z1, z2 float64
        }
    }
)

var slice []int

var array [16][32][31][]int

func f1(a int, b int, c string, d int) {
    return
}
func f2(a, b int, c string, d int) string {
    return c
}

func g(a int) [1][1][1][1]int {
    var x [1][1][1][1]int
    x[0][0][0][0] = a
    return x
}

func main(){
    // int stuff
    x = (+1 + -x - +-^3/(x*5%x)) & 2 &^ x
    // bool stuff
    y = !y||y&&y==(x < x)!=(x > x)||x>=x&&x<=x; 

    /* * weird comments stuff * / / / /* / * *  // */

    // runes and strings
    z = 'a'
    z = '\a'
    z = '\b'
    z = '\f'
    z = '\n'
    z = '\r'
    z = '\t'
    z = '\v'
    z = '\\'
    z = '\''

    a = ""
    a = ``

    // make sure the pretty print still looks like this
    a = "this \a string \b has \f lots \n of \r special \t chars \v but \\ we \" can ' still pretty print it"

    // in the pretty print this is converted into an equivalent interpreted string
    a = `this "' \a string \b will \f not \n have \r special \t characters \\`

    // regular
    x = 5

    // octal, should pretty print 8
    x = 010

    // hex, should pretty print 3405691582
    x = 0xcAfE

    identifer_123_IDENTIFIER := 0
    println(identifer_123_IDENTIFIER)

    var x []point
    var p point;
    p.x = .5
    p.y = 6.
    p.z.z1 = -.5
    p.z.z2 = +1.0
    x = append(x, p)
    slice = append(slice, (123 + - 3 *1))

    another_slice := array[0+1][1*slice[0]][23]
    another_slice = append(another_slice, g(5)[0][0][0][0])
    aa, bb := z, z
    print()
    print(z,'5',1,1.)
    println()
    println(g(100)[0][0][0][0], p.z.z1)
    return

    if f := 5; f<xy {

    } else {
        if f:=2; f>xy {

            } else if f:=1; f > xy {
                if f:=-1; f == f {

                } else if f:=-2; f <= f{

                    } else {
                        println("no way...")
                    }
            }
    }

    switch xyx {
    case 1: print("hi");
        switch xyxx {
            case 2: println("hi")
            case 3: println("hihi")
            default:
                print("hi")
        }
    default:
        print("hello")
    }

    // Infinite loop
    for {
    }
    // "While" loop
    for xy < 10 {
    }
    // Three-part loop
    for i := 0; i < 10; i++ {
    }

    afsdjfk := string(int(float64((((((((((5)+((((xyx))))*((((((((((g(100)[0][0][0][0])))))))))))))))))))))
}
