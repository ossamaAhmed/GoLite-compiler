package main

func main(){
	var x,y = 80,28
	print("the gcd of 80 and 28 is:")
	print(gcd(x,y))
}

func gcd(a, b int) int {
	c:=1;
	for a!= 0 {
		c = a
		a = b%a
		b = c
	}
	return b
}
