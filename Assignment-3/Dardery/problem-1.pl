empty(x).

set_nth0(List, Index, Val, NewList) :-
   nth0(Index, List, _, Rem),
   nth0(Index, NewList, Val, Rem).

inRow(Board, RowIdx, Val):-
    between(0, 8, OFF), 
    Index is RowIdx*9 + OFF, 
    nth0(Index, Board, Val),
    \+empty(Val).

inCol(Board, ColIdx, Val):-
    between(0, 8, OFF),
    Index is OFF*9 + ColIdx,
    nth0(Index, Board, Val),
    \+empty(Val).

inBox(Board, BoxIdxV, BoxIdxH, Val):-
    between(0, 2, OFFH),
    between(0, 2, OFFV),
    Index is BoxIdxV * 27 + BoxIdxH*3 + OFFH + OFFV*9,
    nth0(Index, Board, Val),
    \+empty(Val).

invalid(Board, Idx, Val):-
    RowIdx is div(Idx,9), inRow(Board, RowIdx, Val).
invalid(Board, Idx, Val):-
    ColIdx is mod(Idx,9), inCol(Board, ColIdx, Val).
invalid(Board, Idx, Val):-
    N is div(Idx, 27), M is mod(div(Idx, 3), 3), inBox(Board, N, M, Val).

solve(Board, NewBoard):-
    solve(Board, NewBoard, 0).

solve(Build, Build , 81).

solve(Build, Board, Idx):-
    nth0(Idx, Build, Val),
    (
        empty(Val)->
        (between(1,9,V), \+invalid(Build, Idx, V),
        set_nth0(Build, Idx, V, NBoard))
        ; NBoard = Build
    ),
    NIdx is Idx+1,
    solve(NBoard, Board, NIdx).


board1([x,2,6, x,x,x, 8,1,x,
        3,x,x, 7,x,8, x,x,6,
        4,x,x, x,5,x, x,x,7,

        x,5,x, 1,x,7, x,9,x,
        x,x,3, 9,x,5, 1,x,x,
        x,4,x, 3,x,2, x,5,x,

        1,x,x, x,3,x, x,x,2,
        5,x,x, 2,x,4, x,x,9,
        x,3,8, x,x,x, 4,6,x]).

board2([1,x,x, x,x,7, x,9,x,
        x,3,x, x,2,x, x,x,8,
        x,x,9, 6,x,x, 5,x,x,

        x,x,5, 3,x,x, 9,x,x,
        x,1,x, x,8,x, x,x,2,
        6,x,x, x,x,4, x,x,x,

        3,x,x, x,x,x, x,1,x,
        x,4,x, x,x,x, x,x,7,
        x,x,7, x,x,x, 3,x,x]).

board3([x,6,x, 1,x,4, x,5,x,
        x,x,8, 3,x,5, 6,x,x,
        2,x,x, x,x,x, x,x,1,

        8,x,x, 4,x,7, x,x,6,
        x,x,6, x,x,x, 3,x,x,
        7,x,x, 9,x,1, x,x,4,

        5,x,x, x,x,x, x,x,2,
        x,x,7, 2,x,6, 9,x,x,
        x,4,x, 5,x,8, x,7,x]).

board4([
        2,9,5, 7,4,3, 8,6,1,
        4,3,1, 8,6,5, 9,x,x,
        8,7,6, 1,9,2, 5,4,3,
        3,8,7, 4,5,9, 2,1,6,
        6,1,2, 3,8,7, 4,9,5,
        5,4,9, 2,1,6, 7,3,8,
        7,6,3, 5,3,4, 1,8,9,
        9,2,8, 6,7,1, 3,5,4, 
        1,5,4, 9,3,8, 6,x,x]).