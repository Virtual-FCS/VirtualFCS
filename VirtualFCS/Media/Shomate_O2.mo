within VirtualFCS.Media;

record Shomate_O2 "Shomate equations values for oxygen"
  extends VirtualFCS.Media.ShomateParameters(
    A = 31.32234, 
    B = -20.23531, 
    C = 57.86644, 
    D = -36.50624, 
    E = -0.007374, 
    F = -8.903471, 
    G = 246.7945, 
    H = 0.0);
  annotation(
    Documentation(info = "<html><head></head><body>Validity range 100 K - 700 K.<div>Original data Chase et al. (1998).</div><div><a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7782447&amp;Units=SI&amp;Mask=1#Thermo-Gas\">Source NIST</a></div><!--StartFragment--><!--EndFragment--></body></html>"));

end Shomate_O2;
