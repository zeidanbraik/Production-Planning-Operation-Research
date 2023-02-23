/*********************************************
Question 2 OR Project (Instance 1 & Instance 2)
Written By: Ikhlas Enaieh, Raneem Madani & Zeidan Braik
** Variables Recalled
 *********************************************/
 
 execute timeTermination {
cplex.tilim = 600; // set time model stop (second)
} 


/************************************** Recalling The Variables from Data File *****************************/ 
 
int P=...; 
int S=...;
int M=...;
{int} Family1= ...;
{int} Family2= ... ;
int C[1..P]= ...;
int f=...;
int F=...;
float h[1..P]= ...;
int p0[1..M] = ...;
int Istart[1..P] = ...;
int D[1..P][1..S] = ...;
/******************************************** Define the Decision Variables *********************************/ 
  
dvar boolean x[1..M][1..S];
dvar boolean W[1..S];
dvar boolean y[1..M][1..P][1..S];
dvar int+ I[1..P][1..S];   
dvar boolean t[1..P];  

/********************************* The Objective Function **************************************************/

minimize sum(s in 1..S) F*W[s] + sum(m in 1..M) sum(s in 1..S) f*x[m][s] + sum(s in 1..S)  sum(p in 1..P) h[p]*I[p][s];

/******************************************** Defining the Constraints *************************************/

subject to{
forall(p in 1..P) I[p][1] == Istart[p] + sum(m in 1..M) (C[p] * y[m][p][1]) - D[p][1];   /* Defining Inventory Balance for Shift one */
forall (p in 1..P) forall(s in 2..S) I[p][s] == I[p][s-1] +  sum(m in 1..M) (C[p]*y[m][p][s]) - D[p][s]; /* Inventory Balance */
forall (p in 1..P) forall (s in 1..S) I[p][s] >= 0; /* A redundant constraint as it is defined in int+, to Satisfy Demand Satisfaction for both machines*/
forall (s in 1..S) sum(p in Family1) y[1][p][s] == 1; /* Restrict Machine one to produce only products of family one */
forall (s in 1..S) sum(p in Family2) y[1][p][s] == 0; /* Don't let machine one to produce products of Family two */
forall (s in 1..S) sum(p in 1..P) y[2][p][s] == 1; /* Restrict Machine two to produce only one type whether from family one or two*/ 
x[1][1] + y[1][p0[1]][1] >= 1; /* Restrict x11 to be one if a switch happened at shift one on machine one */
t[p0[2]] ==1; /* Assume the product of type p0 on machine 2 was produced to decide if a switch happened at shift one*/
sum(p in 1..P) t[p] == 1; /* Restrict the other values to be 0 */ 
sum(p in Family1) (y[2][p][1] - t[p]) <=  W[1]; /* sum of the differences over one family, if one inforce W1 to be 1 */
sum(p in Family2) (y[2][p][1] - t[p]) <=  W[1]; /* Contingent Constraint with the previous one*/
forall (s in 2..S) sum(p in Family1) y[2][p][s] <= sum(p in Family1) y[2][p][s-1] + W[s]; /* Define the values of Ws, and then X2s will take its values*/
forall (s in 2..S) sum(p in Family2) y[2][p][s] <= sum(p in Family2) y[2][p][s-1] + W[s]; /* Contingent Constraint with the Previous one */
forall (p in 1..P)  y[2][p][1] - t[p] <= x[2][1] + W[1];  /* Ristrict x21 & W1 to one of them have value of one if a switch happened at shift one either in same family or between different families  */
forall (p in 1..P)  t[p] - y[2][p][1] <= x[2][1] + W[1]; /* Contingent constraint where this or previous one should hold */
forall (p in Family1) forall (s in 2..S) y[1][p][s] - y[1][p][s-1] <= x[1][s]; /* restrict x1s to be one if a switch happened in machine one  */
forall (p in Family1) forall (s in 2..S)  y[1][p][s-1] - y[1][p][s] <= x[1][s]; /* Contingent constraint with the previous one */
forall (p in 1..P) forall (s in 2..S) y[2][p][s] - y[2][p][s-1] <= x[2][s] + W[s]; /* restrict the value of x2s and Ws where one of them will be 1 if switch happened  */
forall (p in 1..P) forall (s in 2..S)  y[2][p][s-1] - y[2][p][s] <= x[2][s] + W[s]; /* Contingent Constraint with the previous one */

}


