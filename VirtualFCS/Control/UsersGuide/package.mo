within VirtualFCS.Control;

package UsersGuide "User information for the Control sub-library"
  extends Modelica.Icons.Information;
  annotation(
    Documentation(info = "<html><head></head><body>The package VirtualFCS.Control contains models for the control of hybrid fuel cell systems and their components.&nbsp;<div><br></div><div>The models read the state of the component under control, apply some algorithm(s) to process the state variables, and send a control signal back to the component. Signals from sensors and to controls typically use real number interfaces. In some cases, electrical connections are used to directly control electrical components using voltage or current.&nbsp;</div></body></html>"));
end UsersGuide;