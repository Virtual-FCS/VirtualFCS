within VirtualFCS.Media;

record Shomate_H2"Shomate equations values for hydrogen"
  extends VirtualFCS.Media.ShomateParameters(
    A = 33.066178, 
    B = -11.363417, 
    C = 11.432816, 
    D = -2.772874, 
    E = -0.158558, 
    F = -9.980797, 
    G = 172.707974, 
    H = 0.0);
  annotation(
    Documentation(info = "<html><head></head><body>Validity range 298 K - 1000 K.<div>Original data Chase et al. (1998).</div><div><a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C1333740&Units=SI&Mask=1#Thermo-Gas\">Source NIST</a></div><!--StartFragment--><!--EndFragment--></body></html>"));
end Shomate_H2;
