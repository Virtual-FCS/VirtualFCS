within VirtualFCS.Electrochemical.Hydrogen;

model ActivationLossAnCa
extends Electrochemical.Hydrogen.BaseActivationLoss;
  import Modelica.Constants.R;
  import Modelica.Constants.F;
    
  outer parameter Real A_cell "Active Area of the Cell";
  outer parameter Real T_stack "Stack temperature";
  outer parameter Real a_A "Charge transfer coefficient Anode";
  
  parameter Modelica.Units.SI.CurrentDensity i_0 = 1.7e-6 "Exchange Current density";
  constant Real a_C = 0.5 "Cathode charge Transfer coefficient";
  
  // Declare parameters
  Modelica.Units.SI.Voltage E_act_C;
  Modelica.Units.SI.Voltage E_act_A;
  Modelica.Units.SI.Voltage E_act;
  Modelica.Units.SI.CurrentDensity j;
   
equation
   j = i/A_cell;
   E_act_C = R*T_stack/(a_C*F)*Modelica.Math.asinh(j/2*i_0);
   E_act_A = R*T_stack/(a_A*F)*Modelica.Math.asinh(j/2*i_0);
   E_act = E_act_A + E_act_C;
   v = E_act;
end ActivationLossAnCa;
