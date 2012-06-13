# Maze

Imagine a maze

    ***********
    *.1....__.*
    ....***...F
    *2........*
    ***********

You need to navigate to the (F). The '.' represent open space, and the '\*' squares are walls. The "\_" represents ice: if you move onto this square you immediately move an extra square in the direction you are travelling in.

The players are represented by the numbers 1 and 2 on the maze.

The state of the board will be passed in as an argument in the following format:

    You are player 1
    ***********
    *..1...__.*
    ....***...F
    *2........*
    ***********

This will be received as follows as the first argument, with newline characters to seperate the lines:

    "You are player 1\n***********\n*..1...__.*\n....***...F\n*2........*\n***********"

Based on the state of the board, and the header which states which player you are, you need to respond with a move: N, S, E or W. In the example above, you are player 1, so a valid move might be:

    E

# Rules

* The size and layout of the maze cannot be assumed to be fixed and could change each game (but will not change during a single game).
* If you make a move into a wall, you stay put and don't move.
* If you move into the other player, you forfeit the game.
* If you don't respond with N, S, E or W, you forfeit the game.
* If you move onto the F square first, you win.
