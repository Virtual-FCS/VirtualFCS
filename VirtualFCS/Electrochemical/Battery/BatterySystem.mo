within VirtualFCS.Electrochemical.Battery;

model BatterySystem
  // System
  outer Modelica.Fluid.System system "System properties";
  // Battery Pack Parameters
  parameter Real m_bat_pack(unit = "kg") = 100 "Mass of the pack";
  parameter Real L_bat_pack(unit = "m") = 0.6 "Battery pack length";
  parameter Real W_bat_pack(unit = "m") = 0.45 "Battery pack width";
  parameter Real H_bat_pack(unit = "m") = 0.1 "Battery pack height";
  parameter Real Cp_bat_pack(unit = "J/(kg.K)") = 1000 "Specific Heat Capacity";
  parameter Real V_min_bat_pack(unit = "V") = 240 "Battery pack minimum voltage";
  parameter Real V_nom_bat_pack(unit = "V") = 336 "Battery pack nominal voltage";
  parameter Real V_max_bat_pack(unit = "V") = 403.2 "Battery pack maximum voltage";
  parameter Real C_bat_pack(unit = "A.h") = 200 "Battery pack nominal capacity";
  parameter Real SOC_init = 0.5 "Battery pack initial state of charge";
  VirtualFCS.Control.BatteryManagementSystem batteryManagementSystem(N_s = batteryPack.N_s) annotation(
    Placement(visible = true, transformation(origin = {0, 30}, extent = {{-30, -20}, {30, 20}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {44, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {44, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-44, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-44, 96}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getSOC_init(y = batteryPack.SOC_init) annotation(
    Placement(visible = true, transformation(origin = {61, 40}, extent = {{19, -16}, {-19, 16}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression getChargeCapacity(y = batteryPack.C_bat_pack*3600) annotation(
    Placement(visible = true, transformation(origin = {60, 6}, extent = {{18, -16}, {-18, 16}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 298.15) annotation(
    Placement(visible = true, transformation(origin = {70, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sensorOutput annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  LiIonBatteryPack_Lumped batteryPack(C_bat_pack = C_bat_pack, Cp_bat_pack = Cp_bat_pack, H_bat_pack = H_bat_pack, L_bat_pack = L_bat_pack, SOC_init = SOC_init, V_max_bat_pack = V_max_bat_pack, V_min_bat_pack = V_min_bat_pack, V_nom_bat_pack = V_nom_bat_pack, W_bat_pack = W_bat_pack, m_bat_pack = m_bat_pack) annotation(
    Placement(visible = true, transformation(origin = {0.369106, -30.5794}, extent = {{-24.8691, -14.9215}, {24.8691, 16.5794}}, rotation = 0)));
equation
  connect(pin_n, batteryManagementSystem.pin_n_load) annotation(
    Line(points = {{-44, 96}, {-44, 96}, {-44, 80}, {-10, 80}, {-10, 48}, {-10, 48}}, color = {0, 0, 255}));
  connect(pin_p, batteryManagementSystem.pin_p_load) annotation(
    Line(points = {{44, 96}, {44, 96}, {44, 80}, {10, 80}, {10, 48}, {10, 48}}, color = {0, 0, 255}));
  connect(batteryManagementSystem.chargeCapacity, getChargeCapacity.y) annotation(
    Line(points = {{22, 24}, {31, 24}, {31, 6}, {40, 6}}, color = {0, 0, 127}));
  connect(getSOC_init.y, batteryManagementSystem.SOC_init) annotation(
    Line(points = {{40, 40}, {32, 40}, {32, 36}, {22, 36}, {22, 36}}, color = {0, 0, 127}));
  connect(batteryManagementSystem.sensorInterface, sensorOutput) annotation(
    Line(points = {{-22, 30}, {-60, 30}, {-60, 0}, {-110, 0}, {-110, 0}}, color = {0, 0, 127}));
  connect(batteryPack.heatBoundary, fixedTemperature.port) annotation(
    Line(points = {{8, -44}, {8, -44}, {8, -70}, {60, -70}, {60, -70}}, color = {191, 0, 0}));
  connect(batteryManagementSystem.pin_p_battery, batteryPack.pin_p) annotation(
    Line(points = {{10, 12}, {10, 12}, {10, 0}, {16, 0}, {16, -16}, {16, -16}}, color = {0, 0, 255}));
  connect(batteryManagementSystem.pin_n_battery, batteryPack.pin_n) annotation(
    Line(points = {{-10, 12}, {-10, 12}, {-10, 0}, {-14, 0}, {-14, -16}, {-14, -16}}, color = {0, 0, 255}));
  annotation(
    Icon(graphics = {Bitmap(origin = {-2, 2}, extent = {{-98, 98}, {102, -102}}, imageSource = "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"), Text(origin = {-6, -250}, textColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name")}),
    Documentation(info = "<html><head></head><body>




<!--[if gte mso 9]><xml>
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
   <m:mathFont m:val=\"Cambria Math\"/>
   <m:brkBin m:val=\"before\"/>
   <m:brkBinSub m:val=\"&#45;-\"/>
   <m:smallFrac m:val=\"off\"/>
   <m:dispDef/>
   <m:lMargin m:val=\"0\"/>
   <m:rMargin m:val=\"0\"/>
   <m:defJc m:val=\"centerGroup\"/>
   <m:wrapIndent m:val=\"1440\"/>
   <m:intLim m:val=\"subSup\"/>
   <m:naryLim m:val=\"undOvr\"/>
  </m:mathPr></w:WordDocument>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:LatentStyles DefLockedState=\"false\" DefUnhideWhenUsed=\"false\"
  DefSemiHidden=\"false\" DefQFormat=\"false\" DefPriority=\"99\"
  LatentStyleCount=\"376\">
  <w:LsdException Locked=\"false\" Priority=\"0\" QFormat=\"true\" Name=\"Normal\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" QFormat=\"true\" Name=\"heading 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 7\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 8\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 9\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 7\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 8\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 9\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 7\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 8\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 9\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Normal Indent\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"footnote text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"annotation text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"header\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"footer\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index heading\"/>
  <w:LsdException Locked=\"false\" Priority=\"35\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"caption\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"table of figures\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"envelope address\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"envelope return\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"footnote reference\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"annotation reference\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"line number\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"page number\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"endnote reference\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"endnote text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"table of authorities\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"macro\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"toa heading\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"10\" QFormat=\"true\" Name=\"Title\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Closing\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Signature\"/>
  <w:LsdException Locked=\"false\" Priority=\"1\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"Default Paragraph Font\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text Indent\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Message Header\"/>
  <w:LsdException Locked=\"false\" Priority=\"11\" QFormat=\"true\" Name=\"Subtitle\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Salutation\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Date\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text First Indent\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text First Indent 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Note Heading\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text Indent 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text Indent 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Block Text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Hyperlink\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"FollowedHyperlink\"/>
  <w:LsdException Locked=\"false\" Priority=\"22\" QFormat=\"true\" Name=\"Strong\"/>
  <w:LsdException Locked=\"false\" Priority=\"20\" QFormat=\"true\" Name=\"Emphasis\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Document Map\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Plain Text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"E-mail Signature\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Top of Form\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Bottom of Form\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Normal (Web)\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Acronym\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Address\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Cite\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Code\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Definition\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Keyboard\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Preformatted\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Sample\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Typewriter\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Variable\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Normal Table\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"annotation subject\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"No List\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Outline List 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Outline List 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Outline List 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Simple 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Simple 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Simple 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Colorful 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Colorful 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Colorful 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 7\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 8\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 7\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 8\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table 3D effects 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table 3D effects 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table 3D effects 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Contemporary\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Elegant\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Professional\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Subtle 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Subtle 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Web 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Web 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Web 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Balloon Text\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" Name=\"Table Grid\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Theme\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" Name=\"Placeholder Text\"/>
  <w:LsdException Locked=\"false\" Priority=\"1\" QFormat=\"true\" Name=\"No Spacing\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" Name=\"Revision\"/>
  <w:LsdException Locked=\"false\" Priority=\"34\" QFormat=\"true\"
   Name=\"List Paragraph\"/>
  <w:LsdException Locked=\"false\" Priority=\"29\" QFormat=\"true\" Name=\"Quote\"/>
  <w:LsdException Locked=\"false\" Priority=\"30\" QFormat=\"true\"
   Name=\"Intense Quote\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"19\" QFormat=\"true\"
   Name=\"Subtle Emphasis\"/>
  <w:LsdException Locked=\"false\" Priority=\"21\" QFormat=\"true\"
   Name=\"Intense Emphasis\"/>
  <w:LsdException Locked=\"false\" Priority=\"31\" QFormat=\"true\"
   Name=\"Subtle Reference\"/>
  <w:LsdException Locked=\"false\" Priority=\"32\" QFormat=\"true\"
   Name=\"Intense Reference\"/>
  <w:LsdException Locked=\"false\" Priority=\"33\" QFormat=\"true\" Name=\"Book Title\"/>
  <w:LsdException Locked=\"false\" Priority=\"37\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"Bibliography\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"TOC Heading\"/>
  <w:LsdException Locked=\"false\" Priority=\"41\" Name=\"Plain Table 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"42\" Name=\"Plain Table 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"43\" Name=\"Plain Table 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"44\" Name=\"Plain Table 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"45\" Name=\"Plain Table 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"40\" Name=\"Grid Table Light\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\" Name=\"Grid Table 1 Light\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\" Name=\"Grid Table 6 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\" Name=\"Grid Table 7 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\" Name=\"List Table 1 Light\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\" Name=\"List Table 6 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\" Name=\"List Table 7 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Mention\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Smart Hyperlink\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Hashtag\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Unresolved Mention\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Smart Link\"/>
 </w:LatentStyles>
</xml><![endif]-->

<!--[if gte mso 10]>
<style>
 /* Style Definitions */
 table.MsoNormalTable
	{mso-style-name:\"Table Normal\";
	mso-tstyle-rowband-size:0;
	mso-tstyle-colband-size:0;
	mso-style-noshow:yes;
	mso-style-priority:99;
	mso-style-parent:\"\";
	mso-padding-alt:0cm 5.4pt 0cm 5.4pt;
	mso-para-margin-top:0cm;
	mso-para-margin-right:0cm;
	mso-para-margin-bottom:8.0pt;
	mso-para-margin-left:0cm;
	line-height:107%;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:\"Calibri\",sans-serif;
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

<p class=\"MsoNormal\"><font face=\"Arial\" size=\"4\">The BatterySystem class packages together a&nbsp;</font><a href=\"modelica://VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Lumped\" style=\"font-family: Arial; font-size: large;\">lumped model of a lithium-ion battery pack</a><font face=\"Arial\" size=\"4\">&nbsp;and a&nbsp;</font><a href=\"modelica://VirtualFCS.Control.BatteryManagementSystem\" style=\"font-family: Arial; font-size: large;\">battery management system</a><font face=\"Arial\" size=\"4\">. This class can be directly integrated into a powertrain model, for example in <a href=\"modelica://VirtualFCS.Powertrains.BatteryPowerTrain\">BatteryPowerTrain</a> and <a href=\"modelica://VirtualFCS.Powertrains.RangeExtenderPowerTrain\">RangeExtenderPowerTrain</a>.<o:p></o:p></font></p>

<p class=\"MsoNormal\"><font face=\"Arial\" size=\"4\"><b><u>Related packages:</u></b><o:p></o:p></font></p><p class=\"MsoNormal\"></p><ul><li><a href=\"modelica://VirtualFCS.Electrochemical.Battery.LiIonBatteryPack_Lumped\" style=\"font-family: Arial; font-size: large;\">LiIonBatteryPack_Lumped</a></li><li><a href=\"modelica://VirtualFCS.Control.BatteryManagementSystem\" style=\"font-family: Arial; font-size: large;\">BatteryManagementSystem</a></li></ul><table border=\"0.9\"><caption align=\"Left\" style=\"text-align: left;\"><b><u><font face=\"Arial\" size=\"4\">Default Parameters</font></u></b></caption><tbody><tr><th><font face=\"Arial\" size=\"4\">Parameter name</font></th><th><font face=\"Arial\" size=\"4\">Value</font></th><th><font face=\"Arial\" size=\"4\">Unit</font></th></tr><tr><td align=\"Left\"><font face=\"Arial\" size=\"4\">m_bat_pack</font></td><td><font face=\"Arial\" size=\"4\">=100</font></td><td align=\"Right\"><font face=\"Arial\" size=\"4\">kg<br></font></td></tr><tr><td align=\"Left\"><font face=\"Arial\" size=\"4\">L_bat_pack</font></td><td><font face=\"Arial\" size=\"4\">=0.6</font></td><td align=\"Right\"><font face=\"Arial\" size=\"4\">m</font></td></tr><tr><td align=\"Left\"><font face=\"Arial\" size=\"4\">W_bat_pack</font></td><td><font face=\"Arial\" size=\"4\">=0.45</font></td><td align=\"Right\"><font face=\"Arial\" size=\"4\">m</font></td></tr><tr><td align=\"Left\"><font face=\"Arial\" size=\"4\">H_bat_pack</font></td><td><font face=\"Arial\" size=\"4\">=0.1</font></td><td align=\"Right\"><font face=\"Arial\" size=\"4\">m</font></td></tr><tr><td align=\"Left\"><font face=\"Arial\" size=\"4\">Cp</font></td><td><font face=\"Arial\" size=\"4\">=1000</font></td><td align=\"Right\"><font face=\"Arial\" size=\"4\">J/(kg.K)</font></td></tr><tr><td align=\"Left\"><font face=\"Arial\" size=\"4\">V_min_bat_pack</font></td><td><font face=\"Arial\" size=\"4\">=240</font></td><td align=\"Right\"><font face=\"Arial\" size=\"4\">V</font></td></tr><tr><td align=\"Left\"><font face=\"Arial\" size=\"4\">V_nom_bat_pack</font></td><td><font face=\"Arial\" size=\"4\">=336</font></td><td align=\"Right\"><font face=\"Arial\" size=\"4\">V</font></td></tr><tr><td align=\"Left\"><font face=\"Arial\" size=\"4\">V_max_bat_pack</font></td><td><font face=\"Arial\" size=\"4\">=403.2</font></td><td align=\"Right\"><font face=\"Arial\" size=\"4\">V</font></td></tr><tr><td align=\"Left\"><font face=\"Arial\" size=\"4\">C_bat_pack</font></td><td><font face=\"Arial\" size=\"4\">=200</font></td><td align=\"Right\"><font face=\"Arial\" size=\"4\">Ah</font></td></tr><tr><td align=\"Left\"><font face=\"Arial\" size=\"4\">SOC_init</font></td><td><font face=\"Arial\" size=\"4\">=0.5</font></td><td align=\"Right\"><font face=\"Arial\" size=\"4\">-</font></td></tr></tbody></table>

<!--EndFragment--></body></html>"));
end BatterySystem;
