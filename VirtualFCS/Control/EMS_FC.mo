within VirtualFCS.Control;

block EMS_FC
  parameter Real ramp_up(unit = "1/s") = 20 "FC stack current ramp up rate";
  Modelica.Blocks.Math.Abs abs1 annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OFF(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput sensorInterface annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-121, -1}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant ON(k = Vehicles.VehicleProfile.V_load) annotation(
    Placement(visible = true, transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter(Rising = ramp_up) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput controlInterface annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Hysteresis hysteresis(pre_y_start = true, uHigh = 0.8, uLow = 0.2) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(sensorInterface, hysteresis.u) annotation(
    Line(points = {{-120, 0}, {-82, 0}, {-82, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, abs1.u) annotation(
    Line(points = {{42, 0}, {56, 0}, {56, 0}, {58, 0}}, color = {0, 0, 127}));
  connect(abs1.y, controlInterface) annotation(
    Line(points = {{82, 0}, {102, 0}, {102, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(hysteresis.y, switch1.u2) annotation(
    Line(points = {{-58, 0}, {-24, 0}, {-24, 0}, {-22, 0}}, color = {255, 0, 255}));
  connect(OFF.y, switch1.u1) annotation(
    Line(points = {{-58, 40}, {-40, 40}, {-40, 8}, {-22, 8}, {-22, 8}}, color = {0, 0, 127}));
  connect(switch1.y, slewRateLimiter.u) annotation(
    Line(points = {{2, 0}, {16, 0}, {16, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(ON.y, switch1.u3) annotation(
    Line(points = {{-58, -40}, {-40, -40}, {-40, -8}, {-22, -8}, {-22, -8}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Bitmap(origin = {-5, 6}, extent = {{-95, 94}, {105, -106}}, imageSource = "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X6CNOzudc5uu54SXPtqhGwDMCjs+2v+rUnXbr7VpZ68zFum6Jm9u1q0ADrvNe59lkSw6Qxt2dpt/s65v8ux7/CUXs8C2957Vlkxunq/NOvudcoOus3lhHX/KxWG1dZ2eRetuOEUbtR3mLrhHV9wsW73xW90u4JD6duPq/Xc5TLhnwVxt0hY5eeGDuvpu+bubeE1cHFLfb3p3/93gyYMLT9b2bJ0zrntcN0JWvL/lB91OYKx+2PK+znO81+N/b8edDjlzfhPv3DOr3v5w83ae/ISx2bl984dv+2s7B4suHu9rWhwSx11xu25OtOy1NRu28nsUGvXt1g1rXpv0G5LcfsVx2o6td8SZC/eeBHayZ1a+8da7a9et/2TT59u2f7PjJ60JMJSfdnyzfdvnmz5Zv27tu2+9sfIZbavJFi888whtxK448pyr79OtAw6R+64+50htwK456vxr9z+2HBir+689/yhtvK469vTLrlm0VLcXGIOli6657PRjteG6b8688666fvEjuvFAIx5ZfP1V583rwL12o5g7/+wLL738D9f87aZb71iy9OHHtCbAUB57eOmSO2696a9X//7ySy88e/5hfWjDYPD/AWVvEgJ09vv6AAAAAElFTkSuQmCC")}));
end EMS_FC;