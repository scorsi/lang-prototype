# small-yaul

Project for prototyping Yaul language.

The language is actually ~ 350 LOC.

To compile run `make`. You need `bundle`, if you don't have it run `gem install bundle` before.

You can give a file to the interpreter by typing `./yaul [filename]`.
Or you can run REPL by typing `./yaul`.

    $> ./yaul
    Yaul REPL. Press Ctrl+C to quit.
    >> a = "toto"
    => "toto"
    >> print(a)
    toto
    => nil
