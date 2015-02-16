// ============================================================================
// Module: profiles   
//
// Description:
// 
// Aluminium profiles
//
// Fabrication:
// 
// n/a
//
// Licence:
//
// GNU GPL v2
// Copyright CC-BY-SA Bob Cousins 2013
//
// ============================================================================

//Disable $fn and $fa, do not change these
$fn=16;
$fa=0.01;
//Use only $fs to control the number of facets globally.
// fine ~ 0.5  coarse ~ 1-2
$fs=2;
// ============================================================================



// ============================================================================

// extrusion dims
ext_h = 30;
ext_w = 30;
ext_slot_w  = 8;
ext_slot_w2 = 16;
ext_slot_d  = 9;
ext_slot_d2 = 5;
ext_thickness = 2.25;
ext_centre_d = 5;

profile_30 = [
    ext_h,
    ext_w,
    ext_slot_w,
    ext_slot_w2,
    ext_slot_w,
    ext_slot_d,
    ext_slot_d2,
    ext_thickness,
    ext_centre_d
];

profile_20 = [
    20,
    20,
    5,
    11.5,
    4.5,
    5.5,    //slot_d
    1.8,    //slot_d2
    1.8,
    4.3
];

profile_40_20 = [
    20,
    40,
    5,
    11.5,
    4.5,
    5.5,    //slot_d
    1.8,    //slot_d2
    1.8,
    4.3
];

// ============================================================================
//
module beam_base (len, profile)
{
    prof_h          = profile [0];
    prof_w          = profile [1];
    prof_slot_w     = profile [2];
    prof_slot_w2    = profile [3];
    prof_slot_w3    = profile [4];
    prof_slot_d     = profile [5];
    prof_slot_d2    = profile [6];
    prof_thickness  = profile [7];
    prof_centre_d   = profile [8];
    
    
    difference ()
    {
        cube ([len, prof_w, prof_h], center=true);
    
        for (ang=[-90:90:180])
        rotate ([ang,0,0])
        {
            translate ([0, prof_h/2 - prof_thickness/2, 0])
                cube ([len+1, prof_thickness+1, prof_slot_w], center=true);
        }
        
        for (ang=[-90:90:180])
        {
            rotate ([ang,0,0])
            translate ([0, prof_h/2 - (prof_slot_d2 - prof_thickness)/2 - prof_thickness - 0.1, 0])
                cube ([len+1, prof_slot_d2 - prof_thickness, prof_slot_w2], center=true);
        }
        
        for (ang=[-90:90:180])
        rotate ([ang,0,0])
        {
            translate ([0, 0, -prof_h/2 + (prof_slot_d-prof_slot_d2)/2+ prof_slot_d2])
                trapezoid (len+1, prof_slot_w2, prof_slot_w3, prof_slot_d-prof_slot_d2);
        }
                         
        rotate ([0,90,0])
            cylinder (h=len+1, r=prof_centre_d/2, center=true);
    }
}

//
module beam (len)
{
    beam_base (len, profile_30);
}

module y_beam (len)
{
    rotate ([0,0,90])
    beam_base (len, profile_30);
}

module z_beam (len)
{
    rotate ([0,90,0])
    beam_base (len, profile_30);
}

module corner (profile)
{
    prof_h          = profile [0];
    prof_w          = profile [1];

    translate ([0, 0, -prof_h/2])
    difference ()
    {
      cube ([prof_w, prof_w, prof_h]);
  
      translate ([5, 5, 5])
      	cube ([prof_w, prof_w, prof_h-10]);
      
      translate ([prof_w,0,-0.5])
      rotate ([0,0,45])
      translate ([0,-prof_w/4,0])
      	cube ([prof_w, prof_w*2, prof_h+1]);
    }
}

module z_corner (profile = profile_30)
{
    translate ([0,0,0])
    rotate ([0,90,0])
        corner(profile);
}


//



// maker slide style
module v_rail_makerslide (len=50, thick=6)
{
    height = profile_40_20 [0];
    width = profile_40_20 [1];
    
    p = (thick/2) / cos(45) ;
    
    //cube ([len, width, thick], center=true);
    group()
    {
        translate ([0, 0, -height/2 ])
            beam_base (len, profile_40_20);
      
        difference ()
        {
            group()
            {
                translate ([0, width/2, 0])
                rotate ([45,0,0])
                    cube ([len, p, p], center=true);
      
                translate ([0, -width/2,0])
                rotate ([45,0,0])
                    cube ([len, p, p], center=true);
            }
        
            cube ([len+1, width, thick+1], center=true);
        }
    }
}

// open rail style
module v_rail_openrail (len=50, thick=6)
{
    width = profile_20 [1];
    
    p = (thick/2) / cos(45) ;
    
    //echo ("track_width=", width + thick); 

    group()
    {
        translate ([0, width/2, 0])
        rotate ([45,0,0])
            cube ([len, p, p], center=true);

        translate ([0, -width/2,0])
        rotate ([45,0,0])
            cube ([len, p, p], center=true);
            
        cube ([len, width, thick], center=true);
    }    
    
    translate ([0, 0, -width/2 - thick/2])
        //cube ([len, width, thick2], center=true);
        beam_base (len, profile_20);
      
}

module v_bearing (width=20, thick=6, angle=45, id=6)
{
    p = (thick/2) / cos(angle) ;
    
    difference ()
    {
        group()
        {
          translate ([0,0, thick/4])
          cylinder (r2=width/2, r1=width/2 - thick/2, h=thick/2, center=true);
        
          translate ([0,0, -thick/4])
          cylinder (r1=width/2, r2=width/2 - thick/2, h=thick/2, center=true);
        }
        
        cylinder (r=id/2, h=thick+1, center=true);
    }
}
