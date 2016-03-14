package main

//this is not allowed in go lite
func f(a int, b string) (string,int){
    return a,b
}

func main()
{
    f(1,"hello")
}
