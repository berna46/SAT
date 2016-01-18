:- use_module(library(lists)).


%sat
sat(A,R) :- split(A,As), getl(As,Lts), sol(Lts,As,Rs), sort(Rs,R).

%propagates every single literal - gets all the possible solutions (S+{x#}) 
tryall([],_,[]).
tryall([X|Xs],As,[Rs|R]) :- append([[X]],As,Ap), build_cnf(Ap,CNF), sat2(CNF,[],Rs), tryall(Xs,As,R).

sat2([],A,A).
sat2(A,Sls,Rs) :- split(A,As), \+abs(As), chooseu(As,L,Asc), L\==[], prop(L,Asc,Ap), insertv(L,v,Sls,Sr), build_cnf(Ap,CNF), sat2(CNF,Sr,Rs), !.
sat2(A,Sls,Rs) :- split(A,As), \+abs(As), choosel(As,L), (prop(L,As,R), insertv(L,v,Sls,Sr); M is -1*L, prop(M,As,R), insertv(L,f,Sls,Sr)),
		 build_cnf(R,CNF), sat2(CNF,Sr,Rs), !.


%inserts new values to the solution
insertv(Key,Val,L,R) :- \+member(Key-Val,L), append([Key-Val],L,R).

%gets all literals (no duplicates)
getl(A,X) :- flatten(A,R), sort(R,X).

%splits CNF
split(A,As) :- split_cnf(A,Aspl), sort(Aspl, Ar), lsort(Ar,As).

%gets all the caluses
split_cnf(X,[[X]]) :- (atom(X); var(X); X=..[-,_]), !.
split_cnf(Expr,[LRR|R]) :- Expr=..[*,L,LR], split_cls(LR,LRR), split_cnf(L,R), !.
split_cnf(Expr,[ExprR]) :- Expr=..[+,L,R], split_cls(Expr,ExprR), !.

%gets clauses literals
split_cls(X,[X]) :- (atom(X); var(X); X=..[-,_]), !.
split_cls(X,[R|LR]) :- X=..[+,L,R], split_cls(L,LR), !.

%unit propagation
prop(A,[],[]).
prop(A,[X|Xs],R) :- member(A,X), prop(A,Xs,R).
prop(A,[X|Xs],[Xr|R]) :- rmlit(A,X,Xr), prop(A,Xs,R), !.

%removes literals - length(Xs,N), N>0,
rmlit(A,[],[]).
rmlit(A,[B|Xs],R) :- A=..[-,A1], A1==B, rmlit(A,Xs,R), !.
rmlit(A,[B|Xs],R) :- B=..[-,B1], A==B1, rmlit(A,Xs,R), !.
rmlit(A,[X|Xs],[X|R]) :- rmlit(A,Xs,R), !.

%choose unit clause
chooseu([[X|Xs]|Xss],X,Xss) :- length(Xs,0), !.
chooseu(X,[],X).

%choose literal from clause
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
build_cls([X|Xs],K+X) :- build_cls(Xs,K), !.

%buils cnf from a list of clauses
build_cnf([],[]).
build_cnf([X|Xs],Xr) :- length(Xs,0), build_cls(X,Xr), !.
build_cnf([X|Xs],K*Xr) :- build_cls(X,Xr), build_cnf(Xs,K), !.

%absurd
abs([[X|Xs]|Xss]) :- length([X|Xs],1), (X=..[-,A], member([A],Xss); member([-X],Xss)), !.
abs([X|Xs]) :- abs(Xs), !.
