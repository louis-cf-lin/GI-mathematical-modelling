# 2D visualisation of simulated slow wave propagations
# ABI GI Group
# 22 September 2009
# Auckland, New Zealand

# Set the output directory, and time to start and end the animation

# Input, modify this variable to point to where the output files are stored
$OUT="\output";  
# Output
$IMAGE = "image"; unless (-d $IMAGE) {mkdir $IMAGE};

# Animation time parameters

$TSTART= 620;
#$TSTART= 840;
$TEND= 1220;
$dT =  1;

#$TSTART=200;
#$TEND= 300;
#$dT =  20;

# Read in the node and elment files for the slice
gfx read node $OUT/stomach;
gfx read elem $OUT/stomach;
gfx mod g_elem stomach line material white;

$FILENAME=sprintf("field%05d.exelem.gz",$TSTART);
system( "zcat $OUT/$FILENAME > tmp.exelem" );
gfx read elem tmp.exelem
system("rm tmp.exelem");


# Setup physical properties of the solved grid points
gfx mod g_elem stomach element_points glyph cube_solid general size "0.05*0.05*0.05" centre 0,0,0 use_elements cell_corners discretization "4*4*4" native_discretization potential select_on material default data potential spectrum default selected_material default_selected;
# Colour bar
gfx mod spectrum default clear overwrite_colour;
gfx mod spectrum default linear reverse range -75 -25 extend_above extend_below rainbow colour_range 0 1 ambient diffuse component 1;

#gfx modify g_element stomach surfaces select_on material red data potential spectrum default selected_material default_selected render_shaded;


# Read dipole solution (the properties MUST be kept consistent throughout the code)
#$TDIPOLE=$TSTART+1; #dipole labels start from 1 not 0.
#gfx read data $OUT/dipole_all;
#gfx mod g_elem dipole data_points glyph sphere general size "0.1*0.1*0.1" coordinate center.$TDIPOLE material green;
#gfx mod g_elem dipole data_points glyph arrow_solid general size "0*0.2*0.2" centre 0.0,0,0 coordinate center.$TDIPOLE orientation orient.$TDIPOLE #scale_factors "1*0*0" material green;

# Create graphic window and modify display (adjust view_angle to 'fit' the image to window)
gfx create window 1
#gfx mod win 1 layout 2d ortho_axes -z -y eye_spacing 0.15 width 512 height 512;
#gfx modify window 1 view parallel eye_point 0.1585 0.1585 -0.914498 interest_point 0.1585 0.1585 0 up_vector -0 1 -0 view_angle 27 near_clipping_plane 0.00914498 far_clipping_plane 3.2681 relative_viewport ndc_placement -1 1 2 2 viewport_coordinates 0 0 1 1;
gfx mod win 1 set slow;
gfx update window 1
#gfx mod win 1 background colour 1 1 1; # to white background colour if required

gfx modify window 1 layout 2d ortho_axes -z y eye_spacing 0.15 width 512 height 516;
gfx modify window 1 background colour 0 0 0 texture none;
gfx modify window 1 view parallel eye_point 30 30 -173.091 interest_point 30 30 0 up_vector -0 1 0 view_angle 28.8189 near_clipping_plane 1.73091 far_clipping_plane 618.568 relative_viewport ndc_placement -1 1 2 2 viewport_coordinates 0 0 1 1;
gfx modify window 1 set transform_tool current_pane 1 std_view_angle 40 normal_lines no_antialias depth_of_field 0.0 slow_transparency blend_normal;

#gfx modify window 1 background colour 1 1 1 texture none;

$STEP = 0;

# Loop over all the solutions and animate
sub anim 
{
   foreach ($TIME=$TSTART;$TIME<$TEND;$TIME+=$dT) 
   {
   
      print( "Time $TIME of $TEND\n" );
      #gfx print file img_hi_res.png format rgb width 4096 height 4096
      #gfx print file $IMAGE/$STEP.jpg format rgb width 1024 height 1024
      gfx print file $IMAGE/$STEP.jpg format rgb width 512 height 512
   
      $FILENAME=sprintf("$OUT/field%05d.exelem.gz",$TIME);
      system( "zcat $FILENAME > tmp.exelem" );
      print "   Reading $FILENAME\n";

      # Update potential field
      gfx read elem tmp.exelem;
      
      # Delete the last dipole glyph
      #gfx mod g_elem dipole data_points glyph sphere general size "0.1*0.1*0.1" coordinate center.$TDIPOLE material green delete ;      
      #gfx mod g_elem dipole data_points glyph arrow_solid general size "0*0.2*0.2" centre 0.0,0,0 coordinate center.$TDIPOLE orientation orient.$TDIPOLE #scale_factors "1*0*0" material green delete;

      gfx update window 1
      
      # Add the new dipole glyph
      #$TDIPOLE=$TIME+1;
      #gfx mod g_elem dipole data_points glyph sphere general size "0.1*0.1*0.1" coordinate center.$TDIPOLE material green;     
      #gfx mod g_elem dipole data_points glyph arrow_solid general size "0*0.2*0.2" centre 0.0,0,0 coordinate center.$TDIPOLE orientation orient.$TDIPOLE #scale_factors "1*0*0" material green;

      gfx update window 1
      
      $STEP = $STEP + 1;
      
      gfx print file $IMAGE/$TIME.jpg format rgb width 512 height 512
   }

   system("rm tmp.exelem");
}




print "Type \"anim\" to animate solutions.\n";



