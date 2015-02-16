
dxf_file = "../HS-81_Hobby_Servo_Model/hs81.dxf";

module HS81()
{
	servodepth    = dxf_dim(file = dxf_file, name = "servo-depth");
	servoheight   = dxf_dim(file = dxf_file, name = "servo-height");
	gearboxheight = dxf_dim(file = dxf_file, name = "gearbox-height");
	capheight     = dxf_dim(file = dxf_file, name = "cap-height");
	capstart         = dxf_dim(file = dxf_file, name = "cap-start");
	wheelshaftheight = dxf_dim(file = dxf_file, name = "wheelshaft-height");
	wheelheight      = dxf_dim(file = dxf_file, name = "wheel-height");

	echo ("HS81 - depth=", servodepth);
	echo ("HS81 - height=", servoheight);
	
	union()
	{
		linear_extrude (height = servoheight, center = true, convexity = 10)
			import (file = dxf_file, layer = "body");

		translate([0, 0, (servoheight/2) + (gearboxheight/2)])
		linear_extrude(height = gearboxheight, center = true, convexity = 10)
			import (file = dxf_file, layer = "gearbox");

		translate([0, 0, capstart])
		linear_extrude(height = capheight, center = true, convexity = 10)
			import (file = dxf_file, layer = "cap");

		translate([0, 0,  (servoheight/2) + gearboxheight + (wheelshaftheight/2)])
		linear_extrude(height = wheelshaftheight, center = true, convexity = 10)
			import (file = dxf_file, layer = "wheelshaft");

		*translate([0, 0,  (servoheight/2) + gearboxheight + wheelshaftheight + (wheelheight/2)])
		linear_extrude(height = wheelheight, center = true, convexity = 10)
			import (file = dxf_file, layer = "wheel");
			
	}
}

HS81();