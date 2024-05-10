# CPE 487 2024S: Final Project
## Kevin Ulis & Arminder Singh
### Breakout Game

## Introduction/Design concept/foundation

For our CPE 487 project, we decided to modify the base Lab 6 code to recreate the game 'Breakout', where the objective is to break all of the bricks at the top of the screen. (Display prints out "E487") When the game ends, pressing a button on the board will reset the game if either all bricks are broken (Display prints out "G00D") or the ball hits the bottom wall (Display prints out "L0SE").\
\
A cyan-colored bat is drawn at the bottom of the screen, which is user-controlled by buttons on the board. The user should hold button `BTNL` to move the bat to the left, and should hold button `BTNR` to move the bat to the right. To start or reset the game, the user must press the button `BTNC`, which will reset all of the bricks and the ball's position on the screen. As the ball constantly moves across the screen with independent X and Y motion vectors, the bat must be moved in order to bouce the ball back up into the bricks to win. If the ball is not hit by the bat, it will disappear from the bottom of the screen, and the user must reset the game.

## [Demo video](https://youtu.be/KR1i7qVgJVU)

## Attachments needed

- VGA-capable monitor, or a VGA-to-HDMI converter to see video output
- Nexys A7-100T board, the bat and game state is controlled by the buttons on the board, and game status is on the display.

## Block Diagram
![alt text](diagram.jpeg)
#
## Modifications done to Lab 6 base code
This project was originally built from the alternative Lab 6 source code, which used the board buttons to move the bat across the screen. The "adc_if.vhd" file is not used in this project, as the external potentiometer is not used and no analog to digital conversion is needed.
\
\
Modifications were only made to the files "pong.vhd," "bat_n_ball.vhd," "leddec16.vhd," and the constraints file "pong.xdc." A new file named "brick.vhd" was created to initialize a brick object, but this was an experimental file which was created early in the development process, and it now has no behavioral architecture. As a future improvement, it is more efficient to do all of the collision detection and drawing within the "brick.vhd" file and create 15 different instances of `brick`. However, many signals must be passed into "brick.vhd" that deal with VGA colors, the VGA sync pulse, and the ball coordinates in order to do all calculations.

## Vivado and Board Usage
- Download all files from this repository
- Open "breakout.xpr" in AMD Vivado
- Run Synthesis
- Run Implementation
- Generate Bitstream
- Upload to board using Hardware Manager

## "pong.xdc" Modifications
In the constrains file, a new constraint linked to SW0 at port `J15` is assigned to signal `speed` in the pong.vhd file. This switch determines the rate at which the bat moves across the screen. At the rising edge of the system clock and with the switch in the upward position, the bat moves 15 pixels across the screen, depending if the left button or the right button is pressed. When the switch is in the downward position, the bat only moves 10 pixels across the screen each system clock.\
```set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {speed}]```

## "pong.vhd" Modifications
A signal was added to the "pong" entity named "speed," which is an input signal linked to the constraints file as mentioned above. The signal is created as an input, as it will be controlled externally by the switch SW0 at port `J15`.\
```speed : IN STD_LOGIC```
### "pong.vhd" Behavioral Architecture Modifications
In the Behavioral Architecture, no additional signals were needed as the `speed` signal will be directly used by the process `pos`. When declaring the `bat_n_ball` component in the behavioral architecture, a new 16-bit output signal `disp_data` must be declared, which is a signal that controls what is displayed on the seven-segment displays. This signal will only be changed by the "bat_n_ball.vhd" file, but it must be referenced in "pong.vhd" as it must be passed through into "leddec16.vhd" in order to display it.
```vhdl
COMPONENT bat_n_ball IS
      PORT (
            v_sync : IN STD_LOGIC;
            pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            bat_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
            serve : IN STD_LOGIC;
            red : OUT STD_LOGIC;
            green : OUT STD_LOGIC;
            blue : OUT STD_LOGIC;
            disp_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- Added
      );
```

In the `pos` process within the behavioral architecture, changes were made to check the value of `speed` when moving the bat across the screen. At the rising edge of `clk_in`, another IF statement is used after the program recognizes a button press that moves the bat. Once the button has been detected as pressed, it checks the value of `speed`. If the switch is in the "up" position, it will either subtract 15 from the bat's current position if the `BTNL` button is pressed, or it will subtract 10 from the bat's current position if switch is in the "down" position. It is the same functionality if the `BTNR` button is pressed, but it instead adds 15 or 10 to the bat's current position depending on the state of the switch. 

```vhdl
pos : PROCESS (clk_in) is
    BEGIN
        if rising_edge(clk_in) then
            count <= count + 1;
            IF (btnl = '1' and count = 0 and batpos > 0) THEN
                -- Begin Added Code
                IF (speed = '1') THEN
                    batpos <= batpos - 15;
                ELSE
                    batpos <= batpos - 10;
                END IF;
                -- End Added Code
            ELSIF (btnr = '1' and count = 0 and batpos < 800) THEN
                -- Begin Added Code
                IF (speed = '1') THEN
                    batpos <= batpos + 15;
                ELSE
                    batpos <= batpos + 10;
                 -- End Added Code
                END IF;
            END IF;
        end if;
    END PROCESS;
```

When initializing the port map for `add_bb` as a type `bat_n_ball`, the new signal declared `disp_data` in the Component for `bat_n_ball` must be linked to the 16-bit signal `display` which was created in the behavioral architecture. Changes are only made to `disp_data` within "bat_n_ball.vhd," but these signals must be linked in order to get the signal over to "leddec16.vhd," where it can then be displayed on the seven-segment display. 
```vhdl
add_bb : bat_n_ball
    PORT MAP(--instantiate bat and ball component
        v_sync => S_vsync, 
        pixel_row => S_pixel_row, 
        pixel_col => S_pixel_col, 
        bat_x => batpos, 
        serve => btn0, 
        red => S_red, 
        green => S_green, 
        blue => S_blue,
        disp_data => display -- Added
    );
```

## "bat_n_ball.vhd" Modifications
In the `bat_n_ball` entity declaration, a new 16-bit signal `disp_data` is added, which is used to change what is displayed on the seven-segment display. This signal is changed only when checking which state the game is currently in. 
```vhdl
ENTITY bat_n_ball IS
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        bat_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current bat x position
        serve : IN STD_LOGIC; -- initiates serve
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC;
        disp_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- Added
    );
END bat_n_ball;
```
### "bat_n_ball.vhd" Behavioral Architecture Modifications
The constant `bat_w`, which describes the bat width in pixels, was changed from 20 to 40 in order to make the game easier for the player, since the bat can be difficult to control when using the board buttons.
```vhdl
CONSTANT bat_w : INTEGER := 40; -- bat width in pixels
```

### Brick initializations
In order to create a brick on the screen, new signals must be created to describe where the brick should be drawn, the brick dimensions (height, width) the initial X and Y coordinates of the brick, and the present state of the brick. The signal `brick_on` is set when drawing each brick in order to tell the VGA driver to draw a magenta pixel on the screen. The constant integer signals `brick_width` and `brick_height` tell the width of the brick and the height of the brick in pixels, respectively. The constant integer signals `brick1x` and `brick1y` tell the initial position of the first brick, which is used as a reference to all other bricks that are drawn. These initial coordinates represent the top left of the brick, as the X and Y coordinates increase the further away the current pixel is from the top left. Lastly, the signals `brick1present` through `brick15present` represent if the brick should be displayed on the screen. If the bit is `1`, then the brick has not been hit yet, so it should be displayed. If the bit is `0`, then the brick has been hit and should not be drawn.
```vhdl
SIGNAL brick_on : STD_LOGIC; -- indicates whether brick at over current pixel position
    CONSTANT brick_width : INTEGER := 60;
    CONSTANT brick_height : INTEGER := 15;
    CONSTANT brick1x : INTEGER := 100;
    CONSTANT brick1y : INTEGER := 60;
    SIGNAL brick1present : STD_LOGIC := '1';
    SIGNAL brick2present : STD_LOGIC := '1';
    SIGNAL brick3present : STD_LOGIC := '1';
    SIGNAL brick4present : STD_LOGIC := '1';
    SIGNAL brick5present : STD_LOGIC := '1';
    SIGNAL brick6present : STD_LOGIC := '1';
    SIGNAL brick7present : STD_LOGIC := '1';
    SIGNAL brick8present : STD_LOGIC := '1';
    SIGNAL brick9present : STD_LOGIC := '1';
    SIGNAL brick10present : STD_LOGIC := '1';
    SIGNAL brick11present : STD_LOGIC := '1';
    SIGNAL brick12present : STD_LOGIC := '1';
    SIGNAL brick13present : STD_LOGIC := '1';
    SIGNAL brick14present : STD_LOGIC := '1';
    SIGNAL brick15present : STD_LOGIC := '1';
```

The `brick` component is then declared, which uses signals `v_sync`, `brick_x`, `brick_y`, `ball_x1`, `ball_y1`, `bsize1`, and `present`. The `v_sync` signal is the vertical sync pulse signal from the VGA driver. The `brick_x` and `brick_y` signals are the X and Y coordinates of the brick respectively. The `ball_x1` and `ball_y1` signals describe the current X and Y coordinate of the ball respectively. The `bsize1` signal describes the radius of the ball, which would have been used for collision detection with the ball and the brick. Lastly, the `present` signal describes if the brick should be drawn or not, and it if should do collision detection or not.
```vhdl
COMPONENT brick IS
        PORT(
            v_sync : IN STD_LOGIC;
            brick_x : IN INTEGER;
            brick_y : IN INTEGER;
            ball_x1: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            ball_y1 : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            bsize1 : IN INTEGER;
            present : out STD_LOGIC
            );
    END COMPONENT;
```
Each brick's port map is then initialized. All bricks are given the same signals `v_sync`, `ball_x`, `ball_y`, and `bsize`. For each subsequent brick in the first row, the X location is incremented by 150 pixels. For example, all bricks in the row have an X position `brick1x`, `brick1x+150`, `brick1x+300`, `brick1x+450`, and `brick1x+600`. All of the bricks in a row have the same Y coordinate. For the first row, all bricks have a Y coordinate of `brick1y`. For the second row, the bricks have a similar sequence in their X coordinate as above, but their Y coordinate is `brick1y+brick1y`. For the next row, the Y coordinate is `brick1y+brick1y+brick1y`. Each brick is given its "brick_present" signal, where "_" is the brick number. 
```vhdl
brick1 : brick
    PORT MAP(
        v_sync => v_sync,
        --brick_x => brick1x+5,
        brick_x => brick1x,
        brick_y => brick1y,
        ball_x1 => ball_x,
        ball_y1 => ball_y,
        bsize1 => bsize,
        present => brick1present
    );
    brick2 : brick
    PORT MAP(
        v_sync => v_sync,
        --brick_x => brick1x+5,
        brick_x => (brick1x+150),
        brick_y => brick1y,
        ball_x1 => ball_x,
        ball_y1 => ball_y,
        bsize1 => bsize,
        present => brick2present
    );
    brick3 : brick
    PORT MAP(
        v_sync => v_sync,
        --brick_x => brick1x+5,
        brick_x => (brick1x+300),
        brick_y => brick1y,
        ball_x1 => ball_x,
        ball_y1 => ball_y,
        bsize1 => bsize,
        present => brick3present
    );
    brick4 : brick
    PORT MAP(
        v_sync => v_sync,
        --brick_x => brick1x+5,
        brick_x => (brick1x+450),
        brick_y => brick1y,
        ball_x1 => ball_x,
        ball_y1 => ball_y,
        bsize1 => bsize,
        present => brick4present
    );
    brick5 : brick
    PORT MAP(
        v_sync => v_sync,
        --brick_x => brick1x+5,
        brick_x => brick1x,
        brick_y => brick1y+40,
        ball_x1 => ball_x,
        ball_y1 => ball_y,
        bsize1 => bsize,
        present => brick5present
    );
    brick6 : brick
    PORT MAP(
        v_sync => v_sync,
        --brick_x => brick1x+5,
        brick_x => (brick1x+150),
        brick_y => (brick1y+brick1y),
        ball_x1 => ball_x,
        ball_y1 => ball_y,
        bsize1 => bsize,
        present => brick6present
    );
    brick7 : brick
    PORT MAP(
        v_sync => v_sync,
        --brick_x => brick1x+5,
        brick_x => (brick1x+300),
        brick_y => (brick1y+brick1y),
        ball_x1 => ball_x,
        ball_y1 => ball_y,
        bsize1 => bsize,
        present => brick7present
......................................
    );
```
For the color of the bricks, we thought magenta would be the best in order to have some contrast on the screen. To create magenta, the `brick_on` signal must not be green, so it can be NAND'ed with `ball_on` when setting the `green` signal for the VGA output.
```vhdl
red <= NOT bat_on; -- color setup for red ball and cyan bat on white background
    green <= NOT brick_on AND NOT ball_on ; --bricks are purple (red and blue)
    blue <= NOT ball_on;
```

### "blockdraw" Process
In order to draw the bricks onto the screen, we found it was easiest to change the `brick_on` in the "bat_n_ball.vhd" file because it had all of the necessary VGA signals associated with it. If we were to do drawing within "brick.vhd," we would need to pass through all necessary VGA signals while needing to wait for `v_sync` to turn on.\
The drawing process for the bricks is extremely similar as drawing the bat. It first checks if the brick should be drawn on screen by checking `brick_present`. If it is present, it continues on to check if the current pixel being drawn (`pixel_col` and `pixel_row`) are within the boundaries of the bricks. If the location is within the boundaries, it sets `brick_on` to 1. The rest of the bricks are drawn through the same process by using an ELSIF statement.
```vhdl
blockdraw : PROCESS (pixel_row, pixel_col) IS
    BEGIN
        IF brick1present = '1' AND ((pixel_col >= brick1x - brick_width) OR (brick1x <= brick_width)) AND
        (pixel_col <= brick1x + brick_width) AND
             (pixel_row >= brick1y - brick_height) AND
             (pixel_row <= brick1y + brick_height) THEN
                brick_on <= '1';
        ELSIF brick2present = '1' AND ((pixel_col >= (brick1x+150) - brick_width) OR ((brick1x) <= brick_width)) AND
        (pixel_col <= (brick1x+150) + brick_width) AND
             (pixel_row >= brick1y - brick_height) AND
             (pixel_row <= brick1y + brick_height) THEN
                brick_on <= '1';
        ELSIF brick3present = '1' AND ((pixel_col >= (brick1x+300) - brick_width) OR ((brick1x) <= brick_width)) AND
        (pixel_col <= (brick1x+300) + brick_width) AND
             (pixel_row >= brick1y - brick_height) AND
             (pixel_row <= brick1y + brick_height) THEN
                brick_on <= '1';
        ELSIF brick4present = '1' AND ((pixel_col >= (brick1x+450) - brick_width) OR ((brick1x) <= brick_width)) AND
        (pixel_col <= (brick1x+450) + brick_width) AND
             (pixel_row >= brick1y - brick_height) AND
             (pixel_row <= brick1y + brick_height) THEN
                brick_on <= '1';
        ELSIF brick5present = '1' AND ((pixel_col >= (brick1x) - brick_width) OR ((brick1x) <= brick_width)) AND
        (pixel_col <= (brick1x) + brick_width) AND
             (pixel_row >= (brick1y+brick1y) - brick_height) AND
             (pixel_row <= (brick1y+brick1y) + brick_height) THEN
                brick_on <= '1';
        ELSIF brick6present = '1' AND ((pixel_col >= (brick1x+150) - brick_width) OR ((brick1x) <= brick_width)) AND
        (pixel_col <= (brick1x+150) + brick_width) AND
             (pixel_row >= (brick1y+brick1y) - brick_height) AND
             (pixel_row <= (brick1y+brick1y) + brick_height) THEN
                brick_on <= '1';
.........................................................................................................................
.........................................................................................................................
        ELSIF brick15present = '1' AND ((pixel_col >= (brick1x+600) - brick_width) OR ((brick1x) <= brick_width)) AND
              (pixel_col <= (brick1x+600) + brick_width) AND
                   (pixel_row >= (brick1y+brick1y+brick1y) - brick_height) AND
                   (pixel_row <= (brick1y+brick1y+brick1y) + brick_height) THEN
                      brick_on <= '1';
        ELSE
            brick_on <= '0';
        END IF;
      END PROCESS;
```
### "mball" Process Modifications
Changes must be made to this process in order to have collision detection with the bricks, to properly reset the game, and to change the data on the seven-segment display. When the process checks if the reset button `BTNC` is pressed and the game is over, the `game_on` and `ball_y_motion` signals are set as expected, but all of the `brick_present` signals must also be reset to their default value of 1. This ensures that all of the bricks are present at the beginning of the game. The data on the display is also set to show the values "E487" to indicate the game is being played.
```vhdl
 -- process to move ball once every frame (i.e., once every vsync pulse)
    mball : PROCESS
        VARIABLE temp : STD_LOGIC_VECTOR (11 DOWNTO 0);
    BEGIN
        WAIT UNTIL rising_edge(v_sync);
        IF serve = '1' AND game_on = '0' THEN -- test for new serve
            game_on <= '1';
            ball_y_motion <= (NOT ball_speed) + 1; -- set vspeed to (- ball_speed) pixels
            brick1present <= '1';
            brick2present <= '1';
            brick3present <= '1';
            brick4present <= '1';
            brick5present <= '1';
            brick6present <= '1';
            brick7present <= '1';
            brick8present <= '1';
            brick9present <= '1';
            brick10present <= '1';
            brick11present <= '1';
            brick12present <= '1';
            brick13present <= '1';
            brick14present <= '1';
            brick15present <= '1';
            disp_data <= "1110010010000111";
......................................................................................
```
When the ball meets the bottom wall, the `game_on` signal is set to 0, indicating the game is over. It will then check if any of the `brick_present` signals are equal to 1, in which it will set the display data to show "L0SE" to show the player they lost the game.
```vhdl
..................................................................................
ELSIF ball_y + bsize >= 600 THEN -- if ball meets bottom wall
            ball_y_motion <= (NOT ball_speed) + 1; -- set vspeed to (- ball_speed) pixels
            game_on <= '0'; -- and make ball disappear
            IF brick1present = '1' OR brick2present = '1' OR brick3present = '1' OR 
            brick4present = '1' OR brick5present = '1' OR brick6present = '1' OR 
            brick7present = '1' OR brick8present = '1' OR brick9present = '1' OR brick10present = '1' 
             OR brick11present = '1' OR brick12present = '1' OR brick13present = '1' OR brick14present = '1' OR brick15present = '1' THEN
                disp_data <= "1010000010111110";
            END IF;
        END IF;
..................................................................................
```

Within the "mball" process, an IF statement checks to see whether the `game_on` signal is set to 1, as well as if all of the `brick_present` signals are set to 0. If these conditions are fulfilled, then it will set the data on the display to show "G00D" to congratulate the user on winning the game.
```vhdl
..........................
IF game_on = '1' AND brick1present = '0' AND brick2present = '0' AND brick3present = '0' AND brick4present = '0' AND brick5present = '0' AND brick6present = '0' AND brick7present = '0' AND brick8present = '0' AND brick9present = '0' AND brick10present = '0' THEN
            disp_data <= "0110000000001101";
        END IF;
..........................
```

The collision detection for the bricks is very similar to the collision dection for the bat, as it just needs to invert the `ball_y_motion` signal. The same parameters for checking if the ball is colliding with the bat are used for the brick collision detection. However, another check must be done to ensure that brick is present on the screen, which is done by adding another conditional `AND brick_present = '1'` to the IF statement. If all of the conditions are met, it will set the `brick_present` signal to 0. It will also determine which value `ball_y_motion` should be set as. If `(ball_y_motion = ball_speed)` then it sets it to `(NOT ball_speed)+1`. If they are not equal, it sets it to `ball_speed`. This IF statement is done for every single brick, as they are independent of each other and must be checked every `v_sync` pulse.\
The code below only shows the collision detection for brick1 and brick2 for simplicity.
```vhdl
        IF (ball_x + bsize/2) >= (brick1x - brick_width) AND
         (ball_x - bsize/2) <= (brick1x + brick_width) AND
             (ball_y + bsize/2) >= (brick1y - brick_height) AND
             (ball_y - bsize/2) <= (brick1y + brick_height) AND brick1present = '1' THEN
                brick1present <= '0';
                IF(ball_y_motion = ball_speed) THEN
                    ball_y_motion <= (NOT ball_speed)+1;
                ELSE
                    ball_y_motion <= ball_speed;
                END IF;
        END IF;
        IF (ball_x + bsize/2) >= ((brick1x+150) - brick_width) AND
         (ball_x - bsize/2) <= ((brick1x+150) + brick_width) AND
             (ball_y + bsize/2) >= (brick1y - brick_height) AND
             (ball_y - bsize/2) <= (brick1y + brick_height) AND brick2present = '1' THEN
                brick2present <= '0';
                IF(ball_y_motion = ball_speed) THEN
                    ball_y_motion <= (NOT ball_speed)+1;
                ELSE
                    ball_y_motion <= ball_speed;
                END IF;
        END IF;
.............................................................................................
```
## "leddec16.vhd" Modifications
In order to create custom characters on the seven-segment display like "G" and "L", modifications must be made to the `seg` data assignments to correctly enable certain segments on the display. The digits "0", "4", "7", "8", "D", and "E" were not needed to be modified in any way. To create special characters, digits that were not used were repurposed. The digit "6" was repurposed into a letter "G" for use when the user won the game. [This website](https://www.electronicsforu.com/resources/7-segment-display-pinout-understanding) was used to help generate the binary sequence needed for certain letters, however the provided sequences must be reversed to work correctly on the board's seven-segment display. Digits "6", "A", and "B" were repurposed to create the letters "G", "L", and "S".
```vhdl
-- Turn on segments corresponding to 4-bit data word
	seg <= "0000001" WHEN data4 = "0000" ELSE -- 0 used "0"
	       "1001111" WHEN data4 = "0001" ELSE -- 1
	       "0010010" WHEN data4 = "0010" ELSE -- 2
	       "0000110" WHEN data4 = "0011" ELSE -- 3
	       "1001100" WHEN data4 = "0100" ELSE -- 4 used "4"
	       "0100100" WHEN data4 = "0101" ELSE -- 5
	       --"0100000" WHEN data4 = "0110" ELSE -- 6
	       "0100001" WHEN data4 = "0110" ELSE -- 6 used "G"
	       "0001111" WHEN data4 = "0111" ELSE -- 7 used "7"
	       "0000000" WHEN data4 = "1000" ELSE -- 8 used "8"
	       "0000100" WHEN data4 = "1001" ELSE -- 9 
	       --"0001000" WHEN data4 = "1010" ELSE -- A
	       "1110001" WHEN data4 = "1010" ELSE -- A used "L"
	       --"1100000" WHEN data4 = "1011" ELSE -- B
	       "0100100" WHEN data4 = "1011" ELSE -- B used "S"
	       "0110001" WHEN data4 = "1100" ELSE -- C
	       "1000010" WHEN data4 = "1101" ELSE -- D used "D"
	       "0110000" WHEN data4 = "1110" ELSE -- E used "E"
	       "0111000" WHEN data4 = "1111" ELSE -- F
	       "1111111";
```
### Conclusion
The project and the finished product came out good, as the basic premise of "Breakout" was successfully implemented on the boards' FPGA module. In the future, or if given more time, the brick collision detection and drawing should be in its own separate file and simply created as a module/object instead. There was much trouble trying to implement all of the needed signals related to the VGA output as well as other dependencies for collision detection into the "brick" module, but given more time it could have been solved. 
- Project Outline: Arminder
- Brick Drawing: Kevin
- Brick Initialization: Arminder
- Brick Collision Detection: Arminder and Kevin
- Seven-segment Display Integration: Kevin
### Images
![alt text](run.jpg)
![alt text](good.jpg)
![alt text](lose.jpg)
#
