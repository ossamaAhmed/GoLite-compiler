package fact

func factfor(limit int) int {
    var acc int = 1

    for i := 1 ; i <= limit ; i++ {
        acc *= i
    }

    return acc
}

func factwhile(limit int) int {
    var acc int = 1;

    i := 1

    for i <= limit {
        acc *= i
    }

    return acc
}

func factrecursive(limit int) int {
    if limit == 0 {
        return 1
    } else {
        return limit * factrecursive(limit - 1);
    }
}

func main() {
    limit := 100 /* hi

    */ println("Computing factorial three ways.")

    println(factfor(limit))
    println(factwhile(limit))
    println(factrecursive(limit))

    println(
        'h',
        'a',
        'v',
        'e',
        ' ',
        'a',
        ' ',
        'n',
        'i',
        'c',
        'e',
        ' ',
        'd',
        'a',
        'y')
}
