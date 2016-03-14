package return_ifelse

func main() {
    plus(1,2)
}

func plus(a, b int) int {
    if true {
        if false {
            return 1
        } else {
            return 1
        }
    } else {
        return 0
    }
}
