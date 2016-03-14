// Atoi && bad atof
package main

//undefined behavior with bad values or long values just like real life
func atoi(value string, length int) int {
	return atoi_implementation(value, length, 0);
}

func atoi_implementation( value string, length int, start int) int {
	var ret int;
	for i := start; i < length; i++ {
		if value[i] > '0' && value[i] < '9'{
			ret = ret << 3 + ret << 1;
			switch value[i]{
			  case '1': ret += 1;
			  case '2': ret += 2;
			  case '3': ret += 3;
			  case '4': ret += 4;
			  case '5': ret += 5;
			  case '6': ret += 6;
			  case '7': ret += 7;
			  case '8': ret += 8;
			  case '9': ret += 9;
			  case '0': ret += 0;
			}
		}else{
			println("Error. Invalid String\n");
			return 0;
		}
	}
	return ret;
}

func atof( value string, length int ) float64 {
	var ret float64 = 0;
	var decimal float64;
	var i int;
	for i = 0; i < length; i++ {
		if(value[i] == '.'){
		   break;
		}
	}
	ret += float64(atoi_implementation(value, i, 0));

	i++;
	decimal = float64(atoi_implementation(value, length, i));
	for j:= 0; j < length - i; j++{
		decimal /= 10;
	}

	return ret + decimal;

}
func main() {
	println( 1 << 3);
	println(atoi("2344", 4));
}
