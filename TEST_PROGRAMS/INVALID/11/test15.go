// You can edit this code!
// Click here and start typing.
package main


type stack struct{
	element [20]string;
	size int;
}

func create_stack() stack{
	var ret stack;
	ret.size = 0;
	return ret;
}

func pop(stack current) string {
	if(size == 0)
		return nil;
	else{
	return current.element[size--];
	}
}
func main() {
	fmt.Println("Hello, 世界")
}
