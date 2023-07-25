%dflat: -e assumption -e body -e head -e contrary -e atom
length(2).
or(0).
and(1).

%  An item set interprets a rule as unsatisfied.
unsat(S,R) :-  atNode(S,N), not rootOf(S,N), bag(N,R), rule(R), not childAuxItem(S,R).

% Guess item tree nodes to extend.
1 { extend(0,R): rootOf(R,N) } 1 :- childNode(N).
1 { extend(L+1,S) : sub(R,S) } 1 :- extend(L,R), L < 2.


% Only join item tree nodes that coincide on common atoms.
notIn(S, A) :- childNode(N), atNode(S,N), not rootOf(S,N), bag(N,A), assumption(A), not childItem(S, A).
:- extend(L, S1), extend(L, S2), S1!=S2, assumption(A), childItem(S1,A), notIn(S2,A).
notInAt(S, A) :- childNode(N), atNode(S,N), not rootOf(S,N), bag(N,A), atom(A), not childItem(S, A).
:- extend(L, S1), extend(L, S2), S1!=S2, atom(A), childItem(S1,A), notInAt(S2,A).

% True atoms and satisfied rules remain so unless removed.
item(L,A) :- extend(L,S), childItem(S,A), current(A), atom(A), L=1..2.
item(L,A) :- extend(L,S), childItem(S,A), current(A), assumption(A), L=1..2.
auxItem(L,R) :- extend(L,S), childAuxItem(S,R), current(R), rule(R), L=1..2.

% A child item tree node cannot be extended if it contains an unsat rule that is removed.
:-  rule(R), removed(R), extend(L,S), unsat(S,R), L=1..2.

{item(L,A)} :- assumption(A), introduced(A), L=1..2.
{item(L,A)} :- atom(A), introduced(A), L=1..2.

:- atom(A), item(2,A), not item(1,A).
%:- atom(A), item(1,A), not item(2,A).
:- assumption(A), item(2,A), not item(1,A).
:- assumption(A), item(1,A), not item(2,A).

% Through the guess, rules may become satisfied.
auxItem(L,C) :- current(A), current(C), head(C,A), item(L,A), L=1..2.
auxItem(L,C) :- current(A), current(C), body(C,A), not item(L,A), L=1..2.

item(2,smaller) :- extend(2,S), childItem(S,smaller).
item(2,smaller) :- introduced(A), atom(A), item(1,A), not item(2,A).

% Conflict-Free
:- contrary(A,B), item(L,A), item(L,B), L=1..2.


reject:- final, item(2,smaller).
accept :- final, not reject.

%-------Display------%
#show length/1.
#show or/1.
#show and/1.
#show accept/0.
#show reject/0.
#show item/2.
#show auxItem/2.
#show extend/2.
%------End Display--- 
