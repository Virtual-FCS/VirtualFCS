within VirtualFCS.Media;

record Shomate_H2O_G "Shomate equations values for water vapour"
  extends VirtualFCS.Media.ShomateParameters(
    A = 30.09200, 
    B = 6.832514,
    C = 6.793435,
    D = -2.534480, 
    E = 0.082139, 
    F = -250.8810, 
    G = 223.3967, 
    H = -241.8264);
    annotation(
    Documentation(info = "<html><head></head><body>Validity range <b>500 K - 1700 K: need alternative!</b></div><div>Original data Chase et al. (1998).</div><div><a href=\"https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&Units=SI&Mask=1#Thermo-Gas\">Source NIST</a></div></body></html>"));
end Shomate_H2O_G;
