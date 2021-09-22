within VirtualFCS.XInTheLoop.UserInTheLoop;

block JoystickRoadElectricVehicleControl
  Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize realtimeSynchronize annotation(
    Placement(visible = true, transformation(origin = {-70, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ctl_accelerate annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ctl_Steering annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter steeringRateLimiter "Limit the time rate of change of the steering control." annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica_DeviceDrivers.Blocks.InputDevices.JoystickInput joystickInput(axes(each fixed = false))  annotation(
    Placement(visible = true, transformation(origin = {-72, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ctl_brake annotation(
    Placement(visible = true, transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold annotation(
    Placement(visible = true, transformation(origin = {0, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold annotation(
    Placement(visible = true, transformation(origin = {0, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {72, 48}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter accelerationRateLimiter(Rising = 3) annotation(
    Placement(visible = true, transformation(origin = {-40, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Abs abs1 annotation(
    Placement(visible = true, transformation(origin = {80, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(steeringRateLimiter.y, ctl_Steering) annotation(
    Line(points = {{62, -40}, {102, -40}, {102, -40}, {110, -40}}, color = {0, 0, 127}));
  connect(joystickInput.axes[1], steeringRateLimiter.u) annotation(
    Line(points = {{-60, 0}, {-20, 0}, {-20, -40}, {38, -40}, {38, -40}}, color = {0, 0, 127}));
  connect(switch1.y, ctl_accelerate) annotation(
    Line(points = {{61, 20}, {110, 20}}, color = {0, 0, 127}));
  connect(greaterEqualThreshold.y, switch1.u2) annotation(
    Line(points = {{11, 20}, {38, 20}}, color = {255, 0, 255}));
  connect(lessEqualThreshold.y, switch.u2) annotation(
    Line(points = {{11, 80}, {38, 80}}, color = {255, 0, 255}));
  connect(lessEqualThreshold.u, accelerationRateLimiter.y) annotation(
    Line(points = {{-12, 80}, {-12, 50}, {-29, 50}}, color = {0, 0, 127}));
  connect(accelerationRateLimiter.y, greaterEqualThreshold.u) annotation(
    Line(points = {{-29, 50}, {-12, 50}, {-12, 20}}, color = {0, 0, 127}));
  connect(accelerationRateLimiter.y, switch1.u1) annotation(
    Line(points = {{-29, 50}, {32, 50}, {32, 28}, {38, 28}}, color = {0, 0, 127}));
  connect(accelerationRateLimiter.u, joystickInput.axes[2]) annotation(
    Line(points = {{-52, 50}, {-52, 0}, {-60, 0}}, color = {0, 0, 127}));
  connect(const.y, switch1.u3) annotation(
    Line(points = {{61, 48}, {44, 48}, {44, 12}, {38, 12}}, color = {0, 0, 127}));
  connect(switch.u3, const.y) annotation(
    Line(points = {{38, 72}, {44, 72}, {44, 48}, {61, 48}}, color = {0, 0, 127}));
  connect(accelerationRateLimiter.y, switch.u1) annotation(
    Line(points = {{-29, 50}, {32, 50}, {32, 88}, {38, 88}}, color = {0, 0, 127}));
  connect(switch.y, abs1.u) annotation(
    Line(points = {{62, 80}, {66, 80}, {66, 80}, {68, 80}}, color = {0, 0, 127}));
  connect(abs1.y, ctl_brake) annotation(
    Line(points = {{92, 80}, {104, 80}, {104, 80}, {110, 80}}, color = {0, 0, 127}));
end JoystickRoadElectricVehicleControl;
