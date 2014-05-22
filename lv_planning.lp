#const min_lv=1.
#const max_lv=10.
#const min_ects=10.
#const max_ects=20.
#const sws_weight=1.
#const ects_weight=2.

visit(X,Y) :- lv(X,_,_,_,Y), wants(X).

can_miss(X) :- lv(X,_,"Vorlesung",_,_).
collide_unit(X,Y,D1) :- unit(X,_,D1,BH1,BM1,EH1,EM1),unit(Y,_,D2,BH2,BM2,EH2,EM2), D1 == D2, BH1 < BH2, EH1 > EH2, X != Y, visit(X,_).
collide_unit(X,Y,D1) :- unit(X,_,D1,BH1,BM1,EH1,EM1),unit(Y,_,D2,BH2,BM2,EH2,EM2), D1 == D2, BH1 < BH2, EH1 == EH2, EM1 >= EM2, X != Y,visit(X,_).
collide_unit(X,Y,D1) :- unit(X,_,D1,BH1,BM1,EH1,EM1),unit(Y,_,D2,BH2,BM2,EH2,EM2), D1 == D2, BH1 == BH2, BM1 < BM2, EH1 >= EH2, X != Y,visit(X,_).
collide_unit(X,Y,D1) :- unit(X,_,D1,BH1,BM1,EH1,EM1),unit(Y,_,D2,BH2,BM2,EH2,EM2), D1 == D2, BH1 == BH2, BM1 <= BM2, EH1 == EH2, EM1 >= EM2, X != Y, visit(X,_).
collide_unit(X,Y,D1) :- unit(X,_,D1,BH1,BM1,EH1,EM1),unit(Y,_,D2,BH2,BM2,EH2,EM2), D1 == D2, BH1 > BH2, BH1 < EH2, X != Y.
collide_unit(X,Y,D1) :- unit(X,_,D1,BH1,BM1,EH1,EM1),unit(Y,_,D2,BH2,BM2,EH2,EM2), D1 == D2, BH1 == BH2, BM1 >=BM2, BH1 < EH2, X != Y, visit(X,_).
collide_unit(X,Y,D1) :- unit(X,_,D1,BH1,BM1,EH1,EM1),unit(Y,_,D2,BH2,BM2,EH2,EM2), D1 == D2, BH1 > BH2, BH1 == EH2, BM1 <= EM2, X != Y, visit(X,_).
collide_unit(X,Y,D1) :- unit(X,_,D1,BH1,BM1,EH1,EM1),unit(Y,_,D2,BH2,BM2,EH2,EM2), D1 == D2, BH1 == BH2, BM1 >= BM2, BH1 == EH2, BM1 <= EM2, X != Y, visit(X,_).
collide_unit(X,Y,D1) :- collide_unit(Y,X,D1).
collide(X,Y) :- not can_miss(X), visit(X,_), collide_unit(X,Y,_), X != Y.

% generate
min_lv { visit(X,Y) : lv(X,_,_,_,Y) } max_lv.

% integrity
:- visit(X,_), visit(Y,_), collide(X,Y).
:- visit(X,_), visit(Y,_), collide(Y,X).

% constraints
:- not min_ects [ visit(X,Y) = Y] max_ects.
:- visit(_,Y), Y < 1.
:- visit(_,Y), Y > 10. 

%optimize
#minimize [ sws(R) = R @ sws_weight ].
#maximize [ ects(R) = R @ ects_weight ].

% obligatories
-wants(Z) :- visit(X,_), lv(X,Y,_,_,_), lv(Z,Y,_,_,_), Z != X, Y==Y.


%show targets
ects(X):- X:= [ visit(_,Y) = Y ].
sws(R) :- R:= [ visit(X,_) : lv(X,_,_,Z,_) = Z].
#hide .

#show visit/2.
#show ects/1.
#show sws/1.
