// ============================================================================
// Module: reel_feeders   
//
// Description:
// 
// Standalone automatic tape feeder for Pick and Place
//
// Fabrication:
// 
// - TODO 
//
// Licence:
//
// CERN OHL v1.2
// Copyright Bob Cousins 2015
//
// Design derived from V Besmans brilliant PP4 Automatic Feeder design
// https://www.vbesmens.de/en/pick-and-place/automatic-feeder.html
//
// ============================================================================

//Disable $fn and $fa, do not change these
$fn=16;
$fa=0.01;
//Use only $fs to control the number of facets globally.
// fine ~ 0.5  coarse ~ 1-2
$fs=2;
// ============================================================================

pi = 3.14;

// ============================================================================
/*

BOM

2 x		side panel 	 8mm MDF
2 x 	smmothed rod 6/8mm
2 x   threaded rod 8mm 

2 x   wood strip
2 x   wood strip



5 x   servo
5 x   spool

5 x 	switch assembly
			tact switch
			microswitch
			pcb
			spacer
			spring spacer
			3 x M3
			3 way connector
					
1 x   feed block
			upper plate
			lower plate		
			
			
			
wiring

5 x servo lead
5 x switch lead (3 core)								
*/
// ============================================================================



use <../HS-81_Hobby_Servo_Model/hs81.scad>
use <vitamins.scad>


// ============================================================================

module round_slot (x, z, r)
{
	translate ([0,0,0])
	{
		translate ([-x/2+r ,0,0])
			cylinder (r=r, h=z, center=true);
			
		translate ([x/2 - r,0,0])
			cylinder (r=r, h=z, center=true);
			
		cube ([x-r*2, r*2, z], center=true);
	}         
}

module round_slot2 (x, y, z, r)
{
	translate ([0,0,0])
	{
		for (i=[-1,1], j=[-1,1])
			translate ([i*(x/2-r), j*(y/2-r), 0])
				cylinder (r=r, h=z, center=true);
			
		cube ([x-r*2, y, z], center=true);
		cube ([x, y-r*2, z], center=true);
	}         
}

module tact_switch ()
{
	body_w = 6;
	
	color ("black")
	cube ([body_w, body_w, 3], center=true);
	
	color ("red")
	translate ([0,0,0])
	cylinder (r=1.5/2, h=2);
}

// 7" = 180
// 12" = 310
module reel (diam, tape_width=8, $fn=32)
{
    width = tape_width + 3;
    
    difference ()
    {
        translate ([0,0,-width/2])
        union ()
        {
          cylinder (h=width, r=diam/2 - 10);
          
          cylinder (h=1, r=diam/2);
          
          translate ([0,0,width-1])
          	cylinder (h=1, r=diam/2);
        }
        
        translate ([0,0,-width/2-0.5])
            cylinder (h=width+1, r=12.5/2);
    }
}

module spool (diam, tape_width=8, axle_d = 3, $fn=16)
{
    width = tape_width + 3;
    
    difference ()
    {
        translate ([0,0,-width/2])
        union ()
        {
          cylinder (h=width, r=diam/4);
          
          cylinder (h=1, r=diam/2);
          
          translate ([0,0,width-1])
          	cylinder (h=1, r=diam/2);
        }
        
        translate ([0,0,-width/2-0.5])
            cylinder (h=width+1, r=axle_d/2);
    }
}




module feeder_base (len, num_slots = 5, spacing=18) 
{
    w = (num_slots) * 18 + 9; 

    difference ()
    {
        color ("silver")
        cube ([w, len,4]);
        
        // tape slots
        for (i=[0:num_slots-1])
        {
          translate ([i*spacing+11, -0.5, 2])
          	cube ([6, len+1, 3]);
        }
    }
		
    // tape slots
    for (i=[0:num_slots-1])
    {
    		color ("white")
        translate ([i*spacing+11, -0.5, 2])
    	  	cube ([8, len+1, 1]);
		}    
}


module tape_channels_8mm () 
{
  num_slots = 5;
	edge_size = 8;  // was 6
	tape_w    = 8;
	width     = 88;
	
	space = (width - edge_size*2 - (num_slots)*tape_w) / (num_slots-1) + tape_w;

	spacing    = [0, space, space*2, space*3, space*4, space*5];
	slot_sizes = [tape_w, tape_w, tape_w, tape_w, tape_w, tape_w];
	
	echo ("* space = ",space);
	
	tape_channels (100, width, num_slots, slot_sizes, spacing, edge_size);
}

module tape_channels_12mm () 
{
  num_slots = 4;
	edge_size = 6;
	tape_w    = 12;
	width     = 80;
	
	space = (width - edge_size*2 - (num_slots)*tape_w) / (num_slots-1) + tape_w;

	spacing    = [0, space, space*2, space*3, space*4, space*5];
	slot_sizes = [tape_w, tape_w, tape_w, tape_w, tape_w, tape_w];
	
	echo ("* space = ",space);
	
	tape_channels (100, width, num_slots, slot_sizes, spacing);
}

module tape_channels_16mm () 
{
  num_slots = 3;
	edge_size = 6;
	tape_w    = 16;
	width     = 80;
	
	space = (width - edge_size*2 - (num_slots)*tape_w) / (num_slots-1) + tape_w;

	spacing    = [0, space, space*2, space*3, space*4, space*5];
	slot_sizes = [tape_w, tape_w, tape_w, tape_w, tape_w, tape_w];
	
	echo ("* space = ", space - tape_w);
	
	tape_channels (100, width, num_slots, slot_sizes, spacing);
}

module tape_channels_24_32mm () 
{
  num_slots = 2;
	edge_size = 6;
	width     = 80;
	
	space = (width - edge_size*2 - (24+32)) / (num_slots-1);

	spacing    = [0, space+24];
	slot_sizes = [24, 32];
	
	echo ("* space = ", space);
	
	tape_channels (100, width, num_slots, slot_sizes, spacing);
}


module tape_channels (len=100, width=60, num_slots, slot_size, spacing, edge_size=6) 
{
		//edge_size = 6;
		
		//		num_slots = floor ( (width-16) / (tape_w+2) );
		//    spacing = tape_w + (width - edge_size*2 - num_slots*tape_w) / (num_slots-1); 
    //w = num_slots * spacing + space;
		 
    upper_h = 2;
    lower_h = 15;
    
    depth = 12;
    
    color ("darkgray")
    difference ()
    {
        cube ([width, len, lower_h]);
        
        // tape slots
        for (i=[0:num_slots-1])
        {
          translate ([edge_size + spacing[i] + (slot_size[i])/2, len/2, lower_h/2+lower_h-depth])
          	cube ([slot_size[i]-2, len+2, lower_h], center=true);
          	
          translate ([edge_size + spacing[i] + (slot_size[i])/2 + 0*(slot_size[i]+0.2)/2, len/2, lower_h])
          	cube ([slot_size[i]+0.2, len+2, 2], center=true);
        }
        
        for (i=[edge_size/2, width-edge_size/2])
        for (j=[0,1])
          translate ([i, 5 + j*(len-10), lower_h/2])
	        	cylinder (h=lower_h+1, r=3.2/2, center=true);
    }

    color ("silver")
    translate ([0,0,lower_h])
    difference ()
    {
        cube ([width, len, upper_h]);
        
        // tape slots
        for (i=[0:num_slots-1])
        {
          translate ([edge_size + spacing[i] + slot_size[i]/2, len/2, upper_h/2])
          rotate ([0,0,90])
          	round_slot2 (len-10, slot_size[i]-2, upper_h+1, 3 );
        }
        
        for (i=[edge_size/2, width-edge_size/2])
        for (j=[0,1])
          translate ([i, 5 + j*(len-10), 1])
	        	cylinder (h=upper_h+1, r=3.2/2, center=true);
    }
		
    // sample tapes
    for (i=[0:num_slots-1])
    {
    		color ("white")
        translate ([edge_size + spacing[i] + slot_size[i]/2, len/2, lower_h - 0.5])
    	  	cube ([slot_size[i], len+50, 1], center=true);
		}    
}

module feeder_slots (len, num_slots = 5, space=8, tape_w=8) 
{
    spacing = space + tape_w; 
    
    w = num_slots * spacing + space; 
    h = 5;
    
    h_upper = 3;
    
    tape_d = 1;
		    
    slot_d = 1.2;
    slot_w = tape_w + 0.2;
    
    lower_slot_w = tape_w - 2;
    //lower_slot_d = 0;						// 0 = flush to tape bottom
    lower_slot_d = 4;

		
		// upper part
		translate ([0,0,h])
    difference ()
    {
        color ("gray")
        	translate ([0,0,0])
        	cube ([w, 50, h_upper]);
        
        // tape slots
        for (i=[0:num_slots-1])
        {
          translate ([i*spacing + space - 0.1, -0.5, -1])
          	cube ([slot_w, len+1, slot_d+1]);
        }
        
        // pickup slots
        // Note: pickup point is +12mm from front line of feeder block
        for (i=[0:num_slots-1])
        {
          translate ([i*spacing + space + 1, -0.5 - 3/2, 1])
          	cube ([tape_w-2, 19+0.5, h_upper+1]);

          translate ([i*spacing + space + 1.5,  19 - (19-5)/2, 1.5])
          	rotate ([0,0,90])
          	round_slot (19-5, h_upper+1, 3/2);
          	
          // slot for cover tape	
          translate ([i*spacing + space + tape_w/2 - 0.5, 19-3/2, 1.5])
          	round_slot (tape_w-1, h_upper+1, 3/2);
          	
          
					// pick up head (guide)	
          #translate ([i*spacing + space + 2.75, 16-2, 1+10])
						cylinder (r1=2/2, r2=3/2, h=20, center=true);

        }

				// holes for uswitches
        for (i=[0:num_slots-1])
        {
          translate ([i*spacing + space + tape_w-1.75, 32+1.7, 2.5/2])
          	//cube ([2.5, 10.5, h_upper+1]);
          	rotate ([0,0,90])
          	round_slot (10.5, h_upper+1, 2.5/2);
        }

		    // recess for pressure plates     
				assign (d=1) 
        for (i=[0:num_slots])
        {
          translate ([i*spacing-1.5, 14, -1])
          	cube ([spacing-tape_w+3, 20, d+1]);
        }
        
        // holes for cover tape
        *for (i=[0:num_slots-1])
        {
          translate ([i*spacing + space, 35, 1])
          	cube ([tape_w, 10, h_upper+1]);
        }
        
        // holes for screws
        for (i=[0:num_slots])
        {
          translate ([i*spacing + space/2, 5, h_upper/2])
          	cylinder (r=3.2/2, h = h_upper+1, center=true);
          	
          translate ([i*spacing + space/2, 45, h_upper/2])
          	cylinder (r=3.2/2, h = h_upper+1, center=true);
        
          translate ([i*spacing + space/2, 50-13, h_upper/2])	// was 25
          	cylinder (r=3.2/2, h = h_upper+1, center=true);
        }

    }

    // M3 bolt
    color ("black")
    translate ([0, 0, h_upper + 4])
    for (i=[0:num_slots])
    {
      translate ([i*spacing + space/2, 5, 1.1])
      	bolt_m3 (h_upper+h+1);
      	
      translate ([i*spacing + space/2, 45, 1.1])
      	bolt_m3 (h_upper+h+1);
    }

    color ("black")
    translate ([0, 0, h_upper + 4])
    for (i=[1:num_slots])
    {
        translate ([i*spacing + space/2, 50-13, 5.1])	// was 25
         	bolt_m3 (h_upper+h+1);
		}

		// lower part
		group()
		{
		    difference ()
		    {
		        color ("silver")
		        cube ([w, len, h]);
		        
		        //if (lower_slot_d>0)
		        
		        // tape slots
		        for (i=[0:num_slots-1])
		        //assign(lower_slot_d=i)
		        {
		          translate ([i*spacing + space + tape_w/2, (len+1)/2-0.5, h+(lower_slot_d+1)/2 - lower_slot_d])
		          	cube ([lower_slot_w, len+1, lower_slot_d+1], center=true);
		        }
		    
				    // recess for pressure plates    
						assign (d=2) 
		        for (i=[0:num_slots])
		        {
		          translate ([i*spacing +space/2, 24, h+d/2+1/2-d])
		          	cube ([spacing-tape_w+2+0.1, 20.5, d+1], center=true);

  		        translate ([i*spacing+space/2, 24, h/2])
          			cylinder (r=3.2/2, h=h+1, center=true);
		         	
  		        translate ([i*spacing+space/2, 14, h-d])
          			cylinder (r=3.5/2, h=d+1);
  		        translate ([i*spacing+space/2, 14+20, h-d])
          			cylinder (r=3.5/2, h=d+1);
	        	}
		        
		        // holes for screws
		        for (i=[0:num_slots])
		        {
		          translate ([i*spacing + space/2, 5, h/2])
		          	cylinder (r=3.2/2, h = h+1, center=true);
		          	
		          translate ([i*spacing + space/2, 45, h/2])
		          	cylinder (r=3.2/2, h = h+1, center=true);
		        
		          translate ([i*spacing + space/2, 50-13, h/2])	// was 25
		          	cylinder (r=3.2/2, h = h+1, center=true);
		        }
		    }
		    
        // pressure plate
				color ("green")
				assign(d=2)		// 0.8 + 1.2
        translate ([0, 0, h-d])
        for (i=[0:num_slots])
        {
          translate ([i*spacing + space/2, 14 + 10, 0])
	        	pressure_plate (20, space+2, d);
        }
        
        // pressure plate in tape slot
				color ("green")
				assign(d=3)
        translate ([0, 0, h-d])
        for (i=[0:num_slots-1])
        {
          translate ([i*spacing + space + tape_w/2, 14, 0])
	        	pressure_plate2 (tape_w, tape_w-2, d);
        }

		}

		
    // tapes
    for (i=[0:num_slots-1])
    {
        translate ([i*spacing + space, -12, h])
    	  	tape (tape_w, 200);
		}    
}

module pressure_plate (len, width, d=2)
{
  translate ([0, 0, d/2])
  {
  	difference ()
  	{
	  	union ()
	  	{
		    translate ([0, 0, 0])
		    	cube ([width, len, d], center=true);
		    	
		    translate ([0, -len/2, -1/2])
					cylinder (r=3/2, h=1, center=true);
					
		    translate ([0, len/2, -1/2])
					cylinder (r=3/2, h=1, center=true);
			}
			
			// 
			assign (angle=10)
			assign (a=1/tan(angle))
			{
				for (y=[-1,1])
				for (x=[-1,1])
		    translate ([0, y*len/2, 0])
				rotate ([-y*angle,0,0])
		    translate ([x*width/2, 0, 1])
		    	cube ([2, len, 2], center=true);
			
			}			
		}	
  }
}

module pressure_plate2 (len, width, d=2)
{
  translate ([0, 0, d/2])
  {
  	difference ()
  	{
	  	union ()
	  	{
		    translate ([0, 0, 0])
		    	cube ([width, len, d], center=true);
			}
			
			// 
			assign (angle=30)
			assign (a=1/tan(angle))
			{
				for (y=[-1,1])
		    translate ([0, y*len/2, 0])
				rotate ([-y*angle,0,0])
		    translate ([0, 0, 1])
		    	cube ([width+2, len, 2], center=true);
			}
		}	
		    translate ([0, -len/2, -1/2])
					cylinder (r=3/2, h=1, center=true);
					
		    translate ([0, len/2, -1/2])
					cylinder (r=3/2, h=1, center=true);
						
			
  }
}

module tape (width, len)
{

  dim = [3.048, 1.524, 0.5, 4];		// 1206
  //dim = [1.524, 0.762, 0.5, 4];		// 0603
  //dim = [1.016, 0.508, 0.5, 4];		// 0402
	//dim = [10, 10, 10, 12];
  //dim = [15, 15, 10, 16];
  
  y = width-2;  // 2.75
  pitch = dim[3];
  
  
	num_holes = len/4;

	difference ()
	{	
		color ("white")
  		cube ([width, len, 1]);
  	
	  for (i=[0:num_holes-1])
	  {
	    translate ([width-1.75, i*4, 0.5])
				cylinder (h=1.2, r=1.5/2, center=true, $fn=12);
				
		}
		
	  for (i=[0:num_holes-1])
	  {
	    translate ([y/2, i*pitch+2, 1.25 + dim[2]/2 - dim[2] ])
				cube ([dim[0], dim[1], dim[2]+0.5], center=true);				                     		
		}
	}		  	
}
 
module reel_holders (num_slots = 5, diameter, show_reels=1)
{
    spacing = 18;

		pos_y = diameter/2 + 22;
		
    union ()
    {
        // reel holder uprights
        for (i=[0:num_slots])
        {
            color ("silver")
            translate ([i*spacing + 2, -10, 0])
                cube ([5, 20, pos_y+8]);
        }
        
        for (i=[0:num_slots-1])
        {        
            color ("black")
            translate ([i*spacing + 2 + 11.5, 0, pos_y])
            rotate ([0,90,0])
                cylinder (h=11+1, r=12/2, center=true);

            color ("black")
            translate ([i*spacing + 2 + 11.5, 0, pos_y])
            rotate ([0,90,0])
                cylinder (h=spacing, r=5/2, center=true);
        }
                  
        if (show_reels)
        {
          // sample component reels
          for (i=[0:num_slots-1])
          {
              color ("white")
              translate ([i*spacing + 13.5, 0, pos_y])
              rotate ([0,90,0])
            
              reel (diameter); 
          }
        }
    }
}

module top_reel_holder (num_slots = 5, diameter = 180)
{
    spacing = 18;

    feeder_base (280, num_slots);
            
    translate ([0, 10 + 6, 4])
        reel_holders (num_slots, diameter);
}

module bottom_reel_holder (num_slots = 5, diameter = 180)
{
		show_reels = 1;
    spacing = 18;
				
		len_x = spacing * num_slots + 8;
		pos_y = diameter/2 + 25;
		axle_z = -diameter/2/2;
		
		*group()
		{		
			translate ([-200, 0, -6])
			 	 cube ([400, 200, 6]);
	
	    translate ([0, 0, 0])
		     feeder_base (280, num_slots);
		}            
//    

    translate ([-10, -pos_y, axle_z])
    color ("red")
    	rotate ([0,90,0])
			cylinder (h=len_x + 20, r=8/3);

		for (i=[0,1])
		{
		  translate ([-8 + (len_x+8)*i, -pos_y-50, -abs(axle_z)-50])
			 	 cube ([8, 100, abs(axle_z)+50]);
	
		  translate ([-8 + (len_x+8)*i, -pos_y, -100])
			 	 cube ([8, pos_y, 100]);
		} 	 

    translate ([0, -pos_y, axle_z])
    if (show_reels)
    {
      // sample component reels
      for (i=[0:num_slots-1])
      {
          color ("white")
          translate ([i*spacing + 13.5, 0, 0])
          rotate ([0,90,0])
        
          reel (diameter); 
      }
	  }
}

module switch_assembly (space=8)
{
	// an "L" shaped pcb 
	 color ("green")
	 difference ()
	 {
		 translate ([-7, -25, 0])
		 	 cube ([10, 30, 1.6]);
		 	 
		 translate ([-7-6, -35, -.2])
		 	 cube ([10, 30, 2]);
	 }
	 
	 // Note : switch actuator is aligned exactly 14mm from front  of feeder blcok  
   translate ([0, -1.7 - 16-2, 3.2])
	    tact_switch();
 
   translate ([-1.75 - space/2, 0, 0])
		 	 uswitch();

	//spacer
		color ("white")				
		 translate ([-3, -25, -2.7])
		 	 cube ([6, 30, 2.7]);
				   
}

module uswitch ()
{    
    {
	    // uswitch
	    color ("black")
	    translate ([0, 0, -4.5/2])
	    	cube ([2.5, 7.5, 4.5], center=true);
	    	
	    for (i=[0:2])
	    color ("silver")
	    translate ([0, -2.54+i*2.54, 3.1/2])
	    	cylinder (r=0.6/2, h=3.1, center=true);
	    	
	    color ("red")
	    translate ([0, -1.7, -4.5 + 0.5 - 0.7])
	    	cube ([1, 1, 1], center=true);
	    	
		}	
}

module feeder_module (with_reels = 1)
{
	
	tape_w    = 8;
	num_slots = 5;
	
	space     = 8;

	spacing = tape_w + space;
	reel_pos_y = 230;
	side_len = reel_pos_y + 50; 
		
	block_width = num_slots * spacing + space;
	
	motor_mount_offset_y = 60;
	
	echo ("block width = ", block_width);
	echo ("side length = ", side_len);
	
	//
	group ()
	{
		feeder_slots (50, num_slots, space, tape_w);

		// Note: the uswitch aligns exactly to +32mm from front line of feeder block
	  for (i=[1:num_slots])
	  {
	      translate ([i*spacing + space/2, 32+1.7, 10.5 + 0.2])
					switch_assembly(spacing - tape_w);
	  }
	}

	// base
	%translate ([-8, 0, -8])
		cube ([block_width+16, side_len, 8]);


	group()
	{	
			// side panels
			translate ([-8, motor_mount_offset_y, 0])
				cube ([8, side_len-motor_mount_offset_y, 25]);
				
			translate ([block_width, motor_mount_offset_y, 0])
				cube ([8, side_len-motor_mount_offset_y, 25]);
	}

	  // control pcb
*	  translate ([-10, reel_pos_y, 50])
	  color ("green")
	  //	rotate ([90,0,0])
	  	rotate ([0,90,0])
		  cube ([100,60,1.6], center=true);
	
	if (with_reels)
	{
			translate ([-8, reel_pos_y-25, 0])
				cube ([8, 50, 150]);
				
			translate ([block_width, reel_pos_y-25, 0])
				cube ([8, 50, 150]);
				
				
		  // sample component reels
		  for (i=[0:num_slots-1])
		  {
		      color ("white")
		      translate ([i*spacing + space + tape_w/2, reel_pos_y, 105])
		      rotate ([0,90,0])
			      reel (180, tape_w); 
		  }
		
			// axle for reels  
		  color ("silver")
		  translate ([-8-10, reel_pos_y, 0])
		  {
		  	translate ([0, 0, 105])
			  rotate ([0,90,0])
				  cylinder (r=3, h= block_width + 16+20);
			
			  color ("darkgray")
		  	translate ([0, 40, 10])
			  rotate ([0,90,0])
				  cylinder (r=4, h=block_width + 16+20);
				  
			  color ("darkgray")
		  	translate ([0, -40, 10])
			  rotate ([0,90,0])
				  cylinder (r=4, h=block_width + 16+20);
			}
			
			// guide rail for tapes
		  color ("silver")
		  translate ([-8-10, 95, 11])
		  rotate ([0,90,0])
			  cylinder (r=3, h= block_width + 16+20);
	}	
	

	translate ([-8,0,0])
	difference()
	{
		group()
		{
			// sides
			translate ([-8, 60, 0])
			cube ([8, 50, 90]);
			
			translate ([block_width+16, 60, 0])
			cube ([8, 50, 90]);
		}
		
		translate ([-12, 60, 25])
  		rotate ([45,0,0])
			cube ([block_width+40, 100, 70]);
	}


	// servos
  translate ([0, 88, 40])
  rotate ([45,0,0])
	group()
	{
		*translate ([-8,0,0])
		{
			// sides
			translate ([-8, -60, -2])
			cube ([8, 90, 10]);
			
			translate ([block_width+16, -60 ,-2])
			cube ([8, 90, 10]);
		}
  
	  group()
	  {
	  	 	// cross pieces
	  		translate ([-16, 15, 8])
				cube ([block_width+16+16, 15, 5]);
	
	  		translate ([-16, -15-15, 8])
				cube ([block_width+16+16, 15, 5]);

				for (i=[0:num_slots-1])
			  {
	      	color ("darkgray")
	      	translate ([i*spacing + space + tape_w/2, 0, 0])
	        rotate ([0,0,180 * (i%2)])
	          HS81();
	          
	      	translate ([i*spacing + space + tape_w/2, 0, 22+tape_w/2])
	        	rotate ([0,0,180 * (i%2)])
	        	translate ([0,5,0])
						spool (10+tape_w, tape_w);	          
				}
		}				

	  // control pcb
	  *translate ([block_width/2, 45, 15])
	  color ("green")
		  cube ([100,60,1.6], center=true);

  	// alternative motors
		*group()
		{
			assign (w=70)
			color ("brown")
			translate ([-16, -w/2, 8])
				cube ([block_width+16+16, w, 2]);

			for (i=[0:num_slots-1])
			assign (xd=spacing)
			assign (p=1-i%2)
	  	{
	      translate ([i*xd + space + tape_w/2, p*20-10, 8])
//	      rotate ([0, 90, 180 * (i%2)])
//       	HS81();
	   	    rotate ([0, 180, 180 * p + 45])
	   	    translate ([0,-9,0])
	   			small_stepper();
	          
	      translate ([i*spacing + space + tape_w/2, 0, 22+tape_w/2])
	        rotate ([0,0, 180 * (i%2)])
	        translate ([0,10,0])
					spool (10+tape_w, tape_w);	          
			}
		}

	  for (i=[0:num_slots-1])
	  {
				// show cover tape	
	      translate ([i*spacing + space+1 , -75, 26])
	      color ([0.6,0.6,0.6,0.7])
					cube ([tape_w-3, 65, 0.1]);	          
	  }
	}
}



// ============================================================================
//  MAIN
// ============================================================================


feeder_module();
