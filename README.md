# VGA-Project
Final project/Exam from my HDL Digital design class.

#Purpose
The purpose of this project is to drive a monitor through VGA at a resolution of 800X600.
I have been given code for a base-level design by my professor, and am tasked with modifying it to
accomplish a few tasks.

1) Simple modification of the base Verilog to supply a different result than the given files.

2) A single moving sprite that interacts with boundaries of the screen, up to multiple sprites interacting with one another.

3) Two or more sprites that change in display form through interaction with the user. (Think Pong)

#Users Guide

Upon boot with all switches down you should see a black rectangle with a white border. The color of this rectangle can be modified via switches 0 through 2 on the Basys 3 prototyping board. Switch 2 is red, switch 1 is green, switch 0 is blue. Flipping multiple switches on will result in mixtures of colors, with all three switches yielding a gray rectangle with white border. Switch 3 is a display mode with an interesting color pattern, generated from multiplying the current horizontal and vertical positions of the driver and selecting parts of it to be the color sent to screen. Switch 4 is where my personal design really comes into play, which I will detail below.

#User Interactive Mode
When switch 4 is toggled, you will see a rectangle on the right hand side of the screen, with a small square floating around the screen. The rectangle can me moved with the top and bottom switches on the Basys 3 board. If the square makes contact with the rectangle, it bounces back and changes color.
                                      
