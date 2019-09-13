# Progetto di Ricerca Operativa
# Anno Accademico 2018-2019
# Buratto Enrico, 1142644
# MODELLO DEL PROBLEMA

#INSIEMI
set I; #tipologie di strumenti
set J; #insieme degli stabilimenti
set K; #componenti degli strumenti
set Tipi; #tipi degli strumenti (Chitarra, Basso)

#insiemi ausiliari per una modellazione piu' elegante del problema
set Chitarre;
set ComponentiSpeciali;


#PARAMETRI
param P{I}; #prezzi di vendita degli strumenti
param Y{I} integer; #numero di strumenti di tipo i da modificare
param M{I}; #guadagno per l'azienda dalla modifica di uno strumento tipo i
param CM{I}; #costo per l'azienda della modifica di uno strumento tipo i
param LS{I}; #ore di manodopera necessarie per modificare strumento tipo i
param ND{K, Tipi} integer; #numero di componenti tipo k DISPONIBILI per strumento tipo i
param NN{K, I} integer; #numero di componenti tipo k NECESSARIE per strumento tipo i
param NP{K, I}; #prezzo componente k per strumento i
param C{i in I} := sum{k in K} NP[k,i]; #costo all'azienda degli strumenti di tipo i
param LM{J}; #numero ore di manodopera DISPONIBILI per stabilimento j
param L{I, J}; #numero ore di manodopera NECESSARIE per produrre uno strumento i in stabilimento j


#VARIABILI
var x{I, J}>=0 integer; #numero strumenti di tipo i da produrre in stabilimento j
var y>=0 integer; #quantita' adattatori selettore pick-up da utilizzare
var z>=0 integer; #quantita' modulatori potenziometro da utilizzare

var v{J}>=0; #variabile temporanea: tiene conto delle ore di manodopera di modifica strumento

#variabili temporanee per calcolare y e z
var a>=0 integer;
var b>=0 integer;
var c>=0 integer;
var d>=0 integer;


#FUNZIONE OBIETTIVO
maximize RicavoMassimo:
	(sum{i in I} sum{j in J} P[i]*x[i,j]) - #guadagno da vendita strumenti
	(sum{i in I} sum{j in J} C[i]*x[i,j]) + #costo strumenti all'azienda
	(sum{i in I} M[i]*Y[i]) - #guadagno da modifica strumenti
	(sum{i in I} CM[i]*Y[i]) - #costo modifica strumenti all'azienda
	(4*y) - (7*z); #eventuali scambi di componenti chitarra-basso
;


#VINCOLI

#Vincolo sul numero massimo di componenti disponibile per le chitarre
subject to ComponentiStandardChit{k in K diff ComponentiSpeciali} :
	sum{i in Chitarre} (NN[k,i]*(sum{j in J} x[i,j])) <=
	ND[k,"C"];

#Vincolo sul numero massimo di componenti disponibile per i bassi
subject to ComponentiStandardBass{k in K diff ComponentiSpeciali} :
	sum{i in I diff Chitarre} (NN[k,i]*(sum{j in J} x[i,j])) <=
	ND[k,"B"];

#Vincolo sul numero massimo di selettori Pick-UP disponibile per le chitarre
subject to ComponentiPUChit{k in ComponentiSpeciali} :
	sum{i in Chitarre} (NN[11,i]*(sum{j in J} x[i,j])) <=
	a;

#Vincolo sul numero massimo di selettori Pick-UP disponibile per i bassi
subject to ComponentiPUBass{k in ComponentiSpeciali} :
	sum{i in I diff Chitarre} (NN[11,i]*(sum{j in J} x[i,j])) <=
	b;
	
#Vincolo su a e b
subject to InizAB: a+b<=sum{t in Tipi} (ND[11,t]);

#calcolo di y
subject to AA: y>=ND[11, "C"]-a;
subject to BB: y>=a-ND[11, "C"];

#Vincolo sul numero massimo di potenziometri disponibile per le chitarre
subject to ComponentiPotChit{k in ComponentiSpeciali} :
	sum{i in Chitarre} (NN[12,i]*(sum{j in J} x[i,j])) <=
	c;

#Vincolo sul numero massimo di potenziometri disponibile per i bassi
subject to ComponentiPotBass{k in ComponentiSpeciali} :
	sum{i in I diff Chitarre} (NN[12,i]*(sum{j in J} x[i,j])) <=
	d;
	
#Vincolo su c e d
subject to InizCD: c+d <= sum{t in Tipi} (ND[12,t]);

#calcolo di z
subject to CC: z>=ND[12, "C"]-c;
subject to DD: z>=c-ND[12, "C"];

#Vincoli su manodopera
subject to Manod{j in J}:
	sum{i in I} (L[i,j]*x[i,j]) +v[j] <=
	LM[j];

subject to ManodMod:
	sum{j in J} v[j] = sum{i in I} LS[i]*Y[i];	



