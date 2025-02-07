within VirtualFCS.Electrochemical.Hydrogen;
block fd1
  // Degradation parameters fc
  parameter Real fc_lowP = 1.26e-5;   // Low power
  parameter Real fc_hiP = 1.03e-5;    // High power
  parameter Real fc_cylP = 5.93e-7;   // Load cycling
  parameter Real fc_ss = 1.96e-5/2;     // Start Stop
  parameter Real fc_nomP = 1.96e-5;   // Nominal operation
  parameter Real del_j0 = 0.99 * 10^4;
  parameter Real j_hiP = 1 * 10^4;
  parameter Real j_lowP = 0.33 * 10^4;
  parameter Real dt = 1;              // Time step parameter

  // Variables
  Real del_fc, del_lowP, del_hiP, del_cylP, del_ss, del_nomP;
  Real dj_lowP, dj_hiP, dj_cylP;
  Real del_T, del_rh;
  Real del_j;
  Real j;
  Real FCDeg_old(start=0);

  Modelica.Blocks.Interfaces.RealInput I_FC annotation (Placement(transformation(extent={{-12,-12},{12,12}}, origin={-106,-22}), iconTransformation(extent={{-118,
            -34},{-94,-10}})));
  Modelica.Blocks.Interfaces.RealInput T_FC annotation (Placement(transformation(extent={{-12,-12},{12,12}}, origin={-112,60}), iconTransformation(extent={{-118,56},
            {-94,80}})));
  Modelica.Blocks.Interfaces.RealInput RH_ca annotation (Placement(transformation(extent={{-12,-12},{12,12}}, origin={-106,26}), iconTransformation(extent={{-118,14},
            {-94,38}})));
  Modelica.Blocks.Interfaces.RealInput V_FC annotation (Placement(transformation(extent={{-12,-12},{12,12}}, origin={-112,-44}), iconTransformation(extent={{-118,
            -82},{-94,-58}})));
  Modelica.Blocks.Interfaces.RealOutput FCDeg_new annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={82,-42}), iconTransformation(extent={{94,-10},
            {114,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=FCDeg_old) annotation (Placement(transformation(extent={{14,-50},{34,-30}})));

equation
  j = if I_FC > 0.00000001 then I_FC / (284 * 10^(-4)) else 1e-6;
  del_j = der(j);

  del_T = -(5.390 * 10^(-4) * T_FC^2) + (0.399 * T_FC) - 71.576;
  del_rh = 0.10646 * exp(0.028 * RH_ca);

  if j < j_lowP then // Low power mode
    dj_lowP = -0.176 * log(j) + 0.169;
    dj_hiP = 0;
    dj_cylP = 0;
  elseif j > j_hiP then // High power mode
    dj_lowP = 0;
    dj_hiP = j / j_hiP;
    dj_cylP = 0;
  elseif del_j >= del_j0 then // Load cycling mode
    dj_lowP = 0;
    dj_hiP = 0;
    dj_cylP = del_j / (2 * del_j0);
  else // Nominal operation
    dj_lowP = 0;
    dj_hiP = 0;
    dj_cylP = 0;
  end if;

  del_lowP = fc_lowP * dj_lowP * del_T * del_rh; // Low power mode
  del_hiP = fc_hiP * dj_hiP * del_T * del_rh; // High power mode
  del_cylP = fc_cylP * dj_cylP * del_T * del_rh; // Load cycling mode

  if j == 1e-6 then // Start Stop mode
    del_ss = fc_ss;
    del_nomP = 0;
  else
    del_ss = 0;
    del_nomP = ((fc_hiP * dj_hiP - fc_lowP * dj_lowP) * (j - j_lowP) / (j_hiP - j_lowP)) + (fc_lowP * j_lowP);
  end if;

  del_fc = del_lowP + del_hiP + del_cylP + del_ss + del_nomP;

  when sample(0, dt) then
    FCDeg_old = pre(FCDeg_old) + del_fc;
  end when;

  connect(realExpression.y, FCDeg_new) annotation (Line(points={{35,-40},{68,-40},{68,-42},{82,-42}}, color={0,0,127}));

    annotation (
    Icon(graphics={  Bitmap(origin={-23,5},  extent = {{-97, 89}, {145, -99}}, imageSource = "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")},
    Diagram(graphics={  Bitmap(BitmapEncoder.create_png(f.read()))})));
end fd1;
