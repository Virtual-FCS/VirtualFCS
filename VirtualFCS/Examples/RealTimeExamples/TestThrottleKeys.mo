within VirtualFCS.Examples.RealTimeExamples;
model TestThrottleKeys
  extends Modelica.Icons.Example;
  VirtualFCS.XInTheLoop.UserInTheLoop.ThrottleKeys throttleKeys annotation (
    Placement(visible = true, transformation(origin = {0, 2}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
equation

  annotation (
    Documentation(info = "<html><p>This real-time example exposes the up and down keyboard states as a throttle-control signal. It has no prescribed simulation horizon or physical boundary conditions; user key events provide the excitation.</p><p>It requires Modelica_DeviceDrivers.</p></html>"));
end TestThrottleKeys;
