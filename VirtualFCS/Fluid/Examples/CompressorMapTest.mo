within VirtualFCS.Fluid.Examples;

model CompressorMapTest
  extends CompressorTest(redeclare Fluid.CompressorMap compressor);
  annotation(
    Documentation(info = "<html><head></head><body>Same as CompressorTest, but using a more advanced CompressorMap.</body></html>"));

end CompressorMapTest;
