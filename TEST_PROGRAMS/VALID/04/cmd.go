package cmd

type instruction int

var (
    EXIT instruction
    PUSH1, PUSH2, PRINT instruction = 1, 2, 3
    NOP instruction = 4
    ADD, SUB, MUL instruction = 5, 6, 7;)


/* Two extra slots of buffer. */
type state struct { sp int; stk [66]int; }

func operate(op instruction, st state) state {

    if error := "Stack overflow!"; st.sp >= 64 {
        println(error); exit();
    }

    // I know, some cases are missing
    switch ; op {
        case PUSH1:
            st.stk[st.sp] = 1
            st.sp++
        case PUSH2:
            st.stk[st.sp] = 2
            st.sp++
        case ADD:
            if st.sp == 0 { break; }
            st.stk[st.sp - 1] += st.stk[st.sp]
            st.sp--
        case PRINT:
            println("[", st.sp, "] = ",
                     st.stk[st.sp])

    }

    return st
}

func exec(program [128]instruction) {

    var pc = 0
    var st struct { sp int; stk [66]int; }

    for pc < len(program) {
        if program[pc] == EXIT {
            return
        } else if program[pc] == NOP {
            continue
        } else {
            st = operate(program[pc], st)
        }

        pc += 1
    }

    end()
}

func end() { println("Hurrah!"); }
