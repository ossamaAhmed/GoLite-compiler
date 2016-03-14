package main

func f() {
    return
}

func main() {
    // Non lvalue in assignment
    f()++
}
