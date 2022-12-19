within VirtualFCS.Vehicles;

model VehicleProfile "Calculates the driving power for a vehicle that corresponds to a given speed profile."
  import Modelica.Blocks.Tables.Internal;
  type vehicle_name = enumeration(Default "Default", Mirai "Mirai", UserDefined "User Defined") annotation(
    Evaluate = true);
  parameter vehicle_name VN = VirtualFCS.Vehicles.VehicleProfile.vehicle_name.Default "Vehicle name";
  //parameter
  Real m(unit = "kg") "mass of the vehicle";
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  // *** DECLARE PARAMETERS *** //
  // Parameters of the vehicle and the air
  //parameter Real m(unit = "kg") = 1850 "Mass of the vehicle";
  parameter Real rho_air(unit = "kg/m3") = 1.2 "Volumic mass of the air";
  parameter Real A_front(unit = "m2") = 2.7 "Front area of the vehicle";
  parameter Real C_D(unit = "1") = 0.26 "Drag coefficient";
  parameter Real D_tire(unit = "m") = 0.4318 "Tire Diameter";
  parameter Real R_gear(unit = "1") = 3.478 "Reduction Gear Ratio";
  parameter Real V_load(unit = "V") = 343 "Load Voltage";
  parameter Boolean useRegenerativeBreaking = false annotation(
    choices(checkBox = true));
  // Efficiency coefficients
  parameter Real eff_drivetrain(unit = "1") = 0.9 "Efficiency of the drivetrain";
  parameter Real eff_brake(unit = "1") = 0.5 "Efficiency of the regenerative breaking";
  // --- Class Outputs --- //
  // Derived Quantities
  Real V(unit = "km/h") "Vehicle Speed";
  Real v(unit = "m/s") "Speed of the vehicle in m/s";
  Real a(unit = "m/s2") "Vehicle acceleration";
  Real F_accel(unit = "N") "Vehicle acceleration force";
  Real F_drag(unit = "N") "Vehicle drag force";
  //  Real F_roll(unit = "N") "Vehicle rolling force";
  Real F_T(unit = "N") "Vehicle total force";
  Real omega_engine(unit = "rad/s") "Motor Rotation, rad/s";
  Real N_engine(unit = "rpm") "Motor Rotation, rpm";
  //  Real tau(unit = "N.m") "Motor Torque";
  Real x(unit = "m") "Position";
  Real P(unit = "W");
  // *** INSTANTIATE COMPONENTS *** //
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {72, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{80, -60}, {100, -40}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {72, 34}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(extent = {{100, 40}, {80, 60}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vehicleVelocity annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
equation
// *** DEFINE EQUATIONS *** //
  if VN == VirtualFCS.Vehicles.VehicleProfile.vehicle_name.Mirai then
    m = 1850;
  elseif VN == VirtualFCS.Vehicles.VehicleProfile.vehicle_name.Default then
    m = 1980;
  elseif VN == VirtualFCS.Vehicles.VehicleProfile.vehicle_name.UserDefined then
    m = 1100;
  end if;
// Redeclare variables
  V = vehicleVelocity;
// Change of units (from km/h to m/s)
  v = V / 3.6;
// Calculate position
  der(x) = v;
  der(v) = a;
  F_drag = 0.5 * C_D * rho_air * v ^ 2 * A_front;
  F_accel = m * a;
//  F_roll = 0.02 * m * 9.81;
  F_T = F_drag + F_accel;
  P = F_T * v / 0.9;
  if P >= 0 then
    signalCurrent.i = -(P / 0.9) / V_load;
  else
    signalCurrent.i = -(P * 0.5) / V_load;
  end if;
  omega_engine = v * R_gear / (0.5 * D_tire);
  N_engine = 30 * omega_engine / Modelica.Constants.pi;
//der_v = if der(V) > 4.5 then 0 elseif der(V) < (-7) then 0 else der(v);
// Calculate motor rpm
//  omega = 60 * v * R_gear / (Modelica.Constants.pi * D_tire);
// Calculation of the weight and drag powers
//  P_weight = m * der_v * v;
//  P_drag = 0.5 * rho_air * A_front * C_D * v ^ 3;
// Calculation of the driving power
//  P = (P_weight + P_drag) / eff_drivetrain;
// Calculate motor torque
//tau = if omega > 0 then 9.5488 * (P / 1000) / omega else 0;
// Calculation of the driving energy
//  der(E) = P;
//  speedControlledDCMotor.contol_input = N_engine;
//  speedControlledDCMotor.torqueInput = tau;
// Assign current load value
//  if P_weight >= 0 then
//    currentLoad.i = P / V_load;
//  elseif useRegenerativeBreaking == true then
//    currentLoad.i = (P_weight + P_drag) * (eff_drivetrain * eff_regeneration) / V_load;
//  else
//    currentLoad.i = 0;
//  end if;
// *** DEFINE CONNECTIONS *** //
// --- Appearance of the Driving power block --- //
// Coloured rectangle //
// RGB code for the colour + Type of the pattern + Limit points of the rectangle
// Names of the inputs/outputs written on the block //
// In the extent command, write the coordinates of the bottom left corner and the top right corner of the rectangle that should contain the writting
  connect(signalCurrent.p, pin_p) annotation(
    Line(points = {{40, 10}, {40, 10}, {40, 34}, {72, 34}, {72, 34}}, color = {0, 0, 255}));
  connect(signalCurrent.n, pin_n) annotation(
    Line(points = {{40, -10}, {40, -10}, {40, -46}, {72, -46}, {72, -46}}, color = {0, 0, 255}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.05), graphics = {Text(origin = {-4, -12}, lineColor = {0, 0, 255}, extent = {{-150, 120}, {150, 150}}, textString = "%name"), Bitmap(origin = {-2, 1}, extent = {{-98, 99}, {102, -101}}, imageSource = "iVBORw0KGgoAAAANSUhEUgAAA0sAAANLCAMAAACnmvZEAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAH+UExURQAAAEAAIDkAHEAAMDcALD0AKTsAJzkAJj4ALDoAKToALDsAKjoAKT0AJzwAJjkAKjwAKjwAJjwAKD4AJz0AKjwAJzsAJjsAKTwAKD0AJz0AJj0AKTwAKTsAKDwAJzsAKTwAKD0AJzwAKTsAKD0AKDwAJz0AJzwAKTwAJz0AKT0AJzwAKTsAKDwAJzwAKD0AJzwAKTwAJz0AJzwAKTwAKDsAKD0AKDwAKDwAKTwAKTwAKT0AKD0AKDwAJzsAJzsAKTwAKDsAJzwAKTwAJzwAKDwAKTwAKDwAKDwAKDwAKTwAKDwAKD0AKDwAKDwAKDwAJz0AKDwAJzwAKDwAKTsAKDwAKDwAKDwAKDwAKDwAJzwAKDwAKDwAKDwAKDwAKDwAKDwAKDwAKD0AKD8AKkEAK0MALUQALUUALkYALkYAL0cAL0cAMEgAMEkAMUoAMUoAMkwAMkwAM00AM04ANE8ANE8ANVAANVEANlIANlIAN1MAN1UAOFUAOVYAOVYAOlcAOlgAOlkAO1sAPFsAPV0APl4APl8AP2AAQGEAQGEAQWIAQWIAQmQAQmQAQ2UAQ2YARGcARGgARWkARmoARmoAR2sAR2sASG0ASW4ASXAAS3EAS3EATHIATHMATHMATXQATXQATnUATnYAT3cAT3cAUHgAUJpAfLuAp92/0////1SgGXoAAABhdFJOUwAICRAXGRobHR8jKywuLzE3PEBCQ0hJSk1PUFBRUlVXWVxeX2BhaWpvcXZ3eXuAgoOIj5CRkpOUlpydn6Cio6OmqKmvtLa3v8DDxMXGx8jJzs/Q1tfd4Ojq7/X29/j5+/3iGCLeAAAACXBIWXMAADLAAAAywAEoZFrbAAApe0lEQVR4Xu3d94MU5R3H8UXFjgVbNLFHDZYkQIpJNLFiDSqKvY0iFsAeC1gxokFAERVbMEG9I/9l7vnM97w9bsvMfmd2n2fm/fqBO2bb7LPPe3d2b3e2M1mLl55+7oUX/2bFn665/qY1a+99IAOKe+DetWtuuv6aP6/87cUXnnv60sU2q1pm0ZKzLrty9X02JkAV7lt95WVnLVlkc6z5jjz5opWr1tqVB6q3dtXKi04+0uZbUx129uV32vUF6nXn5WcfZvOuaQ49Y8Uddi2B8bhjxRmH2vxrikNOXb7art18j298+bUt72x9/8Mdn+zZ+9W+/T8Cxe3f99XePZ/s+PD9re9see3ljY/brJpv9fJTD7F5mLyjLrnRrlW39S++uW331zYmQBW+3r3tzRfX2wzrduMlR9lsTNii81fZ1fnJptff27mXRyDUZf/ene+9vslm209W/TLt1/dO+cuDdk3Mhrd2fWfXGKjTd7ve2mCzzjx4xSk2L5Nz/PK77Urkntqy41u7nsA4fLtjy1M2+3J3Lz/eZmdCFi+7zVZf1m/eznMjTMLX2zfPewZ127K03h5xwlW24vL01t12vYBJ2L31aZuLctUJNk/jt/RaW+dg3Rt77AoBk7PnjXU2I4Nrl9pcjdsp3S/cvbLTrgowaTtfsVkZrIr/dYhf3GDrOuPZbfvsWgAx2LftWZubM274uc3ZOJ0z9+6G9e9+aVcAiMeX7869EvH3c2zexueCNbaOWfbUB7bqQGw+mHudfM0FNnfjcubcO8A3bre1BmK0faPN1Cy780ybv/E4+mpbt5mnSTtsjYFY7Zh74nT10TaHI3Hpo7Zi2fMf29oCMfv4eZux2aOX2iyOwWm321plL/FXWaRi90s2a7PbT7OZPGlHXGFrlL3En2WRkj0/1XTFETabJ2rZ/bY6T3xkawik4qMnbPbev8zm8+ScdKutS/Y2H0lCeva/bfM3u/Ukm9MT8jtbj+yFL2zdgLR88YLN4ex3Nqsn4dibbSXW8adZpOuD2be93nyszeyxO/8hW4U3/msrBaTov2/YTH7ofJvbY/YHu/znePUOqdvznM3mP9jsHqclsy86vGJrA6TsHzafb11iM3xsLng4v+SnP7NVAdL2mX329uExv9/1j/nFZpu/txUBUvf9ZpvVf7RZPg7HzX5MaZutBdAE22xerz7OZnrtznskv8RnPrdVAJrh82fyqf3IeTbXa/ar/OLYvkPz/LSd9yub7bX6tV0Y23dootntvF/bfK+RvWtoA9t3aKbPbdfJv7cZX5u/5pfz6g92wUDT/PBqPsn/ZnO+Houuyy/lDbtUoInsLUXX1fjNGIffkl/Gu3aRQDO9m0/0Ww63mV+5Y+7KL+GfdoFAU/0zn+p3HWNzv2In3pOf/7/s4oDm+lc+2e850WZ/pX6WvwPvsV12YUCT7XpM8/3hn9n8r9CJeUrrPrWLAprt0/wTgg9X/sh0TL6B9+ReuyCg6fY+qTl/T8XPmQ7PX3bY9I1dDNB83+RfIH1Xpa/mLcpfDN/0b7sQoA3+ncd0S5V/Z8r/RPskj0pol2/yzbzrrIMK/E1nuI7nSmibvfkLEH+1Etx+r7N7jFfw0D6f5i+NV7TrPPuQBX9XQhvtyqd/JR/BsI/+8W4HtJO9A6KCDweel58T78FDW9l789wfWz8u37cD7wxHe+XvGn/Eu0OVfI9DfF4JbZZ/nmm1NTGifD94r9pZAu2Uf9LWtd+8C3QWG/hAOtrth3wfEI49ui7J3xvOblLQdp+rhIdH39d4vvt9dt4F5Lv6utXKKC3/UpjNdmZAm+U7oRzxK2XO14mfYe+swI8/fp/vHnmkLzs7Nv/WP54sAUH+lOmhUb6GM/8uWp4sAbn8KdPN1kcJ+b6OebIEzMqfMpV+y/hJOtnTPFkCZn2ff3PgSdZIUfnL4XyBJjDnM1VR8oXxZTrRP+wsAASvqItlVkkhR9wfTvKcnQGA3HMhjPuPsE6KuCKcIuND6cB8e1TGFdZJAafpBHzQAjhY/vGL06yU4W4PR1/3Hzs1gFn/1Y6JbrdShro0HDv7wE4MYM4HquNSa2WIox8NR37BTgqg2wshj0ePtloGuzocN/vCTgmg2xfq42qrZaAzddS37YQA5ntbhZxpvQxyZzjiE/vtdADm2/9ESORO62WAfBcPH9nJABzsIzUyfOcPa8LRXrITAVjopRDJGiumr3PCsbI9dhoAC+XvfjjHmunn7+FIPCwBg+iBaci+J38ejpPttlMA6GW3OvmFVdPbDeEoz9sJAPT2fAjlBqump1PCMbKP7fgAevtYpZxi3fSyKhzhWTs6gH6eDamssm56WBoOz3bYsQH0s0OtLLVyFro2HLzRjgygv40hlmutnAVOCIdm2+24APrbrlpOsHYOdlU48Ck7KoBBngq5XGXtHGRxOIyPAAKF5B8KXGz1zKf9eK23IwIYbH0Ipvf+vW4LB/Elz0Ax+kro26yeeY4Ph2Rf2vEADPalijne+um2PBzA32mBovT32uXWT7e7wwF8RQxQlL5E5m7rp0v+Vrx9diwAw+xTMwvflKfdHr9iRwIwnHbV/xcr6CeLHgyLd9pxAAy3M0Tz4CJraNYvw9J1dhQARWiHyAd/HbQ+bcHe+IEytKf+gz55cVRYxi5TgFLynagcZRXlLgmLnrYjAChG32B7iVWUuzEs2mqHAyhmawjnRqtIDglL2P0QUFK+Q6JDrKPg1LCAt4gDZenN4qdaR4Hei7fZDgVQ1OaQTvd78laHBXw4HShLH1Xv2oProeH/2dd2KICivlY7h1pJnc4Z4b/s6AEoT7t9OMNK6nRWhP9uscMAFLclxLPCSup07gj/ZReTQHna6eQdVlLnsPC/7Fs7DEBx36qew6yls8N/NthBAMrYEPI521q6PPznLTsEQBlvhXwut5b0zem77BAAZewK+di3qh8Zfs++s0MAlPGd+jlSLZ0cft1kBwAoZ1MI6GS1dFH49XVbDqCc10NAF6mlleHX92w5gHLeCwGtVEva1QN7IAJGo70R5Tt9WBt+3WvLAZSzNwS0NqS0KPyW7bflAMrZr4LCXvKWhF/4TC0wKn22dslMS2eFX160pQDKejEkdNZMS5eFX960pQDKejMkdNlMS1eGX/iuGGBU+u6YK2da0r4e2J0XMCrt2Cvs8+G+8Av7egBGpX0+3NfpLA4/H7eFAMp7PES0uLM0/NhoywCUtzFEtLRzevjxsi0DUN7LIaLTO+eGH6/ZMgDlvRYiOrdzYfjB/ryA0Wm/Xhd2Lg4/3rFlAMp7J0R0cee34QffvASMTt/C9Jv8k4Dv2zIA5b0fIlrR+XP48aEtA1DehyGiP3WuCT/Y/zEwOu0H+ZrO9eHHJ7YMQHmfhIiu79wUfuyxZQDK2xMiuqmzJvxgbw/A6LTHhzX5nlO+smUAyvsqRLS2c2/4sc+WAShvX4jo3s4D4Qd7IQJGpz0RPdAJ/2a2CMAoVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES4CbKqIlwE0V0RLgpopoCXBTRbQEuKkiWgLcVBEtAW6qiJYAN1VES1MzplM3cx3s6mASVFGrW5qaPnDgf81xYHrarhjGTBW1tqWpRmU0h54mQRW1s6WpZnZkyGnsVFELW2p2SDlqGi9V1LqW2lBSwIPTOKmilrXUlpICahofVdSullpUUkBM46KK2tTStE2xFqGm8VBF7WmpTZt3c4hpLFRRa1pq4YNSjprGQBW1paXWpkRM46CKWtJSK7fvZhFT7VRRK1pq51OlOQdsHFAXVdSGlqZsSrUXMdVMFbWgJVKawUcyaqWKmt8SKQkx1UkVNb4lUjLEVCNV1PSWSOknxFQfVdTwlkipCzHVRhU1uyVSmoeY6qKKGt0SKR2EmGqiiprcEiktQEz1UEUNbomUeiCmWqii5rZESj0RUx1UUWNbIqU+iKkGqqipLRVP6UDVOz21812ovvdrhz3P2oUMR0zVU0UNbaloSgdq2HewnfVCdX/2Ybrg2+GJqXKqqJktFUzpQC2zys58ofo/R1Tw0YmYqqaKGtlSsZTqKWmiLRX9/DAxVUwVNbGlYinVNrPt/BcaR0sFayKmaqmiBrZULKX6ZpNdwELjaYmYJkAVNa+lQinVtX0X2EUsNKaWiGn8VFHjWiqWkh25FnYZC42rJWIaO1XUtJYmn1IELRHTuKmihrUUQUoxtERMY6aKmtVSDClF0RIxjZcqalRLUaQUR0vFYhrrGjWZKmpSS3GkFElLxDROqqhBLUWSUiwtEdMYqaLmtBRLStG0REzjo4oa01I0KcXTEjGNjSpqTEs2MwYaS0oRtURM46KKmtJSkY/ujCelmFoipjFRRQ1pqUhK45oydnELTWLOFtr0JSYvVdSMlmJKKa6WiGksVFEjWooqpchaIqZxUEVNaCmulGJriZjGQBU1oKXIUoquJWKqnypKv6XYUoqvJWKqnSpKvqXoUoqwJWKqmypKvaX4UoqxJWKqmSpKvKUIU4qyJWKqlypKu6UYU4qzJWKqlSpKuqUoU4q0JWKqkypKuaU4U4q1JWKqkSpKuKVIU4q2JWKqjypKt6VYU4q3JWKqjSpKtqVoU4q4JWKqiypKtaV4U4q5JWKqiSpKtKWIU4q6JWKqhypKs6WYU4q7JWKqhSpKsqWoU4q8JWKqgypKsaW4U4q9JWKqgSpKsKXIU4q+JWKqnipKr6XYU4q/JWKqnCpKrqXoU0qgJWKqmipKraX4U0qhJWKqmCpKrKUEUkqiJWKqlipKq6UUUkqjJWKqlCpKqqUkUkqkJWKqkipKqaU0UkqlJWKqkCpKqKVEUkqmJWKqjipKp6VUUkqnJWKqjCpKpqVkUkqoJWKqiipKpaV0UkqpJWKqiCpKpKWEUkqqJWKqhipKo6WUUkqrJWKqhCpKoqWkUkqsJWKqgipKoaW0UkqtJWKqgCpKoKXEUkquJWLyU0Xxt5RaSum1RExuqij6lop8q35cN7Ot1ELxzkZiclJFsbeUXkoptkRMTqoo8pYSTCnJlojJRxXF3VKKKaXZEjG5qKKoW0oypURbIiYPVRRzS2mmlGpLxOSgiiJuKdGUkm2JmEaniuJtKdWU0m2pWEwH7MjoooqibSnZlBJuiZhGpYpibSndlFJuiZhGpIoibSnhlJJuiZhGo4ribCnllNJuiZhGooqibCnplBJviZhGoYpibCntlFJviZhGoIoibCnxlJJvqWBMU3ZszFBF8bVU5JaMelbaOi6USkvFYvofMc1RRfG1ZLfUIHFPSlvJhZJpqWBM6Vyf2qmi6FoqsIUX+W1oa7lQQnOvWEzUNEsVRdeS3UoDxH4D2moulNLMKxgTNeVUUWwtDX9Yiv7Ws/VcKKl5VzSm/x2Y5olTlC0V2MI7EDtbzx7sCImwlS7GTlPadDCVfI2qKL2W0EgzVdkcSJEqiqwlG1i0U7I9qaK4WuJhCUnmpIpoCbE5kF5Oqiiulmww0XapvTaoimgJUUrrqZMqiqqlwn/TQAukVJMqoiVEK52YVFFULfHSA+ZLpSZVREuIWho1qSJaQtySiEkV0RIil8IneFURLSF68T80qSJaQvyij0kV0RISEPtuj1QRLSEFkT9pUkW0hDREHZMqoiUkIuaYVBEtIRURx6SKaAnJiDcmVURLSEe0MakiWkI6on1pXBXREhISa0yqiJaQkkjfAaGKaAlJiTMmVURLSEuUrz+oIlpCWqJ8yqSKaAmJiXErTxXRElIT4VaeKqIlpCbCrTxVREtITnxbeaqIlpCe6LbyVBEtIT3RbeWpIlpCgmJ7YFJFtIQExfbApIpoCSmK7IFJFdESUhTZA5MqoiUkKa4HJlVES0hSXA9MqoiWkCabM3FQRbSENEW1kaeKaAlpimojTxXREhJlkyYKqoiWkKiYNvJUES0hUTFt5KkiWkKqbNbEQBXRElIV0UaeKqIlpCqijwSqIlpCqiJ6wqSKaAnJsmkTAVVES0hWPE+YVBEtIVm01B8toYx4XnxQRbSEZMXz4oMqoiUki5b6oyWUYvNm8lQRLckBmda/tggDaagmPWLRvPigitre0sx0mFpwi0xNTU+TVB8xjRgt9TXelg4cWDgn5plmm3O+6EaMlvoa4y0xbFbMoqdZMY4YLfU1rlvhQKnbgJyiHTFa6mssN0G5aZFr97OneEcsmj/WqqK2tTTKvJDWPjjFPGK01Fftoz/yvAhaWVPcI0ZLfdU89u6Rb11NsY8YLfVV68hX8oaTVtUU/4jRUl81jrtrW6VLe16FSGHEaKmv+lqqcNBb8tCUxIjRUl91DXrF7yduQU2JjBgt9VXTkFc+4o2PKZURo6W+ahnxqrb7u03ZeTdTOiNGS33V0VJNnxdr8ENTQiNGS33VMNy1jXZjY0ppxGipr+pHu4atlVkNjSmpEaOlviof7BonRkOfNKU1YrTUV9UtlZkYU8b+W0QDY0psxGipr2pbKvgcempqev4eCw4cmJ4uOEEa9iaI5EaMlvqqtKUiE2Nqqu9tW2x2NCqm9EaMlvqqdBPAzrO/qaE70Bl+UzVqM8+uU3/RjRgt9VXlOA+7j+x//9rtwLBbq0ExJThitNRXhcM8ZGKU2Joccns1JqYUR4yW+qpulAcOcrE72DmDb7GqX3yckCRHjJb6syFyGzjGI9yUVZ9ffNIcMVrqr+TdXz+DhrjsXWxu4LOAitZ6khIdMVrqr6IxtnPrZeS7xGbHZFekl5hHjJb6q+bBv/8Ij3YXmxvwSYTkX39IdcRoqb9Khrj/ADtTre2MJy3ZEaOlAWyMPGq8/fqfddJbeemOGC0NUMEI2zktVMF5973tkt7Ks+uwUPQjRksD+G+9vsNbyR1h37esJbyVl/CI0dIA/nsrO6MFKpkYA6ZGRec/AXYFFkhgxGhpEBukkfUb3cqmer+pkexWXsojRkuDOG/B2idG/6lR4UWMU9IjRkuDOO+s7FwOVumzmT43YKIPTLb2B0tjxGhpINedVZ+xrfiFgT6XkuQDU9ojRksDue6sev+hveKJ0e9iknxgSnvEaGkwG6ZR9BlaO7RCvadGgg9MiY8YLQ3muE/sPbQ1TPHez6YTfGBKfMRoaQgbp/J6j2zl2yvB2OZgvVIfMVoaYuSbsvfI2oEV67nNktwDU+ojRkvD2ECVZiefr5Y72X7bLKk9MNlqz5fQiNHSMCPeWfUc2JomRp+72cRaSn7EaGmo0Qa4521lh1Wv591sYht5yY8YLQ010gD3vKlqu5NtwgNT+iPW8xwnQRVF2dJIN2jP+yg7rA7pPzClP2K0VMAI91Z2ynlqvJPtfUMm1ZKt8zxpjZidx+SpokhbKh9Tzzs9O6wePS8xoY28BoyYncXkqaJYWyp9d9Vrg6XWO9ned7MJtZT+iEXz0kPcLZW+VScwM3rdzSa0kZf+iNFSQSVvVjvVPHZQbexi5rGDEmArPI8dVBu7mHnsoBHYGURAFcXbUrmYet3j1Xwnm/hGXvojFs/DUvQtlbplJ7DB0ns6JtNS+iNGSyWUuGl7jasdVCO7oG7JPGFKfsQiSimBlkrEZCfoNoZZ3WOTJZmWbH27pTVidvIoqKK4Wyoekx2/W+0bLJO6b6+GrW63pEYspoelJFoqevNO6JlLwk+Ykh8xO3EcVFHsLRWsaVIPEHZR3RJpKfUR6/WK4OSoovhbKhTTpGZGj1t0DBtKVUh8xKLawkunpR+nhg92j6Edy4sA6b74kPaIRZZSOi0VuOea1OPDpGakX9IjFltKKbU09Hae1Mzo8VSalgaqYsSiSymtlobc0nacbmN5DSDdlmxtu6UyYj3uBiZNFaXT0sCa7BjdJjUzxvIM3s9WtlsaIzbgG6UnRxWl1NJMTf1yssO70dJAtrLdUhixKEtKsqUZvXOyA7vZITWzC+tmh0TOVrabHVIzu7BudshwkZaUakvB9PTBd6F2QDc7pGZ2Yd3skMjZynazQ2pmF9bNDhki2pBmqKIkW5Kpqek5tqyb3QI1swvrZqsUOVvZbnaVamYX1s1WaYCpqYhDmqGK0m1pGLvpamYX1gh2lWpmF9YsqoiWfOzCGsGuUs3swppFFTW3pYm9KpUsRmxkqoiWXGipLFpKEDOjLEZsZKqIllzie2eYAyM2MlXU3JbG8k7NRs0MRmxkqqi5LY3lPaaNmhmM2MhUES25xP0XxJIYsZGpoua2NJY/l9hFNYRdqVrZRTWMKmpwS2N4Kt2wF6UYsVGpIlryaNjGPyM2KlXU4JbGsPnfsJnBiI1KFTW4pTFs/tsFNYZdrRrZBTWNKmpyS7VvsjRu458RG5EqanJLtW+yNG6DhREbkSpqcku1b7LYxTSIXbHa2MU0jipqdEs1b7I08E6WERuNKmp0SzVvsjRwZjBio1FFjW6p5k0Wu5BGsatWE7uQ5lFFzW6p1nc+N/JOlhEbiSpqdku13s3aRTSMXbla2EU0kCpqeEs13s029E6WERuFKmp4SzXezdoFNI5dvRrYBTSRKmp6S7XdzTb2TpYRG4EqanpLtf3FxM6+gRix8lRR41uq6S8mDb6TZcTKU0WNb6meu9lGTwxGrDRV1PyWankybWfdUHYlK2Vn3VCqqAUt1bDN0uw7WUasNFXUgpaqf2Wq4RODEStNFbWhpaqfADQ+JUasLFXUipaqnRpN/WzoPIxYKaqoHS1VOjXsLBuOEStDFbWkpQqfTTdzx6MLMGJlqKKWtFTd1GhJSoxYKaqoLS1VNTVakxIjVoYqak1LlTwDiPlr8WvAiBWlilrUkn9qtOIVvG6MWEGqqE0tef8E2YK/Kx2MEStGFbWqJd/UaNf2nWHEClFF7WrJsdXSsqdKcxixAlRR21oa9Y62hdt3sxix4VRR61oaaW607kWH+RixYVRRC1v6cbrk3Gjt5t1PGLEhVFEbWyo3NygpYMQGUkXtbKn43KCkWYzYAKqorS3NGD45CGk+RqwfVdTilmYMmhwHpihpIUasJ1XU7pZmTE1PL/gLygE6GoARW0gVtb6l3NTUzAyZMfOTigphxLqpIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdVREuAmyqiJcBNFdES4KaKaAlwU0W0BLipIloC3FQRLQFuqoiWADdV1Hkg/LvfFgEob3+I6IHOveHHPlsGoLx9IaJ7O2vDj69sGYDyvgoRre2sCT/22jIA5e0NEa3p3BR+7LFlAMrbEyK6qXN9+PGJLQNQ3ichous714QfO2wZgPJ2hIiu6fwp/PjQlgEo78MQ0Z87K8KP920ZgPLeDxGt7Pwm/NhqywCUtzVE9NvOxeHHO7YMQHnvhIgu7lwYfmyxZQDK2xIiurBzbvjxmi0DUN5rIaJzO6eHHy/bMgDlvRwiOr2zNPzYaMsAlLcxRLS0szj8eNyWASjv8RDR4k7nvvDza1sIoKyvQ0L3dTqd1eGX3bYUQFm7Q0KrZ1q6MvyyzZYCKGtbSOjKmZYuC7+8aUsBlPvOiymZbOCr+8aEsBlPViSOismZaWhF/W21IAZa0PCS2ZaWlR+IU9EQEj0l6IskUzLeV7T2GPD8BotLeHtSGlzqrw605bDqCcnSGgVWppZfj1PVsOoJz3QkAr1dJF4dfXbTmAcl4PAV2klk4Ov26y5QDK2RQCOlktHRl+zb6zAwCU8Z36OVItde4Mv++yQwCUsSvkc2eeUufy8J+37BAAZbwV8rncWjo7/GeDHQKgjA0hn7OtpcPCf7Jv7SAAxX2reg6zljp3hP+xH2SgPO3/+A4rqZPvu5X9egHlaX9eK6ykTueM8N+n7DAAxT0V4jnDSup0Dg3/ZZ8PQGna10N2qJU0Q/t82G6HAihqe0gn7Oth1vKwYLMdCqCozSGd5dZRcGpYwGdrgbL0mdpTraPgkLCAHXsBJWl3Xtkh1pHcGJbwLUxAOfrmpRutotwlYdHTdjiAYp4O4VxiFeWOCouyPXYEAEXsUTdHWUVGO314w44BoIg3Qjb5rh7mnB8WrrNjAChiXcjml9bQrEUPhqXsjQgoTnsgelB7xuv2l7D4FTsOgOFeCdFcYQXNOSUszvbZkQAMs0/NnGIFdbk7LOe7Y4Ci9F0xd1s/3fSevGftWACGeTYk0/1evFnHhwOyL+1oAAb7UsUcb/3Mc1s45F07HoDB3g3B3Gb1zLcsHMSbxYFi9BbxZVbPfIvDQdkHdkQAg3ygXhZbPQe5KhzGbh+AIrSjh6usnYOdEA7ko+pAAfpwenaCtbPAteHQjXZcAP1tDLFca+UstDQczE4ngaG0i8lsqZXTgz55wd9rgWH0d9qDP23RLX9T3sd2dAC9faxSerwVb84N4RjP2/EB9PZ8COUGq6a3X4SjsEMiYKB890M/t2r60B5cX7JTAOjlpZDJ362Zfs4JR2InKsAA+S5TzrFm+loTjsUDE9CfHpbWWDH9XRCOln1kJwJwsI/UyAVWzAD6VvUn9tvJAMy3/4mQyOw3pw9yZjhi9radDsB8b6uQM62Xga7WUb+wEwLo9oX6uNpqGezoR8NxX7BTAuj2Qsjj0aOtliEuDUfmQ4FAD/lHAC+1Voa6PRx73X/sxABm/Ve7Pb7dShnutHB09tQPLKC98WenWSkFXKETfGonB5DL3/GwcLfH/R1xfzjFc3Z6ALnnQhj3H2GdFKL9e2X/sDMAEPxDXfTej1dft+pEn9lZAPjxx89Uxa3WSFEn6VRPf29nAuB7fTttdpI1UtjvdLLNdi4ANquJ31khJdysE/IlMkBOXxGT3Wx9lHHsQzrp53ZGQLt9rh4eOtb6KEVfB509w1MmYObJ0jPq4Xyro6Q/6MQ8ZQJmnyz9wdooLX9hnKdMQP5kqezL4XOWPKwz4CkT2i5/svTwEitjBPnOHzb8YGcItNMPG1RCgV089PdHncWrdo5AO72qDv5oVYxI+57k4xdotfyDFqutiVEd94jOhq+ERnvpS56zR46zJkZ2ns4n+6edLdA2/8wTOM+KcPhVfk7/sjMG2uVfeQC/sh5cfp2f1y47a6BNduXT/9dWg1P+lvHH+Mg62ufTxzT7f28tuP1VZ7dur5090BZ7tduh7G9WQgWu0xk++Y1dANAO3zypmX+ddVCFRbfoLDf92y4CaIN/b9K8v2WRdVCJw+/SmW7ikQnt8U2e0l2HWwUVOeYene2TPGdCW+zNN/DuOcYaqMyJ+XvG1/FqHtrh0/xlh4dPtAIq9LM8psf4OxPaYFf+YvjDP7P5X6kT88083gGBFrB3O9xTw6NScEz+AgTvzUPj2Xvw7qr8udKsw/OXxnnXOBouf2d4dkvFr+B1W5T/0ZbPM6HR8s8rZddV+nelBf6WX8qrfGwdTfVD/ina7K8252vz+/xyNrBDFTTT5/m+HUbZ13FZ9hEMdvWFRsp33lXZhywGsw8HZpvZoyua5vt8l5IVffRvuPPyfUBkz7Cdh2b5PN/RcfZIBR9IL+a4fO9EbOehWWa371a7d5NSQr7fPLbz0CA/bd8594NX1gX5u/Oyp/kaTjTDZ/m3/mUPu/bOOool+Y77+YJoNEP+tc5Zdqtjn+Ejy79SJsue42MYSN2nz9lsHvlLYXzOz785MMve+I+tEZCi/9ibhrKHRvyqMr9j8++0zbJ1H9hKAen5IP/UX5bdPNIXaFYk33XejBe+sPUC0vLFCzaHx/GuoUFOmn0JInt7v60bkI79b9v8zW49yeb05Cy739bliY9s9YBUfPSEzd77l9l8nqgjrrDVyV7aY2sIpGDPSzZzsyuOsNk8aafdbmuUvbTb1hKI3e6fSrr9NJvJMbj0UVur7PmPbU2BmH38vM3Y7NFLbRZH4uirbcWy7NkdtrZArHY8a7M1y64+2uZwPM6809YtyzZutzUGYrR9o83ULLvzTJu/cblgja1flj3FH28Rqw+eslmaZWvG/j7Wws75u61jlq1/90tbdSAeX7673mZolq0+x+ZtnH5+g63njGe37bMrAMRg37a5p0nZDb+wORuvU1bZugav7LRrAUzazldsVgarTrH5Grel19r6Buve4A+4mLw9b8y+gTW4dqnN1fidcJWtszy9lb/gYpJ2b7XPzOauOsHmaRoWL7vNVlzWb97+tV0vYJy+3r557tWGGbctW2xzNCHHL7/bVj/31JYd39r1A8bh2x1b5l7/Du5efrzNzuSccsWDdiXMhrd2fWfXE6jTd7vesp0Zz3rwL2m83tDPol92v6wnm15/b+dePuyEuuzfu/O91/Ovbe6y6vx6v7ViLI665Ea7Ot3Wv/jmtt08h0KVvt697c0X5z07MjdecpTNxuQdcury2V29zvf4xpdf2/LO1vc/3PHJnr1f7ePRCmXs3/fV3j2f7Pjw/a3vbHnt5Y2P26yab/XyUw+xedgUh56x4g67dsB43LHijENt/jXNYWdfPvducqBOd15+9mE275rqyJMvWrlqrV1foHprV6286OQjbb4136IlZ1125er77MoDVbhv9ZWXnbWkAa/XjWLx0tPPvfDi36788zXX37Rm7b0P2JgARTxw79o1N11/zZ9W/ObiC889felE39DQ6fwfekSttlB4ajcAAAAASUVORK5CYII="), Bitmap(origin = {-2, 1}, extent = {{-98, 99}, {102, -101}}, imageSource = "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rHY8a7M1y64+2uZwPM6809YtyzZutzUGYrR9o83ULLvzTJu/cblgja1flj3FH28Rqw+eslmaZWvG/j7Wws75u61jlq1/90tbdSAeX7673mZolq0+x+ZtnH5+g63njGe37bMrAMRg37a5p0nZDb+wORuvU1bZugav7LRrAUzazldsVgarTrH5Grel19r6Buve4A+4mLw9b8y+gTW4dqnN1fidcJWtszy9lb/gYpJ2b7XPzOauOsHmaRoWL7vNVlzWb97+tV0vYJy+3r557tWGGbctW2xzNCHHL7/bVj/31JYd39r1A8bh2x1b5l7/Du5efrzNzuSccsWDdiXMhrd2fWfXE6jTd7vesp0Zz3rwL2m83tDPol92v6wnm15/b+dePuyEuuzfu/O91/Ovbe6y6vx6v7ViLI665Ea7Ot3Wv/jmtt08h0KVvt697c0X5z07MjdecpTNxuQdcury2V29zvf4xpdf2/LO1vc/3PHJnr1f7ePRCmXs3/fV3j2f7Pjw/a3vbHnt5Y2P26yab/XyUw+xedgUh56x4g67dsB43LHijENt/jXNYWdfPvducqBOd15+9mE275rqyJMvWrlqrV1foHprV6286OQjbb4136IlZ1125er77MoDVbhv9ZWXnbWkAa/XjWLx0tPPvfDi36788zXX37Rm7b0P2JgARTxw79o1N11/zZ9W/ObiC889felE39DQ6fwfekSttlB4ajcAAAAASUVORK5CYII=")}),
    Documentation(info = "<html><head></head><body><div>The VehicleProfile block is designed to replicate the power demand of a vehicle considering a pre-determined drive cycle and vehicle parameters such as weight and frontal area. The generated power profile considers the needs to propel the vehicle plus the aerodynamic drag. The block allows the user to select if regenerative breaking is used or not.</div><div><br></div><div><div>The block enables the user to select from standard testing drive cycles including WLTC Class 1-3 and NEDC. The drive cycles are provided as .mat files in the library directory containing the block.</div></div></body></html>"));
end VehicleProfile;
