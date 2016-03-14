// _Switch statements_ express conditionals across many
// branches.

package main

func main() {

    // Here's a basic `switch`.
    i := 2
    print("write ", i, " as ")
    switch i {
    case 1:
        println("one")
    case 2:
        println("two")
    case 3:
        println("three")
    }

    // // You can use commas to separate multiple expressions
    // // in the same `case` statement. We use the optional
    // // `default` case in this example as well.
    switch i {
    case 1,2:
        println("it's the weekend")
    default:
        println("it's a weekday")
    }

    // `switch` without an expression is an alternate way
    // to express if/else logic. Here we also show how the
    // `case` expressions can be non-constants.
    switch {
    case 1 < 12:
        println("it's before noon")
    default:
        println("it's after noon")
    }
}

// todo: type switches

