within VirtualFCS.Electrochemical.Hydrogen;

model FuelCellSystem

  parameter Real m_FC_system(unit = "kg") = fuelCellStack.m_FC_stack + fuelCellSubSystems.m_FC_subsystems;

// Fuel Cell Stack Paramters
  parameter Real m_FC_stack(unit = "kg") = 14.3 "FC stack mass";
  parameter Real L_FC_stack(unit = "m") = 0.255 "FC stack length";
  parameter Real W_FC_stack(unit = "m") = 0.760 "FC stack length";
  parameter Real H_FC_stack(unit = "m") = 0.060 "FC stack length";
  parameter Real vol_FC_stack(unit = "m3") = L_FC_stack * W_FC_stack * H_FC_stack "FC stack volume";
  parameter Real V_rated_FC_stack(unit="V") = 57.9 "Maximum stack operating voltage"; 
  parameter Real I_rated_FC_stack(unit="A") = 300 "Minimum stack operating voltage";
  parameter Real i_L_FC_stack(unit = "A") = 1.3 * I_rated_FC_stack "FC stack cell maximum limiting current";
  parameter Real N_FC_stack(unit = "1") = floor(V_rated_FC_stack/0.6433) "FC stack number of cells";
  // H2 Subsystem Paramters
  parameter Real V_tank_H2(unit="m3") = 0.13 "H2 tank volume";
  parameter Real p_tank_H2(unit="Pa") = 35000000 "H2 tank initial pressure";
  

  VirtualFCS.Electrochemical.Hydrogen.FuelCellStack fuelCellStack( H_FC_stack = H_FC_stack, I_rated_FC_stack = I_rated_FC_stack, L_FC_stack = L_FC_stack, V_rated_FC_stack = V_rated_FC_stack, W_FC_stack = W_FC_stack, m_FC_stack = m_FC_stack, vol_FC_stack = vol_FC_stack)  annotation(
    Placement(visible = true, transformation(origin = {-1, 10}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {20, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {-40, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  VirtualFCS.SubSystems.FuelCellSubSystems fuelCellSubSystems(V_tank_H2 = V_tank_H2, p_tank_H2 = p_tank_H2)  annotation(
    Placement(visible = true, transformation(origin = {-1, -60}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex2 multiplex2 annotation(
    Placement(visible = true, transformation(origin = {-54, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation(
    Placement(visible = true, transformation(origin = {-98, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(visible = true, transformation(origin = {-58, 46}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  inner Modelica.Fluid.System system annotation(
    Placement(visible = true, transformation(origin = {-94, 94}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(visible = true, transformation(origin = {92, 42}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression setConvectiveCoefficient(y = 12) annotation(
    Placement(visible = true, transformation(origin = {132, 42}, extent = {{15, -10}, {-15, 10}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.BodyRadiation bodyRadiation(Gr = 0.95 * fuelCellStack.A_FC_surf) annotation(
    Placement(visible = true, transformation(origin = {52, 42}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T = 293.15)  annotation(
    Placement(visible = true, transformation(origin = {70, 86}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = i_L_FC_stack, uMin = 0)  annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(pin_p, fuelCellStack.pin_p) annotation(
    Line(points = {{20, 96}, {20, 36}, {9, 36}}, color = {0, 0, 255}));
  connect(fuelCellStack.port_b_Air, fuelCellSubSystems.air_port_a) annotation(
    Line(points = {{18, -2}, {18, -37.5}, {16.5, -37.5}}, color = {0, 127, 255}));
  connect(fuelCellSubSystems.air_port_b, fuelCellStack.port_a_Air) annotation(
    Line(points = {{21.5, -37.5}, {26, -37.5}, {26, 22}, {18, 22}}, color = {0, 127, 255}));
  connect(fuelCellStack.port_b_H2, fuelCellSubSystems.H2_port_a) annotation(
    Line(points = {{-20, -2}, {-18, -2}, {-18, -37.5}, {-18.5, -37.5}}, color = {0, 127, 255}));
  connect(fuelCellSubSystems.H2_port_b, fuelCellStack.port_a_H2) annotation(
    Line(points = {{-23.5, -37.5}, {-26, -37.5}, {-26, 22}, {-20, 22}}, color = {0, 127, 255}));
  connect(multiplex2.y, fuelCellSubSystems.contolInput) annotation(
    Line(points = {{-43, -60}, {-31, -60}}, color = {0, 0, 127}, thickness = 0.5));
  connect(temperatureSensor.T, multiplex2.u2[1]) annotation(
    Line(points = {{-88, -66}, {-66, -66}}, color = {0, 0, 127}));
  connect(currentSensor.n, fuelCellStack.pin_n) annotation(
    Line(points = {{-58, 36}, {-11, 36}}, color = {0, 0, 255}));
  connect(fuelCellStack.port_a_Coolant, fuelCellSubSystems.coolant_port_b) annotation(
    Line(points = {{-6, -6}, {-6, 6}, {-3.5, 6}, {-3.5, -37.5}}, color = {0, 127, 255}));
  connect(fuelCellStack.port_b_Coolant, fuelCellSubSystems.coolant_port_a) annotation(
    Line(points = {{4, -6}, {1.5, -6}, {1.5, -37.5}}, color = {0, 127, 255}));
  connect(temperatureSensor.port, fuelCellStack.heatPort) annotation(
    Line(points = {{-108, -66}, {-132, -66}, {-132, 76}, {-2, 76}, {-2, 22}, {0, 22}}, color = {191, 0, 0}));
  connect(fuelCellStack.heatPort, bodyRadiation.port_a) annotation(
    Line(points = {{0, 22}, {-2, 22}, {-2, 32}, {52, 32}, {52, 32}}, color = {191, 0, 0}));
  connect(fuelCellStack.heatPort, convection.solid) annotation(
    Line(points = {{0, 22}, {-2, 22}, {-2, 32}, {92, 32}, {92, 32}}, color = {191, 0, 0}));
  connect(fixedTemperature.port, bodyRadiation.port_b) annotation(
    Line(points = {{70, 76}, {70, 76}, {70, 64}, {52, 64}, {52, 52}, {52, 52}}, color = {191, 0, 0}));
  connect(fixedTemperature.port, convection.fluid) annotation(
    Line(points = {{70, 76}, {70, 76}, {70, 64}, {92, 64}, {92, 52}, {92, 52}}, color = {191, 0, 0}));
  connect(setConvectiveCoefficient.y, convection.Gc) annotation(
    Line(points = {{116, 42}, {104, 42}, {104, 42}, {102, 42}}, color = {0, 0, 127}));
  connect(currentSensor.i, limiter.u) annotation(
    Line(points = {{-68, 46}, {-80, 46}, {-80, 12}, {-80, 12}}, color = {0, 0, 127}));
  connect(limiter.y, multiplex2.u1[1]) annotation(
    Line(points = {{-80, -12}, {-80, -12}, {-80, -54}, {-66, -54}, {-66, -54}}, color = {0, 0, 127}));
  connect(pin_n, currentSensor.p) annotation(
    Line(points = {{-40, 96}, {-58, 96}, {-58, 56}, {-58, 56}}, color = {0, 0, 255}));
protected
  annotation(
    Icon(graphics = {Bitmap(origin = {-5, 4}, extent = {{-95, 96}, {105, -104}}, imageSource = "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Up7ibH6mu47F2RfsW2vBF+pU7upwfpYnj8GbzFtr0ZvGrTzZ4fwMdxrffnatdWsturaO5U5O56c9cXzzG4xbazfgDeNanuh0fsodx7eefdq2tXYDPl3nckfH85MeN77xtaattRv02nEvj3M8P+FW49vOPmHZWrtBn6iDuZXz+XH15b1ebdhauxGvHhfzs7/s1zPHN/XvBN3aearfN/qZzufH3GF8y9nX7VprN+LrdTJ3cEDX94jxDf11J1s7b/UVKR/hgK7v+eMb+neQae28fWzczPMd0PXsPy3vO1attRv1nTqan/4JevUVkd9l1Fo7D+8aV/PHTuhHbvaSkT9n01o7D58bV/OSmzmiH/qNUV9h0lo7L68Yd/OTv2d0/eKL91u01s7L+8fd/MQvxLjtaP11VFq7MPtXVrmtM9o9dKTXGbTWztPrxuU81BntnjrSNb69tXaerhmX81RnVG4+Sn9RotYu1P5lim7ukIa7jfAa39xaO2+vGbdzN4c01M/Le69vba2dt/eO27n+z897xgif8a2ttfP2mXE71/varrcY//nsm761tXbevlnHcwun5Isi9xd/aO0i1JeCuKdTOnfukeM/vs+3tdYuwPvG9TzSKZ079+zxH/trT7Z2EeqrUT7bKZ275fhPZ9/yba21C/CtOp9bOqb7jP/wet/UWrsgrx/3cx/H9OjxHz7oW1prF+SD434e7Zjq91f/vG9prV2Qz4/78Xuv32b8+dl3fUtr7YJ8tw7oNnVMdxl/+kbf0Fq7QG8cF3SXOqYHjT99j95au0DvGRf0oDqmR40/7V/L1NpFql/T9Kg6pvryD/2vbFu7SPWvbfcvBPG88adf01trF+hr44KeN27pZuPPzr6vt9Yu0PfrhMZXz7v9+JP+bZlau2j1GzXdfjume48/eZvaWrtgbxs3dO/tmB4+/qR/MlFrF61+QtHDt2N67PiTj6uttQv28XFDj92Oqb7+w5fV1toF+/K4ofF1IF44/qS//kNrF62+DsQLz5271fjjy8XW2kV4+biiW5270/jDG7TW2kV4w7iiO527x/jDO7XW2kV457iie5y73/jDu7XW2kV497ii+5174PhDf5mv1i5BfbmvB557yPjDh7XW2kX48Liih5z7nfGH/tVMrV2C+hVNv73/0sCPaq21i/DRcUWPPPdH4w+f0lprF+FT44r+8NwTxh/619m2dgnq19o+4dyTxh++qLXWLsIXxxU96dzTxh+u01prF+G6cUVPO/ec8Yf+ChCtXYL6KhDP2b+cyje01tpF+Ma4ouede8H4w7e11tpF+Pa4ohece/H4w/e01tpF+N64ohefG//vmdRauyh1Rn1MrV26OqM+ptYuXZ1RH1Nrl67OqI+ptUtXZ9TH1NqlqzPqY2rt0tUZ9TG1dunqjPqYWrt0dUZ9TK1dujqjPqbWLl2dUR9Ta5euzqiPqbVLV2fUx9Tapasz6mNq7dLVGfUxtXbp6oz6mFq7dHVGfUytXbo6oz6m1i5dnVEfU2uXrs6oj6m1S1dn1MfU2qWrM+pjau3S1Rldlsf0/03kyXb58JGZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZwpPL1Rn1MbVT85GZ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"), Text(origin = {-6, -250}, lineColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name")}, coordinateSystem(initialScale = 0.1)));
end FuelCellSystem;
