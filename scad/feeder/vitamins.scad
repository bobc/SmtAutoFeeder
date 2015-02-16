// ============================================================================
// Module: vitamins    
//
// Description:
// 
// Off the shelf and non-fabricated parts
//
// Fabrication:
// 
// n/a
//
// Licence:
//
// GNU GPL v2
// Copyright Bob Cousins 2013-2015
//
// ============================================================================

include <../mcad/nuts_and_bolts.scad>

use <../common/rmc_shapes.scad>


// cap head bolt
module bolt_base (diam, len)
{
 
// socket_size [J]
// head height [H]
// head_diam   [A]
// socket len  [K]
 
	socket_size = METRIC_CAP_SCREW_SIZES [diam][0];
	head_height = METRIC_CAP_SCREW_SIZES [diam][1];
  head_diam   = METRIC_CAP_SCREW_SIZES [diam][2];
  socket_len  = METRIC_CAP_SCREW_SIZES [diam][3];
  
  difference ()
  {
    color ("black")
    group()
    {
      translate ([0, 0, -len/2])
        cylinder (r=diam/2, h=len, center=true);

      translate ([0, 0, head_height/2])
        cylinder (r=head_diam/2, h=head_height, center=true);
    }

    translate ([0,0, -socket_len/2 + head_height+0.1])
        cylinder (r=socket_size/2, h=socket_len+0.1, center=true, $fn=6);
  }
}
module bolt_m3 (len)
{
  bolt_base (3, len);
}

module bolt_m4 (len)
{
  bolt_base (4, len);
}

module bolt_m5 (len)
{
  bolt_base (5, len);
}

// t-nut M5

module t_nut_m5 ()
{
  diam = 5;
	e = 0.75*diam;

  translate ([0,0,4.5/2])
  difference ()
  {
      rotate ([0,180,0])
      trapezoid (8, 16, 10, 4.5);
      
      cylinder (r=e/2, h=5, center=true);
  }
}


///
module sc10uu()
{
    W=40;
    L=35;
    G=21;
    H=26;
    h=13;
    
    J = 28;
    K = 21;
    S1 = 4.3;
    S2 = 5;
    S2_len = 12;

    *translate ([0,0,H/2])
        cube ([L, W, H], center=true);

    difference ()
    {
      color ("silver")
      union ()
      {
        translate ([0,0,G/2])
            cube ([L, W, G], center=true);
            
        translate ([0,0, G + (H-G)/2])
        rotate ([0,0, 90])
          //tooth (10, (H-G), 30, W);
          trapezoid (W, 15, 10, (H-G));
      }
      
      translate ([0,0, h])
      rotate ([90,0,0])
        cylinder (r=10/2, h=W+1, center=true);
        
      *group()
      {
        translate ([K/2, -J/2, S2_len/2])
          cylinder (r=S2/2, h=S2_len+1, center=true);
          
        translate ([K/2, J/2, S2_len/2])
          cylinder (r=S2/2, h=S2_len+1, center=true);
          
        translate ([-K/2, -J/2, S2_len/2])
          cylinder (r=S2/2, h=S2_len+1, center=true);
          
        translate ([-K/2, J/2, S2_len/2])
          cylinder (r=S2/2, h=S2_len+1, center=true);
      }
      
      group()
      {
        for (x=[-1,1], y=[-1,1])
        translate ([x*K/2, -y*J/2, G/2])
          cylinder (r=S1/2, h=G+1, center=true);
          
      }
      
    }
}

module sc10uu_bolts(len)
{
    W=40;
    L=35;
    G=21;
    H=26;
    h=13;
    
    J = 28;
    K = 21;
    S1 = 4.3;
    S2 = 5;
    S2_len = 12;

    for (x=[-1,1], y=[-1,1])
    {
        translate ([x*K/2, y*J/2, G/2])
          bolt_m5 (len);
    }
}

module sc10uu_holes(len)
{
    W=40;
    L=35;
    G=21;
    H=26;
    h=13;
    
    J = 28;
    K = 21;
    S1 = 4.3;
    S2 = 5;
    S2_len = 12;

    for (x=[-1,1], y=[-1,1])
    {
        translate ([x*K/2, y*J/2, 0])
          cylinder (r=S2/2, h=len, center=true);
    }
}


//
module lm10uu ()
{
  // LM10UU/rod dimensions
  outer_dia      = 19;
  length         = 29;
  rod_dia        = 10;

  color ("silver")
	rotate([90,0,0])
	difference()
	{
		cylinder(r=outer_dia/2, h=length, center=true);
		
		cylinder(r=rod_dia/2, h=length+1, center=true);
	}
}

module lm12uu ()
{
  // LM12UU/rod dimensions
  LM12UU_dia     = 21;
  LM12UU_length  = 30;
  rod_dia        = 12;

  color ("silver")
	rotate([90,0,0])
	difference()
	{
		cylinder(r=LM12UU_dia/2, h=LM12UU_length, center=true);
		
		cylinder(r=rod_dia/2, h=LM12UU_length+1, center=true);
	}
}


module bearing_608 ()
{
    color ("silver")
    difference ()
    {
        cylinder (r=22/2, h=7, center=true);
        
        cylinder (r=8/2, h=8, center=true);
    }
}

module small_stepper ()
{
    r = 28;
        
    color ("silver")
    difference ()
    {
      group()
      {  
        cylinder (r=r/2, h=19);
    
        translate ([r/2 + 7/2, 0, 0.5]) 
            cube ([8,7,1], center=true);
            
        translate ([-(r/2 + 7/2), 0, 0.5]) 
            cube ([8,7,1], center=true);
            
      }
      
      translate ([-(r/2 + 7/2), 0, 0.5]) 
        cylinder (r=4/2, h=2, center=true);
        
      translate ([r/2 + 7/2, 0, 0.5]) 
        cylinder (r=4/2, h=2, center=true);
    }

        translate ([0, 9, -5]) 
            cylinder (r=5/2, h=10);
    
    color ("blue")
    translate ([0, -r/2, 18/2]) 
        cube ([15,6,18], center=true);
        

}



module square_tube (len, width, wall)
{
    inner = width - wall*2;
    difference ()
    {
        cube ([width,width,len], center=true);
        
        cube ([inner,inner,len+1], center=true);
    }
}

module round_tube (len, width, wall)
{
    inner = width - wall*2;
    difference ()
    {
        cylinder (h = len, r=width/2, center=true);
        
        cylinder (r=inner/2, h=len+1, center=true);
    }
}
