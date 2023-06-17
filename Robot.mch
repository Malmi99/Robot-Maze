/* Robot
 * Author: MALMI
 * Creation date: 1/8/2023
 */
MACHINE
    Robot
    
SEES
    Maze
    
SETS
    MESSAGES = {MoveSuccess,MoveFailedDueToAnInternalWall,MoveFailedDueToTheMazeBoundary,YES,NO};
    
    VISITED_SQUARE = {VISITED, NOT_VISITED}
    
    
DEFINITIONS
    isMazeEmptySquare(x, y) == (x |-> y : mazeEmptySquares);
    isOutOfBounds(x, y) == (x |-> y /: maze);

// GUI animation function
    ANIMATION_FUNCTION == ( {row, column, image | row: maze_height & column: maze_width &
            
            
            (IF ({column |->(6 - row) } <: mazeInternalWalls) 
                THEN
                    // image of internal wall square 
                    image = 1
                ELSE
                    IF (column = currentLocationX & row = (6 - currentLocationY)) 
                    THEN
                        // image of robot 
                        image = 2
                    ELSE
                        // image of empty maze square 
                        image = 0
                    END
                END)});
    
    // Images for the animations
    ANIMATION_IMG0 == "2.png";
    ANIMATION_IMG1 == "1.png";
    ANIMATION_IMG2 == "3.png";
    
VARIABLES
    currentLocationX, currentLocationY, robotMovementHistory
    
INVARIANT
    currentLocationX : maze_width &
    currentLocationY : maze_height &
    robotMovementHistory : seq(mazeEmptySquares)
    
INITIALISATION
    currentLocationX := prj1(maze_width, maze_height)(entranceSquare) || 
    currentLocationY := prj2(maze_width, maze_height)(entranceSquare) ||
    robotMovementHistory := [entranceSquare]
    
OPERATIONS
    
    // Operation to Move the robot to the North by one square. 
    move_message <-- moveNorth =
    BEGIN
        IF
            isMazeEmptySquare(currentLocationX, currentLocationY + 1)
        THEN
            currentLocationY :=  currentLocationY + 1 ||
            robotMovementHistory := robotMovementHistory <- (currentLocationX |-> currentLocationY + 1) ||
            move_message := MoveSuccess
        ELSE
            IF
                isOutOfBounds(currentLocationX, currentLocationY + 1)
            THEN
                move_message:= MoveFailedDueToTheMazeBoundary
            ELSE                
                move_message := MoveFailedDueToAnInternalWall
            END                
        END
    END;
    
    // Operation to Move the robot to the south by one square. 
    move_message <-- moveSouth =
    BEGIN
        IF
            isMazeEmptySquare(currentLocationX, currentLocationY - 1)
        THEN
            currentLocationY :=  currentLocationY - 1 ||
            robotMovementHistory := robotMovementHistory <- (currentLocationX |-> currentLocationY - 1) ||
            move_message := MoveSuccess
        ELSE
            IF
                isOutOfBounds(currentLocationX, currentLocationY - 1)
            THEN
                move_message:= MoveFailedDueToTheMazeBoundary
            ELSE                
                move_message := MoveFailedDueToAnInternalWall
            END                
        END
    END;
    
    // Operation to Move the robot to the East by one square. 
    move_message <-- moveEast =
    BEGIN
        IF
            isMazeEmptySquare(currentLocationX + 1, currentLocationY)
        THEN
            currentLocationX :=  currentLocationX + 1 ||
            robotMovementHistory := robotMovementHistory <- (currentLocationX + 1 |-> currentLocationY) ||
            move_message := MoveSuccess
        ELSE
            IF
                isOutOfBounds(currentLocationX + 1, currentLocationY)
            THEN
                move_message:= MoveFailedDueToTheMazeBoundary
            ELSE                
                move_message := MoveFailedDueToAnInternalWall
            END
        END
    END;
    
    // Operation to Move the robot to the west by one square. 
    move_message <-- moveWest =
    BEGIN
        IF
            isMazeEmptySquare(currentLocationX - 1, currentLocationY)
        THEN
            currentLocationX :=  currentLocationX - 1 ||
            robotMovementHistory := robotMovementHistory <- (currentLocationX - 1 |-> currentLocationY) ||
            move_message := MoveSuccess
        ELSE
            IF
                isOutOfBounds(currentLocationX - 1, currentLocationY)
            THEN
                move_message:= MoveFailedDueToTheMazeBoundary
            ELSE                
                move_message := MoveFailedDueToAnInternalWall
            END
        END
    END;
    

    // Teleport the robot to any open square in the maze with this operation.
    move_message <-- teleport(newXPosition, newYPosition) =
    PRE
        move_message : MESSAGES &
        newXPosition : maze_width & 
        newYPosition : maze_height
        
    THEN
        IF
            isMazeEmptySquare(newXPosition, newYPosition)
        THEN
            currentLocationX := newXPosition ||
            currentLocationY := newYPosition ||
            robotMovementHistory := robotMovementHistory <- (newXPosition |-> newYPosition) ||
            move_message := MoveSuccess
        ELSE
            IF
                isOutOfBounds(newXPosition, newYPosition)
            THEN
                move_message:= MoveFailedDueToTheMazeBoundary
            ELSE                
                move_message := MoveFailedDueToAnInternalWall
            END
        END
    END;
    
    // Operation to get the current location of the robot
    robotLocation <-- getPosition = 
    BEGIN
        robotLocation := currentLocationX |-> currentLocationY 
    END;
    
    exitFound <-- foundExit = 
    BEGIN
        IF(currentLocationX |-> currentLocationY = exitSquare)
        THEN
            exitFound := YES
        ELSE
            exitFound := NO
        END
    END;
    
    // Operation to inquire whether the robot has visited a certain square 
    visitedSquare <-- hasVisitedSquare(xPosition, yPosition) =
    PRE
        visitedSquare : VISITED_SQUARE &
        xPosition : maze_width & 
        yPosition : maze_height
    THEN
        IF({xPosition |-> yPosition} <: ran(robotMovementHistory))
        THEN
            visitedSquare := VISITED
        ELSE
            visitedSquare := NOT_VISITED
        END
    END;
    
    // Operation to inquire the path taken (i.e. sequence of squares visited) by the robot
    routeTaken <-- robotsRoute =
    BEGIN
        routeTaken := robotMovementHistory
    END;
    
    //reset operation & Delete operation
    resetRobot = 
    BEGIN
        currentLocationX, currentLocationY, robotMovementHistory := 1, 1, [entranceSquare]
    END
    
END