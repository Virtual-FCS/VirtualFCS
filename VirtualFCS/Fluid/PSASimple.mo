within VirtualFCS.Fluid;

model PSASimple
  extends VirtualFCS.Fluid.PSAInterface;
  parameter Real sep_eff "Product separation efficiency";
  
equation
product.m_flow = feed.Xi_outflow[1] * sep_eff;
tail.Xi_outflow[1] = feed.Xi_outflow[1] * (1 - sep_eff);

end PSASimple;
