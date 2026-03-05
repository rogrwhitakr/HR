

=LET(tirol; 'Clients TIROL (Zirl)'!A1:G100;
 wels; 'Clients WELS'!A1:G100;
 graz; 'Clients GRAZ'!A1:G100;
 wiener; 'Clients WienerNeustadt'!A1:G100;

 f1; FILTER(tirol;  BYROW(tirol;  LAMBDA(r; SUM(--ISNUMBER(SUCHEN("IGEL"; r)))>0)));
 f2; FILTER(wels;   BYROW(wels;   LAMBDA(r; SUM(--ISNUMBER(SUCHEN("IGEL"; r)))>0)));
 f3; FILTER(graz;   BYROW(graz;   LAMBDA(r; SUM(--ISNUMBER(SUCHEN("IGEL"; r)))>0)));
 f4; FILTER(wiener; BYROW(wiener; LAMBDA(r; SUM(--ISNUMBER(SUCHEN("IGEL"; r)))>0)));

 WENNFEHLER(VSTACK(f1; f2; f3; f4); ""))

 =LET(tirol; 'Clients TIROL (Zirl)'!A1:G100;
  wels; 'Clients WELS'!A1:G100;
  graz; 'Clients GRAZ'!A1:G100;
  wiener; 'Clients WienerNeustadt'!A1:G100;
  f1; FILTER(tirol;  NACHZEILE(tirol;  LAMBDA(r; SUMME(--ISTZAHL(SUCHEN("IGEL"; r)))>0)));
  f2; FILTER(wels;   NACHZEILE(wels;   LAMBDA(r; SUMME(--ISTZAHL(SUCHEN("IGEL"; r)))>0)));
  f3; FILTER(graz;   NACHZEILE(graz;   LAMBDA(r; SUMME(--ISTZAHL(SUCHEN("IGEL"; r)))>0)));
  f4; FILTER(wiener; NACHZEILE(wiener; LAMBDA(r; SUMME(--ISTZAHL(SUCHEN("IGEL"; r)))>0))));
  WENNFEHLER(VSTAPELN(f1; f2; f3; f4); ""))