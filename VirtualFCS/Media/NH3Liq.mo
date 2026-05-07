within VirtualFCS.Media;

package NH3Liq

extends Modelica.Media.Incompressible.TableBased(
    mediumName="Ammonia_liquid",
    T_min = Cv.from_degC(-30), T_max = Cv.from_degC(100),
    TinK = false, T0=273.15,
    tableDensity=
      [-30, 1066; -20, 1062; -10, 1058; 0, 1054;
       20, 1044; 40, 1030; 60, 1015; 80, 999; 100, 984],
    tableHeatCapacity=
      [-30, 3450; -20, 3490; -10, 3520; 0, 3560;
       20, 3620; 40, 3690; 60, 3760; 80, 3820; 100, 3890],
    tableConductivity=
      [-30,0.397;  -20,0.396;  -10,0.395;  0,0.395;
       20,0.394;  40,0.393;  60,0.392;  80,0.391;  100,0.390],
    tableViscosity=
      [-30, 0.160; -20, 0.0743; -10, 0.0317; 0, 0.0190;
       20, 0.00626; 40, 0.00299; 60, 0.00162; 80, 0.00110; 100, 0.00081],
    tableVaporPressure=
      [0, 500; 20, 1.9e3; 40, 5.3e3; 60, 16e3; 80, 37e3; 100, 80e3]);
    annotation (Documentation(info="<html>

</html>"));


end NH3Liq;
