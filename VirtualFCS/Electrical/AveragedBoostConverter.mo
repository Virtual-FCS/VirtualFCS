within VirtualFCS.Electrical;

model AveragedBoostConverter
  extends VirtualFCS.Electrical.AbstractBoostConverter(redeclare AveragedCommutator commutator_A(useHeatPort=useHeatPort),
                                                       redeclare AveragedCommutator commutator_B(useHeatPort=useHeatPort));
  Modelica.Blocks.Interfaces.RealInput D annotation(
    Placement(transformation(origin = {-60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  connect(D, commutator_B.D) annotation(
    Line(points = {{-60, -120}, {-60, -20}, {-20, -20}, {-20, -10}, {-2, -10}}, color = {0, 0, 127}));
  connect(D, commutator_A.D) annotation(
    Line(points = {{-60, -120}, {-60, 40}, {-30, 40}, {-30, 50}, {6, 50}}, color = {0, 0, 127}));
annotation(
    Documentation(info = "<html><head></head><body>An averaged model of a boost DC-DC converter with coupled inductors.<div>The usage of averaged units allows a far quicker simulation than with the rigorous model, but also loses track of details: the model is not reliable outside of continuous current mode (CCM).</div></body></html>"));
end AveragedBoostConverter;
