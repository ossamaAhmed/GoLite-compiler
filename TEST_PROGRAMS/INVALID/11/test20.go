// You can edit this code!
// Click here and start typing.
package main

type stack struct{
	element []string
	size int;
}

func create_stack() stack{
	var ret stack;
	ret.size = 0;
	return ret;
}

func pop(current stack) string {
	if(current.size == 0){s
	        return "";
	}else{
		current.size--;
		return current.element[current.size+1];
	}
}

func push(current stack, value string) stack{
	current.element = append(current.element, stack);
	return current;
}


func main() {
	println("Hello, 世界")
}
