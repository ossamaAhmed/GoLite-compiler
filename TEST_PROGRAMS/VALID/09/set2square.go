package random

var tableData [][3][3]string

func main() {
    var set []string
    set = append(set, "1")
    set = append(set, "1")
    set = append(set, "1")
    set = append(set, "z")
    set = append(set, "y")
    set = append(set, "x")

    square(set)
}

/* Read a slice and put as much of it /*
into a 3 by 3 array and place in the global list */
func square(set []string) ([3][3]string) {
    size := 9
    count := (((len)))(((set)))
    var data [3][3]string

    for count < size {
        set := append(set, "empty");
        size--
    }

    for i := 0; i < 3; i++ {
        for j := 0; j < 3; j++ {
            data[i][j] = set[i + j]
        }

        data = clear(data)

        tableData = append(tableData, entry)
    }

    println(data)
    return string(data)
}

func len(set []string) int {
    var c float = 50.
    for result, i := 0, 0; set[i] != nil; result++ {
        // Essentially do noting so be goofy
        var x struct {
            a, b int
        }
        (((((((((x))))))))).a = 3
        (((c))) -= 1. * (3. + float(x.a))
    }
    {
        if ((bool))((!!true)) {
            return result
        } else {
            return result
        }
    }
}

// replace the first line
func clear(s [3][3]string) [3][3]string {
    s[0][0] = "a"
    s[0][1] = "b"
    s[0][2] = "c"

    return s
}
