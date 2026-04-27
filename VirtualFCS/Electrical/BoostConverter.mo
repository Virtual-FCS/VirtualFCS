within VirtualFCS.Electrical;

model BoostConverter
  extends VirtualFCS.Electrical.AbstractBoostConverter(redeclare Commutator commutator_A(useHeatPort=useHeatPort),
                                                       redeclare Commutator commutator_B(useHeatPort=useHeatPort));
  extends Modelica.Electrical.PowerConverters.Interfaces.Enable.Enable2;
equation
  connect(andCondition_n.y, commutator_A.fire) annotation(
    Line(points = {{60, -68}, {60, 40}, {0, 40}, {0, 50}, {8, 50}}, color = {255, 0, 255}));
  connect(andCondition_p.y, commutator_B.fire) annotation(
    Line(points = {{-60, -68}, {-60, -14}, {-20, -14}, {-20, -10}, {0, -10}}, color = {255, 0, 255}));
annotation(
    Documentation(info = "<html><head></head><body>A rigorous model for DC-DC boost converters. The two boolean inputs allow firing the gates separately.<div>Note that the rate of simulation is directly dependent on the PWM frequency, since at each change an event is triggered. In practice, this model can be used for detailed simulations in the sub-second range.</div></body></html>"));
end BoostConverter;
