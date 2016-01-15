:- use_module(library(lists)).


%sat - sort (removes duplicates) -  backtracking???? 
sat([]).
sat(A) :- split_cnf(A,Asplit), sort(Asplit,Ar), lsort(Ar,As), choosel(As,L), prop(L,As,R), build_cnf(R,CNF), \+abs(CNF), sat(CNF), !. 
sat(A) :- split_cnf(A,Asplit), sort(Asplit,Ar), lsort(Ar,As), choosel(As,L), prop(-L,Ar,R), build_cnf(R,CNF), \+abs(CNF), sat(CNF).

%absurd
abs(A* -A).
abs(-A*A).

%gets all the caluses - sort added
split_cnf([],[]).
split_cnf(X,[[X]]) :- (atom(X); X=..[-,_]), !.
split_cnf(Expr,[LRRR|R]) :- Expr=..[*,L,LR], split_cls(LR,LRR), sort(LRR,LRRR), split_cnf(L,R), !.
split_cnf(Expr,[ExprRR]) :- Expr=..[+,L,R], split_cls(Expr,ExprR), sort(ExprR,ExprRR).

%gets clauses literals
split_cls(X,[X]) :- (atom(X); X=..[-,_]), !.
split_cls(X,[R|LR]) :- X=..[+,L,R], split_cls(L,LR), !.

%unit propagation
prop(A,[],[]).
prop(A,[X|Xs],R) :- contains(A,X), prop(A,Xs,R), !.
prop(A,[X|Xs],[Xr|R]) :- rmlit(A,X,Xr), prop(A,Xs,R).

%removes literals
rmlit(-A,[],[]).
rmlit(A,[],[]).
rmlit(-A,[A|Xs],R) :- rmlit(-A,Xs,R), !.
rmlit(-A,[X|Xs],[X|R]) :- rmlit(-A,Xs,R), !.
rmlit(A,[-A|Xs],R) :- rmlit(A,Xs,R), !.
rmlit(A,[X|Xs],[X|R]) :- rmlit(A,Xs,R).

%checks if the list (cluase) contains A
contains(A,[A|_]).
contains(A,[B|C]) :- contains(A,C).

%choose literal
choosel([[X|Xs]|Xss],X).

%Sorts a list of lists according to length of sublists
lsort([],[]).
lsort(A,R) :- keygen(A,RR), keysort(RR,RRR), del_key(RRR,R).

keygen([],[]).
keygen([X|Xs],[L-X|R]) :- length(X,L), keygen(Xs,R).

del_key([],[]).
del_key([K-X|Xs],[X|R]) :- del_key(Xs,R).


%builds clause from list
build_cls([],[]).
build_cls([X|Xs],X) :- length(Xs,0), !.
build_cls([X|Xs],X+K) :- build_cls(Xs,K).

%buils cnf from a list of clauses
build_cnf([],[]).
build_cnf([X|Xs],(Xr)) :- length(Xs,0), build_cls(X,Xr), !.
build_cnf([X|Xs],(Xr)*K) :-build_cls(X,Xr), build_cnf(Xs,K).

%Eliminate consecutive duplicates of list elements.
%compress([],[]) :- !.
%compress([A|[]],[A]) :- !.
%compress([A,A|B],R) :- compress([A|B],R), !.
%compress([A,C|B],[A|R]) :- compress([C|B],R).




				   
