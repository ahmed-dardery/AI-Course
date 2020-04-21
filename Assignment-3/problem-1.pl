% To define the empty character symbol based on input.
empty_char(x).


% Replaces in list based on index -> ZERO BASED.
replace(List, Index, NewElem, NewList) :-
    empty_char(Empty_Char),
    nth0(Index,List,Empty_Char,Transfer), % Gets remaining list without that index.
    nth0(Index,NewList,NewElem,Transfer). % Inserts in list the required value.

% Finds the first occurence of charachter.
find_first(Empty_Index, State,Empty_Char):- nth0(Empty_Index, State,Empty_Char),!.


% Gets the discriminator of a block given an index
% Suppose you have the follwing board
%   L   M  R    L   M  R    L   M  R
% U 0*  1  2  | 3*  4  5  | 6*  7  8
% M 9  10 11  | 12 13 14  | 15 16 17
% D 18 19 20  | 21 22 23  | 24 25 26
% Given index you can know it's row type (L(0)/M(1)/R(2)) by taking Index mod 3
% Given index you can know it's col type (U(0)/M(1)/D(2)) by Dividing Index by 9 and take mod 3 to answer
% Each block will have a discriminator I will choose it the top left point
% Goal: Given an Index Get it's discriminator and make sure the discriminators are not the same
% First transform row types (M,R) to L type so subtract from Index (value of (row type (0,1,2)))
% Second transform col types (M,D) to U type so subtract from Index (value of (col type (0,1,2))) * 9
get_discriminator(Index, Discriminator):- 
    RowType is mod(Index,3) , ColType is mod((Index//9),3),
    Discriminator is (Index - (RowType + (ColType * 9))).

% Checks if the two indicies lie in same block or not
are_on_same_block(Current_Index,Empty_Index):- get_discriminator(Current_Index, D1), get_discriminator(Empty_Index,D2) , D1 = D2.

% Checks if the given indices are on the same row or same column
are_valid_indices(Current_Index,Empty_Index):-
    D is 9,
    (Current_Index =\= Empty_Index), % Not the same index.
    ((Current_Index//D =:= Empty_Index//D , !) ; (mod(Current_Index,D) =:= mod(Empty_Index,D),!) ; (are_on_same_block(Current_Index,Empty_Index))). % Not in the same row or not in the same column.

% Checks Validity of the new State
is_valid_state(State,Empty_Index):-
    nth0(Empty_Index, State,Element), % Gets the value on the index.
    findall(N, nth0(N, State, Element), Indicies), % Finds all indicies that have the same value.
    findall(Current_Index, (member(Current_Index, Indicies), are_valid_indices(Current_Index, Empty_Index)) ,[]). % Must return an empty list (not found) to be valid.


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

% Prints the Answer
format_output([E1,E2,E3,E4,E5,E6,E7,E8,E9|Rest]) :- nl,write((E1,E2,E3,E4,E5,E6,E7,E8,E9)),nl, format_output(Rest).
format_output([]).

% Gets all children of a state.
% Don't Use bagOf because it returns false if there is no valid state and you need to return []
get_children(State, Empty_Index, Children):- findall(New_State, moves(State, Empty_Index, New_State), Children).

% If you reached this -> you have no solution. First is the base case and second if the user enters an empty list
path([]):-write("End"),nl,!.
path([[]]):-write("End"),nl,!.


% No Empty Cell then you reached the end.
path([State|_]):-
    empty_char(Empty_Char), \+find_first(_, State,Empty_Char),!,format_output(State),nl,!. % To find more than one solution add after nl "path(Rest)" and replace the "_" with "Rest".


% Tries to find a solution.
path([State|Open_Rest]):-
    empty_char(Empty_Char),find_first(Empty_Index, State,Empty_Char), % Gets the Index of the Empty_Char.
    get_children(State,Empty_Index,Children), % Gets Children of current state.
    append(Children,Open_Rest,New_Open), % Adds the children to open list. -> Note: If you swap Children and Open_Rest it will take longer time to find the first solution but same time to find all solutions
    path(New_Open).

% Entry Point
go(Start):- path([Start]). % Custom input


% Test Cases
test1 :- board1(Start),go(Start).
test2 :- board2(Start),go(Start).
test3 :- board3(Start),go(Start).

board1([x,2,6,x,x,x,8,1,x,
        3,x,x,7,x,8,x,x,6,
        4,x,x,x,5,x,x,x,7,
        x,5,x,1,x,7,x,9,x,
        x,x,3,9,x,5,1,x,x,
        x,4,x,3,x,2,x,5,x,
        1,x,x,x,3,x,x,x,2,
        5,x,x,2,x,4,x,x,9,
        x,3,8,x,x,x,4,6,x]).

board2([1,x,x,x,x,7,x,9,x,
        x,3,x,x,2,x,x,x,8,
        x,x,9,6,x,x,5,x,x,
        x,x,5,3,x,x,9,x,x,
        x,1,x,x,8,x,x,x,2,
        6,x,x,x,x,4,x,x,x,
        3,x,x,x,x,x,x,1,x,
        x,4,x,x,x,x,x,x,7,
        x,x,7,x,x,x,3,x,x]).

board3([x,6,x,1,x,4,x,5,x,
        x,x,8,3,x,5,6,x,x,
        2,x,x,x,x,x,x,x,1,
        8,x,x,4,x,7,x,x,6,
        x,x,6,x,x,x,3,x,x,
        7,x,x,9,x,1,x,x,4,
        5,x,x,x,x,x,x,x,2,
        x,x,7,2,x,6,9,x,x,
        x,4,x,5,x,8,x,7,x
]).
    