/*
  Modified by Tony Buser <tbuser@gmail.com>
  http://tonybuser.com
  Added custom bitmap plate on top

  DOMEKIT-2V • PENTAGON
  http://effalo.com

  Math based on:
  http://www.desertdomes.com/dome2calc.html  
  
  Original OpenSCAD code by c60:
  http://www.thingiverse.com/thing:1719
*/

// Get bitmap.scad from http://www.thingiverse.com/thing:2054
<../openscad-bitmap/bitmap.scad>

style = "cutout"; // "blocks" or "cutout"
initials = ["T","B"]; // must be 2, either can be a blank string
logo_bitmap = [
  0,0,0,0,0,0,0,0,
  0,1,1,0,0,1,1,0,
  0,1,0,0,0,0,1,0,
  0,0,0,1,1,0,0,0,
  0,0,0,1,1,0,0,0,
  0,1,0,0,0,0,1,0,
  0,1,1,0,0,1,1,0,
  0,0,0,0,0,0,0,0
];

strutradius = 5;
holedepth = 40;

bracketradius=40;
bracketheight=18; 
angleoff=16; // 2V B STRUTS @ 16°

module tearDrop(radius, height) {
  union(){
    cylinder(h=height,r=radius,center=true);
    intersection(){
      rotate(45,[0, 0, 1]) scale([1, 1, height]) cube(size=2*radius, center = true);
      translate([1.75*radius,0,0]) scale([1,1,height/10]) cube(size=2*radius, center=true);
    }
  }
}


module buckyBracket(folds, prad) {
  difference() {
    scale ([bracketradius,bracketradius,bracketheight]) {
      scale ([1/10,1/10,1/10]) {
        rotate([0,0,18]) {
          cylinder (r=10,h=10,center=true,$fn=21 );
        }
      }
    }
    
    for ( i= [0:folds-1]) {
      rotate (a=[0,0,i*(360/folds)]) {
        rotate (a=[(90+angleoff),0,0]) {
          translate ([0,4,0]) {
            rotate([0,0,90]) {
              translate ([0,0,27]) {
                tearDrop(strutradius, holedepth);
              }
            }
          }
        }
      }
    }
  }
}

module bracket() {
  difference() {
    intersection() {
      buckyBracket(5, 5);
      translate( [0,0,-15]) {
        scale([25,25,25]) {
          rotate(a=126) {
            cylinder(h=15, r=1);
            }
          }
        }
      }
      for (i= [0:4]) {
        rotate (a=[0,0,i*(360/5)]){ 
        translate([00,-19,7]) {
          cylinder(r=2, h=10, $fn=21);
        }
      }
    }
  }
}

module cutout() {
  // I wanted to make it inset instead of with a box on top, 
  // but it was causing openscad to freak out...
  rotate([0,0,180]) {
  union() {
    translate([0, 0, bracketheight/2]) bracket();
    translate([6,-6, bracketheight]) {
      rotate([0,0,90]) {
        difference() {
          translate([-6,-6,0]) cube(size=[24,24,4]);  
          translate([0,0,-1]) 8bit_str(initials, 2, 1.5, 7);
          translate([12,6,-1]) bitmap(logo_bitmap, 1.5, 7, 8);
        }
      }
    }
  }
  }
}

module blocks() {
  rotate([0,0,180]) { 
  union() {
    translate([0, 0, bracketheight/2]) bracket();
    translate([6,-6, bracketheight]) {
      rotate([0,0,90]) {
        translate([0,0,-1]) 8bit_str(initials, 2, 1.5, 4);
        translate([12,6,-1]) bitmap(logo_bitmap, 1.5, 4, 8);
      }
    }
  }
  }
}

if (style == "cutout") {
  cutout();
} else {
  blocks();
}