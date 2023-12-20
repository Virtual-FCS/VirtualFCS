within VirtualFCS.Examples.RealTimeExamples;

model TestThrottleKeys
  extends Modelica.Icons.Example;
  VirtualFCS.XInTheLoop.UserInTheLoop.ThrottleKeys throttleKeys annotation(
    Placement(visible = true, transformation(origin = {0, 2}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
equation

  annotation(
    Documentation(info = "<html><head></head><body>This example reads the state of the up and down arrows on the keyboard in real time.&nbsp;<div><br></div><div>Requires the user to load the library: Modelica_DeviceDrivers</div></body></html>"));
end TestThrottleKeys;