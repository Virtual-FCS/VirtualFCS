within VirtualFCS.Electrochemical.Battery;
model BatterySystem
  // System
  outer Modelica.Fluid.System system "System properties";
  // Battery Pack Parameters
  parameter Modelica.Units.SI.Mass m_bat_pack = 100 "Mass of the pack";
  parameter Modelica.Units.SI.Length L_bat_pack = 0.6 "Battery pack length";
  parameter Modelica.Units.SI.Breadth W_bat_pack = 0.45 "Battery pack width";
  parameter Modelica.Units.SI.Height H_bat_pack = 0.1 "Battery pack height";
  parameter Modelica.Units.SI.SpecificHeatCapacity Cp_bat_pack = 1000 "Specific Heat Capacity";
  parameter Modelica.Units.SI.Voltage V_min_bat_pack = 240 "Battery pack minimum voltage";
  parameter Modelica.Units.SI.Voltage V_nom_bat_pack = 336 "Battery pack nominal voltage";
  parameter Modelica.Units.SI.Voltage V_max_bat_pack = 403.2 "Battery pack maximum voltage";
  parameter Modelica.Units.NonSI.ElectricCharge_Ah C_bat_pack = 200 "Battery pack nominal capacity";
  parameter Real SOC_init = 0.5 "Battery pack initial state of charge";
  // Power & efficiencies
  Modelica.Units.SI.Power Power = pin_p.i*pin_p.v "Battery delivered power";
  Modelica.Units.SI.Efficiency eta_batt "Battery efficiency, calculated by assuming loss in terms of heat";
  VirtualFCS.Control.BatteryManagementSystem batteryManagementSystem(N_s = batteryPack.N_s) annotation (
    Placement(visible = true, transformation(origin = {0, 30}, extent = {{-30, -20}, {30, 20}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
    Placement(visible = true, transformation(origin = {44, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {44, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
    Placement(visible = true, transformation(origin = {-44, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-44, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = batteryPack.SOC_init) annotation (
    Placement(visible = true, transformation(origin = {61, 40}, extent = {{19, -16}, {-19, 16}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = batteryPack.C_bat_pack*3600) annotation (
    Placement(visible = true, transformation(origin = {60, 6}, extent = {{18, -16}, {-18, 16}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 298.15) annotation (
    Placement(visible = true, transformation(origin = {70, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sensorOutput annotation (
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  LiIonBatteryPack_Lumped batteryPack(C_bat_pack = C_bat_pack, Cp_bat_pack = Cp_bat_pack, H_bat_pack = H_bat_pack, L_bat_pack = L_bat_pack, SOC_init = SOC_init, V_max_bat_pack = V_max_bat_pack, V_min_bat_pack = V_min_bat_pack, V_nom_bat_pack = V_nom_bat_pack, W_bat_pack = W_bat_pack, m_bat_pack = m_bat_pack) annotation (
    Placement(visible = true, transformation(origin = {0.369106, -30.5794}, extent = {{-24.8691, -14.9215}, {24.8691, 16.5794}}, rotation = 0)));
equation
  eta_batt = max((abs(Power)-(batteryPack.heatSource.Q_flow))/(max(abs(Power), 0.00001)), 0.9);
  connect(pin_n, batteryManagementSystem.pin_n_load) annotation (
    Line(points = {{-44, 96}, {-44, 96}, {-44, 80}, {-10, 80}, {-10, 48}, {-10, 48}}, color = {0, 0, 255}));
  connect(pin_p, batteryManagementSystem.pin_p_load) annotation (
    Line(points = {{44, 96}, {44, 96}, {44, 80}, {10, 80}, {10, 48}, {10, 48}}, color = {0, 0, 255}));
  connect(batteryManagementSystem.chargeCapacity, getChargeCapacity.y) annotation (
    Line(points={{22,24},{31,24},{31,6},{40.2,6}},        color = {0, 0, 127}));
  connect(getSOC_init.y, batteryManagementSystem.SOC_init) annotation (
    Line(points={{40.1,40},{32,40},{32,36},{22,36},{22,36}},          color = {0, 0, 127}));
  connect(batteryManagementSystem.sensorInterface, sensorOutput) annotation (
    Line(points = {{-22, 30}, {-60, 30}, {-60, 0}, {-110, 0}, {-110, 0}}, color = {0, 0, 127}));
  connect(batteryPack.heatBoundary, fixedTemperature.port) annotation (
    Line(points={{8.65881,-43.843},{8.65881,-43.843},{8.65881,-70},{60,-70},{60,
          -70}},                                                        color = {191, 0, 0}));
  connect(batteryManagementSystem.pin_p_battery, batteryPack.pin_p) annotation (
    Line(points={{10,12},{10,12},{10,0},{16,0},{16,-15.6579},{15.2906,-15.6579}},
                                                                                color = {0, 0, 255}));
  connect(batteryManagementSystem.pin_n_battery, batteryPack.pin_n) annotation (
    Line(points={{-10,12},{-10,12},{-10,0},{-14,0},{-14,-15.6579},{-14.5524,
          -15.6579}},                                                                 color = {0, 0, 255}));
  annotation (
    Icon(graphics={   Rectangle(fillColor = {0, 60, 101}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}, radius = 35), Polygon(origin = {-33, -2}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{29, 38}, {29, 28}, {-19, 28}, {-19, -28}, {25, -28}, {29, -38}, {-21, -38}, {-29, -30}, {-29, 28}, {-21, 38}, {-5, 38}, {29, 38}}), Ellipse(origin = {-53, 27}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-9, -9}, {9, 9}}, startAngle = 30, endAngle = 200, closure = EllipseClosure.Chord), Ellipse(origin = {-53, -31}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-9, -9}, {9, 9}}, startAngle = 160, endAngle = 330, closure = EllipseClosure.Chord), Polygon(origin = {3, 0}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{0, 50}, {24, -3.5}, {3.5, -3.5}, {3.5, -50}, {-22, 12.5}, {0, 12.5}, {0, 50}, {0, 50}}), Polygon(origin = {44, -2}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-28, 38}, {12, 38}, {20, 32}, {20, 14.5}, {26, 14.5}, {32.5, 8}, {32.5, -8}, {26, -14}, {20, -14}, {20, -32}, {14, -37.5}, {-31.5, -37.5}, {-31.5, -28}, {10.5, -28}, {10.5, 28}, {-24, 28}, {-28, 38}, {-28, 38}}), Ellipse(origin = {57, 29}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-7, -7}, {7, 7}}, startAngle = -10, endAngle = 170, closure = EllipseClosure.Chord), Ellipse(origin = {69.5, 5.5}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-7, -7}, {7, 7}}, startAngle = -10, endAngle = 170, closure = EllipseClosure.Chord), Ellipse(origin = {69.5, -9}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-7, -7}, {7, 7}}, startAngle = 180, endAngle = 370, closure = EllipseClosure.Chord), Ellipse(origin = {57, -32.5}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-7, -7}, {7, 7}}, startAngle = 180, endAngle = 370, closure = EllipseClosure.Chord)}),
    Documentation(info = "<html><head></head><body><h2>1. Parameters and inputs</h2><p>Parameters, signal inputs, and physical input-side interfaces are listed below.&nbsp;</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Type</th><th>Unit</th><th>Default</th><th>Description</th></tr><tr><td><code>m_bat_pack</code></td><td>SI.Mass</td><td>kg</td><td>100</td><td>Mass of the pack</td></tr>
<tr><td><code>L_bat_pack</code></td><td>SI.Length</td><td>m</td><td>0.6</td><td>Battery pack length</td></tr>
<tr><td><code>W_bat_pack</code></td><td>SI.Breadth</td><td>m</td><td>0.45</td><td>Battery pack width</td></tr>
<tr><td><code>H_bat_pack</code></td><td>SI.Height</td><td>m</td><td>0.1</td><td>Battery pack height</td></tr>
<tr><td><code>Cp_bat_pack</code></td><td>SI.SpecificHeatCapacity</td><td>J/(kg.K)</td><td>1000</td><td>Specific Heat Capacity</td></tr>
<tr><td><code>V_min_bat_pack</code></td><td>SI.Voltage</td><td>V</td><td>240</td><td>Battery pack minimum voltage</td></tr>
<tr><td><code>V_nom_bat_pack</code></td><td>SI.Voltage</td><td>V</td><td>336</td><td>Battery pack nominal voltage</td></tr>
<tr><td><code>V_max_bat_pack</code></td><td>SI.Voltage</td><td>V</td><td>403.2</td><td>Battery pack maximum voltage</td></tr>
<tr><td><code>C_bat_pack</code></td><td>NonSI.ElectricCharge_Ah</td><td>Ah</td><td>200</td><td>Battery pack nominal capacity</td></tr>
<tr><td><code>SOC_init</code></td><td>Real</td><td>1</td><td>0.5</td><td>Battery pack initial state of charge</td></tr></tbody></table><h3>Inputs and input-side interfaces</h3><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>pin_p</code></td><td>Input-side interface</td><td>PositivePin</td><td>-</td><td></td></tr></tbody></table><h2>2. Model description</h2><!--[if gte mso 9]><xml>
 <o:OfficeDocumentSettings>
  <o:AllowPNG/>
 </o:OfficeDocumentSettings>
</xml><![endif]-->


<!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:View>Normal</w:View>
  <w:Zoom>0</w:Zoom>
  <w:TrackMoves/>
  <w:TrackFormatting/>
  <w:PunctuationKerning/>
  <w:ValidateAgainstSchemas/>
  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>
  <w:IgnoreMixedContent>false</w:IgnoreMixedContent>
  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>
  <w:DoNotPromoteQF/>
  <w:LidThemeOther>NO-BOK</w:LidThemeOther>
  <w:LidThemeAsian>JA</w:LidThemeAsian>
  <w:LidThemeComplexScript>AR-SA</w:LidThemeComplexScript>
  <w:Compatibility>
   <w:BreakWrappedTables/>
   <w:SnapToGridInCell/>
   <w:WrapTextWithPunct/>
   <w:UseAsianBreakRules/>
   <w:DontGrowAutofit/>
   <w:SplitPgBreakAndParaMark/>
   <w:EnableOpenTypeKerning/>
   <w:DontFlipMirrorIndents/>
   <w:OverrideTableStyleHps/>
  </w:Compatibility>
  <m:mathPr>
   <m:mathFont m:val=&quot;Cambria Math&quot;/>
   <m:brkBin m:val=&quot;before&quot;/>
   <m:brkBinSub m:val=&quot;&#45;-&quot;/>
   <m:smallFrac m:val=&quot;off&quot;/>
   <m:dispDef/>
   <m:lMargin m:val=&quot;0&quot;/>
   <m:rMargin m:val=&quot;0&quot;/>
   <m:defJc m:val=&quot;centerGroup&quot;/>
   <m:wrapIndent m:val=&quot;1440&quot;/>
   <m:intLim m:val=&quot;subSup&quot;/>
   <m:naryLim m:val=&quot;undOvr&quot;/>
  </m:mathPr></w:WordDocument>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:LatentStyles DefLockedState=&quot;false&quot; DefUnhideWhenUsed=&quot;false&quot;
  DefSemiHidden=&quot;false&quot; DefQFormat=&quot;false&quot; DefPriority=&quot;99&quot;
  LatentStyleCount=&quot;376&quot;>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;0&quot; QFormat=&quot;true&quot; Name=&quot;Normal&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;9&quot; QFormat=&quot;true&quot; Name=&quot;heading 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;9&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; QFormat=&quot;true&quot; Name=&quot;heading 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;9&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; QFormat=&quot;true&quot; Name=&quot;heading 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;9&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; QFormat=&quot;true&quot; Name=&quot;heading 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;9&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; QFormat=&quot;true&quot; Name=&quot;heading 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;9&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; QFormat=&quot;true&quot; Name=&quot;heading 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;9&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; QFormat=&quot;true&quot; Name=&quot;heading 7&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;9&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; QFormat=&quot;true&quot; Name=&quot;heading 8&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;9&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; QFormat=&quot;true&quot; Name=&quot;heading 9&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;index 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;index 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;index 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;index 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;index 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;index 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;index 7&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;index 8&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;index 9&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;39&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; Name=&quot;toc 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;39&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; Name=&quot;toc 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;39&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; Name=&quot;toc 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;39&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; Name=&quot;toc 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;39&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; Name=&quot;toc 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;39&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; Name=&quot;toc 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;39&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; Name=&quot;toc 7&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;39&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; Name=&quot;toc 8&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;39&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; Name=&quot;toc 9&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Normal Indent&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;footnote text&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;annotation text&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;header&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;footer&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;index heading&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;35&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; QFormat=&quot;true&quot; Name=&quot;caption&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;table of figures&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;envelope address&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;envelope return&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;footnote reference&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;annotation reference&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;line number&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;page number&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;endnote reference&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;endnote text&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;table of authorities&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;macro&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;toa heading&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List Bullet&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List Number&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List Bullet 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List Bullet 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List Bullet 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List Bullet 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List Number 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List Number 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List Number 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List Number 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;10&quot; QFormat=&quot;true&quot; Name=&quot;Title&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Closing&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Signature&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;1&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; Name=&quot;Default Paragraph Font&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Body Text&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Body Text Indent&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List Continue&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List Continue 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List Continue 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List Continue 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;List Continue 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Message Header&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;11&quot; QFormat=&quot;true&quot; Name=&quot;Subtitle&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Salutation&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Date&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Body Text First Indent&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Body Text First Indent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Note Heading&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Body Text 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Body Text 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Body Text Indent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Body Text Indent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Block Text&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Hyperlink&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;FollowedHyperlink&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;22&quot; QFormat=&quot;true&quot; Name=&quot;Strong&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;20&quot; QFormat=&quot;true&quot; Name=&quot;Emphasis&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Document Map&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Plain Text&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;E-mail Signature&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;HTML Top of Form&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;HTML Bottom of Form&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Normal (Web)&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;HTML Acronym&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;HTML Address&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;HTML Cite&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;HTML Code&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;HTML Definition&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;HTML Keyboard&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;HTML Preformatted&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;HTML Sample&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;HTML Typewriter&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;HTML Variable&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Normal Table&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;annotation subject&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;No List&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Outline List 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Outline List 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Outline List 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Simple 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Simple 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Simple 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Classic 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Classic 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Classic 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Classic 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Colorful 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Colorful 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Colorful 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Columns 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Columns 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Columns 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Columns 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Columns 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Grid 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Grid 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Grid 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Grid 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Grid 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Grid 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Grid 7&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Grid 8&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table List 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table List 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table List 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table List 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table List 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table List 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table List 7&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table List 8&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table 3D effects 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table 3D effects 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table 3D effects 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Contemporary&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Elegant&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Professional&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Subtle 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Subtle 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Web 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Web 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Web 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Balloon Text&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;39&quot; Name=&quot;Table Grid&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Table Theme&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; Name=&quot;Placeholder Text&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;1&quot; QFormat=&quot;true&quot; Name=&quot;No Spacing&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;60&quot; Name=&quot;Light Shading&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;61&quot; Name=&quot;Light List&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;62&quot; Name=&quot;Light Grid&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;63&quot; Name=&quot;Medium Shading 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;64&quot; Name=&quot;Medium Shading 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;65&quot; Name=&quot;Medium List 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;66&quot; Name=&quot;Medium List 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;67&quot; Name=&quot;Medium Grid 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;68&quot; Name=&quot;Medium Grid 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;69&quot; Name=&quot;Medium Grid 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;70&quot; Name=&quot;Dark List&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;71&quot; Name=&quot;Colorful Shading&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;72&quot; Name=&quot;Colorful List&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;73&quot; Name=&quot;Colorful Grid&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;60&quot; Name=&quot;Light Shading Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;61&quot; Name=&quot;Light List Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;62&quot; Name=&quot;Light Grid Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;63&quot; Name=&quot;Medium Shading 1 Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;64&quot; Name=&quot;Medium Shading 2 Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;65&quot; Name=&quot;Medium List 1 Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; Name=&quot;Revision&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;34&quot; QFormat=&quot;true&quot;
   Name=&quot;List Paragraph&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;29&quot; QFormat=&quot;true&quot; Name=&quot;Quote&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;30&quot; QFormat=&quot;true&quot;
   Name=&quot;Intense Quote&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;66&quot; Name=&quot;Medium List 2 Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;67&quot; Name=&quot;Medium Grid 1 Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;68&quot; Name=&quot;Medium Grid 2 Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;69&quot; Name=&quot;Medium Grid 3 Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;70&quot; Name=&quot;Dark List Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;71&quot; Name=&quot;Colorful Shading Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;72&quot; Name=&quot;Colorful List Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;73&quot; Name=&quot;Colorful Grid Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;60&quot; Name=&quot;Light Shading Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;61&quot; Name=&quot;Light List Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;62&quot; Name=&quot;Light Grid Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;63&quot; Name=&quot;Medium Shading 1 Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;64&quot; Name=&quot;Medium Shading 2 Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;65&quot; Name=&quot;Medium List 1 Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;66&quot; Name=&quot;Medium List 2 Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;67&quot; Name=&quot;Medium Grid 1 Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;68&quot; Name=&quot;Medium Grid 2 Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;69&quot; Name=&quot;Medium Grid 3 Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;70&quot; Name=&quot;Dark List Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;71&quot; Name=&quot;Colorful Shading Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;72&quot; Name=&quot;Colorful List Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;73&quot; Name=&quot;Colorful Grid Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;60&quot; Name=&quot;Light Shading Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;61&quot; Name=&quot;Light List Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;62&quot; Name=&quot;Light Grid Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;63&quot; Name=&quot;Medium Shading 1 Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;64&quot; Name=&quot;Medium Shading 2 Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;65&quot; Name=&quot;Medium List 1 Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;66&quot; Name=&quot;Medium List 2 Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;67&quot; Name=&quot;Medium Grid 1 Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;68&quot; Name=&quot;Medium Grid 2 Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;69&quot; Name=&quot;Medium Grid 3 Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;70&quot; Name=&quot;Dark List Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;71&quot; Name=&quot;Colorful Shading Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;72&quot; Name=&quot;Colorful List Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;73&quot; Name=&quot;Colorful Grid Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;60&quot; Name=&quot;Light Shading Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;61&quot; Name=&quot;Light List Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;62&quot; Name=&quot;Light Grid Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;63&quot; Name=&quot;Medium Shading 1 Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;64&quot; Name=&quot;Medium Shading 2 Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;65&quot; Name=&quot;Medium List 1 Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;66&quot; Name=&quot;Medium List 2 Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;67&quot; Name=&quot;Medium Grid 1 Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;68&quot; Name=&quot;Medium Grid 2 Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;69&quot; Name=&quot;Medium Grid 3 Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;70&quot; Name=&quot;Dark List Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;71&quot; Name=&quot;Colorful Shading Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;72&quot; Name=&quot;Colorful List Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;73&quot; Name=&quot;Colorful Grid Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;60&quot; Name=&quot;Light Shading Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;61&quot; Name=&quot;Light List Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;62&quot; Name=&quot;Light Grid Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;63&quot; Name=&quot;Medium Shading 1 Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;64&quot; Name=&quot;Medium Shading 2 Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;65&quot; Name=&quot;Medium List 1 Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;66&quot; Name=&quot;Medium List 2 Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;67&quot; Name=&quot;Medium Grid 1 Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;68&quot; Name=&quot;Medium Grid 2 Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;69&quot; Name=&quot;Medium Grid 3 Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;70&quot; Name=&quot;Dark List Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;71&quot; Name=&quot;Colorful Shading Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;72&quot; Name=&quot;Colorful List Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;73&quot; Name=&quot;Colorful Grid Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;60&quot; Name=&quot;Light Shading Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;61&quot; Name=&quot;Light List Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;62&quot; Name=&quot;Light Grid Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;63&quot; Name=&quot;Medium Shading 1 Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;64&quot; Name=&quot;Medium Shading 2 Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;65&quot; Name=&quot;Medium List 1 Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;66&quot; Name=&quot;Medium List 2 Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;67&quot; Name=&quot;Medium Grid 1 Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;68&quot; Name=&quot;Medium Grid 2 Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;69&quot; Name=&quot;Medium Grid 3 Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;70&quot; Name=&quot;Dark List Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;71&quot; Name=&quot;Colorful Shading Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;72&quot; Name=&quot;Colorful List Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;73&quot; Name=&quot;Colorful Grid Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;19&quot; QFormat=&quot;true&quot;
   Name=&quot;Subtle Emphasis&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;21&quot; QFormat=&quot;true&quot;
   Name=&quot;Intense Emphasis&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;31&quot; QFormat=&quot;true&quot;
   Name=&quot;Subtle Reference&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;32&quot; QFormat=&quot;true&quot;
   Name=&quot;Intense Reference&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;33&quot; QFormat=&quot;true&quot; Name=&quot;Book Title&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;37&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; Name=&quot;Bibliography&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;39&quot; SemiHidden=&quot;true&quot;
   UnhideWhenUsed=&quot;true&quot; QFormat=&quot;true&quot; Name=&quot;TOC Heading&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;41&quot; Name=&quot;Plain Table 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;42&quot; Name=&quot;Plain Table 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;43&quot; Name=&quot;Plain Table 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;44&quot; Name=&quot;Plain Table 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;45&quot; Name=&quot;Plain Table 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;40&quot; Name=&quot;Grid Table Light&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;46&quot; Name=&quot;Grid Table 1 Light&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;47&quot; Name=&quot;Grid Table 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;48&quot; Name=&quot;Grid Table 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;49&quot; Name=&quot;Grid Table 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;50&quot; Name=&quot;Grid Table 5 Dark&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;51&quot; Name=&quot;Grid Table 6 Colorful&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;52&quot; Name=&quot;Grid Table 7 Colorful&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;46&quot;
   Name=&quot;Grid Table 1 Light Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;47&quot; Name=&quot;Grid Table 2 Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;48&quot; Name=&quot;Grid Table 3 Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;49&quot; Name=&quot;Grid Table 4 Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;50&quot; Name=&quot;Grid Table 5 Dark Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;51&quot;
   Name=&quot;Grid Table 6 Colorful Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;52&quot;
   Name=&quot;Grid Table 7 Colorful Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;46&quot;
   Name=&quot;Grid Table 1 Light Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;47&quot; Name=&quot;Grid Table 2 Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;48&quot; Name=&quot;Grid Table 3 Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;49&quot; Name=&quot;Grid Table 4 Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;50&quot; Name=&quot;Grid Table 5 Dark Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;51&quot;
   Name=&quot;Grid Table 6 Colorful Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;52&quot;
   Name=&quot;Grid Table 7 Colorful Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;46&quot;
   Name=&quot;Grid Table 1 Light Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;47&quot; Name=&quot;Grid Table 2 Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;48&quot; Name=&quot;Grid Table 3 Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;49&quot; Name=&quot;Grid Table 4 Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;50&quot; Name=&quot;Grid Table 5 Dark Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;51&quot;
   Name=&quot;Grid Table 6 Colorful Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;52&quot;
   Name=&quot;Grid Table 7 Colorful Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;46&quot;
   Name=&quot;Grid Table 1 Light Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;47&quot; Name=&quot;Grid Table 2 Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;48&quot; Name=&quot;Grid Table 3 Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;49&quot; Name=&quot;Grid Table 4 Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;50&quot; Name=&quot;Grid Table 5 Dark Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;51&quot;
   Name=&quot;Grid Table 6 Colorful Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;52&quot;
   Name=&quot;Grid Table 7 Colorful Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;46&quot;
   Name=&quot;Grid Table 1 Light Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;47&quot; Name=&quot;Grid Table 2 Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;48&quot; Name=&quot;Grid Table 3 Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;49&quot; Name=&quot;Grid Table 4 Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;50&quot; Name=&quot;Grid Table 5 Dark Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;51&quot;
   Name=&quot;Grid Table 6 Colorful Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;52&quot;
   Name=&quot;Grid Table 7 Colorful Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;46&quot;
   Name=&quot;Grid Table 1 Light Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;47&quot; Name=&quot;Grid Table 2 Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;48&quot; Name=&quot;Grid Table 3 Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;49&quot; Name=&quot;Grid Table 4 Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;50&quot; Name=&quot;Grid Table 5 Dark Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;51&quot;
   Name=&quot;Grid Table 6 Colorful Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;52&quot;
   Name=&quot;Grid Table 7 Colorful Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;46&quot; Name=&quot;List Table 1 Light&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;47&quot; Name=&quot;List Table 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;48&quot; Name=&quot;List Table 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;49&quot; Name=&quot;List Table 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;50&quot; Name=&quot;List Table 5 Dark&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;51&quot; Name=&quot;List Table 6 Colorful&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;52&quot; Name=&quot;List Table 7 Colorful&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;46&quot;
   Name=&quot;List Table 1 Light Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;47&quot; Name=&quot;List Table 2 Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;48&quot; Name=&quot;List Table 3 Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;49&quot; Name=&quot;List Table 4 Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;50&quot; Name=&quot;List Table 5 Dark Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;51&quot;
   Name=&quot;List Table 6 Colorful Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;52&quot;
   Name=&quot;List Table 7 Colorful Accent 1&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;46&quot;
   Name=&quot;List Table 1 Light Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;47&quot; Name=&quot;List Table 2 Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;48&quot; Name=&quot;List Table 3 Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;49&quot; Name=&quot;List Table 4 Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;50&quot; Name=&quot;List Table 5 Dark Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;51&quot;
   Name=&quot;List Table 6 Colorful Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;52&quot;
   Name=&quot;List Table 7 Colorful Accent 2&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;46&quot;
   Name=&quot;List Table 1 Light Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;47&quot; Name=&quot;List Table 2 Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;48&quot; Name=&quot;List Table 3 Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;49&quot; Name=&quot;List Table 4 Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;50&quot; Name=&quot;List Table 5 Dark Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;51&quot;
   Name=&quot;List Table 6 Colorful Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;52&quot;
   Name=&quot;List Table 7 Colorful Accent 3&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;46&quot;
   Name=&quot;List Table 1 Light Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;47&quot; Name=&quot;List Table 2 Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;48&quot; Name=&quot;List Table 3 Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;49&quot; Name=&quot;List Table 4 Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;50&quot; Name=&quot;List Table 5 Dark Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;51&quot;
   Name=&quot;List Table 6 Colorful Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;52&quot;
   Name=&quot;List Table 7 Colorful Accent 4&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;46&quot;
   Name=&quot;List Table 1 Light Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;47&quot; Name=&quot;List Table 2 Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;48&quot; Name=&quot;List Table 3 Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;49&quot; Name=&quot;List Table 4 Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;50&quot; Name=&quot;List Table 5 Dark Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;51&quot;
   Name=&quot;List Table 6 Colorful Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;52&quot;
   Name=&quot;List Table 7 Colorful Accent 5&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;46&quot;
   Name=&quot;List Table 1 Light Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;47&quot; Name=&quot;List Table 2 Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;48&quot; Name=&quot;List Table 3 Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;49&quot; Name=&quot;List Table 4 Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;50&quot; Name=&quot;List Table 5 Dark Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;51&quot;
   Name=&quot;List Table 6 Colorful Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; Priority=&quot;52&quot;
   Name=&quot;List Table 7 Colorful Accent 6&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Mention&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Smart Hyperlink&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Hashtag&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Unresolved Mention&quot;/>
  <w:LsdException Locked=&quot;false&quot; SemiHidden=&quot;true&quot; UnhideWhenUsed=&quot;true&quot;
   Name=&quot;Smart Link&quot;/>
 </w:LatentStyles>
</xml><![endif]-->

<!--[if gte mso 10]>
<style>
 /* Style Definitions */
 table.MsoNormalTable
	{mso-style-name:&quot;Table Normal&quot;;
	mso-tstyle-rowband-size:0;
	mso-tstyle-colband-size:0;
	mso-style-noshow:yes;
	mso-style-priority:99;
	mso-style-parent:&quot;&quot;;
	mso-padding-alt:0cm 5.4pt 0cm 5.4pt;
	mso-para-margin-top:0cm;
	mso-para-margin-right:0cm;
	mso-para-margin-bottom:8.0pt;
	mso-para-margin-left:0cm;
	line-height:107%;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:&quot;Calibri&quot;,sans-serif;
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;
	mso-bidi-font-family:Arial;
	mso-bidi-theme-font:minor-bidi;
	mso-ansi-language:NO-BOK;
	mso-fareast-language:EN-US;}
</style>
<![endif]-->



<!--StartFragment-->

<p class=\"&quot;MsoNormal&quot;\"><font face=\"&quot;Arial&quot;\" size=\"&quot;4&quot;\">The BatterySystem class packages together a&nbsp;</font><a href=\"&quot;modelica://VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Lumped&quot;\" style=\"&quot;font-family:\" arial;=\"\" font-size:=\"\" large;&quot;=\"\">lumped model of a lithium-ion battery pack</a><font face=\"&quot;Arial&quot;\" size=\"&quot;4&quot;\">&nbsp;and a&nbsp;</font><a href=\"&quot;modelica://VirtualFCS.Control.BatteryManagementSystem&quot;\" style=\"&quot;font-family:\" arial;=\"\" font-size:=\"\" large;&quot;=\"\">battery management system</a><font face=\"&quot;Arial&quot;\" size=\"&quot;4&quot;\">. This class can be directly integrated into a powertrain model, for example in <a href=\"&quot;modelica://VirtualFCS.Powertrains.BatteryPowertrain&quot;\">BatteryPowertrain</a> and <a href=\"&quot;modelica://VirtualFCS.Powertrains.RangeExtenderPowertrain&quot;\">RangeExtenderPowertrain</a>.</font></p>

<!--EndFragment--><h2>3. Governing equations and references</h2><p>The following representative equations are implemented directly. Equations inherited through <code>extends</code> and component connections also contribute to the complete model balance.</p><pre>eta_batt = max((abs(Power)-(batteryPack.heatSource.Q_flow))/(max(abs(Power), 0.00001)), 0.9);</pre><h2>4. Outputs</h2><p>Declared signal outputs and output-side physical interfaces are listed below.</p><table border=\"&quot;1&quot;\" cellspacing=\"&quot;0&quot;\" cellpadding=\"&quot;4&quot;\"><tbody><tr><th>Name</th><th>Direction</th><th>Interface</th><th>Unit</th><th>Description</th></tr><tr><td><code>pin_n</code></td><td>Output-side interface</td><td>NegativePin</td><td>-</td><td></td></tr>
<tr><td><code>sensorOutput</code></td><td>Output</td><td>RealOutput</td><td>-</td><td></td></tr></tbody></table></body></html>"));
end BatterySystem;
