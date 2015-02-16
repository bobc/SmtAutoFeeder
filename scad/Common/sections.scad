module y_section (size = 150)
{
    difference ()
    {
        children();
        translate ([size/2,0,0])
            cube ([size,size,size], center=true);
    }
}

module x_section (size = 150)
{
    difference ()
    {
        children();
        translate ([0,size/2,0])
            cube ([size,size,size], center=true);
    }
}

module z_section (size = 150, color="red")
{
    difference ()
    {
        children();
        
//        color (color)
        translate ([0,0,size/2])
            cube ([size,size,size], center=true);
    }
}
