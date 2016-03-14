package main

type num int
func main(){
	var x = num(5)
	print("the result is:")
	print(fac(x))
}

func fac(n num) num {
	if int(n) > 0{
		return num(int(n) * int(fac(n-1)))
	}
	return num(1)
}
