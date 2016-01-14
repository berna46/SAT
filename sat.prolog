:- use_module(library(lists)).

%

%sat
sat([]).
sat(A) :- split_cnf(A,Ar), lsort(Ar,As), choosel(As,L), prop(L,Ar,R), build_cnf(R,CNF), sat(CNF), !. 
sat(A) :- split_cnf(A,Ar), lsort(Ar,As), choosel(As,L), prop(-L,Ar,R).

%gets all the caluses
split_cnf([],[]).
split_cnf(Expr,[LRR|R]) :- Expr=..[*,L,LR], split_cls(LR,LRR), split_cnf(L,R), !.
split_cnf(Expr,[ExprR]) :- Expr=..[+,L,R], split_cls(Expr,ExprR).

%unit propagation
prop(A,[],[]).
prop(A,[X|Xs],R) :- contains(A,X), prop(A,Xs,R), !.
prop(A,[X|Xs],[Xr|R]) :- rmlit(A,X,Xr), prop(A,Xs,R).

%gets clauses literals
split_cls(X,[X]) :- (atom(X); X=..[-,_]), !.
split_cls(X,[R|LR]) :- X=..[+,L,R], split_cls(L,LR), !.

%removes literals
rmlit(-A,[],[]).
rmlit(A,[],[]).
rmlit(-A,[A|Xs],R) :- rmlit(-A,Xs,R), !.
rmlit(-A,[X|Xs],[X|R]) :- rmlit(-A,Xs,R), !.
rmlit(A,[-A|Xs],R) :- rmlit(A,Xs,R), !.
rmlit(A,[X|Xs],[X|R]) :- rmlit(A,Xs,R).

%checks if the list contains A
contains(A,[A|_]).
contains(A,[B|C]) :- contains(A,C).

%chooses literal
choosel([[X|Xs]|Xss],X).

%Sorting a list of lists according to length of sublists
lsort([],[]).
lsort(A,R) :- keygen(A,RR), keysort(RR,RRR), del_key(RRR,R).

keygen([],[]).
keygen([X|Xs],[L-X|R]) :- length(X,L), keygen(Xs,R).

del_key([],[]).
del_key([K-X|Xs],[X|R]) :- del_key(Xs,R).


%builds clause from list
build_cls([X|Xs],X) :- length(Xs,0), !.
build_cls([X|Xs],X+K) :- build_cls(Xs,K).

%buils cnf from a list of clauses
build_cnf([X|Xs],(Xr)) :- length(Xs,0), build_cls(X,Xr), !.
build_cnf([X|Xs],(Xr)*K) :-build_cls(X,Xr), build_cnf(Xs,K).
