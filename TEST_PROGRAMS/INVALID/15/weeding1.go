/* LHS '=' RHS with a non-lvalue in LHS */

package error
var a int
func f(b int) int {
    f(a), b = 1, 2
    return b
}
