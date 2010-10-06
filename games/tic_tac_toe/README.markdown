# Tic, Tac, Toe

Imagine the squares on a tic-tac-toe board are numbered like this:

     0 | 1 | 2
    -----------
     3 | 4 | 5
    -----------
     6 | 7 | 8


When your player is asked to move, you'll be given a string representing the current state of the board. You'll respond with a number from 0-8, saying which square you want to take your turn on.

The board state string uses the following symbols to represent the state of each square:
  
    -  Empty
    0  Nought
    x  Cross

So, for example, if the board looks like this:

     x | 0 | x
    -----------
       | 0 |  
    -----------
       |   |  

Then the command-line argument passed to your player will be:

    x0x-0----

Based on the state of the board, *and the knowledge that 0 goes first*, you need to work out which player you are, and respond with a move. In the example above, it must be 0's turn, so respond like this to win:

    7

Make sense?

## Rules

* 0 goes first
* If you don't respond with a number that represents an empty square, you forfeit the game immediately