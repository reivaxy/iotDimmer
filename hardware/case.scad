include <../../iotinator/hardware/oledPanel.scad>;

// cover();
case();
// wireBlockerBottom();
// wireBlockerTop();
// test();
//reinforcement(wall, zi, 30);

wall = 1.5;

xi = 93;
yi = 73;
zi = 42;

x = xi + 2*wall;
y = yi + 2*wall;
z = zi + 2*wall;
bottomSpacerZ = 6;
xOffset = 6;

cornerSide = 8;
tolerance = 0.1;
oledPanelSide = 40;

module test() {
  translate([wall + tolerance/2, yi + wall + tolerance/2, z])
    rotate(180, [1, 0, 0])
      cover();
  case();
}

module cover()
{
  oledPosition = [1, (yi - tolerance - oledPanelSide) / 2, 0];
  difference()
  {
    union()
    {
      translate(oledPosition)
      rWindowPanel(oledPanelSide, oledPanelSide, wall, 0, 90);
      difference()
      {
        cube([xi - tolerance, yi - tolerance, wall]);
        translate([cornerSide / 2, cornerSide / 2, -1])
        cylinder(d = 3, h = wall + 2, $fn = 50);
        translate([cornerSide / 2, yi - cornerSide / 2, -1])
        cylinder(d = 3, h = wall + 2, $fn = 50);
        translate([xi - cornerSide / 2, cornerSide / 2, -1])
        cylinder(d = 3, h = wall + 2, $fn = 50);
        translate([xi - cornerSide / 2, yi - cornerSide / 2, -1])
        cylinder(d = 3, h = wall + 2, $fn = 50);
        // hole for the oled panel
        translate(oledPosition)
        {
          translate([0.5, 0.5, -0.5])
          cube([oledPanelSide - 1, oledPanelSide - 1, wall + 1]);
        }
      }
    }
    // Hole for the reset button
    translate([20, 12, -1])
    cylinder(d = 8, h = wall + 2, $fn = 50);
  }
}

module case() {
  difference() {
    cube([x, y, z]);  // outer shell
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
  // side reinforcement
  translate([x/2 + wall, wall, wall])
    rotate(90,[0, 0, 1])
      reinforcement(wall, zi, 20);

  // side reinforcement
  translate([x/2 - wall, y - wall, wall])
    rotate(-90,[0, 0, 1])
      reinforcement(wall, zi, 20);
  
  translate([x - 11 - wall, y - 30 - wall - 8, wall]) {
    wireBlockerBottom();
  }
  // screws for triac board
  translate([wall + xOffset, wall + 4, wall]) {
    bottomSpacer(3);
  }
  translate([wall + xOffset + 24, wall + 4, wall]) {
    bottomSpacer(3);
  }
  // Support for triac board
  translate([wall + 4, 45, wall]) {
    cube([25, 2, bottomSpacerZ]);
  }
  // Support for esp board
  translate([wall + 4 + 35, yi - 15, wall]) {
    cube([30, 2, bottomSpacerZ]);
  }

  // screws for esp board
  translate([wall + xOffset + 31, wall + 4 + 12.6, wall]) {
    bottomSpacer(3);
  }
  translate([wall + xOffset + 31 + 48.5, wall + 4 + 11, wall]) {
    bottomSpacer(3);
  }

  // corners to support the cover
  translate([wall, wall, wall])
    corner(cornerSide, zi, 20);
  translate([xi + wall, wall, wall])
    rotate(90, [0, 0, 1])
      corner(cornerSide, zi, 20);
  translate([xi + wall, yi + wall, wall])
    rotate(180, [0, 0, 1])
      corner(cornerSide, zi, 20);
  translate([wall, yi + wall, wall])
    rotate(-90, [0, 0, 1])
      corner(cornerSide, zi, 20);
}

module bottomSpacer(screwDiam) {
  translate([0, 0, 0]) {
    difference() {
      cylinder(d1 = screwDiam + 6, d2 = screwDiam + 3, h = bottomSpacerZ, $fn=50);
      translate([0, 0, 1]) {
        cylinder(d = screwDiam, h = bottomSpacerZ, $fn=50);
      }
    }
  }
}

module wireBlockerBottom(z = 6, screwThrew = false) {
  y = 30;
  x = 11;
  difference() {
    union() {
      difference() {
        cube([x, y, z]);
        // wire passage
        translate([-0.1, 9, z+1]) {
           rotate(90, [0, 1, 0]) {
             cylinder(d=5, h=x+2, $fn=50);
           }
        }
        translate([-0.1, y - 9, z+1]) {
           rotate(90, [0, 1, 0]) {
             cylinder(d=5, h=x+2, $fn=50);
           }
        }
      }
      // bottom edge to improve grip on wire
      color("lime") {
        side = z/2;
        translate([(x - sqrt(2 * side * side))/2, 0, z/2 + 0.1]) {
          rotate(45, [0, 1, 0]) {
            cube([side, y, side]);
          }
        }
      }
    }
    // Screw holes
    translate([x/2, 3, screwThrew?-0.1:0.1]) {
      cylinder(d=2.5, h=6, $fn=50);
    }
    translate([x/2, y - 3, screwThrew?-0.1:0.1]) {
      cylinder(d=2.5, h=6, $fn=50);
    }
     translate([x/2, y/2, screwThrew?-0.1:0.1]) {
       cylinder(d=2.5, h=6, $fn=50);
    }
  }
}

module wireBlockerTop() {
  wireBlockerBottom(z = 3.5, screwThrew = true);
}

module reinforcement(side, height, zOffset) {
  angle = 20;
  translate([0, side, 0])
    difference() {
      translate([0, 0, zOffset])
        linear_extrude(height = height - zOffset, center = false, convexity = 10, scale=side*200)
          square(size = .01, center = true);
      translate([-side, -side, 0])
        cube([side, side*2, height +1]);
    }
} 

module corner(side, height, zOffset, holeDiam = 3) {
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