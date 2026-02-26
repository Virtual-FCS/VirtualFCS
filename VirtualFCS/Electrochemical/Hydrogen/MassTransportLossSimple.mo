within VirtualFCS.Electrochemical.Hydrogen;

model MassTransportLossSimple
extends Electrochemical.Hydrogen.BaseMassTransportLoss;
  import Modelica.Constants.R;
  import Modelica.Constants.F;
  
  parameter Modelica.Units.SI.CurrentDensity i_limit = 16000 "Limiting current A/m^2 (Barbir 2005)";
  
  outer Modelica.Units.SI.Temperature T_stack "stack temperature";
  outer Modelica.Units.SI.Area A_el "Area of the fuel cell electrode (m^2)";
  
  Modelica.Units.SI.CurrentDensity i_area;
  
protected
  constant Integer N = 2 "Number of electrons in reaction";
  parameter Modelica.Units.SI.Current i_epsilon = 1E-39*i_limit "Very small positive current";
  
   
equation
  i_area = i/A_el;
  v = N_cells * R*T_stack/(N*F) * log(i_limit/max(i_limit-i_area, i_epsilon));

annotation(Documentation(info = "<html><head></head><body>Mass transport loss implemented as loss of reversible potential.<div><br><div>This formulation has the advantage of requiring only one parameter, but it is far steeper than real concentration overpotential, since most of it is due to the reduction of the exchange current density in the catalyst loss term, and will therefore occur on its own assuming the effect of reduced reactant concentration on i<sub>x</sub>&nbsp;has been modelled; in that case this element may be discarded.</div><div>Also, different parts of the CL will have different thickness and thereby different limiting currents, effectively \"diffusing\" the effect which will not be as sudden.</div><div><br></div><div>The formula used in this element is taken from Barbir's \"PEM Fuel Cells - Theory and Practice\", Elsevier, 2013, eq. 3-41.</div><div>It expresses the loss in Nernst potential when reactant concentration goes to zero, so this element should not be deployed if the voltage source is a Nernst element that accounts for concentration already.</div><h2>Assumptions</h2><div>A key assumption is that reactant concentration at the reaction site will decrease linearly with current, uniformly across the entire area, which is a simplification of a very complex multiphase, multicomponent diffusion and convection problem.</div><div><br></div><div>As the starving species is almost always oxygen, there should be an additional 0.5 factor to account for its exponent in the Nernst voltage; however, as the function is so steep when closing to the limit current, it will not have any practical effect.</div></div><h2>Implementation</h2><div>Note that the denominator of the logarithm argument (I<sub>L</sub>-I)&nbsp;has a lower limit at&nbsp;<span style=\"color: rgb(32, 33, 34); font-family: sans-serif; font-variant-ligatures: normal; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\"><span title=\"Greek-language text\"><span lang=\"el\">I<sub>ε</sub>. This is because the solver will often guess values of current I, and if we are at a place where the mass transport barrier is active, the range through which I will iterate is very short; should I be larger than I<sub>L</sub>, the equation will be undefined, and the solver will not know where to go from there. Putting a floor level slightly larger than zero ensures that the equation always computes. This&nbsp;</span></span></span><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\">I</span><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\"><sub>ε</sub></span><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\">&nbsp;has to be so small that, when active, it can nullify alone the stack voltage, since this class' task is to bring voltage to zero at the mass-transport limit.</span></div><div><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\"><br></span></div><div><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\">Therefore, it must be 1.23 V &lt; RT/nF * log(I<sub>L</sub>/I</span><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\"><sub>ε</sub>), which is ensured when&nbsp;</span><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\">I</span><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\"><sub>ε</sub>&lt;10<sup>-37</sup>&nbsp;I<sub>L</sub> using normal values for the variables.</span></div><div><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\"><br></span></div></body></html>"));


end MassTransportLossSimple;
