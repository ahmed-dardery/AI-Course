dim(4,4).
start([1,0]).
end([2,2]).
bomb([0,1]).
bomb([1,2]).
bomb([2,0]).
bomb([3,0]).
star([2,1]).
star([2,3]).
star([3,2]).

%-------------------------------------------------------
move([CurrX,CurrY],[NewX,NewY],right):-  NewX is CurrX,NewY is CurrY + 1,isValid([NewX,NewY]).
move([CurrX,CurrY],[NewX,NewY],down):- NewX is CurrX + 1,NewY is CurrY,isValid([NewX,NewY]).
move([CurrX,CurrY],[NewX,NewY],up):-  NewX is CurrX - 1,NewY is CurrY,isValid([NewX,NewY]).
move([CurrX,CurrY],[NewX,NewY],left):-  NewX is CurrX,NewY is CurrY - 1,isValid([NewX,NewY]).

available_directions([up,down,right,left]).

isInRange(X,K) :- X >= 0 , X < K .
isValid([X,Y]):- dim(MaxX,MaxY),isInRange(X,MaxX),isInRange(Y,MaxY),\+bomb([X,Y]).

member(X, [Y|T]) :- X = Y; member(X, T).
append([], X, X).
append([X | Y], Z, [X | W]) :- append( Y, Z, W).

play(Moves,Stars):-start(S), dfs(S,[],0,[],[],Moves,Stars).

increase_if_star(Pos,Cnt,NewCnt):- star(Pos),NewCnt is Cnt + 1.
increase_if_star(Pos,Cnt,Cnt):- \+star(Pos).

try_all_moves([],_,_,_):-false.
try_all_moves(CurrMove,Pos,NPos,CurrMove):- move(Pos,NPos,CurrMove),!.
try_all_moves([CurrMove|T],Pos,NPos,Dir):- try_all_moves(CurrMove,Pos,NPos,Dir);try_all_moves(T,Pos,NPos,Dir).

dfs(Pos,[_|MovesList],StarsCnt,_,Dir,Moves,StarsCnt):-append(MovesList,[Dir],Moves), end(Pos),!.
dfs(Pos,MovesList,StarsCnt,Vis,Dir,Moves,Stars):-
    \+ member(Pos,Vis),available_directions(Directions),
    increase_if_star(Pos,StarsCnt,NewStarsCnt),
    append(Vis,[Pos],NewVis),append(MovesList,[Dir],NewMovesList),
    try_all_moves(Directions,Pos,NPos,NewDir),
    dfs(NPos,NewMovesList,NewStarsCnt,NewVis,NewDir,Moves,Stars).
