within VirtualFCS.Media;

package CrackedNH3_CP

  extends ExternalMedia.Media.CoolPropMedium(
    mediumName = "CrackedGasMedium",
    substanceNames = {"Ammonia","Hydrogen","Nitrogen"},
    reference_X = {1,0,0},
    p_default = 1e5,
    T_default = 300);
    
end CrackedNH3_CP;
