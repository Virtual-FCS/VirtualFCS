within VirtualFCS.Examples.VehicleExamples;
model BatteryElectricVehicle_JoystickControl
  extends BatteryElectricVehicle(redeclare Vehicles.JoystickDriveInput source);
  
  annotation(Documentation(info = "<html><p>This example replaces a prescribed drive cycle with joystick velocity input for a Mirai-profile battery-electric vehicle. The battery starts at SOC = 0.9 with 200 Ah capacity, nominal voltage 320 V, and limits of 300 V to 360 V.</p><p>The user provides the driving excitation.</p></html>"));
end BatteryElectricVehicle_JoystickControl;
