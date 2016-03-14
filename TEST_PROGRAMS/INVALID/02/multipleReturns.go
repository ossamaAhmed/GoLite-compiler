package main

//this is both a type and parse error
func f(a int, b string){
    return a,b;
}

func main(){
    f(1,3)
}


