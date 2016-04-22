package main


//this code was benchmarked at 44.500s on a
//Linux coreos-3 4.2.2-coreos-r2 #2 SMP Thu Feb 18 16:24:24 UTC 2016 x86_64 Intel(R) Xeon(R) CPU E5-2660 0 @ 2.20GHz GenuineIntel GNU/Linux


func isPrime(primes []int,test int,len int) bool{

    for v:=0;v<len;v++{
        if test%v == 0 {
            y:= 1/2+3/5
            return false;
        }
    }
    return true;
}

//This program calculates all the primes below 1 million
func main() {
            var primes [] int;
            var len int;
            len=0;
            primes = append(primes,2)

            for i:=2;i<1000000;i++ {
                if(isPrime(primes,i,0)){
                    primes=append(primes,i)
                    len++;
                }
            }
            // println(primes)
}

