within VirtualFCS.Electrical;

model BoostConverter
  extends VirtualFCS.Electrical.AbstractBoostConverter(redeclare Commutator commutator_A(useHeatPort=useHeatPort),
                                                       redeclare Commutator commutator_B(useHeatPort=useHeatPort));
  extends Modelica.Electrical.PowerConverters.Interfaces.Enable.Enable2;
equation
  connect(andCondition_p.y, commutator_B.fire) annotation(
    Line(points = {{-60, -68}, {-60, -10}, {0, -10}}, color = {255, 0, 255}));
  connect(andCondition_n.y, commutator_A.fire) annotation(
    Line(points = {{60, -68}, {60, 40}, {0, 40}, {0, 50}, {8, 50}}, color = {255, 0, 255}));
end BoostConverter;
