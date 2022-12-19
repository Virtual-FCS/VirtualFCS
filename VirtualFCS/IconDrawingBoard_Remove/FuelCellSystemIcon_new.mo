within VirtualFCS.IconDrawingBoard_Remove;

model FuelCellSystemIcon_new
  
  equation
  
  annotation(
    Icon(graphics = {Text(origin = {-6, -250}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Rectangle(origin = {-55, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-9, 60.5}, {9, -61}}), Rectangle(origin = {58.5, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-9, 60.5}, {9, -61}}), Rectangle(origin = {-40, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-29.8, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-19.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {-8.7, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {1.5, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {12.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {22.1, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {32.3, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}}), Rectangle(origin = {42.9, -1}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-3, 46.9}, {4.2, -47}})}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body>The FuelCellSystem class packages together a <a href=\"modelica://VirtualFCS.Electrochemical.Hydrogen.FuelCellStack\">FuelCellStack</a> module and a&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.FuelCellSubSystems\">FuelCellSubSystems</a>&nbsp;module for controlling hydrogen, air, and coolant feeds into and out of the fuel cell.<div><br></div><div>The hydrogen, air, and coolant ports can be connected to their respective subsystems, either by using theblock, or individual&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Hydrogen.SubSystemHydrogen\">SubSystemHydrogen</a>,&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Air.SubSystemAir\">SubSystemAir</a>, and&nbsp;<a href=\"modelica://VirtualFCS.SubSystems.Cooling.SubSystemCooling\">SubSystemCooling</a>&nbsp;blocks.</div><div><br></div><div>In addition to the coolant subsystem, it is assumed that the fuel cell stack exchanges heat with its surroundings by convection and radiation.</div><div><br></div><div><div>Default parameters fit the polarization curve given by Powercell in their Powercellution data sheet, available&nbsp;<a href=\"https://powercellution.com/p-stack\">here</a>.</div>&nbsp;<table border=\"0.9\"><caption align=\"Left\" style=\"text-align: left;\"><strong><u>Default Parameters</u></strong></caption><caption align=\"Left\" style=\"text-align: left;\"><strong><u><br></u></strong></caption><tbody><tr><th>Parameter name</th><th>Value</th><th>Unit</th></tr><tr><td align=\"Left\">m_FC_stack</td><td>=42</td><td align=\"Right\">kg</td></tr><tr><td align=\"Left\">L_FC_stack</td><td>=0.42</td><td align=\"Right\">m</td></tr><tr><td align=\"Left\">W_FC_stack</td><td>=0.582</td><td align=\"Right\">m</td></tr><tr><td align=\"Left\">H_FC_stack</td><td>=0.156</td><td align=\"Right\">m</td></tr><tr><td align=\"Left\">I_rated_FC_stack</td><td>=450</td><td align=\"Right\">A</td></tr><tr><td align=\"Left\">i_L_FC_stack</td><td>=760</td><td align=\"Right\">A</td></tr><tr><td align=\"Left\">N_FC_stack</td><td>=455</td><td align=\"Right\">-</td></tr><tr><td align=\"Left\">V_tank_H2</td><td>=0.13</td><td align=\"Right\">m<sup>3</sup></td></tr><tr><td align=\"Left\">p_tank_H2</td><td>=35000000</td><td align=\"Right\">Pa</td></tr><tr><td align=\"Left\"><br><u><b>Equations</b></u></td><td><br></td><td align=\"Right\"><br></td></tr></tbody></table><div><i><u>Convective Heat Transfer</u></i></div><div>Q<sub>conv</sub>&nbsp;= hA<sub>cool</sub>(T&nbsp;<span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>&nbsp;298 K); h = 12 W m<sup><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>2</sup>&nbsp;K<sup><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; font-size: 14px; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>1</sup></div><div><br></div><div><div><i><u>Radiative Heat Transfer</u></i></div><div>Q<sub>rad</sub>&nbsp;= 0.95A<sub>cool</sub><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\">σ</span>(T<sup>4</sup>&nbsp;<span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(253, 253, 253);\">−</span>&nbsp;(298 K)<sup>4</sup>)</div></div></div></body></html>"));
end FuelCellSystemIcon_new;
