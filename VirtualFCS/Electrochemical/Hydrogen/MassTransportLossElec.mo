within VirtualFCS.Electrochemical.Hydrogen;

model MassTransportLossElec
  extends Electrochemical.Hydrogen.BaseMassTransportLoss;
  import Modelica.Constants.R;
  import Modelica.Constants.F;
  
  outer parameter Real A_cell "Active Area of the Cell";
  outer parameter Integer N_cells "number of cells in the stack";
  outer parameter Real T_stack "Stack temperature";
  outer parameter Real a_A "Charge transfer coefficient Anode";
  // Declare parameters
  Modelica.Units.SI.CurrentDensity j;
  Modelica.Units.SI.Voltage E_diff;
  // Constants
  parameter Modelica.Units.SI.CurrentDensity i_L = 6 "Maximum Current Limit density";
equation
  j = i/A_cell;
  // Mass transport not relavant for el, (R*T_stack)/(2* A_a*F) used in previous Electrolyser model 
  E_diff = (R*T_stack)/(2*F)*log(abs(1 - (j/i_L)));
  v = E_diff;
  annotation(
    Icon(graphics = {Line(points = {{-90, 0}, {-40, 0}}, color = {0, 0, 255}), Line(points = {{40, 0}, {90, 0}}, color = {0, 0, 255}), Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-40, 40}, {40, -40}}), Line(origin = {40, 0}, points = {{0, 40}, {0, -40}, {0, -40}, {0, -40}}, color = {0, 0, 255}), Bitmap(extent = {{-78, 0}, {-78, 0}}), Text(textColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name")}),
    Documentation(info = "<html><head></head><body><div>This is a base class for units calculating the mass transport loss in a fuel cell stack.</div><p>It only implements the number of cells, which is imported from the <i>outer</i> scope.</p></body></html>"),
    Diagram(graphics));end MassTransportLossElec;
