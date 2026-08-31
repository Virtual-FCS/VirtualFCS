within VirtualFCS.Media.Examples;

model CathodeAirH2Test
  extends Modelica.Media.Examples.Utilities.PartialTestModel(redeclare package Medium = Media.CathodeAirH2, fixedMassFlowRate(X_ambient = X_start+ {-x_H2O_increase*0.2, -x_tot_increase*0.8, x_H2_increase, x_H2O_increase}, T_ambient = T_source), ambient(p_ambient = P_ambient));
  extends Modelica.Icons.Example;
  
  parameter Modelica.Units.SI.MassFraction x_H2O_increase = 0.05;
  parameter Modelica.Units.SI.MassFraction x_H2_increase = 0.02;
  parameter Modelica.Units.SI.MassFraction x_tot_increase = x_H2O_increase + x_H2_increase;
  parameter Modelica.Units.SI.Temperature T_source = 293;
  parameter Modelica.Units.SI.AbsolutePressure P_ambient = 1e5;
  

end CathodeAirH2Test;
