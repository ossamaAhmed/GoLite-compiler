package main
//bubble sort
func main(){
    var x [10]int;
    ;
    ;
    x[0], x[1], x[2], x[3], x[4], x[5], x[6], x[7], x[8], x[9] = 10, 9, 8, 7, 6, 5, 4, 3, 2, 1;
    for i:=0 ; i < 10 ; i++ {
       swapped:=false; 
       for j:=9 ; j >= i ; j-- {
            if x[j] < x[j-1] {
                tmp := x[j]
                x[j] = x[j+1]
                x[j+1] = tmp;
                swapped = true;
            }
       }
       if swapped == false {
            break;
       }
    }
    println(x[0], x[1], x[2], x[3], x[4], x[5], x[6], x[7], x[8], x[9]);
}
