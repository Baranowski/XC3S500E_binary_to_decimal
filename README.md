This is a little fun project to help me learn programming the Xilinx Core3S500E
(https://www.waveshare.com/wiki/Open3S500E) FPGA. Perhaps someone else will find
this useful.

This configuration listens for button presses on the 4x4 accessory keyboard,
translates them into a 16-bit number (each button toggles one bit), displays
this number in binary on the 128x64 LCD and below that displays the same number
in base 10.

===== Setup =====

* Plug the lcd12864 into the board. There is one row clearly marked "LCD12864"
* Plug the 4x4 keyboard into the lower row of 16I/Os\_1
* Download the demo package from the link above
* Open any of the sample verilog project in the package (LCD12864 works for me)
* Replace the \*.v and \*.ucf files with the sources in this repo.
* Generate Programming File and Program as usual (See https://www.youtube.com/watch?v=\_lZcWH0gjIw for a walkthrough if this is your first time).

Yes, I know the whole "copy a project and replace sources" approach is lame, but
I haven't figured out yet how to create a new project that will work.
