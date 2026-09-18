within VirtualFCS.Electrochemical.Hydrogen.ECM;

partial model BaseMassTransportLoss
  extends Modelica.Electrical.Analog.Interfaces.OnePort;

  outer parameter Integer N_cells "number of cells in the stack";

  annotation(
    Icon(graphics = {Line(points = {{-90, 0}, {-40, 0}}, color = {0, 0, 255}), Line(points = {{40, 0}, {90, 0}}, color = {0, 0, 255}), Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-40, 40}, {40, -40}}), Line(origin = {40, 0}, points = {{0, 40}, {0, -40}, {0, -40}, {0, -40}}, color = {0, 0, 255}), Bitmap(extent = {{-78, 0}, {-78, 0}}), Text(textColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name")}),
  Documentation(info = "<html><head></head><body><div>This is a base class for units calculating the mass transport loss in a fuel cell stack.</div><p>It only implements the number of cells, which is imported from the <i>outer</i> scope.</p></body></html>"),
  Diagram(graphics));

end BaseMassTransportLoss;
