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
%-----------------------------------------------------------------------------------------------------
% Auxiliary
auxItem(L, asm(X)) :- current(X), assumption(X), L=1..2.
auxItem(L, atm(X)) :- current(X), atom(X), L=1..2.
%------------------------------------------------------------------------------------------------------
% Guess undf
notUndf(S, A) :- childNode(N), atNode(S,N), not rootOf(S,N), bag(N,A), assumption(A), not childItem(S, undf(A)), L=1..2.
:- extend(L, S1), extend(L, S2), S1!=S2, assumption(A), childItem(S1, undf(A)), notUndf(S2,A),L=1..2.
notUndfAt(S, A) :- childNode(N), atNode(S,N), not rootOf(S,N), bag(N,A), atom(A), not childItem(S, undf(A)), L=1..2.
:- extend(L, S1), extend(L, S2), S1!=S2, atom(A), childItem(S1, undf(A)), notUndfAt(S2,A), L=1..2.

{item(L, undf(A))} :- assumption(A), introduced(A), L=1..2.
{item(L, undf(A))} :- atom(A), introduced(A), L=1..2.
item(L, undf(A)) :- extend(L,S), childItem(S, undf(A)), current(A), atom(A), L=1..2.
item(L, undf(A)) :- extend(L,S), childItem(S, undf(A)), current(A), assumption(A), L=1..2.

:- atom(A), item(2, undf(A)), not item(1, undf(A)).
%:- atom(A), item(1, undf(A)), not item(2, undf(A)).
:- assumption(A), item(2, undf(A)), not item(1, undf(A)).
:- assumption(A), item(1, undf(A)), not item(2, undf(A)).
%-------------------------------------------------------------------------------------------------------


% cant be undf and attacked by IN.
:- current(A), current(Z), contrary(A,Z), item(L, undf(A)), item(L, Z), L=1.


% Remove (not undf and not attackedbyIN)--------------
auxItem(L, attackedByIn(A)) :- current(X), current(A), contrary(A,X), item(L, X), L=1.
auxItem(L, attackedByIn(A)) :- current(A), extend(L, S1), childAuxItem(S1, attackedByIn(A)), L=1.
% assumption for when removed R
auxItem(L, asm(A)) :-current(A), assumption(A), L=1..2.
:- removed(A), childAuxItem(S1, asm(A)), extend(L, S1), not childItem(S1, undf(A)), not childAuxItem(S1, attackedByIn(A)), L=1. %basicallt means it cant be both undf and not df. it has to be one or the other.

%-----------------------------------------------------------------------------------------------------------

%Admissiblity, cant be attacked by undefeated
:- current(A), current(Z), contrary(A,Z), item(L, A), item(L, undf(Z)), L=1.

unsat_undf(S,R) :-  atNode(S,N), not rootOf(S,N), bag(N,R), rule(R), not childAuxItem(S, sat_undf(R)).
:-  rule(R), removed(R), extend(L,S), unsat_undf(S,R), L=1..2.

auxItem(L, sat_undf(R)) :- current(A), current(R), head(R,A),  item(L, undf(A)), L=1..2.
auxItem(L, sat_undf(R)) :- current(A), current(R), body(R,A), not item(L, undf(A)), L=1..2.
auxItem(L, sat_undf(R)):- current(R), rule(R), extend(L,S), childAuxItem(S, sat_undf(R)), L=1..2.


%Completeness
% every defended assumption is IN

%auxItem(L, isolatedUndf(A)) :- current(A), assumption(A), not contrary(A, _), item(L, undf(A)), L=1..2.
%auxItem(L, isolatedUndf(A)) :- current(A), assumption(A), extend(L, S1), not contrary(A,_), childAuxItem(S1, isolatedUndf(A)), L=1..2.


auxItem(L, attackedByUndf(A)) :- current(X), current(A), contrary(A,X), item(L, undf(X)), L=1.
auxItem(L, attackedByUndf(A)) :- current(A), extend(L, S1), childAuxItem(S1, attackedByUndf(A)), L=1.

% COMPLETENESS
%:- removed(A), childAuxItem(S1, asm(A)), extend(L, S1), not childItem(S1,A), childItem(S1, undf(A)), not childAuxItem(S1, attackedByUndf(A)), L=1.


%auxItem(L, defended(A)) :- current(A), current(X), assumption(A), item(L, undf(A)), not contrary(A,X), L=1.
%auxItem(L, defended(A)) :- current(A), current(X), assumption(A), contrary(A, Z), auxItem(L, attackedByIn(Z)), L=1.
%auxItem(L, defended(A)) :- current(A), extend(L, S1), childAuxItem(S1, defended(A)), current(A), L=1.

%:- current(A), not item(L, A), item(L, undf(A)),  auxItem(L, attackedByUndf(A)),L=1.



%:- removed(A), childAuxItem(S1, asm(A)), extend(L, S1), not childItem(S1, A), childAuxItem(S1, defended(A)), not childAuxItem(S1, attackedByIn(A)),L=1.





%:- removed(A), extend(L, S1), childAuxItem(S1, asm(A)),  not childItem(S1,undf(A)),  childAuxItem(S1, attackedByIn(A)), L=1. 

%:- assumption(A), not item(L, A), item(L, undf(A)), not  auxItem(L, attackedByIn(A)), L=1.

%:- introduced(A), item(L, undf(A)), not item(L,A), L=1.

item(2, smallerundf) :- extend(2,S), childItem(S, smallerundf).
item(2, smallerundf) :- introduced(A), atom(A), item(1, undf(A)), not item(2,undf(A)).
reject:- final, item(2, smallerundf).


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
