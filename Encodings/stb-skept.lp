%dflat: -e assumption -e body -e head -e contrary -e atom -e query

length(2).
or(0).
and(1).

% An item set interprets an atom as false or a rule as unsatisfied.
%false(S,A) :-  atNode(S,N), not rootOf(S,N), bag(N,A), atom(A), not childItem(S,A).
%false(S,A) :-  atNode(S,N), not rootOf(S,N), bag(N,A), assumption(A), not childItem(S,A).


notIn(S, A) :- childNode(N), atNode(S,N), not rootOf(S,N), bag(N,A), assumption(A), not childItem(S, A).
:- extend(L, S1), extend(L, S2), S1!=S2, assumption(A), childItem(S1,A), notIn(S2,A).
% Guess df(A).
notInAt(S, A) :- childNode(N), atNode(S,N), not rootOf(S,N), bag(N,A), atom(A), not childItem(S, A).
:- extend(L, S1), extend(L, S2), S1!=S2, atom(A), childItem(S1,A), notInAt(S2,A).
% Guess df(A).

unsat(S,R) :-  atNode(S,N), not rootOf(S,N), bag(N,R), rule(R), not childAuxItem(S,R).

%undf(S,A):- atNode(S,N), not rootOf(S,N), bag(N,A), 1{atom(A);assumption(A)}, not childAuxItem(S,dft(A)).
%auxItem(L, undf(A)) :- not auxItem(L, dft(A)), current(A), undf(S,A), L=1..2.


% Guess item tree nodes to extend.
1 { extend(0,R): rootOf(R,N) } 1 :- childNode(N).
1 { extend(L+1,S) : sub(R,S) } 1 :- extend(L,R), L < 2.

% Only join item tree nodes that coincide on common atoms.
%:- extend(L,X), extend(L,Y), assumption(A), childItem(X,A), false(Y,A), L=1..2.
%:- extend(L,X), extend(L,Y), atom(A), childItem(X,A), false(Y,A), L=1..2.


% True atoms and satisfied rules remain so unless removed.
item(L,A) :- extend(L,S), childItem(S,A), current(A), atom(A), L=1..2.
item(L,A) :- extend(L,S), childItem(S,A), current(A), assumption(A), L=1..2.
auxItem(L,R) :- extend(L,S), childAuxItem(S,R), current(R), rule(R), L=1..2.

% A child item tree node cannot be extended if it contains an unsat rule that is removed.
:-  rule(R), removed(R), extend(L,S), unsat(S,R), L=1..2.

{item(L,A)} :- assumption(A), introduced(A), L=1..2.
{item(L,A)} :- atom(A), introduced(A), L=1..2.

:- atom(A), item(2,A), not item(1,A).

:- assumption(A), item(2,A), not item(1,A).
:- assumption(A), item(1,A), not item(2,A).

% skeptical
:- query(A), item(1,A). %

% Through the guess, rules may become satisfied.

auxItem(L,C) :- current(A), current(C), head(C,A), item(L,A), L=1..2.
auxItem(L,C) :- current(A), current(C), body(C,A), not item(L,A), L=1..2.


item(2,smaller) :- extend(2,S), childItem(S,smaller).
item(2,smaller) :- introduced(A), atom(A), item(1,A), not item(2,A).

% Conflict-Free
:- contrary(A,B), item(L,A), item(L,B), L=1..2.

%-----------------------------------------------------------------------------------------------------

% Complement of IN set
item(L, out(A)) :- assumption(A), not item(L,A), L=1..2.

%item(L, out(A)) :- atom(A), not item(L, A), L=1..2.
%auxItem(L, out(A)) :- current(A), assumption(A), extend(L,S1), childAuxItem(S1, out(A)), L=1.

%:- auxItem(2, out(A)), not auxItem(1, out(A)).
%:- auxItem(1, out(A)), not auxItem(2, out(A)).

% Defeated
item(L, df(A)) :- current(A), current(Z), contrary(A, Z), item(L, Z), not item(L,A), L=1..2.

item(L, df(A)) :- current(A), extend(L, S1), childItem(S1, df(A)), L=1..2.

%:- auxItem(2, df(A)), not auxItem(1, df(A)).
%:- auxItem(1, df(A)), not auxItem(2, df(A)).

%:- item(L, df(A)), extend(L, S1), not childItem(df(A)), L=1..2.a
%:- extend(L, S1), extend(L, S2), childItem(S1, defeated(X)), not childItem(S2, defeated(X)).

% Stable semantic

:- removed(A), extend(L, S1),  childItem(S1, out(A)), not childItem(S1, df(A)), L=1.
%:- removed(A), extend(L, S1),  childItem(S1, out(A)), not childItem(S1, df(A)), not item(2, smaller) ,L=2.

%:- final, extend(L, S1), childItem(S1, out(A)), not childItem(S1, df(A)),L=1..2.


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
