/*
  DOMEKIT-2V • HEXAGON
  http://effalo.com

  Math based on:
  http://www.desertdomes.com/dome2calc.html  
  
  Original OpenSCAD code by c60:
  http://www.thingiverse.com/thing:1719
  
  openSCAD shapes library by Catarina Mota:
  http://svn.makerbot.com/users/hoeken/openscad/shapes.scad
*/

strutradius = 5;
holedepth = 38;

module tearDrop(radius, height) {
  union(){
    cylinder(h=height,r=radius,center=true);
    intersection(){
      rotate(45,[0, 0, 1]) scale([1, 1, height]) cube(size=2*radius, center = true);
      translate([1.75*radius,0,0]) scale([1,1,height/10]) cube(size=2*radius, center=true);
    }
  }
}

module hexagon(height, depth) {
  boxWidth=height/1.75;
  union(){
    box(boxWidth, height, depth);
    rotate([0,0,60]) box(boxWidth, height, depth);
    rotate([0,0,-60]) box(boxWidth, height, depth);
  }
}

module box(w,h,d) {
  scale ([w,h,d]) cube(1, true);
}

module buckyBracket(folds) {
  bracketradius=40;
  bracketheight=20;

  difference() {
    scale ([bracketradius,bracketradius,bracketheight]){
      scale ([1/10,1/10,1/10]){
        rotate([0,0,18]){
          cylinder (r=10,h=10,center=true, $fn=21);
        }
      }
    }
    for ( i= [0:folds-1]) {
      rotate (a=[0,0,i*(360/folds)]){
        if (i%3 == 0) {
          // 2V B STRUTS @ 16°
          rotate (a=[(90+16),0,0]){
            translate ([0,4,0]){
              rotate([0,0,90]){
                translate ([0,0,27]){
                  tearDrop(strutradius, holedepth);
                }
              }
            }
          }
        }
        if (i%3 != 0){
          // 2V A STRUTS @ 18°	
          rotate (a=[(90+18),0,0]){
            translate ([0,4,0]){
              rotate([0,0,90]){
                translate ([0,0,27]){
                  tearDrop(strutradius, holedepth);
                }
              }
            }
          }
        }
      }
    }
  }
}

difference() {
  intersection() {
    buckyBracket(6, 5);
    rotate([0,0,90]) { hexagon(40, 18); }
  }
  translate([00,19,7]) {cylinder(r=2, h=10, $fn=21);}
  translate([00,-19,7]) {cylinder(r=2, h=10, $fn=21);}
}

