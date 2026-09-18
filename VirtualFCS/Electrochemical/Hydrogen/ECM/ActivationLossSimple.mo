within VirtualFCS.Electrochemical.Hydrogen.ECM;

model ActivationLossSimple
extends VirtualFCS.Electrochemical.Hydrogen.ECM.BaseActivationLoss;
  import Modelica.Constants.R;
  import Modelica.Constants.F;
    
  parameter Modelica.Units.SI.CurrentDensity i_0 = 0.03"Exchange current density A/m^2 (Barbir 2005)";
  parameter Real alpha = 1 "Charge transfer coefficient (-)";
  
  outer Modelica.Units.SI.Temperature T_stack "stack temperature";
  outer Modelica.Units.SI.Area A_el "Area of the fuel cell electrode (m^2)";
  
  Modelica.Units.SI.CurrentDensity i_area;
   
equation
  i_area = i/A_el;
  v = N_cells * R*T_stack/(alpha*F) * log(max(i_area/i_0, 1));

annotation(Documentation(info = "<html><head></head><body>Voltage activation loss which occurs due to sluggish kinetics associated with small overpotentials, i.e low current regime. The formula used in this element is taken from Barbir's \"PEM Fuel Cells - Theory and Practice\", Elsevier, 2013, eq. 3-41.</div><div>It expresses the loss in Nernst potential when drawn current approaches the exchange current density i<sub>0</sub>&nbsp;</span></div><div><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\"><br></span></div></body></html>"));


end ActivationLossSimple;
