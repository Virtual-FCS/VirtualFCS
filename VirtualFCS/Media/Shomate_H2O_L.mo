within VirtualFCS.Media;

record Shomate_H2O_L
  extends VirtualFCS.Media.ShomateParameters(
    A = -203.6060, 
    B = 1523.290,
    C = -3196.413,
    D = 2474.455, 
    E = 3.855326, 
    F = -256.5478,
    G = -488.7163,
    H = -285.8304);
    annotation(
    Documentation(info = "<html><head></head><body>Validity range 298 K - 500 K.</div><div>Original data Chase et al. (1998).</div><div><a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&Units=SI&Mask=2#Thermo-Condensed\">Source NIST</a></div></body></html>"));
end Shomate_H2O_L;
