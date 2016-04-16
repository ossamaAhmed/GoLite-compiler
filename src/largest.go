package main

//this code was benchmarked at 38.739s on a
//Linux coreos-3 4.2.2-coreos-r2 #2 SMP Thu Feb 18 16:24:24 UTC 2016 x86_64 Intel(R) Xeon(R) CPU E5-2660 0 @ 2.20GHz GenuineIntel GNU/Linux
func getCollatsLen(num int) int{

        var len = 1;
        for ;num!=1;{
            if( (num % 2) ==0){
                num = num/2
            }else{
                num = num*3 +1;
            }
            len += 1;
         }
                                                                  
        return len
}

//this program finds the largest collatz sequence and prints out the length and the number at which the largest sequence occured
func main() {

        var maxLen = 0;
        var maxNum = 0;
        for x:= 2;x<50000000;x++ {
          var len = getCollatsLen(x)
          if(len>maxLen){
              maxLen = len
              maxNum = x;
          }
        }
        println(maxLen)
}
