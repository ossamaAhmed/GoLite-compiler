Yoni Keshet
Boris Spektor

The amazing woman complement generator

are you tired of not knowing what to say at the time of need? are you tired of trying to complement a woman and getting slapped in the face?
then this is the answer! our program will generate a complement for you, with hilarious results.
run the program by running: java Main.
there are two ways to enter your input, after you have been prompted to:

1. "random" , <number> : when <number> is an int in the range 0-9. this way the program will randomly generate the full commplement. warning: while this might be extra funny, don't expect the woman to be charmed with the results..
    on top of being a complement generator, our program also does something very funny with the number you have entered.
2. <adjective>,<noun>,<verb>,<number> :  this way the words are chosen by you from the dictionary that is supplied with the program. 
    note: sometimes the words that looks good are not so good when put in to a specific sentence, and vice-versa.

the two pairs of files, in1-out1 and in2-out2 demonstrates both ways of running the program.

to add even more fun, the program will randomly decide if you are complementing your girl-friend or your boss. 
obviously, what sounds great to your girlfriend will not satisfy your boss, and vice-versa (try not to get fired, it's quite a challenge).


Have fun!

note:

the program as it is now is not deterministic. in order to make it deterministic, change the parameter for the constructors of the 'JoosRandom' objects from nothing to '1', in two places:
Class Main, line 36
Class ComplementGenerator, line 11

