within VirtualFCS.Electrochemical.Hydrogen.ECM;

model OhmicResistance "Ohmic resistance to proton flow through MEA"
  extends VirtualFCS.Electrochemical.Hydrogen.ECM.BaseOhmic;
  
  import Modelica.Math.exp;

  parameter VirtualFCS.Electrochemical.ArealResistivity R_ref = 0.15e-4 "(Ohm.m^2) Reference Internal area resistivity (Barbir 2025)";
  parameter Modelica.Units.SI.Temperature T_ref = 330 "Reference temperature";
  
  outer Modelica.Units.SI.Temperature T_stack "stack temperature";
  outer Real phi;
  outer Modelica.Units.SI.Area A_el "Area of the fuel cell electrode (m^2)";
  
  Modelica.Units.SI.Resistance R "Actual resistance";
  Modelica.Units.SI.CurrentDensity i_area;
   
equation
  i_area = i/A_el;
  R = R_ref*exp(1/T_stack - 1/T_ref) / phi;
  v = N_cells * R * i_area;

  annotation(
    Documentation(info = "<html><head></head><body><p>This resistor implements a variable ohmic resistance as typically encountered in PEM fuel cells.</p><p>A reference value is usually provided by the manufacturer for a reference temperature, which is then corrected for temperature and relative humidity.</p><p></p><ul><li>From <a href=\"http://doi.org/10.1149/2.104203jes\">Yadav and Fedkiw</a>, temperature dependence of conductivity follows an Arrhenius relationship;</li><li>From <a href=\"https://doi.org/10.1016/j.electacta.2008.02.074\">Zhang et al.</a>&nbsp;conductivity is closely linear with relative humidity, meaning the actual resistance value is obtained dividing by &phi;.</li></ul><p>Relative humidity is provided with the custom input connector; temperature with the conditional heat port.</p><p>The default value for resistance <i>R<sub>ref</sub></i> is taken from Yadav and Fedkiw's typical value for Nafion 117 at 330 K, 0.1 S/cm. A thickness of 0.2 mm and and area of 100 cm<sup>2</sup> are then assumed, resulting in 2 m&Omega;.</p>
</body></html>")
    );
end OhmicResistance;
