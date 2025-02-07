within VirtualFCS.ComponentTesting.ECMS_Experiment_Testing;
model Article_test_run
  extends Modelica.Icons.Example;
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  DriveCycle_EMS_experiment driveCycle_EMS_experiment
    annotation (Placement(transformation(extent={{-60,-20},{-20,20}})));

  ECMSPowerTrain_test eCMSPowerTrain_test(
    V_tank_H2=1,
    p_tank_H2=3800000,
    V_min_bat_pack=37.5,
    V_nom_bat_pack=48,
    V_max_bat_pack=54.75,
    C_bat_pack=180,
    SOC_init=0.3)
    annotation (Placement(transformation(extent={{20,-20},{60,20}})));
equation
  connect(driveCycle_EMS_experiment.pin_p, eCMSPowerTrain_test.pin_p)
    annotation (Line(points={{-22,10},{22,10}}, color={0,0,255}));
  connect(driveCycle_EMS_experiment.pin_n, eCMSPowerTrain_test.pin_n)
    annotation (Line(points={{-22,-10},{22,-10}}, color={0,0,255}));
  annotation (experiment(
      StopTime=1490,
      __Dymola_NumberOfIntervals=1490,
      __Dymola_Algorithm="Dassl"));
end Article_test_run;
