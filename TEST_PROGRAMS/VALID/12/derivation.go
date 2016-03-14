/* drives the function f(x) = x^2 at integers in the domain [0,10]
   with repeatedly smaller deltaX values (for increasing accuracy) */
   
 package derivation
 
 var delta_x float64 = 1.0
 var results [10][11]float64
 
 var domain_start, domain_stop int = 0, 10
 
 func derive_x2(point int, delta_x float64) float64 {
	return ((point+delta_x)*(point+delta_x) - point*point)/delta_x
 }
 
 func main() {
	for i := 0; i < 10; i++ {
		for j := domain_start; j <= domain_stop; j++ {
			results[i][j] = derive_x2(j, delta_x)
		}
		delta_x *= 0.1
	}
	
	println("The results are:")
	for i := 0; i < 10; i++ {
		for j := domain_start; j < domain_stop; j++ {
			print(results[i][j], ", ")
		}
		println(results[i][10])
	}
 }
