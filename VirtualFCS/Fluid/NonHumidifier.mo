within VirtualFCS.Fluid;

model NonHumidifier
  extends VirtualFCS.Fluid.HumidifierInterface;
equation
  connect(portB_in, portB_out) annotation(
    Line(points = {{-100, 0}, {100, 0}}, color = {255, 0, 0}, thickness = 1));
  connect(portA_in, portA_out) annotation(
    Line(points = {{0, 100}, {0, -100}}, color = {0, 0, 255}, thickness = 1));
annotation(Documentation(info = "<html><p>Pass-through implementation of the humidifier interface. Air and hydrogen streams are connected without humidification.</p></html>"));
end NonHumidifier;
