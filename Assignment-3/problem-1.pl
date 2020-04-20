% To define the empty character symbol based on input.
empty_char(x).

% Sqare dimension of the board.
dim(9).

% Replaces in list based on index -> ZERO BASED.
replace(List, Index, NewElem, NewList) :-
    empty_char(Empty_Char),
    nth0(Index,List,Empty_Char,Transfer), % Gets remaining list without that index.
    nth0(Index,NewList,NewElem,Transfer). % Inserts in list the required value.

% Finds the first occurence of charachter.
find_first(Empty_Index, State,Empty_Char):- nth0(Empty_Index, State,Empty_Char),!.

% Checks if the given indices are on the same row or same column
are_on_same_row_or_column(Current_Index,Empty_Index):-
    dim(D),
    (Current_Index =\= Empty_Index), % Not the same index.
    ((Current_Index//D =:= Empty_Index//D , !) ; (mod(Current_Index,D) =:= mod(Empty_Index,D),!)). % Not in the same row or not in the same column.

% Checks Validity of the new State
is_valid_state(State,Empty_Index):-
    nth0(Empty_Index, State,Element), % Gets the value on the index.
    findall(N, nth0(N, State, Element), Indicies), % Finds all indicies that have the same value.
    findall(Current_Index, (member(Current_Index, Indicies), are_on_same_row_or_column(Current_Index, Empty_Index)) ,[]). % Must return an empty list (not found) to be valid.


% All possible moves in sudoku from 1 to 9.
move(State,Empty_Index,New_State):- replace(State, Empty_Index, 1, New_State).
move(State,Empty_Index,New_State):- replace(State, Empty_Index, 2, New_State).
move(State,Empty_Index,New_State):- replace(State, Empty_Index, 3, New_State).
move(State,Empty_Index,New_State):- replace(State, Empty_Index, 4, New_State).
move(State,Empty_Index,New_State):- replace(State, Empty_Index, 5, New_State).
move(State,Empty_Index,New_State):- replace(State, Empty_Index, 6, New_State).
move(State,Empty_Index,New_State):- replace(State, Empty_Index, 7, New_State).
move(State,Empty_Index,New_State):- replace(State, Empty_Index, 8, New_State).
move(State,Empty_Index,New_State):- replace(State, Empty_Index, 9, New_State).

% Runs all possible moves and checks the validity of generated state.
moves(State, Empty_Index, New_State):- move(State,Empty_Index,New_State), is_valid_state(New_State,Empty_Index).

% Gets all children of a state.
% Don't Use bagOf because it returns false if there is no valid state and you need to return []
get_children(State, Empty_Index, Children):- findall(New_State, moves(State, Empty_Index, New_State), Children).

% If you reached this -> you have no solution. First is the base case and second if the user enters an empty list
path([]):-write("End"),nl,!.
path([[]]):-write("End"),nl,!.

% No Empty Cell then you reached the end.
path([State|Rest]):-
    empty_char(Empty_Char), \+find_first(_, State,Empty_Char),!,write(State),nl,path(Rest). % to print only one solution replace path(Rest) with false


% Tries to find a solution.
path([State|Open_Rest]):-
    empty_char(Empty_Char),find_first(Empty_Index, State,Empty_Char), % Gets the Index of the Empty_Char.
    get_children(State,Empty_Index,Children), % Gets Children of current state.
    append(Children,Open_Rest,New_Open), % Adds the children to open list. -> Note: If you swap Children and Open_Rest it will take longer time to find the first solution but same time to find all solutions
    path(New_Open).

go(Start):- path([Start]). % Custom input

% Entry Point.
test :- board(Start),go(Start). % Test Case

board([x,2,6,x,x,x,8,1,x,
       3,x,x,7,x,8,x,x,6,
       4,x,x,x,5,x,x,x,7,
       x,5,x,1,x,7,x,9,x,
       x,x,3,9,x,5,1,x,x,
       x,4,x,3,x,2,x,5,x,
       1,x,x,x,3,x,x,x,2,
       5,x,x,2,x,4,x,x,9,
       x,3,8,x,x,x,4,6,x]).