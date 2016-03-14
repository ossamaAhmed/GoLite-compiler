package main
func factorial(n int ) int {
    if(n < 0){
        return -1;
    }
    var ret = 1;
    for i:=2 ; i < n ; i++ {
        ret *= i; 
    }
    return ret;
}
