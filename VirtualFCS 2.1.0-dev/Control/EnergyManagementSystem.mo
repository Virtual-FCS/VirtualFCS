within VirtualFCS.Control;

block EnergyManagementSystem "Implement algorithms to control the energy and power distribution in a hybrid system."
  parameter Modelica.Units.SI.Current I_nom_FC_stack = 100 "FC stack nominal operating current";
  parameter Modelica.Units.SI.TimeAging ramp_up = 20 "FC stack current ramp up rate";
  parameter Real SOC_lower_limit(unit = "1") = 0.2 "SOC lower limit";
  parameter Real SOC_higher_limit(unit = "1") = 0.8 "SOC lower limit";
  Modelica.Blocks.Sources.Constant shut_down(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Hysteresis hysteresis(pre_y_start = true, uHigh = SOC_higher_limit, uLow = SOC_lower_limit) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant setFuelCellCurrent(k = -I_nom_FC_stack) annotation(
    Placement(visible = true, transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Abs abs1 annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput sensorInterface annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-121, -1}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter(Rising = 1) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput controlInterface annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(abs1.y, controlInterface) annotation(
    Line(points = {{82, 0}, {102, 0}, {102, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, abs1.u) annotation(
    Line(points = {{42, 0}, {56, 0}, {56, 0}, {58, 0}}, color = {0, 0, 127}));
  connect(switch1.y, slewRateLimiter.u) annotation(
    Line(points = {{2, 0}, {16, 0}, {16, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(hysteresis.y, switch1.u2) annotation(
    Line(points = {{-58, 0}, {-24, 0}, {-24, 0}, {-22, 0}}, color = {255, 0, 255}));
  connect(shut_down.y, switch1.u1) annotation(
    Line(points = {{-58, 40}, {-40, 40}, {-40, 8}, {-22, 8}, {-22, 8}}, color = {0, 0, 127}));
  connect(setFuelCellCurrent.y, switch1.u3) annotation(
    Line(points = {{-58, -40}, {-40, -40}, {-40, -8}, {-22, -8}, {-22, -8}}, color = {0, 0, 127}));
  connect(sensorInterface, hysteresis.u) annotation(
    Line(points = {{-120, 0}, {-82, 0}, {-82, 0}, {-82, 0}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {50, 50, 50}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-8, 121}, lineColor = {0, 0, 255}, extent = {{-54, 17}, {54, -17}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body><div>The EnergyManagementSystem component is designed to manage the flow of power between the fuel cell stack, battery, vehicle load, and balance-of-plant load. It splits the load according to pre-defined energy management rules, which are implemented within the bounds of the battery management system and the fuel cell control unit.</div><div><br></div>This model implements a simple energy management algorithm for a hybrid fuel cell &amp; battery system. The model reads the state-of-charge (SOC) of the battery. If it is less than a lower threshold value, then a signal is sent to activate the fuel cell with a given electric current. The rate at which current can be demanded from the fuel cell is limited by a slew rate.&nbsp;</body></html>"));
end EnergyManagementSystem;
