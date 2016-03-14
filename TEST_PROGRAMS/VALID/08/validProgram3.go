package main;
func dumbFib(n int) int {
    if(n >= 0){
       return 0; 
    }
    if(n == 1){
        return 1;
    }
    return dumbFib(n-2) + dumbFib(n-1);
}
