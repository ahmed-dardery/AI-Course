% will be a valid state if and only if Devils = Missionaries or There is an Island that has 0 Missionaries
isValidState(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils):-
    (((LeftMissionaries is 0 ; RightMissionaries is 0),(LeftMissionaries >= 0 , RightMissionaries >= 0 , LeftDevils >= 0 , RightDevils >= 0),!);
    ((LeftDevils is LeftMissionaries, RightMissionaries is RightDevils),(LeftMissionaries >= 0 , RightMissionaries >= 0 , LeftDevils >= 0 , RightDevils >= 0))).
    
    % Adds one to avoid zero problem
hashState(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,Hash,Location):-
    Hash is ((LeftMissionaries+1) + (LeftDevils + 1) * 10 + (RightMissionaries+1) * 100 + (RightDevils+1) * 1000 + Location * 10000).
    
    % All Moves Performed from left to right
moveMissionary(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,LeftDevils,NRightMissionaries,RightDevils,Val):-
    NLeftMissionaries is LeftMissionaries - Val, NRightMissionaries is RightMissionaries + Val.
    
    
moveDevil(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,LeftMissionaries,NLeftDevils,RightMissionaries,NRightDevils,Val):-
    NLeftDevils is LeftDevils - Val, NRightDevils is RightDevils + Val.

moveOneMissionary(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils):-
    moveMissionary(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils,1),
    isValidState(NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils).

moveOneDevil(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils):-
    moveDevil(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils,1),
    isValidState(NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils).

moveOneMissionaryOneDevil(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils):-
    moveMissionary(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,LeftDevils,NRightMissionaries,RightDevils,1),
    moveDevil(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,LeftMissionaries,NLeftDevils,RightMissionaries,NRightDevils,1),
    isValidState(NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils).

moveTwoMissionaries(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils):-
    moveMissionary(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils,2),
    isValidState(NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils).

moveTwoDevils(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils):-
    moveDevil(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils,2),
    isValidState(NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils).


tryAllCombinations(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils):-
    moveTwoDevils(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils);
    moveOneDevil(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils);
    moveOneMissionaryOneDevil(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils);
    moveTwoMissionaries(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils);
    moveOneMissionary(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils).


moveBoatFromLeftToRight(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils):-
    tryAllCombinations(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils).

moveBoatFromRightToLeft(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils):-
    tryAllCombinations(RightMissionaries,RightDevils,LeftMissionaries,LeftDevils,NRightMissionaries,NRightDevils,NLeftMissionaries,NLeftDevils).

abs(X, Y) :- X < 0, Y is -X.
abs(X, X) :- X >= 0.

appendNewStateMove(Missionaries,Devils,NMissionaries,NDevils,Moves,NMoves):-
    MissionaryDiffTemp is Missionaries - NMissionaries, DevilDiffTemp is Devils - NDevils,
    abs(MissionaryDiffTemp, MissionariesChange), abs(DevilDiffTemp,DevilsChange),
    append(Moves,[[MissionariesChange,DevilsChange]],NMoves).
    

solve(3,3,0,0,_,_,Moves,Moves).

solve(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,boatInLeft,Vis,Moves,FinalMoves):-
    hashState(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,Hash,1), \+ member(Hash, Vis), append(Vis,[Hash],NVis),
    moveBoatFromLeftToRight(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils),
    appendNewStateMove(RightMissionaries,RightDevils,NRightMissionaries,NRightDevils,Moves,NMoves),
    solve(NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils,boatInRight,NVis,NMoves,FinalMoves).
        
solve(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,boatInRight,Vis,Moves,FinalMoves):-
    hashState(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,Hash,2), \+ member(Hash, Vis), append(Vis,[Hash],NVis),
    moveBoatFromRightToLeft(LeftMissionaries,LeftDevils,RightMissionaries,RightDevils,NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils),
    appendNewStateMove(LeftMissionaries,LeftDevils,NLeftMissionaries,NLeftDevils,Moves,NMoves),
    solve(NLeftMissionaries,NLeftDevils,NRightMissionaries,NRightDevils,boatInLeft,NVis,NMoves,FinalMoves).

play(Moves):- solve(0,0,3,3,boatInRight,[],[],Moves).
