within VirtualFCS.Electrochemical.Hydrogen.ECM;

model ActivationLossNone
  extends VirtualFCS.Electrochemical.Hydrogen.ECM.BaseActivationLoss;
equation
  v = 0;
  annotation(
    Icon(graphics = {Text(textColor = {0, 0, 255}, extent = {{20, -20}, {-20, 20}}, textString = "None")}),
  Documentation(info = "<html><head></head><body>Trivial implementation of mass transport element with no mass transport losses.<div>Voltage across the item is simply set to zero.</div></body></html>"));

end ActivationLossNone;
