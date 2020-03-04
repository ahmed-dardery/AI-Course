% play %
play(Moves, Stars):-start(Pos), solveFromPos(Pos, Moves, Stars, [], 0, [Pos]).

% Legal Moves %
goLeft([I,J],[NI, NJ])  :- NI is I    , NJ is J - 1, not(bomb([NI,NJ])), J\=0.
goUp([I,J],[NI, NJ])    :- NI is I - 1, NJ is J    , not(bomb([NI,NJ])), I\= 0.
goRight([I,J],[NI, NJ]) :- NI is I    , NJ is J + 1, not(bomb([NI,NJ])), not(dim(_,NJ)).
goDown([I,J],[NI, NJ])  :- NI is I + 1, NJ is J    , not(bomb([NI,NJ])), not(dim(NI,_)).

% Star increasing %
starCalc(Pos, Stars, NStars):- star(Pos), NStars is Stars + 1, !.
starCalc(_, Stars, NStars):- NStars is Stars, !.

tryAllDirections(Pos, NPos, Dir):-
    (goDown(Pos,NPos), Dir = down);
    (goUp(Pos,NPos), Dir = up);
    (goRight(Pos,NPos), Dir = right);
    (goLeft(Pos,NPos), Dir = left).

solveFromPos(Pos, Moves, Stars, Moves, Stars, _):- end(Pos), !.

solveFromPos(Pos, Moves, Stars, CntMoves, CntStars, Visited):- 
    tryAllDirections(Pos, NPos, Dir),
    not(member(NPos, Visited)),
    starCalc(NPos, CntStars, NStars), 
    append(Visited,[NPos],NVisited),
    append(CntMoves,[Dir], NMoves),
    solveFromPos(NPos, Moves, Stars, NMoves, NStars,NVisited).