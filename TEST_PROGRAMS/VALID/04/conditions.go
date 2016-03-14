package factrecursive

func factrecursive(limit int) int {
    if limit == 0 {
        return 1
    } else {
        return limit * factrecursive(limit - 1);
    }
}

