within VirtualFCS.Fluid;

model PSASimple
  extends VirtualFCS.Fluid.PSAInterface;
  parameter Real sep_eff "Product separation efficiency";
  
  redeclare package Medium_1 = VirtualFCS.Media.NH3Cracked "Medium for inlet";
  redeclare package Medium_2 = Modelica.Media.IdealGases.SingleGases.H2 "Medium for purified gas outlet" ;
  redeclare package Medium_3 = VirtualFCS.Media.NH3Cracked "Medium for other gases outlet";

equation
// Species mass balance using pure H2 as product stream
feed.Xi_outflow[2] = inStream(feed.Xi_outflow[2]);

product.m_flow = feed.m_flow * inStream(feed.Xi_outflow[1]) * sep_eff;

tail.m_flow = feed.m_flow - product.m_flow;

tail.Xi_outflow[1] = (feed.m_flow*inStream(feed.Xi_outflow[1]) - product.m_flow) / tail.m_flow;
tail.Xi_outflow[2] = (feed.m_flow*inStream(feed.Xi_outflow[2])) / tail.m_flow;


// Momentum balance no pressure drop
product.p = feed.p;
tail.p = feed.p;

// Energy balance: Simplifying initial assumption, constant specific enthalpies (not correct as they vary with composition)
feed.h_outflow = inStream(feed.h_outflow);
product.h_outflow = inStream(feed.h_outflow);
tail.h_outflow = inStream(feed.h_outflow);

end PSASimple;
