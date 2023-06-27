# A simple well-engineered game of mastermind
...using only sqlite and bash
...without using a database at all, only select statements

* Run ./wrapper.sh setup to create a new sqlite game file with a random mastermind state
* Run ./wrapper.sh GAME C1 C2 C3 C4 (where C1 - C4 are single-string characters representing colors) to make a guess
    * Valid colors are RBYGPV
* You'll receive a string like "BBWB"
    * Each "B" means that one of your guesses is exactly correct (color and position)
    * Each "W" means that one of your guesses is the correct color but at the wrong position
* report bugs to /dev/null thank you
