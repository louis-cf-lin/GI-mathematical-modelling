#  The value is [ 0.14000E+01]: 1.65
# The value is [ 0.14000E+01]: 1.42

# 2D model of Corrias & Buist ICC & SMC model a single PCB
# Peng Du
# 22 Feb 2012
# Auckland, New Zealand

# Define output directoary
$OUT="output"; unless (-d $OUT) {mkdir $OUT};

# Define output conditions
$EXPORT=1;
$HISTORY=1; #to export to unemap
$HISTFILE="$OUT/stomach";

system(" rm $HISTFILE.iphist ");

# Read in node and element
fem define para;r;min;
fem define coor;r;2d_coor;
fem define node;r;2d_slice;
fem define base;r;2d_slice;
fem define elem;r;2d_slice;
fem group element 1..45 as ELEM_all;

# Define fibre
fem define fibr;r;2d_slice;
fem define elem;r;2d_slice fibre;

# Allocate grid points
fem define grid;r;2d_slice;
fem update grid geometry

# Group ipgroups
fem group grid external as BOUNDARY;
#fem group grid grid 1676..1678,1737..1739,1798..1800,1859..1861 as STIM;
#fem group grid grid 1676..1678,1737..1739,1798..1800,1859..1861 as CZ;

# Define equations and cell model
fem define equa;r;2d_slice
fem define cell;r;2d_slice

# Define material and cell properties
fem define mate;r;2d_slice
fem define mate;r;mfiles/low-na cell

# Define iptime, initial conditions
#fem define time;r;2d_slice
fem define init;r;2d_slice

# Define solvers
fem define solv;r;LU_Euler;
#fem define solv;r;LU_Euler class 2;

if($EXPORT)
{
   fem export node;"$OUT/stomach" as stomach;
   fem export elem;"$OUT/stomach" as stomach;
   fem export elem;"$OUT/grid"    as stomach grid_numbers;
   fem export elem;"$OUT/field"   as stomach field;
}

if ($HISTORY)
{
   # Identify the index of the export cell variable
   #fem inquire cell_variable Vm_SM return_variables VM_ARRAY,VM_IDX;
   #fem inquire cell_variable Vm return_variables VM_ARRAY,VM_IDX;
   # Open a history file.
   #fem open history;$HISTFILE write variables yqs niqslist 1..6 binary;
   fem open history;$HISTFILE write variables yqs niqslist 1..6;	
   #fem open history;$HISTFILE write variables yqs niqslist 1;	
   
}

# Solve (Tstart = start recording time;Tend = end time; dt = dt all in second)
# Time units in seconds
#$Tstart = 600000;

#$Tstart = 100000;
#$Tend = 130000;

$Tstart = 100000;
$Tend = 130000;


$dt = 10;
$STEP_TOTAL= ($Tend - $Tstart)/$dt;
$STEP = 0;

for ($time=0;$time<=$Tend;$time+=$dt) { 
    if ($time==0) {
    	fem solve to 0;	
    }
    else {
    	fem solve restart to $time;
    }
   print "*** Time $time\n***"; 
   if ($time >= $Tstart) {
   	if ($EXPORT) {
		# Export Vm
        	$FILENAME=sprintf("field%05d",$STEP);
		fem export elem;"$OUT/$FILENAME" field as stomach;
        	system( "gzip -f \"$OUT/$FILENAME.exelem\" &" );

		# Export Phi_e
		#$FILENAME_PHI_E =sprintf("PHI_E_field%05d",$STEP);
        	#fem export elem;"$OUT/$FILENAME_PHI_E" field as stomach_E class 2;
        	#system( "gzip -f \"$OUT/$FILENAME_PHI_E.exelem\" &" );

		# Export current dipole (mA/mm2)
        	# print "*** Calculating dipole sources\n";
         	#fem def source;c grid one_dipole fixed_position grregion 1 grclass 1 time $STEP;

		print "*** Exporting at Time $time and Step $STEP of ${STEP_TOTAL}\n";

        	$STEP = $STEP + 1;
   		if ($HISTORY) {
         		# Write history information.
			#fem write history time $time variables yqs niqslist 1..6 class 1 hist binary;
			fem write history time $time variables yqs niqslist 1..6 hist;
			
   		}
   	}
   }
}


list time;

#fem define sour;w;dipole grid grregion 1 grclass 1;
#fem export sour;$OUT/dipole_all as dipole;

fem close history 


if (0)
{
   # Close the history file.
   fem close history  binary;
   $SIGNALFILE1="$OUT/SW_1_32";
   $SIGNALFILE2="$OUT/SW_33_64";
   $SIGNALFILE3="$OUT/SW_65_96";
   $SIGNALFILE4="$OUT/SW_97_128";
   $SIGNALFILE5="$OUT/SW_129_160";
   $SIGNALFILE6="$OUT/SW_161_192";
   $SIGNALFILE7="$OUT/SW_193_224";
   $SIGNALFILE8="$OUT/SW_225_256";
   $SIGNALFILE9="$OUT/SW_middle_vertical";
   
   $COMPPT1="1,245,489,733,977,1221,1465,1709,1953,2197,2441,2685,2929,3173,3417,3661";
   $COMPPT2="5,249,493,737,981,1225,1469,1713,1957,2201,2445,2689,2933,3177,3421,3665";
   $COMPPT3="9,253,497,741,985,1229,1473,1717,1961,2205,2449,2693,2937,3181,3425,3669";
   $COMPPT4="13,257,501,745,989,1233,1477,1721,1965,2209,2453,2697,2941,3185,3429,3673";
   $COMPPT5="17,261,505,749,993,1237,1481,1725,1969,2213,2457,2701,2945,3189,3433,3677";
   $COMPPT6="21,265,509,753,997,1241,1485,1729,1973,2217,2461,2705,2949,3193,3437,3681";
   $COMPPT7="25,269,513,757,1001,1245,1489,1733,1977,2221,2465,2709,2953,3197,3441,3685";
   $COMPPT8="29,273,517,761,1005,1249,1493,1737,1981,2225,2469,2713,2957,3201,3445,3689";
   $COMPPT9="33,277,521,765,1009,1253,1497,1741,1985,2229,2473,2717,2961,3205,3449,3693";
   $COMPPT10="37,281,525,769,1013,1257,1501,1745,1989,2233,2477,2721,2965,3209,3453,3697";
   $COMPPT11="41,285,529,773,1017,1261,1505,1749,1993,2237,2481,2725,2969,3213,3457,3701";
   $COMPPT12="45,289,533,777,1021,1265,1509,1753,1997,2241,2485,2729,2973,3217,3461,3705";
   $COMPPT13="49,293,537,781,1025,1269,1513,1757,2001,2245,2489,2733,2977,3221,3465,3709";
   $COMPPT14="53,297,541,785,1029,1273,1517,1761,2005,2249,2493,2737,2981,3225,3469,3713";
   $COMPPT15="57,301,545,789,1033,1277,1521,1765,2009,2253,2497,2741,2985,3229,3473,3717";
   $COMPPT16="61,305,549,793,1037,1281,1525,1769,2013,2257,2501,2745,2989,3233,3477,3721";
   
   $COMPPT17="$COMPPT1,$COMPPT2";
   $COMPPT18="$COMPPT3,$COMPPT4";
   $COMPPT19="$COMPPT5,$COMPPT6";
   $COMPPT20="$COMPPT7,$COMPPT8";
   $COMPPT21="$COMPPT9,$COMPPT10";
   $COMPPT22="$COMPPT11,$COMPPT12";
   $COMPPT23="$COMPPT13,$COMPPT14";
   $COMPPT24="$COMPPT15,$COMPPT16";
   $COMPPT25="30,335,640,945,1250,1555,1860,2165,2470,2775,3080,3385,3690";
    
   fem def export;r;unemap;
   
   fem eval elect;$SIGNALFILE1 history $HISTFILE from grid yqs niqslist 1 elect $COMPPT17 binary;
   fem export signal;$SIGNALFILE1 electrode signal $SIGNALFILE1;
      
   fem eval elect;$SIGNALFILE2 history $HISTFILE from grid yqs niqslist 1 elect $COMPPT18 binary;
   fem export signal;$SIGNALFILE2 electrode signal $SIGNALFILE2;
   
   fem eval elect;$SIGNALFILE3 history $HISTFILE from grid yqs niqslist 1 elect $COMPPT19 binary;
   fem export signal;$SIGNALFILE3 electrode signal $SIGNALFILE3;   

   fem eval elect;$SIGNALFILE4 history $HISTFILE from grid yqs niqslist 1 elect $COMPPT20 binary;
   fem export signal;$SIGNALFILE4 electrode signal $SIGNALFILE4;
   
   fem eval elect;$SIGNALFILE5 history $HISTFILE from grid yqs niqslist 1 elect $COMPPT21 binary;
   fem export signal;$SIGNALFILE5 electrode signal $SIGNALFILE5;
   
   fem eval elect;$SIGNALFILE6 history $HISTFILE from grid yqs niqslist 1 elect $COMPPT22 binary;
   fem export signal;$SIGNALFILE6 electrode signal $SIGNALFILE6;

   fem eval elect;$SIGNALFILE7 history $HISTFILE from grid yqs niqslist 1 elect $COMPPT23 binary;
   fem export signal;$SIGNALFILE7 electrode signal $SIGNALFILE7;   

   fem eval elect;$SIGNALFILE8 history $HISTFILE from grid yqs niqslist 1 elect $COMPPT24 binary;
   fem export signal;$SIGNALFILE8 electrode signal $SIGNALFILE8;     
   
   fem def export;r;unemap2;
   fem eval elect;$SIGNALFILE9 history $HISTFILE from grid yqs niqslist 1 elect $COMPPT25 binary;
   fem export signal;$SIGNALFILE9 electrode signal $SIGNALFILE9;    
      
   #if($TESTING)
   #{
   #    fem conv signal from bin infile $SIGNALFILE outfile $SIGNALFILE;
   #}
   # Tidy up temporary files
   system(" rm $HISTFILE.binhis ");
}

quit



# To convert signal to txt
#/hpc/cmiss/unemap/utilities/i686-linux/unemap/sig2text SW_SEL.signal SW_SEL.txt

#/hpc/cmiss/unemap/utilities/i686-linux/unemap/sig2text output/SW_SEL.signal output/SW_SEL.txt
# Additional file of interest
# perl script: AverageingValues_iphist.pl (Convert .iphist into averaged measure (in grid point) for each time increment exported)
# output: AverageCa.txt
# to run:  perl ./AveragingValues_iphist.pl stomach.iphist 
# note: need to multiply by 1/(dxdy) to obtain mM/mm2

# Additional file of interest
# perl script: opgrid2EXDATA_3D_nopotential.pl (Convert .opgrid into .exdata, need to fem list grid points first)
# output: user specified
# to run:  perl opgrid2EXDATA_3D_nopotential.pl $input.opgrid $output.exdata
# note: only works if one element is used

# /usr/bin/ffmpeg -qscale 8 -i 2d_reentry.avi 2d_reentry.wmv
