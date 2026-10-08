within VirtualFCS.Electrochemical.Hydrogen.ECM;

partial model BaseActivationLoss
  extends Modelica.Electrical.Analog.Interfaces.OnePort;

  outer parameter Integer N_cells "number of cells in the stack";

  annotation(
    Icon(graphics = {Line(points = {{-90, 0}, {-40, 0}}, color = {0, 0, 255}), Line(points = {{40, 0}, {90, 0}}, color = {0, 0, 255}), Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-40, 40}, {40, -40}}), Line(origin = {40, 0}, points = {{0, 40}, {0, -40}, {0, -40}, {0, -40}}, color = {0, 0, 255}), Bitmap(extent = {{-78, 0}, {-78, 0}}), Text(textColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name")}),
  Documentation(info = "<html><head></head><body>
<h2>Model Description and References</h2>
<div>This is a base class for units calculating the activation loss in a fuel cell stack.</div><p>It only implements the number of cells, which is imported from the <i>outer</i> scope.</p>
<h2>Governing Equations</h2>
<p>-</p>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr>
<tr><td><code>N_cells</code></td><td>Integer</td><td>1</td><td><code>-</code></td><td>number of cells in the stack</td></tr>
</tbody></table>
<h2>Interfaces and Connections</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"4\">
<tbody><tr><th>Name</th><th>Kind</th><th>Type</th><th>Unit</th><th>Description</th></tr>
<tr><td><code>p</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.PositivePin</td><td>V; A</td><td>Positive electrical pin</td></tr>
<tr><td><code>n</code></td><td>Connection</td><td>Modelica.Electrical.Analog.Interfaces.NegativePin</td><td>V; A</td><td>Negative electrical pin</td></tr>
</tbody></table>

</body></html>"),
  Diagram(graphics));
  
end BaseActivationLoss;
