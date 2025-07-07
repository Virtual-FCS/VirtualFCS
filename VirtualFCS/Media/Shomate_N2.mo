within VirtualFCS.Media;

record Shomate_N2 "Shomate equations values for nitrogen"
  extends VirtualFCS.Media.ShomateParameters(
    A = 28.98641, 
    B = 1.853978, 
    C = -9.647459, 
    D = 16.63537, 
    E = 0.000117, 
    F = -8.671914, 
    G = 226.4168, 
    H = 0.0);
  annotation(
    Documentation(info = "<html><head></head><body>Validity range 100 K - 500 K.<div>Original data Chase et al. (1998).</div><div><a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7727379&Units=SI&Mask=1#Thermo-Gas\">Source NIST</a></div></body></html>"));
 
end Shomate_N2;
