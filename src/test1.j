.class public test1
.super java/lang/Object

.method public <init>()V
	aload_0
	invokenonvirtual java/lang/Object/<init>()V
	return
.end method

func main() {
	var c int = 1;
	var x int = ( c + c );
	print(x)
}
