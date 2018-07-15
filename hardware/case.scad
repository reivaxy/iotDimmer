include <../../iotinator/hardware/oledPanel.scad>;


case();


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
    // Wire holes. TODO: params ! Should actually be part of wireBlockerBottom
    // But don't know how to make the difference for the holes...
    // or use same trick as with oled panel
    translate([xi, yi - 15.5, 8]) {
      rotate(90, [0, 1, 0]) {
        cylinder(d=4, h=5, $fn=50);
      }
    }
    translate([xi, yi - 27.5, 8]) {
      rotate(90, [0, 1, 0]) {
        cylinder(d=4, h=5, $fn=50);
      }
    }
  }

  translate([x - 9 - wall, y - 30 - wall - 8, wall]) {
    wireBlockerBottom();
  }
  // screws for triac board
  translate([wall + xOffset, wall + 4, wall]) {
    bottomSpacer(3);
  }
  translate([wall + xOffset + 25, wall + 4, wall]) {
    bottomSpacer(3);
  }
  // Support for triac board
  translate([wall + 4, 44, wall]) {
    cube([30, 2, bottomSpacerZ]);
  }
  // Support for esp board
  translate([wall + 4 + 35, yi - 10, wall]) {
    cube([30, 2, bottomSpacerZ]);
  }

  // screws for esp board
  translate([wall + xOffset + 31, wall + 4 + 12.6, wall]) {
    bottomSpacer(2);
  }
  translate([wall + xOffset + 31 + 47, wall + 4 + 12.6, wall]) {
    bottomSpacer(2);
  }

  translate([wall, wall, wall])
    corner(8, zi, 20);
  translate([xi + wall, wall, wall])
    rotate(90, [0, 0, 1])
      corner(8, zi, 20);
  translate([xi, yi + wall, wall])
    rotate(180, [0, 0, 1])
      corner(8, zi, 20);
  translate([wall, yi + wall, wall])
    rotate(-90, [0, 0, 1])
      corner(8, zi, 20);
}

module bottomSpacer(screwDiam) {
  translate([0, 0, 0]) {
    difference() {
      cylinder(d = screwDiam+1.5, h = bottomSpacerZ, $fn=50);
      translate([0, 0, 1]) {
        cylinder(d = screwDiam, h = bottomSpacerZ, $fn=50);
      }
    }
  }
}

module wireBlockerBottom() {
  y = 30;
  x = 9;
  difference() {
    union() {
      difference() {
        cube([x, y, 6]);
        // wire passage
        translate([-0.1, 9, 7]) {
           rotate(90, [0, 1, 0]) {
             cylinder(d=5, h=10, $fn=50);
           }
        }
        translate([-0.1, y - 9, 7]) {
           rotate(90, [0, 1, 0]) {
             cylinder(d=5, h=10, $fn=50);
           }
        }
      }
      // bottom edge to improve grip on wire
      color("lime") {
        side = 3;
        translate([0, 0, 5.2]) {
          rotate(45, [0, 1, 0]) {
            translate([(x - side)/2, 0, 0]) {
              cube([side, y, side]);
            }
          }
        }
      }
    }
    // Screw holes
    translate([x/2, 3, 0.1]) {
      cylinder(d=2.5, h=6, $fn=50);
    }
    translate([x/2, y - 3, 0.1]) {
      cylinder(d=2.5, h=6, $fn=50);
    }
     translate([x/2, y/2, 0.1]) {
       cylinder(d=2.5, h=6, $fn=50);
    }
  }
}

module corner(side, height, zOffset, holeDiam = 2) {
  angle = 20;
  difference() {
    color("aqua") {
     translate([0, 0, height - 5]) {
       difference() {
         cube([side, side, 5]);
         translate([side/2, side/2, 0.1]) {
           cylinder(d=holeDiam, h=6, $fn=50);
         }
       }
     }
     translate([0, 0, zOffset])
      linear_extrude(height = height - zOffset - 5, center = false, convexity = 10, scale=side*200)
         square(size = .01, center = true);
    }
    translate([-side, -side, 0])
      cube([side, side, height]);
    translate([-side, 0, 0])
      cube([side, side, height]);
    translate([0, -side, 0])
      cube([side, side, height]);
  }
}