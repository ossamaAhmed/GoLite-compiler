package brainfuck

var (
	goLeft rune = '<';
	goRight rune = '>';
	inc rune = '+';
	dec rune = '-';
	start rune = '[';
	end rune = ']';
	input rune = ',';
	output rune = '.';
);

var memory [1024]int32;
var ptr int32 = 0;

func int32erpret(program string) {
	var n = len(program)
	var stk int32 = 0

	for pc := 0 ; pc < n ; pc++ {
		switch program[pc] {
		case goLeft:
			ptr--
		case goRight:
			ptr++
		case inc:
			memory[ptr]++
		case dec:
			memory[ptr]--
		case start:
			if memory[ptr] == 0 {
				stk_ := stk
				stk++
				pc++
				for {
					switch program[pc] {
					case end:
						stk--;
					case start:
						stk++;
					}

					pc++

					if stk == stk_ {
						break
					}
				}
			}
		case end:
			if memory[ptr] != 0 {
				stk_ := stk
				stk++
				pc--
				for {
					switch program[pc] {
					case end:
						stk++;
					case start:
						stk--;
					}

					if stk == stk_ {
						break
					}

					pc--
				}
			}
		case output:
			print(rune(memory[ptr]))
		case input:
			// there is no way to read input in GoLite !
		}
	}
}

var test_program string = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."

func main() {
	interpret(test_program)
}
