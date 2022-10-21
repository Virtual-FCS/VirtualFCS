within VirtualFCS.UsersGuide;

package Conventions
  extends Modelica.Icons.Information;
  annotation(
    Documentation(info = "<html><head></head><body><p style=\"font-size: 12px;\">This library follows the conventions of the&nbsp;<a href=\"modelica:///Modelica.UsersGuide.Conventions\">Modelica Standard Library</a>, which are as follows:</p><p style=\"font-size: 12px;\">Note, in the html documentation of any Modelica library, the headings \"h1, h2, h3\" should not be used, because they are utilized from the automatically generated documentation and headings. Additional headings in the html documentation should start with \"h4\".</p><p style=\"font-size: 12px;\">In the Modelica package the following conventions are used:</p><ol style=\"font-size: 12px;\"><li>Class and instance names are written in upper and lower case letters, e.g., \"ElectricCurrent\". An underscore is only used at the end of a name to characterize a lower or upper index, e.g., \"pin_a\".</li><li><b>Class names</b>&nbsp;start always with an upper case letter.</li><li><b>Instance names</b>, i.e., names of component instances and of variables (with the exception of constants), start usually with a lower case letter with only a few exceptions if this is common sense (such as \"T\" for a temperature variable).</li><li><b>Constant names</b>, i.e., names of variables declared with the \"constant\" prefix, follow the usual naming conventions (= upper and lower case letters) and start usually with an upper case letter, e.g. UniformGravity, SteadyState.</li><li>The two connectors of a domain that have identical declarations and different icons are usually distinguished by \"_a\", \"_b\" or \"_p\", \"_n\", e.g., Flange_a/Flange_b, HeatPort_a, HeatPort_b.</li><li>The&nbsp;<b>instance name</b>&nbsp;of a component is always displayed in its icon (= text string \"%name\") in&nbsp;<b>blue color</b>. A connector class has the instance name definition in the diagram layer and not in the icon layer.&nbsp;<b>Parameter</b>&nbsp;values, e.g., resistance, mass, gear ratio, are displayed in the icon in&nbsp;<b>black color</b>in a smaller font size as the instance name.</li><li>A main package has usually the following subpackages:<ul><li><b>UsersGuide</b>&nbsp;containing an overall description of the library and how to use it.</li><li><b>Examples</b>&nbsp;containing models demonstrating the usage of the library.</li><li><b>Interfaces</b>&nbsp;containing connectors and partial models.</li><li><b>Types</b>&nbsp;containing type, enumeration and choice definitions.</li></ul></li></ol></body></html>"));
end Conventions;