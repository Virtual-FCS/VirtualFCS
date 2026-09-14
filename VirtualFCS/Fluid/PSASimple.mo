within VirtualFCS.Fluid;

model PSASimple
  extends Fluid.PSAInterface;

  parameter Real sep_eff = 0.9
    "Fraction of inlet H2 recovered in product";

  redeclare package Medium_feed =
      VirtualFCS.Media.CrackedAmmonia
    "Medium for inlet";

  redeclare package Medium_product =
      Modelica.Media.IdealGases.SingleGases.H2
    "Medium for purified gas outlet";

  redeclare package Medium_tail =
      VirtualFCS.Media.CrackedAmmonia
    "Medium for other gases outlet";

  Medium_feed.MassFraction Xi_test[2];

protected

  Medium_feed.ThermodynamicState feedState;

  Real X_H2;
  Real X_N2;
  Real X_NH3;

  Real X_H2_tail;
  Real X_N2_tail;
  Real X_NH3_tail;

  Modelica.Units.SI.MassFlowRate m_flow_product;
  Modelica.Units.SI.MassFlowRate m_flow_tail;

  Modelica.Units.SI.Temperature T_feed;

equation
  Xi_test = inStream(feed.Xi_outflow);
  //------------------------------------------------------------------
  // Incoming feed state
  //------------------------------------------------------------------

  feedState =
    Medium_feed.setState_phX(
      feed.p,
      //-9.8e6,
      inStream(feed.h_outflow),
      inStream(feed.Xi_outflow));

  T_feed = Medium_feed.temperature(feedState);


  //------------------------------------------------------------------
  // Feed composition
  //
  // CrackedAmmonia:
  //   Xi[1] = NH3
  //   Xi[2] = H2
  //   X_N2 = 1 - X_NH3 - X_H2
  //------------------------------------------------------------------

  X_NH3 = inStream(feed.Xi_outflow[1]);
  X_H2 = inStream(feed.Xi_outflow[2]);
  X_N2 = 1 - X_NH3 - X_H2;


  //------------------------------------------------------------------
  // Define the feed-port outflow stream.
  //
  // This is the stream that would leave through the feed port in
  // case of reverse flow. It does not affect the normal feed->outlet
  // operation.
  //------------------------------------------------------------------

  feed.h_outflow =
    Medium_feed.specificEnthalpy(feedState);

  feed.Xi_outflow[1] = X_NH3;
  feed.Xi_outflow[2] = X_H2;


  //------------------------------------------------------------------
  // H2 separation
  //------------------------------------------------------------------

  m_flow_product =
    sep_eff * feed.m_flow * X_H2;

  m_flow_tail =
    feed.m_flow - m_flow_product;


  //------------------------------------------------------------------
  // Outlet mass flows
  //------------------------------------------------------------------

  product.m_flow = -m_flow_product;
  tail.m_flow = -m_flow_tail;


  //------------------------------------------------------------------
  // Outlet pressures
  //------------------------------------------------------------------

  product.p = feed.p;
  //tail.p = feed.p;


  //------------------------------------------------------------------
  // Product: pure H2 at feed temperature
  //------------------------------------------------------------------

  product.h_outflow =
    Medium_product.specificEnthalpy(
      Medium_product.setState_pTX(
        product.p,
        T_feed,
        {1.0}));


  //------------------------------------------------------------------
  // Tail composition
  //------------------------------------------------------------------

  X_H2_tail =
    (1 - sep_eff) * feed.m_flow * X_H2 / m_flow_tail;

  X_N2_tail =
    feed.m_flow * X_N2 / m_flow_tail;

  X_NH3_tail =
    feed.m_flow * X_NH3 / m_flow_tail;


  //------------------------------------------------------------------
  // Tail: same temperature as feed
  //------------------------------------------------------------------

  tail.h_outflow =
    Medium_tail.specificEnthalpy(
      Medium_tail.setState_pTX(
        tail.p,
        T_feed,
        {X_NH3_tail, X_H2_tail}));


  //------------------------------------------------------------------
  // Tail composition
  //------------------------------------------------------------------

  tail.Xi_outflow[1] = X_NH3_tail;
  tail.Xi_outflow[2] = X_H2_tail;
end PSASimple;
