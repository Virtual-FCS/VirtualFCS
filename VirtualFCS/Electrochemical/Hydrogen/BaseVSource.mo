within VirtualFCS.Electrochemical.Hydrogen;

partial model BaseVSource
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  extends Modelica.Electrical.Analog.Icons.VoltageSource;
  
  outer parameter Integer N_cells "number of cells in the stack";

  annotation(
    Icon,
  Documentation(info = "<html><head></head><body>This is the abstract base unit for voltage sources in fuel cells.</body></html>"));

end BaseVSource;
