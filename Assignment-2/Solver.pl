countPerType(3).
boatCapacity(2).

genMoves(X, _):- X < 0, !.
genMoves(X, Y):- NX is X - 1, NY is Y + 1, assertz(moves(X,Y)), genMoves(NX,NY).
genMoves(N):- N = 0, !.
genMoves(N):- genMoves(N, 0), NN is N - 1, genMoves(NN).

:- dynamic moves/2.
:- retractall(moves(_,_)).
:- boatCapacity(N), genMoves(N).

valid(M,C, N):-
     M >= 0, C >= 0, M =< N, C =< N, (M = C; M = 0; M = N), !.

next(M,C,NM,NC,IM,IC,Boat):-
    NM is M + Boat * IM, NC is C + Boat * IC.

solve(0, 0, Order,Order, _, _):-!.
solve(M, C, Order,VIS, N, Boat):-
    moves(IM, IC),
    next(M,C,NM,NC,IM,IC,Boat),
    valid(NM, NC, N),
    not(member([NM,NC,Boat], VIS)),
    append(VIS,[[NM,NC,Boat]], NVIS),
    NBoat is -Boat,
    solve(NM, NC, Order, NVIS, N, NBoat).

solve(Order):-
    countPerType(N), solve(N, N, Order, [[N, N, 1]], N, -1).