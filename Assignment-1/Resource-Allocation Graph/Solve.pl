% Counts number of processes in system:
processCnt(N):-processes(List), processCnt(List, N).
processCnt([],0).
processCnt([_|L],N) :- processCnt(L,N1), N is N1 + 1.

% Same as allocated and requested but instead of returning false, they return an empty list
findRequest(X,Y):- (requested(X,Y), !); Y = [].
findAlloc(X,Y):- (allocated(X,Y), !); Y = [].

% satisfy(RequestList, SystemResources) : returns true if the available resources are sufficient to fullfill the request list.
satisfy([], _).
satisfy([Req|Leftover], Resources):-
    member([Req, Val],Resources),!,
    Val > 0,
    NVal is Val - 1,
    delete(Resources, [Req, Val], Temp),
    append(Temp, [[Req, NVal]], TempResources),
    satisfy(Leftover, TempResources).

% release(AllocationList, SystemResources, NewSystemResources) : adds the allocation list to the system resources.
release([], R, R).
release([Alloc|Leftover], Resources, NewResources):-
    member([Alloc, Val], Resources),!,
    NVal is Val + 1,
    delete(Resources, [Alloc, Val], Temp),
    append(Temp, [[Alloc, NVal]], TempResources),
    release(Leftover,TempResources, NewResources).

% attempts to satisfy any process, and release any resources that satisfied process used to have.
generateOrder(Sys, Res, Order):-
    processCnt(N),
    generateOrder(Sys, Res, Order, 0, [], N).

generateOrder([], _, Order, _, Order,_):-!.
%branch if this process can be satisfied, in this case, release the appropriate resources,
%push to the outorder, and reset the counter.
generateOrder([[P, Alloc, Req]|Leftover], Resources, OutOrder, _, BuildOrder, Cnt):-
    satisfy(Req, Resources),!,
    release(Alloc, Resources, NewResources),
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
    
%System is a list of processes where each item is a pair of two lists, the first is the allocation, second is requested)
getSystem(System):-
    processes(Processes),
    getSystem(Processes,System,[]).

getSystem([], System, System).

getSystem([Top | Leftover], System, Sys):-
    findAlloc(Top, Alloc),
    findRequest(Top, Req),
    append(Sys,[[Top, Alloc, Req]],NewSys),
    getSystem(Leftover, System, NewSys).

getResources(Resources):-
    available_resources(Resources).

safe_state(Out):-
     getSystem(Sys),
     getResources(Res),
     generateOrder(Sys, Res, Out).