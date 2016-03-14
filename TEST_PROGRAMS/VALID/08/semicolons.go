package main

func main() {
	x := 5;
	b := true;
	if b {
		switch x {
			case 5:
				println("5");
				nosemis();
		};
	};
};

func nosemis(){
	x := 5
	b := true
	if b {
		switch x {
			case 4:
				nosemis()
		}
		println("4")
	}
}
