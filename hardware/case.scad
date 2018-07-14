include <../../iotinator/hardware/oledPanel.scad>;


//case();

wireHolder();

wall = 1.5;

xi = 93;
yi = 73;
zi = 42;

x = xi + 2*wall;
y = yi + 2*wall;
z = zi + 2*wall;
bottomSpacerZ = 6;
xOffset = 6;

module case() {
  difference() {
    cube([x, y, z]);
    translate([wall, wall, wall]) {
      cube([xi, yi, z]);
    }
  }
  // screws for triac board
  translate([wall + xOffset, wall + 4, wall]) {
    screw(3);
  }
  translate([wall + xOffset + 25, wall + 4, wall]) {
    screw(3);
  }
  // Support for triac board
  translate([wall + 4, 44, wall]) {
    cube([30, 2, bottomSpacerZ]);
  }

  // screws for esp board
  translate([wall + xOffset + 31, wall + 4 + 12.6, wall]) {
    screw(2);
  }
  translate([wall + xOffset + 31 + 47, wall + 4 + 12.6, wall]) {
    screw(2);
  }

}

module wireHolder() {
  length = 30;
  difference() {
    cube([9, length, 6]);
    translate([4.5, 3, 0.1]) {
      cylinder(d=2.5, h=6, $fn=50);
    }

    // Screws
    translate([4.5, length - 3, 0.1]) {
      cylinder(d=2.5, h=6, $fn=50);
    }
     translate([4.5, length/2, 0.1]) {
       cylinder(d=2.5, h=6, $fn=50);
    }

    // wire passage
    translate([-0.1, 9, 7]) {
       rotate(90, [0, 1, 0]) {
         cylinder(d=5, h=10, $fn=50);
       }
    }
    translate([-0.1, length - 9, 7]) {
       rotate(90, [0, 1, 0]) {
         cylinder(d=5, h=10, $fn=50);
       }
    }
  }

}

module screw(screwDiam) {
  translate([0, 0, wall]) {
    difference() {
      cylinder(d = screwDiam+1.5, h = bottomSpacerZ, $fn=50);
      translate([0, 0, 1]) {
        cylinder(d = screwDiam, h = bottomSpacerZ, $fn=50);
      }

    }

  }

}