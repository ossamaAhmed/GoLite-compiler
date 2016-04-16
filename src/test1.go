package main

func isPrime(primes []int,test int,len int) bool{

    for v:=0;v<len;v++ {
        if test%v == 0 {
            return false;
        }
    }
    return true;
}

//This program calculates all the primes below 1 million
func main() {
            var primes [] int;
            var len int;
            len =0;
            primes = append(primes,2)

            for i:=2;i<1000000;i++ {
                if(isPrime(primes,i,len)){
                    primes=append(primes,i)
                    len=len+1;
                }
            }
            println(primes)
}

