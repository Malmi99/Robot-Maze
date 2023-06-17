/* Maze
 * Author: MALMI
 * Creation date: 1/8/2023
 */
MACHINE
    Maze

CONSTANTS
    maze_width,
    maze_height,
    maze,
    mazeInternalWalls, 
    mazeEmptySquares,
    entranceSquare, 
    exitSquare
    
PROPERTIES
    maze_width = 1..7 & 
    maze_height = 1..5 & 
    maze = maze_width * maze_height &
    mazeInternalWalls <: maze & 
    mazeInternalWalls = {1|->3, 2|->1, 2|->3, 2|->5, 3|->3, 4|->2, 4|->3, 4|->4, 6|->1, 6|->2, 6|->4, 7|->4} &
    mazeEmptySquares <: maze &
    mazeEmptySquares /\ mazeInternalWalls = {} &
    mazeEmptySquares \/ mazeInternalWalls = maze &
    entranceSquare : mazeEmptySquares &
    entranceSquare = 1|->1 &
    exitSquare : mazeEmptySquares & 
    exitSquare = 1|->5
    
    OPERATIONS
    
    // Get the total number of squares in the maze
    number_of_squares <-- getTotalNumberOfSquares = 
    BEGIN
        number_of_squares := card(maze)
    END;
    
    
    // Get the total number of internal walls in the maze
    number_of_internal_walls <-- getTotalNumberOfInternalWalls = 
    BEGIN
        number_of_internal_walls := card(mazeInternalWalls)
    END;
    
    
    // Get the total number of Path squares in the maze
    number_of_empty_squares <-- getTotalNumberOfEmptySquares = 
    BEGIN
        number_of_empty_squares := card(mazeEmptySquares)
    END
    
    
END
    

