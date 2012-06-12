# Maze

Imagine a maze

    ***********
    *......M..*
    3...***...F
    *.........*
    ***********

You need to navigate to the (F), avoiding the monster (M).

The players are represented by the numbers 1 and 2 on the maze. If both players are on the same square, the number will show as 3.

The state of the board will be passed in as an argument in the following format:

    You are player 1
    ***********
    *..1...M..*
    ....***...F
    *2........*
    ***********

This will be received as follows as the first argument, with newline characters to seperate the lines

    "You are player 1\n***********\n*..1...M..*\n....***...F\n*2........*\n***********"

Based on the state of the board, and the header which states which player you are, you need to respond with a move: N, S, E or W. In the example above, you are player 1, so a valid move might be:

    E

# Rules

* If you make a move into a wall, or don't respond with N, S, E or W, you forfeit the game.
* If you move onto the Minotaur, or it moves onto you, you forfeit.
* If you move onto the F square first, you win. If you both move onto the F square in the same turn, then the game is a draw.
