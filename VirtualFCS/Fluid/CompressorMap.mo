within VirtualFCS.Fluid;

model CompressorMap "Compressor whose pressure ratio and efficiency come from a CSV performance map"
  extends VirtualFCS.Fluid.CompressorInterface(useHeatPort=true);

  import Modelica.Constants.eps;

  parameter String mapFileName = Modelica.Utilities.Files.loadResource(
      "modelica://VirtualFCS/Resources/CompressorMaps/compressor_map.csv")
    "Compressor map file: header row + columns RPM, MassFlow_kg_s, PressureRatio, Isentropic_Efficiency"
    annotation(Dialog(loadSelector(filter = "Comma-separated values (*.csv)", caption = "Select compressor map file")));
  parameter Integer nSpeedLines(min = 2) = 6 "Number of distinct speed lines in the map";
  parameter Integer nPointsPerLine(min = 2) = 7 "Number of operating points per speed line";

  parameter Modelica.Units.SI.Efficiency eta_min = 0.05 "Lower bound on the map efficiency used in the outlet enthalpy";
  parameter Modelica.Units.SI.Time tau_p(min = 0) = 0.05 "Time constant with which the delivered pressure ratio follows the map (softens start-up)";
  parameter Modelica.Units.SI.MassFlowRate m_flow_surge_min = 1e-3 "Below this flow the surge/choke warnings are suppressed (machine not pumping)";
  parameter Modelica.Units.SI.Power P_nom(displayUnit = "kW") = 40000 "Nominal compressor power";
  parameter Modelica.Units.SI.AngularVelocity RPM_nom(displayUnit = "rpm") = 8377.580409572781 "Nominal rounds per minute";

  Modelica.Units.SI.AngularVelocity RPM(displayUnit = "rpm", start = RPM_nom) = RPM_nom * sqrt(max(sensor.power, 0)/P_nom) "Actual rounds per minute";
  Modelica.Units.SI.MassFlowRate m_flow(min = 0, start = 1e-4) "Mass flow through the unit";

  Real PR_op(min = 1, start = 1.5) "Operating pressure ratio read from the map";
  Real PR_dyn(min = 1, start = 1, fixed = true) "Delivered pressure ratio, a first-order lag toward the map value";
  Modelica.Units.SI.Efficiency eta_op "Operating isentropic efficiency read from the map";

  Modelica.Units.SI.MassFlowRate m_flow_surge "Surge-line (minimum) mass flow at the current speed";
  Modelica.Units.SI.MassFlowRate m_flow_choke "Choke-line (maximum) mass flow at the current speed";
  Real surgeMargin = (m_flow - m_flow_surge)/max(m_flow_surge, eps) "Relative distance to the surge line, negative when surging";
  Boolean surging = m_flow < m_flow_surge "True while operating left of the surge line";
  Boolean choking = m_flow > m_flow_choke "True while operating right of the choke line";

  Modelica.Units.SI.EnthalpyFlowRate Hin  = port_a.m_flow * inStream(port_a.h_outflow) "Enthalpy inflow at inlet";
  Modelica.Units.SI.EnthalpyFlowRate Hout = port_b.m_flow * port_b.h_outflow "Enthalpy inflow at outlet (mind the sign)";
  Modelica.Units.SI.Power P_shaft = -(Hin + Hout) + lossPower "Aerodynamic power the shaft must deliver at this operating point";

  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 1e-4) annotation(
    Placement(transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sensors.MultiSensor sensor annotation(
    Placement(transformation(origin = {-28, -20}, extent = {{-10, -10}, {10, 10}})));
protected
  Medium.ThermodynamicState state_in = Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow));
  Medium.ThermodynamicState state_out = Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow);
  Modelica.Units.SI.SpecificEnthalpy dh_is = Medium.isentropicEnthalpy(port_b.p, state_in) - inStream(port_a.h_outflow) "Isentropic enthalpy rise across the unit";

  Modelica.Mechanics.Rotational.Components.Damper damper(final d = P_nom/RPM_nom^2) annotation(
    Placement(transformation(origin = {10, -20}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Mechanics.Rotational.Components.Fixed fixed annotation(
    Placement(transformation(origin = {50, -20}, extent = {{-10, -10}, {10, 10}})));

  // Map data, read once from the CSV file at initialisation
  parameter Real N_grid_rpm[nSpeedLines](each fixed = false) "Speed of each map line, as read from the file [rpm]";
  parameter Modelica.Units.SI.MassFlowRate mdot_grid[nSpeedLines, nPointsPerLine](each fixed = false) "Mass flow of every map point";
  parameter Real PR_grid[nSpeedLines, nPointsPerLine](each fixed = false) "Pressure ratio of every map point";
  parameter Modelica.Units.SI.Efficiency eta_grid[nSpeedLines, nPointsPerLine](each fixed = false) "Isentropic efficiency of every map point";
  parameter Modelica.Units.SI.AngularVelocity N_grid[nSpeedLines] = {Modelica.Units.Conversions.from_rpm(N_grid_rpm[i]) for i in 1:nSpeedLines} "Speed of each map line";

  // Slice of the map at the current speed (one value per operating point)
  Modelica.Units.SI.AngularVelocity RPM_lim = min(max(RPM, N_grid[1]), N_grid[nSpeedLines]) "Speed clamped to the mapped range for the look-up";
  Modelica.Units.SI.MassFlowRate mdot_line[nPointsPerLine] "Map mass flow at the current speed";
  Real PR_line[nPointsPerLine] "Map pressure ratio at the current speed";
  Modelica.Units.SI.Efficiency eta_line[nPointsPerLine] "Map efficiency at the current speed";

  impure function readMap "Parse a compressor map CSV file into speed, mass-flow, pressure-ratio and efficiency arrays"
    input String fileName "CSV file with a header row and columns RPM, MassFlow_kg_s, PressureRatio, Isentropic_Efficiency";
    input Integer nLines "Number of speed lines";
    input Integer nPoints "Number of operating points per speed line";
    output Real N[nLines] "Speed of each line [rpm]";
    output Real mdot[nLines, nPoints] "Mass flow of every point";
    output Real PR[nLines, nPoints] "Pressure ratio of every point";
    output Real eta[nLines, nPoints] "Isentropic efficiency of every point";
  protected
    String lines[:] = Modelica.Utilities.Streams.readFile(fileName);
    String s;
    Integer next;
    Integer iLine;
    Integer iPoint;
    Real value;
  algorithm
    assert(size(lines, 1) >= nLines*nPoints + 1,
      "Compressor map file '" + fileName + "' holds " + String(size(lines, 1)) +
      " rows, but nSpeedLines*nPointsPerLine + 1 (header) = " + String(nLines*nPoints + 1) + " are expected.");
    for k in 1:(nLines*nPoints) loop
      iLine  := div(k - 1, nPoints) + 1;
      iPoint := mod(k - 1, nPoints) + 1;
      // Skip the header line, turn the comma separators into blanks and scan four reals
      s := Modelica.Utilities.Strings.replace(lines[k + 1], ",", " ");
      next := 1;
      (value, next) := Modelica.Utilities.Strings.scanReal(s, next);
      N[iLine] := value;
      (value, next) := Modelica.Utilities.Strings.scanReal(s, next);
      mdot[iLine, iPoint] := value;
      (value, next) := Modelica.Utilities.Strings.scanReal(s, next);
      PR[iLine, iPoint] := value;
      (value, next) := Modelica.Utilities.Strings.scanReal(s, next);
      eta[iLine, iPoint] := value;
    end for;
    for i in 1:(nLines - 1) loop
      assert(N[i + 1] > N[i],
        "Compressor map speed lines must be listed with strictly increasing RPM (line " + String(i + 1) + ").");
    end for;
    for i in 1:nLines loop
      for j in 1:(nPoints - 1) loop
        assert(mdot[i, j + 1] > mdot[i, j],
          "Compressor map points must be listed with strictly increasing mass flow within a speed line (line " +
          String(i) + ", point " + String(j + 1) + ").");
      end for;
    end for;
  end readMap;

initial algorithm
  (N_grid_rpm, mdot_grid, PR_grid, eta_grid) := readMap(mapFileName, nSpeedLines, nPointsPerLine);

equation
  // Map look-up: first interpolate every operating point along the speed axis, then along the mass-flow axis
  for j in 1:nPointsPerLine loop
    mdot_line[j] = Modelica.Math.Vectors.interpolate(N_grid, mdot_grid[:, j], RPM_lim);
    PR_line[j]   = Modelica.Math.Vectors.interpolate(N_grid, PR_grid[:, j], RPM_lim);
    eta_line[j]  = Modelica.Math.Vectors.interpolate(N_grid, eta_grid[:, j], RPM_lim);
  end for;
  m_flow_surge = mdot_line[1];
  m_flow_choke = mdot_line[nPointsPerLine];
  PR_op  = max(Modelica.Math.Vectors.interpolate(mdot_line, PR_line, m_flow), 1);
  eta_op = max(Modelica.Math.Vectors.interpolate(mdot_line, eta_line, m_flow), eta_min);

  // Warn only once the machine is actually pumping, so start-up transients stay quiet
  assert(m_flow <= m_flow_surge_min or not surging,
    "CompressorMap: operating point is left of the surge line (m_flow < m_flow_surge).", AssertionLevel.warning);
  assert(m_flow <= m_flow_surge_min or not choking,
    "CompressorMap: operating point is right of the choke line (m_flow > m_flow_choke).", AssertionLevel.warning);

  port_a.m_flow = m_flow;
  port_b.m_flow = -m_flow "No-holdup model - what goes in leaves immediately";
  port_a.Xi_outflow = inStream(port_a.Xi_outflow) "Compositions do not change";
  port_b.Xi_outflow  = port_a.Xi_outflow "Compositions do not change";
  port_a.h_outflow = inStream(port_a.h_outflow) "Not supposed to be used, but must be set to balance equations";

  tau_p * der(PR_dyn) = PR_op - PR_dyn "First-order lag of the delivered pressure ratio toward the map value";
  port_b.p = PR_dyn * port_a.p "Pressure rise imposed by the map; together with the network this sets the mass flow";
  port_b.h_outflow = inStream(port_a.h_outflow) + dh_is/eta_op - lossPower/max(m_flow, eps)
    "Outlet enthalpy from the isentropic rise, the map efficiency and any heat removed through the heat port";

  TheatPort = Medium.temperature(state_out) "Heat port temperature set at outlet temperature";

  connect(flange_a, inertia.flange_a) annotation(
    Line(points = {{-100, 0}, {-90, 0}, {-90, -20}, {-80, -20}}));
  connect(inertia.flange_b, sensor.flange_a) annotation(
    Line(points = {{-60, -20}, {-38, -20}}));
  connect(damper.flange_a, fixed.flange) annotation(
    Line(points = {{20, -20}, {50, -20}}));
  connect(damper.flange_b, sensor.flange_b) annotation(
    Line(points = {{0, -20}, {-18, -20}}));

  annotation(
    Documentation(info = "<html><head></head><body><p>This compressor derives from <tt>CompressorInterface</tt>, like <tt>Compressor</tt>, but instead of a constant isentropic efficiency it reads a performance map from a CSV file relating shaft speed, mass flow, pressure ratio and isentropic efficiency.</p>
<p>The file is a plain comma-separated table with a single header row and four columns, in this order:</p>
<ol><li><tt>RPM</tt> - shaft speed in rounds per minute;</li><li><tt>MassFlow_kg_s</tt> - mass flow in kg/s;</li><li><tt>PressureRatio</tt> - total-to-total pressure ratio;</li><li><tt>Isentropic_Efficiency</tt> - isentropic efficiency (0..1).</li></ol>
<p>Rows must be grouped by speed line, with <tt>nSpeedLines</tt> lines of <tt>nPointsPerLine</tt> points each, speeds listed in strictly increasing order and, within a line, mass flow in strictly increasing order. The default map lives in <tt>Resources/CompressorMaps/compressor_map.csv</tt>; set the <tt>mapFileName</tt> parameter (a file selector is offered in the parameter dialog) to use a different one, adjusting <tt>nSpeedLines</tt> and <tt>nPointsPerLine</tt> to match.</p>
<p>The map is read once at initialisation. At every operating point the model interpolates each speed line's points along the speed axis to the actual <tt>RPM</tt>, then interpolates pressure ratio and efficiency along the mass-flow axis to the actual flow (linear, with linear extrapolation beyond the mapped range).</p>
<p>The first and last point of the speed-interpolated line define the <b>surge line</b> (<tt>m_flow_surge</tt>) and the <b>choke line</b> (<tt>m_flow_choke</tt>) at the current speed. <tt>surgeMargin</tt> gives the relative distance to surge, and the Boolean flags <tt>surging</tt> / <tt>choking</tt> together with warning-level assertions fire when the operating point leaves the mapped flow range.</p>
<p>As in <tt>Compressor</tt>, mechanical work is delivered through the shaft, there is no fluid holdup, outlet conditions use the medium's <tt>isentropicEnthalpy</tt>, and <tt>heatPort</tt> is enabled by default (adiabatic when nothing is connected).</p></body></html>"));
end CompressorMap;
