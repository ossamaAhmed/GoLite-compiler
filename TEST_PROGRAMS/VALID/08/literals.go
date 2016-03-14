package main;
var x rune;
var y string;
var z int;
var a bool;
var b float64;
func main(){
    x = 'a';
    x = '\a';
    x = '\b';
    x = '\f';
    x = '\n';
    x = '\r';
    x = '\t';
    x = '\v';
    x = '\\';
    x = '\'';
    y = "This is a test string\n";
    y = `THIS IS A RAW TEST STRING \n`;
    z = 1111;
    z = 01234;
    z = 0x1234;
    a = true;
    a = false;
    b = 0.12;
    b = .12;
    b = 12.;
}
