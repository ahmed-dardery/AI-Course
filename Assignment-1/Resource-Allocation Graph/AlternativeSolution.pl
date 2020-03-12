listAppend([X | Y], Z, [X | W]) :- listAppend( Y, Z, W).
listAppend([], X, X).

assignList(X,X).

count(H,N):- count(H,0,N).
count([_|T],CurrN , NewN):- TmpN is CurrN + 1, count(T,TmpN,NewN).
count([],CurrN,CurrN).

tryToSolve(Sequence):-
    available_resources(CurrentResources),
    processes(List),
    tryToSolve(List,Sequence,[],_,CurrentResources,_).

tryToSolve([],Sequence,Sequence,_,_,_):-!.

tryToSolve(List,Sequence,CurrSequence,Wait,CurrentResources,NewResources):-
    solveProcessNotWaiting(List,NewSequence,CurrSequence,NewWait,[],CurrentResources,UpdatedResources),
    count(List,CL),count(NewWait,CW), CL =\= CW ,
    tryToSolve(NewWait,Sequence,NewSequence,Wait,UpdatedResources,NewResources).

solveProcessNotWaiting(Sequence,Wait,NewResources):-

     available_resources(CurrentResources),
     processes(List),
     solveProcessNotWaiting(List,Sequence,[],Wait,[],CurrentResources,NewResources).

solveProcessNotWaiting([X|T],Sequence,CurrSequence,Wait,CurrWait,CurrentResources,NewResources):-
     giveProcessAllocation(X,CurrentResources,AfterAllocationResources),!, % if process doesn't need anything it will return true
     listAppend(CurrSequence,[X],NewReturn),
     release(X,AfterAllocationResources,UpdatedResources),
     solveProcessNotWaiting(T,Sequence,NewReturn,Wait,CurrWait,UpdatedResources,NewResources).

solveProcessNotWaiting([X|T],Sequence,CurrSequence,Wait,CurrWait,CurrentResources,NewResources):-
    listAppend(CurrWait,[X],NewWait),
    solveProcessNotWaiting(T,Sequence,CurrSequence,Wait,NewWait,CurrentResources,NewResources).

solveProcessNotWaiting([],CurrSequence,CurrSequence,CurrWait,CurrWait,CuurentResources,CuurentResources):-!.


giveProcessAllocation(P,CurrentResources,CurrentResources):- 
    \+ requested(P,_).

giveProcessAllocation(P,CurrentResources,UpdatedResources):- 
    requested(P,List), % gets all possible values and puts it in list
    consumeListOfResources(List,CurrentResources,TempUpdatedResources),
    isAllValuesPositive2d(TempUpdatedResources),
    % UpdatedResources is TempUpdatedResources,
    assignList(TempUpdatedResources,UpdatedResources).


 release(X,CurrentResources,UpdatedResources):-
     releaseAllocated(X,CurrentResources,AfterReleasingAllocated),
     releaseRequested(X,AfterReleasingAllocated,UpdatedResources).

releaseAllocated(P,CurrentResources,UpdatedResources):-
    allocated(P,List), % gets all possible values and puts it in list
    releaseListOfResources(List,CurrentResources,UpdatedResources).

releaseRequested(P,CurrentResources,UpdatedResources):-
    requested(P,List), % gets all possible values and puts it in list
    releaseListOfResources(List,CurrentResources,UpdatedResources),!.

releaseRequested(P,CurrentResources,CurrentResources):-
    \+requested(P,_). % if the process not requested anything

releaseListOfResources(List,CurrentResources,UpdatedResources):-
    addValueToListOfResources(List,CurrentResources,UpdatedResources,1).

consumeListOfResources(List,CurrentResources,UpdatedResources):-
    addValueToListOfResources(List,CurrentResources,UpdatedResources,-1).


addValueToListOfResources([],CurrentResources,CurrentResources,_):-!.

addValueToListOfResources([Resource|T],CurrentResources,UpdatedResources,Value):-  
    addToResource(Resource,CurrentResources,NewCurrentResources,Value),
    addValueToListOfResources(T,NewCurrentResources,UpdatedResources,Value).


addToResource(Resource,CurrentResources,UpdatedResources,Value):-
    addToResource(Resource,CurrentResources,UpdatedResources,[],Value),!.

addToResource(_,[],TempResources,TempResources,_):-!.
addToResource(Resource,[[Resource,N] | T],UpdatedResources,TempResources,Value):-
    NewValue is N + Value,
    listAppend(TempResources,[[Resource,NewValue]],NewTempResources),
    addToResource(Resource,T,UpdatedResources,NewTempResources,0).

addToResource(Resource,[H|T],UpdatedResources,TempResources,Value):-
    listAppend(TempResources,[H],NewTempResources),
    addToResource(Resource,T,UpdatedResources,NewTempResources,Value).

isAllValuesPositive2d([]):-!.
isAllValuesPositive2d([[_,Value]|T]):- Value >= 0 , isAllValuesPositive2d(T).
