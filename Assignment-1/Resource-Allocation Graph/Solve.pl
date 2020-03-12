processes([p1,p2,p3,p4]).

available_resources([[r1, 0], [r2, 0]]).

allocated(p1, [r2]).
allocated(p2, [r1]).
allocated(p3, [r1]).
allocated(p4, [r2]).

requested(p1, [r1]).
requested(p3, [r2]).

% Counts number of processes in system:
processCnt(N):-processes(List), processCnt(List, N, 0).
processCnt([],N,N).
processCnt([_|L],N,NB) :- NN is NB + 1, processCnt(L,N,NN).

% Same as allocated and requested but instead of returning false, they return an empty list
findRequest(X,Y):- (requested(X,Y), !); Y = [].
findAlloc(X,Y):- (allocated(X,Y), !); Y = [].

satisfy_or_release([],R,R,_).
satisfy_or_release([Req|Leftover], Resources, NewResources, INC):-
    member([Req, Val], Resources),!,
    NVal is Val + INC,
    NVal >= 0,
    delete(Resources, [Req, Val], Temp),
    append(Temp, [[Req, NVal]], TempResources),
    satisfy_or_release(Leftover,TempResources, NewResources, INC).

% attempts to satisfy any process, and release any resources that satisfied process used to have.
generateOrder([], _, Order, _, Order,_):-!.
%branch if this process can be satisfied, in this case, release the appropriate resources,
%push to the outorder, and reset the counter.
generateOrder([P|Leftover], Resources, OutOrder, _, BuildOrder, Cnt):-
    findRequest(P, Req),
    satisfy_or_release(Req, Resources,_,-1),!,
    findAlloc(P, Alloc),
    satisfy_or_release(Alloc, Resources, NewResources,1),
    NSkips is 0,
    append(BuildOrder,[P],NewOutOrder),
    generateOrder(Leftover,NewResources,OutOrder, NSkips, NewOutOrder, Cnt).
%branch if this process cannot be satisfied, in this case, skip the current process by pushing it
%to the end of the list. Increase the counter, if the counter reaches n, that means we are back
%where we started with no processes terminated. i.e, deadlocked.
generateOrder([Head|Tail], Resources, OutOrder, Skips, BuildOrder, Cnt):-
    NSkips is Skips+1,
    NSkips \= Cnt,
    append(Tail,[Head],NewList),
    generateOrder(NewList, Resources,OutOrder, NSkips, BuildOrder, Cnt).
    
safe_state(Out):-
    processes(Procs),
    available_resources(Res),
    processCnt(N),
    generateOrder(Procs, Res, Out, 0, [], N).