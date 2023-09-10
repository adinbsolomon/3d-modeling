card_height = 10;
card_width = 6;
card_depth = 0.2;

module card_pile(n) 
    cube([card_width,n*card_depth,card_height]);


card_pile(100);
translate([20,20,0]) card_pile(10);