within VirtualFCS.Fluid;

model CompressorMap "Compressor whose pressure ratio and efficiency come from a CSV performance map"
  extends VirtualFCS.Fluid.CompressorInterface(useHeatPort = true);
  import Modelica.Constants.eps;
  import Modelica.Units.Conversions.from_rpm;
  import Modelica.Math.Vectors.interpolate;

  parameter String mapFileName = Modelica.Utilities.Files.loadResource("modelica://VirtualFCS/Resources/CompressorMaps/compressor_map.csv") "Compressor map file: header row + columns RPM, MassFlow_kg_s, PressureRatio, Isentropic_Efficiency" annotation(
    Dialog(loadSelector(filter = "Comma-separated values (*.csv)", caption = "Select compressor map file")));
  parameter Integer speedLines(min = 2) = 6 "Number of distinct speed lines in the map";
  parameter Integer pointsPerLine(min = 2) = 7 "Number of operating points per speed line";
  parameter Modelica.Units.SI.Efficiency eta_min = 0.05 "Lower bound on the map efficiency used in the outlet enthalpy";
  parameter Modelica.Units.SI.MassFlowRate m_flow_surge_min = 1e-3 "Threshold below which surge/choke warnings are suppressed";
  
  Modelica.Units.SI.MassFlowRate m_flow(min = 0, start = 1e-4) "Mass flow through the unit";
  Real p_ratio_map(min = 1, start = 1.5) = max(interpolate(m_flow_line, p_ratio_line, m_flow), 1) "Operating pressure ratio read from the map";
  Real p_ratio_dyn(min = 1, start = 1) "Delivered pressure ratio, a first-order lag toward the map value";
  Modelica.Units.SI.Efficiency eta = max(interpolate(m_flow_line, eta_line, m_flow), eta_min) "Operating isentropic efficiency read from the map";
  Modelica.Units.SI.MassFlowRate m_flow_surge = m_flow_line[1] "Surge-line (minimum) mass flow at the current speed";
  Modelica.Units.SI.MassFlowRate m_flow_choke = m_flow_line[end] "Choke-line (maximum) mass flow at the current speed";
  Real surgeMargin = (m_flow - m_flow_surge)/max(m_flow_surge, eps) "Relative distance to the surge line, negative when surging";
  Boolean surging = m_flow < m_flow_surge "True while operating left of the surge line";
  Boolean choking = m_flow > m_flow_choke "True while operating right of the choke line";
  Modelica.Units.SI.EnthalpyFlowRate Hin = port_a.m_flow*inStream(port_a.h_outflow) "Enthalpy inflow at inlet";
  Modelica.Units.SI.EnthalpyFlowRate Hout = port_b.m_flow*port_b.h_outflow "Enthalpy inflow at outlet (mind the sign)";
  Modelica.Units.SI.Power P_shaft = -(Hin + Hout) + lossPower "Aerodynamic power the shaft must deliver at this operating point";

  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 1e-4) annotation(
    Placement(transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sensors.MultiSensor sensor annotation(
    Placement(transformation(origin = {-28, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(transformation(origin = {10, -20}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
protected
  parameter Modelica.Units.SI.Time p_ratio_map_relax(min = 0) = 1e-3 "Relaxation time constant";
  parameter Modelica.Units.SI.AngularVelocity w_grid[speedLines](each fixed = false) "Speed identifying each map line";
  parameter Modelica.Units.SI.MassFlowRate m_flow_grid[speedLines, pointsPerLine](each fixed = false) "Mass flow of every map point";
  parameter Real p_ratio_grid[speedLines, pointsPerLine](each fixed = false) "Pressure ratio of every map point";
  parameter Modelica.Units.SI.Efficiency eta_grid[speedLines, pointsPerLine](each fixed = false) "Isentropic efficiency of every map point";

  Medium.ThermodynamicState state_in = Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow));
  Medium.ThermodynamicState state_out = Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow);
  Modelica.Units.SI.SpecificEnthalpy dh_is = Medium.isentropicEnthalpy(port_b.p, state_in) - inStream(port_a.h_outflow) "Isentropic enthalpy rise";
  
  // Slice of the map at the current speed (one value per operating point)
  Modelica.Units.SI.AngularVelocity w_lim = min(max(sensor.w, min(w_grid)), max(w_grid)) "Speed clamped within map range";
  Modelica.Units.SI.MassFlowRate m_flow_line[pointsPerLine] = {interpolate(w_grid, m_flow_grid[:, j], w_lim) for j} "Map mass flow at the current speed";
  Real p_ratio_line[pointsPerLine] = {interpolate(w_grid, p_ratio_grid[:, j], w_lim) for j} "Map pressure ratio at the current speed";
  Modelica.Units.SI.Efficiency eta_line[pointsPerLine] = {interpolate(w_grid, eta_grid[:, j], w_lim) for j} "Map efficiency at the current speed";

  impure function readMap "Parse a compressor map CSV file into speed, mass-flow, pressure-ratio and efficiency arrays"
    extends Modelica.Icons.Function;
    import Modelica.Utilities.Streams.readFile;
    import Modelica.Utilities.Strings.replace;
    import Modelica.Utilities.Strings.scanReal;
    input String fileName "CSV file with one header row and columns RPM, mass flow (kg/s), pressure ratio, and isentropic efficiency";
    input Integer lines "Number of speed lines";
    input Integer points "Number of operating points per speed line";
    output Modelica.Units.SI.AngularVelocity w[lines] "Speed of each line";
    output Modelica.Units.SI.MassFlowRate m_flow[lines, points] "Mass flow of every point";
    output Real p_ratio[lines, points] "Pressure ratio of every point";
    output Real eta[lines, points] "Isentropic efficiency of every point";
  protected
    String fileLines[:] = readFile(fileName);
    String s;
    Integer next;
    Integer iLine;
    Integer iPoint;
    Real value;
  algorithm
    assert(size(fileLines, 1) >= lines*points + 1, "Compressor map file '" + fileName + "' holds " + String(size(fileLines, 1)) + " rows, but speedLines*pointsPerLine + 1 (header) = " + String(lines*points + 1) + " are expected.");
    for k in 1:(lines*points) loop
      iLine := div(k - 1, points) + 1;
      iPoint := mod(k - 1, points) + 1;
      // Skip the header line, turn the comma separators into blanks and scan four reals
      s := replace(fileLines[k + 1], ",", " ");
      next := 1;
      (value, next) := scanReal(s, next);
      w[iLine] := from_rpm(value);
      (value, next) := scanReal(s, next);
      m_flow[iLine, iPoint] := value;
      (value, next) := scanReal(s, next);
      p_ratio[iLine, iPoint] := value;
      (value, next) := scanReal(s, next);
      eta[iLine, iPoint] := value;
    end for;
    for i in 1:(lines - 1) loop
      assert(w[i + 1] > w[i], "Compressor map speed lines must be listed with strictly increasing RPM (line " + String(i + 1) + ").");
    end for;
    for i in 1:lines loop
      for j in 1:(points - 1) loop
        assert(m_flow[i, j + 1] > m_flow[i, j], "Compressor map points must be listed with strictly increasing mass flow within a speed line (line " + String(i) + ", point " + String(j + 1) + ").");
      end for;
    end for;
  end readMap;

initial algorithm
  (w_grid, m_flow_grid, p_ratio_grid, eta_grid) := readMap(mapFileName, speedLines, pointsPerLine);

equation
  assert(m_flow <= m_flow_surge_min or not surging, "CompressorMap: operating point is left of the surge line (m_flow < m_flow_surge).", AssertionLevel.warning);
  assert(m_flow <= m_flow_surge_min or not choking, "CompressorMap: operating point is right of the choke line (m_flow > m_flow_choke).", AssertionLevel.warning);
  // Warn only once the machine is actually pumping, so start-up transients stay quiet
  port_a.m_flow = m_flow;
  port_b.m_flow = -m_flow "No-holdup model - what goes in leaves immediately";
  port_a.Xi_outflow = inStream(port_a.Xi_outflow) "Compositions do not change";
  port_b.Xi_outflow = port_a.Xi_outflow "Compositions do not change";
  port_a.h_outflow = inStream(port_a.h_outflow) "Not supposed to be used, but must be set to balance equations";
  p_ratio_map_relax*der(p_ratio_dyn) = p_ratio_map - p_ratio_dyn "First-order lag of the delivered pressure ratio toward the map value";
  port_b.p = p_ratio_dyn*port_a.p "Pressure rise as given by map, after relaxation";
  port_b.h_outflow = inStream(port_a.h_outflow) + dh_is/eta - lossPower/max(m_flow, eps) "Outlet enthalpy from the isentropic rise, the map efficiency and any heat removed through the heat port";
  TheatPort = Medium.temperature(state_out) "Heat port temperature set at outlet temperature";
  torque.tau = -P_shaft/max(sensor.w, sqrt(eps));
  
  connect(flange_a, inertia.flange_a) annotation(
    Line(points = {{-100, 0}, {-90, 0}, {-90, -20}, {-80, -20}}));
  connect(inertia.flange_b, sensor.flange_a) annotation(
    Line(points = {{-60, -20}, {-38, -20}}));
  connect(sensor.flange_b, torque.flange) annotation(
    Line(points = {{-18, -20}, {0, -20}}));
  annotation(
    Documentation(info = "<html><head></head><body><p>This compressor derives from <tt>CompressorInterface</tt>, like <tt>Compressor</tt>, but instead of a constant isentropic efficiency it reads a performance map from a CSV file relating shaft speed, mass flow, pressure ratio and isentropic efficiency.</p>
<p>The file is a plain comma-separated table with a single header row and four columns, in this order:</p>
<ol><li><tt>w</tt> - shaft speed in rounds per minute;</li><li><tt>MassFlow_kg_s</tt> - mass flow in kg/s;</li><li><tt>PressureRatio</tt> - total-to-total pressure ratio;</li><li><tt>Isentropic_Efficiency</tt> - isentropic efficiency (0..1).</li></ol>
<p>Rows must be grouped by speed line, with <tt>speedLines</tt> lines of <tt>pointsPerLine</tt> points each, speeds listed in strictly increasing order and, within a line, mass flow in strictly increasing order. The default map lives in <tt>Resources/CompressorMaps/compressor_map.csv</tt>; set the <tt>mapFileName</tt> parameter (a file selector is offered in the parameter dialog) to use a different one, adjusting <tt>speedLines</tt> and <tt>pointsPerLine</tt> to match.</p>
<p>The map is read once at initialisation. At every operating point the model interpolates each speed line's points along the speed axis to the actual <tt>w</tt>, then interpolates pressure ratio and efficiency along the mass-flow axis to the actual flow (linear, with linear extrapolation beyond the mapped range).</p>
<p>The first and last point of the speed-interpolated line define the <b>surge line</b> (<tt>m_flow_surge</tt>) and the <b>choke line</b> (<tt>m_flow_choke</tt>) at the current speed. <tt>surgeMargin</tt> gives the relative distance to surge, and the Boolean flags <tt>surging</tt> / <tt>choking</tt> together with warning-level assertions fire when the operating point leaves the mapped flow range.</p>
<p>As in <tt>Compressor</tt>, mechanical work is delivered through the shaft, there is no fluid holdup, outlet conditions use the medium's <tt>isentropicEnthalpy</tt>, and <tt>heatPort</tt> is enabled by default (adiabatic when nothing is connected).</p></body></html>"),
    Icon(graphics = {Rectangle(origin = {-54, -38}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{30, 30}, {-30, -30}}), Line(origin = {-52, -36}, points = {{-22, 22}, {-22, -22}, {22, -22}}, arrow = {Arrow.Filled, Arrow.Filled}), Line(origin = {-56.02, -36.02}, points = {{-13.9774, -15.9774}, {10.0226, 16.0226}}), Line(origin = {-41, -38}, points = {{-7, 14}, {5, 14}, {7, 0}}, smooth = Smooth.Bezier), Line(origin = {-45.91, -42.09}, points = {{-8.08835, 10.0883}, {3.91165, 10.0883}, {5.91165, 0.08835}}, smooth = Smooth.Bezier), Line(origin = {-51.85, -45.15}, points = {{-6.14993, 5.14993}, {1.9, 4.9}, {5.85007, -0.85007}}, smooth = Smooth.Bezier), Line(origin = {-58.79, -48.21}, points = {{-5.20711, 2.20711}, {0.792893, 2.20711}, {4.79289, -1.79289}}, smooth = Smooth.Bezier)}));
end CompressorMap;
