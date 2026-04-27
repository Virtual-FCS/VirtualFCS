within VirtualFCS.Electrical;

model AveragedBoostConverter
  extends VirtualFCS.Electrical.AbstractBoostConverter(redeclare AveragedCommutator commutator_A(useHeatPort=useHeatPort),
                                                       redeclare AveragedCommutator commutator_B(useHeatPort=useHeatPort));
  Modelica.Blocks.Interfaces.RealInput D annotation(
    Placement(transformation(origin = {-60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
equation
  connect(D, commutator_B.D) annotation(
    Line(points = {{-60, -120}, {-60, -10}, {-2, -10}}, color = {0, 0, 127}));
  connect(D, commutator_A.D) annotation(
    Line(points = {{-60, -120}, {-60, 50}, {6, 50}}, color = {0, 0, 127}));
end AveragedBoostConverter;
