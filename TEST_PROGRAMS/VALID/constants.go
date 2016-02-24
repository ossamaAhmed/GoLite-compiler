/ Go supports _constants_ of character, string, boolean,
// and numeric values.

package main


// `const` declares a constant value.
const s string = "constant"

func main() {
    println(s)

    // A `const` statement can appear anywhere a `var`
    // statement can.
    const n = 500000000

    // Constant expressions perform arithmetic with
    // arbitrary precision.
    const d = 3e20 / n
    println(d)

    // A numeric constant has no type until it's given
    // one, such as by an explicit cast.
    println(int64(d))

}

