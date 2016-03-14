// should be valid but it's invalid (the semicolon after VarSpec): "var" ( VarSpec | "(" { VarSpec ";" } ")" ) . 
// because a var_spec can finish just with a type (which has a semicolon afterwards)
package main
var i int
