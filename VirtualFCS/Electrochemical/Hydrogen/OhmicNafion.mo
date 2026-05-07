within VirtualFCS.Electrochemical.Hydrogen;

model OhmicNafion
  extends VirtualFCS.Electrochemical.Hydrogen.BaseOhmic;
  outer parameter Integer N_cells "number of cells in the stack";
  outer parameter Real A_cell "Active Area of the Cell";
  outer parameter Real T_stack "Stack temperature";
  
  parameter Modelica.Units.SI.Thickness t_ele = 1e-3 "Electrode thickness";
  parameter Modelica.Units.SI.Resistivity rho_ele = 7.5e-5 "Electrode resistivity";
  parameter Real lambda = 22 "Number of water molecules per sulfonic acid site";
  parameter Modelica.Units.SI.Thickness t_mem = 180e-6 "Membrane thickness";
  // Declare param
  Modelica.Units.SI.Conductivity sigma_mem "Membrane conductivity";
  Modelica.Units.SI.Resistance R_ohm_ele "Electronic resistance";
  Modelica.Units.SI.Resistance R_ohm_mem "Membrane resistance";
  Modelica.Units.SI.Voltage E_ohm_A "Anode electronic loss";
  Modelica.Units.SI.Voltage E_ohm_C "Cathode electronic loss";
  Modelica.Units.SI.Voltage E_ohm_mem "Membrane ohmic loss";
  Modelica.Units.SI.Voltage E_ohm "Ohmic Loss";

equation
  
    R_ohm_ele = t_ele*rho_ele/A_cell;
    E_ohm_A = R_ohm_ele*i;
    E_ohm_C = E_ohm_A;
    // Nafion membrane conductivity as a function of water per sulfonic acid group and temperature
    sigma_mem = (0.005139*lambda - 0.00326)*exp(1268*((1/303) - (1/max(T_stack, 293.14))));
    R_ohm_mem = t_mem/(sigma_mem);
    E_ohm_mem = R_ohm_mem*i;
    E_ohm = E_ohm_A + E_ohm_C + E_ohm_mem;
    
  v = E_ohm;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-70, 30}, {70, -30}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Line(points = {{-90, 0}, {-70, 0}}, color = {0, 0, 255}), Line(points = {{70, 0}, {90, 0}}, color = {0, 0, 255}), Text(extent = {{-150, 90}, {150, 50}}, textString = "%name", textColor = {0, 0, 255})}),
    Documentation(info = "<html><head></head><body><div>This is a base class for units calculating the Ohmic loss in a fuel cell stack.</div><p>It only implements the number of cells, which is imported from the <i>outer</i> scope.</p></body></html>"),
    Diagram(graphics));

end OhmicNafion;
