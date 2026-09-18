within VirtualFCS.Electrochemical.Hydrogen.ECM;

partial model BaseOhmic
  extends Modelica.Electrical.Analog.Interfaces.OnePort;

  outer parameter Integer N_cells "number of cells in the stack";

  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-70, 30}, {70, -30}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Line(points = {{-90, 0}, {-70, 0}}, color = {0, 0, 255}), Line(points = {{70, 0}, {90, 0}}, color = {0, 0, 255}), Text(extent = {{-150, 90}, {150, 50}}, textString = "%name", textColor = {0, 0, 255})}),
  Documentation(info = "<html><head></head><body><div>This is a base class for units calculating the Ohmic loss in a fuel cell stack.</div><p>It only implements the number of cells, which is imported from the <i>outer</i> scope.</p></body></html>"),
  Diagram(graphics));
  
end BaseOhmic;
