/* Author: L Emery-Fertitta */

/**
 * This file uses Newton's method to approximate the roots
 * of a polynomial, as while as test some GoLite features /* /
 *
 * I have confirmed functionality (at least with the current main)
 * using the real Go compiler. It also passes all stages of the reference
 * compiler without issue.
 **/

package main // useless package declaration

var my_polynomial []int;

/**
 * f - poly coeffs, e.g f[0]*x^2 + f[1]*x + f[2]
 * n - length of f
 */
func deriv(f []int, n int) []int{
    var df []int // derivative of f

    // build the derivative
    for i := 0; i < (n-1); i++ {
        df = append(df, (n-i-1)*f[i])
    }

    return df
}

// x^n
func pow(x float64, n int) float64 {
    x_to_the_n := 1.0
    for i := 0; i < n; i++ {
        x_to_the_n *= x
    }
    return x_to_the_n
}

// f(x)
func feval(f []int, n int, x float64) float64{
    var fx = 0.0

    // go backwards for no reason
    for i := (n-1); i >= 0; i-- {
        fx += pow(x, n - (i+1))*float64(f[i]);
    }

    return fx
}

// |x|
func abs(x float64) float64 {
    if x < 0.0{
        return -x
    } else { 
        return x
    }
}

/** Approximates a root of the given polynomial
 * f: slice of polynomial coefficients
 * f_length: length of f
 * x: starting point
 * xtol: termination tolerance on size of x
 * ftol: termination tolerance on size of f(x)
 * itermax: max iterations
 */
func newton(f []int, f_length int, x, xtol, ftol float64, itermax int) float64{
    fx := feval(f, f_length, x)
    var df = deriv(f, f_length);
    var root float64
    var fdx float64;
    var d float64;
    if abs(fx) <= ftol {
        root = x
    } else{
        for i := 1; i < itermax; i++ {
            fdx = feval(df, f_length-1, x)
            d = float64(fx)/fdx;
            x = x - d
            fx = feval(f, f_length, x)
            if (abs(d) <= xtol) || (abs(fx) <= ftol) {
                root = x
                break
            }
        }
    }
    return root
}

func main( ) {
    // x^2 - 2x - 4
    my_polynomial = append(my_polynomial, 1)
    my_polynomial = append(my_polynomial, -2)
    my_polynomial = append(my_polynomial, -4)
    root := newton(my_polynomial, 3, 2.5, 0.01, 0.01, 100)
    // exact root is 1+sqrt(5), should be around 3.2
    println(root)
};
