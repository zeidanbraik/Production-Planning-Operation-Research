/*********************************************
Question 1 OR Project (Instance 1 & Instance 2)
Written By: Ikhlas Enaieh, Raneem Madani & Zeidan Braik
** Variables Recalled
 *********************************************/
 
/********************************** THE DATA USED FOR QUESTION **********************/
int P=...;
int S=...;
int C[1..P]= ...;
int f=...;
float h[1..P]=...;
int p0=...;
int Istart[1..P]= ...;
int D[1..P][1..S] = ...;
  
/****************************** THE DECISION VARIABLES ********************************/

dvar boolean X[1..S];
dvar boolean Y[1..P][1..S];
dvar int+ I[1..P][1..S];
dvar int+ Q[1..P][1..S];

/**************************************** THE OBJECTIVE FUNCTION ************************************/

minimize sum(s in 1..S) f*X[s] + sum(s in 1..S) sum(p in 1..P) h[p]*(I[p][s]);

/********************************************** The CONSTRAINTS *********************************/

subject to {
forall (p in 1..P) forall (s in 1..S) Q[p][s] == C[p]*Y[p][s];
forall(s in 1..S) forall(p in 1..P)I[p][s] >= 0;
forall(p in 1..P) I[p][1]== (Istart[p]+ C[p]*Y[p][1]-D[p][1]);
forall(p in 1..P) forall(s in 2..S) I[p][s]== (I[p][s-1]+ C[p]*Y[p][s]-D[p][s]);
forall(s in 1..S) sum(p in 1..P) Y[p][s] == 1;
X[1] + Y[p0][1] >= 1;
forall(p in 1..P) forall(s in 2..S) Y[p][s] <= Y[p][s-1] + X[s]; 
forall(p in 1..P) forall(s in 2..S) Y[p][s-1] <= Y[p][s] + X[s];
}
