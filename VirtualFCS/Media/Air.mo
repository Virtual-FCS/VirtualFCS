within VirtualFCS.Media;

package Air
extends  ExternalMedia.Media.CoolPropMedium(
      mediumName = "HEOS::Nitrogen[0.7]&Oxygen[0.2]&Hydrogen[0.05]&Water[0.05]",

      substanceNames = {"Nitrogen", "Oxygen", "Hydrogen", "Water"}
      
    );
end Air;
