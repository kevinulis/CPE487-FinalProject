LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

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
        disp_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        sw : IN STD_LOGIC
    );
END bat_n_ball;

ARCHITECTURE Behavioral OF bat_n_ball IS
    CONSTANT bsize : INTEGER := 8; -- ball size in pixels
    CONSTANT bat_w : INTEGER := 40; -- bat width in pixels
    CONSTANT bat_h : INTEGER := 3; -- bat height in pixels
    -- distance ball moves each frame
    SIGNAL ball_speed : STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR (6, 11);
    SIGNAL ball_on : STD_LOGIC; -- indicates whether ball is at current pixel position
    SIGNAL bat_on : STD_LOGIC; -- indicates whether bat at over current pixel position
    SIGNAL game_on : STD_LOGIC := '0'; -- indicates whether ball is in play
    -- current ball position - intitialized to center of screen
    SIGNAL ball_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
    SIGNAL ball_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    -- bat vertical position
    CONSTANT bat_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(500, 11);
    -- current ball motion - initialized to (+ ball_speed) pixels/frame in both X and Y directions
    SIGNAL ball_x_motion, ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    
    SIGNAL SEG7_data : STD_LOGIC_VECTOR (15 DOWNTO 0);
    
    
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
    
BEGIN

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
    );
    brick8 : brick
    PORT MAP(
        v_sync => v_sync,
        --brick_x => brick1x+5,
        brick_x => (brick1x+450),
        brick_y => (brick1y+brick1y),
        ball_x1 => ball_x,
        ball_y1 => ball_y,
        bsize1 => bsize,
        present => brick8present
    );
    brick9 : brick
    PORT MAP(
        v_sync => v_sync,
        --brick_x => brick1x+5,
        brick_x => (brick1x+600),
        brick_y => (brick1y),
        ball_x1 => ball_x,
        ball_y1 => ball_y,
        bsize1 => bsize,
        present => brick9present
    );
    brick10 : brick
    PORT MAP(
        v_sync => v_sync,
        --brick_x => brick1x+5,
        brick_x => (brick1x+600),
        brick_y => (brick1y+brick1y),
        ball_x1 => ball_x,
        ball_y1 => ball_y,
        bsize1 => bsize,
        present => brick10present
    );
    brick11 : brick
    PORT MAP(
        v_sync => v_sync,
        --brick_x => brick1x+5,
        brick_x => (brick1x),
        brick_y => (brick1y+brick1y+brick1y),
        ball_x1 => ball_x,
        ball_y1 => ball_y,
        bsize1 => bsize,
        present => brick11present
    );
    brick12 : brick
    PORT MAP(
        v_sync => v_sync,
        --brick_x => brick1x+5,
        brick_x => (brick1x+150),
        brick_y => (brick1y+brick1y+brick1y),
        ball_x1 => ball_x,
        ball_y1 => ball_y,
        bsize1 => bsize,
        present => brick12present
    );
    brick13 : brick
    PORT MAP(
        v_sync => v_sync,
        --brick_x => brick1x+5,
        brick_x => (brick1x+300),
        brick_y => (brick1y+brick1y+brick1y),
        ball_x1 => ball_x,
        ball_y1 => ball_y,
        bsize1 => bsize,
        present => brick13present
    );
    brick14 : brick
    PORT MAP(
        v_sync => v_sync,
        --brick_x => brick1x+5,
        brick_x => (brick1x+450),
        brick_y => (brick1y+brick1y+brick1y),
        ball_x1 => ball_x,
        ball_y1 => ball_y,
        bsize1 => bsize,
        present => brick14present
    );
    brick15 : brick
    PORT MAP(
        v_sync => v_sync,
        --brick_x => brick1x+5,
        brick_x => (brick1x+600),
        brick_y => (brick1y+brick1y+brick1y),
        ball_x1 => ball_x,
        ball_y1 => ball_y,
        bsize1 => bsize,
        present => brick15present
    );
    red <= NOT bat_on; -- color setup for red ball and cyan bat on white background
    green <= NOT brick_on AND NOT ball_on ; --bricks are purple (red and blue)
    blue <= NOT ball_on;
    -- process to draw round ball
    -- set ball_on if current pixel address is covered by ball position
    balldraw : PROCESS (ball_x, ball_y, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF pixel_col <= ball_x THEN -- vx = |ball_x - pixel_col|
            vx := ball_x - pixel_col;
        ELSE
            vx := pixel_col - ball_x;
        END IF;
        IF pixel_row <= ball_y THEN -- vy = |ball_y - pixel_row|
            vy := ball_y - pixel_row;
        ELSE
            vy := pixel_row - ball_y;
        END IF;
        IF ((vx * vx) + (vy * vy)) < (bsize * bsize) THEN -- test if radial distance < bsize
            ball_on <= game_on;
        ELSE
            ball_on <= '0';
        END IF;
    END PROCESS;
    -- process to draw bat
    -- set bat_on if current pixel address is covered by bat position
    batdraw : PROCESS (bat_x, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF ((pixel_col >= bat_x - bat_w) OR (bat_x <= bat_w)) AND
         pixel_col <= bat_x + bat_w AND
             pixel_row >= bat_y - bat_h AND
             pixel_row <= bat_y + bat_h THEN
                bat_on <= '1';
        ELSE
            bat_on <= '0';
        END IF;
    END PROCESS;
    
    -- Process to draw Brick, set brick_on if current pixel address is covered by brick pos.
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
        ELSIF brick7present = '1' AND ((pixel_col >= (brick1x+300) - brick_width) OR ((brick1x) <= brick_width)) AND
        (pixel_col <= (brick1x+300) + brick_width) AND
             (pixel_row >= (brick1y+brick1y) - brick_height) AND
             (pixel_row <= (brick1y+brick1y) + brick_height) THEN
                brick_on <= '1';
        ELSIF brick8present = '1' AND ((pixel_col >= (brick1x+450) - brick_width) OR ((brick1x) <= brick_width)) AND
        (pixel_col <= (brick1x+450) + brick_width) AND
             (pixel_row >= (brick1y+brick1y) - brick_height) AND
             (pixel_row <= (brick1y+brick1y) + brick_height) THEN
                brick_on <= '1';
        ELSIF brick9present = '1' AND ((pixel_col >= (brick1x+600) - brick_width) OR ((brick1x) <= brick_width)) AND
        (pixel_col <= (brick1x+600) + brick_width) AND
             (pixel_row >= (brick1y) - brick_height) AND
             (pixel_row <= (brick1y) + brick_height) THEN
                brick_on <= '1';
        ELSIF brick10present = '1' AND ((pixel_col >= (brick1x+600) - brick_width) OR ((brick1x) <= brick_width)) AND
        (pixel_col <= (brick1x+600) + brick_width) AND
             (pixel_row >= (brick1y+brick1y) - brick_height) AND
             (pixel_row <= (brick1y+brick1y) + brick_height) THEN
                brick_on <= '1';
        ELSIF brick11present = '1' AND ((pixel_col >= (brick1x) - brick_width) OR ((brick1x) <= brick_width)) AND
        (pixel_col <= (brick1x) + brick_width) AND
             (pixel_row >= (brick1y+brick1y+brick1y) - brick_height) AND
             (pixel_row <= (brick1y+brick1y+brick1y) + brick_height) THEN
                brick_on <= '1';
        ELSIF brick12present = '1' AND ((pixel_col >= (brick1x+150) - brick_width) OR ((brick1x) <= brick_width)) AND
        (pixel_col <= (brick1x+150) + brick_width) AND
             (pixel_row >= (brick1y+brick1y+brick1y) - brick_height) AND
             (pixel_row <= (brick1y+brick1y+brick1y) + brick_height) THEN
                brick_on <= '1';
        ELSIF brick13present = '1' AND ((pixel_col >= (brick1x+300) - brick_width) OR ((brick1x) <= brick_width)) AND
        (pixel_col <= (brick1x+300) + brick_width) AND
             (pixel_row >= (brick1y+brick1y+brick1y) - brick_height) AND
             (pixel_row <= (brick1y+brick1y+brick1y) + brick_height) THEN
                brick_on <= '1';
        ELSIF brick14present = '1' AND ((pixel_col >= (brick1x+450) - brick_width) OR ((brick1x) <= brick_width)) AND
        (pixel_col <= (brick1x+450) + brick_width) AND
             (pixel_row >= (brick1y+brick1y+brick1y) - brick_height) AND
             (pixel_row <= (brick1y+brick1y+brick1y) + brick_height) THEN
                brick_on <= '1';
        ELSIF brick15present = '1' AND ((pixel_col >= (brick1x+600) - brick_width) OR ((brick1x) <= brick_width)) AND
        (pixel_col <= (brick1x+600) + brick_width) AND
             (pixel_row >= (brick1y+brick1y+brick1y) - brick_height) AND
             (pixel_row <= (brick1y+brick1y+brick1y) + brick_height) THEN
                brick_on <= '1';
        ELSE
            brick_on <= '0';
        END IF;
        
    END PROCESS;
    
    -- process to move ball once every frame (i.e., once every vsync pulse)
    mball : PROCESS
        VARIABLE temp : STD_LOGIC_VECTOR (11 DOWNTO 0);
    BEGIN
        WAIT UNTIL rising_edge(v_sync);
        IF sw = '1' THEN
            ball_speed <= CONV_STD_LOGIC_VECTOR (6, 11);
        ELSE
            ball_speed <= CONV_STD_LOGIC_VECTOR (3, 11);
        END IF;
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
        ELSIF ball_y <= bsize THEN -- bounce off top wall
            ball_y_motion <= ball_speed; -- set vspeed to (+ ball_speed) pixels
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
        IF game_on = '1' AND brick1present = '0' AND brick2present = '0' AND brick3present = '0' AND brick4present = '0' AND brick5present = '0' AND brick6present = '0' AND brick7present = '0' AND brick8present = '0' AND brick9present = '0' AND brick10present = '0' THEN
            disp_data <= "0110000000001101";
        END IF;
        -- allow for bounce off left or right of screen
        IF ball_x + bsize >= 800 THEN -- bounce off right wall
            ball_x_motion <= (NOT ball_speed) + 1; -- set hspeed to (- ball_speed) pixels
        ELSIF ball_x <= bsize THEN -- bounce off left wall
            ball_x_motion <= ball_speed; -- set hspeed to (+ ball_speed) pixels
        END IF;
        -- allow for bounce off bat
        IF (ball_x + bsize/2) >= (bat_x - bat_w) AND
         (ball_x - bsize/2) <= (bat_x + bat_w) AND
             (ball_y + bsize/2) >= (bat_y - bat_h) AND
             (ball_y - bsize/2) <= (bat_y + bat_h) THEN
                ball_y_motion <= (NOT ball_speed) + 1; -- set vspeed to (- ball_speed) pixels
        END IF;
        -- allow for bounce off top of the bricks
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
        IF (ball_x + bsize/2) >= ((brick1x+300) - brick_width) AND
         (ball_x - bsize/2) <= ((brick1x+300) + brick_width) AND
             (ball_y + bsize/2) >= (brick1y - brick_height) AND
             (ball_y - bsize/2) <= (brick1y + brick_height) AND brick3present = '1' THEN
                brick3present <= '0';
                IF(ball_y_motion = ball_speed) THEN
                    ball_y_motion <= (NOT ball_speed)+1;
                ELSE
                    ball_y_motion <= ball_speed;
                END IF;
        END IF;
        IF (ball_x + bsize/2) >= ((brick1x+450) - brick_width) AND
         (ball_x - bsize/2) <= ((brick1x+450) + brick_width) AND
             (ball_y + bsize/2) >= (brick1y - brick_height) AND
             (ball_y - bsize/2) <= (brick1y + brick_height) AND brick4present = '1' THEN
                brick4present <= '0';
                IF(ball_y_motion = ball_speed) THEN
                    ball_y_motion <= (NOT ball_speed)+1;
                ELSE
                    ball_y_motion <= ball_speed;
                END IF;
        END IF;
        IF (ball_x + bsize/2) >= ((brick1x) - brick_width) AND
         (ball_x - bsize/2) <= ((brick1x) + brick_width) AND
             (ball_y + bsize/2) >= ((brick1y+brick1y) - brick_height) AND
             (ball_y - bsize/2) <= ((brick1y+brick1y) + brick_height) AND brick5present = '1' THEN
                brick5present <= '0';
                IF(ball_y_motion = ball_speed) THEN
                    ball_y_motion <= (NOT ball_speed)+1;
                ELSE
                    ball_y_motion <= ball_speed;
                END IF;
        END IF;
        IF (ball_x + bsize/2) >= ((brick1x+150) - brick_width) AND
         (ball_x - bsize/2) <= ((brick1x+150) + brick_width) AND
             (ball_y + bsize/2) >= ((brick1y+brick1y) - brick_height) AND
             (ball_y - bsize/2) <= ((brick1y+brick1y) + brick_height) AND brick6present = '1' THEN
                brick6present <= '0';
                IF(ball_y_motion = ball_speed) THEN
                    ball_y_motion <= (NOT ball_speed)+1;
                ELSE
                    ball_y_motion <= ball_speed;
                END IF;
        END IF;
        IF (ball_x + bsize/2) >= ((brick1x+300) - brick_width) AND
         (ball_x - bsize/2) <= ((brick1x+300) + brick_width) AND
             (ball_y + bsize/2) >= ((brick1y+brick1y) - brick_height) AND
             (ball_y - bsize/2) <= ((brick1y+brick1y) + brick_height) AND brick7present = '1' THEN
                brick7present <= '0';
                IF(ball_y_motion = ball_speed) THEN
                    ball_y_motion <= (NOT ball_speed)+1;
                ELSE
                    ball_y_motion <= ball_speed;
                END IF;
        END IF;
        IF (ball_x + bsize/2) >= ((brick1x+450) - brick_width) AND
         (ball_x - bsize/2) <= ((brick1x+450) + brick_width) AND
             (ball_y + bsize/2) >= ((brick1y+brick1y) - brick_height) AND
             (ball_y - bsize/2) <= ((brick1y+brick1y) + brick_height) AND brick8present = '1' THEN
                brick8present <= '0';
                IF(ball_y_motion = ball_speed) THEN
                    ball_y_motion <= (NOT ball_speed)+1;
                ELSE
                    ball_y_motion <= ball_speed;
                END IF;
        END IF;
        IF (ball_x + bsize/2) >= ((brick1x+600) - brick_width) AND
         (ball_x - bsize/2) <= ((brick1x+600) + brick_width) AND
             (ball_y + bsize/2) >= ((brick1y) - brick_height) AND
             (ball_y - bsize/2) <= ((brick1y) + brick_height) AND brick9present = '1' THEN
                brick9present <= '0';
                IF(ball_y_motion = ball_speed) THEN
                    ball_y_motion <= (NOT ball_speed)+1;
                ELSE
                    ball_y_motion <= ball_speed;
                END IF;
        END IF;
        IF (ball_x + bsize/2) >= ((brick1x+600) - brick_width) AND
         (ball_x - bsize/2) <= ((brick1x+600) + brick_width) AND
             (ball_y + bsize/2) >= ((brick1y+brick1y) - brick_height) AND
             (ball_y - bsize/2) <= ((brick1y+brick1y) + brick_height) AND brick10present = '1' THEN
                brick10present <= '0';
                IF(ball_y_motion = ball_speed) THEN
                    ball_y_motion <= (NOT ball_speed)+1;
                ELSE
                    ball_y_motion <= ball_speed;
                END IF;
        END IF;
        IF (ball_x + bsize/2) >= ((brick1x) - brick_width) AND
         (ball_x - bsize/2) <= ((brick1x) + brick_width) AND
             (ball_y + bsize/2) >= ((brick1y+brick1y+brick1y) - brick_height) AND
             (ball_y - bsize/2) <= ((brick1y+brick1y+brick1y) + brick_height) AND brick11present = '1' THEN
                brick11present <= '0';
                IF(ball_y_motion = ball_speed) THEN
                    ball_y_motion <= (NOT ball_speed)+1;
                ELSE
                    ball_y_motion <= ball_speed;
                END IF;
        END IF;
        IF (ball_x + bsize/2) >= ((brick1x+150) - brick_width) AND
         (ball_x - bsize/2) <= ((brick1x+150) + brick_width) AND
             (ball_y + bsize/2) >= ((brick1y+brick1y+brick1y) - brick_height) AND
             (ball_y - bsize/2) <= ((brick1y+brick1y+brick1y) + brick_height) AND brick12present = '1' THEN
                brick12present <= '0';
                IF(ball_y_motion = ball_speed) THEN
                    ball_y_motion <= (NOT ball_speed)+1;
                ELSE
                    ball_y_motion <= ball_speed;
                END IF;
        END IF;
        IF (ball_x + bsize/2) >= ((brick1x+300) - brick_width) AND
         (ball_x - bsize/2) <= ((brick1x+300) + brick_width) AND
             (ball_y + bsize/2) >= ((brick1y+brick1y+brick1y) - brick_height) AND
             (ball_y - bsize/2) <= ((brick1y+brick1y+brick1y) + brick_height) AND brick13present = '1' THEN
                brick13present <= '0';
                IF(ball_y_motion = ball_speed) THEN
                    ball_y_motion <= (NOT ball_speed)+1;
                ELSE
                    ball_y_motion <= ball_speed;
                END IF;
        END IF;
        IF (ball_x + bsize/2) >= ((brick1x+450) - brick_width) AND
         (ball_x - bsize/2) <= ((brick1x+450) + brick_width) AND
             (ball_y + bsize/2) >= ((brick1y+brick1y+brick1y) - brick_height) AND
             (ball_y - bsize/2) <= ((brick1y+brick1y+brick1y) + brick_height) AND brick14present = '1' THEN
                brick14present <= '0';
                IF(ball_y_motion = ball_speed) THEN
                    ball_y_motion <= (NOT ball_speed)+1;
                ELSE
                    ball_y_motion <= ball_speed;
                END IF;
        END IF;
        IF (ball_x + bsize/2) >= ((brick1x+600) - brick_width) AND
         (ball_x - bsize/2) <= ((brick1x+600) + brick_width) AND
             (ball_y + bsize/2) >= ((brick1y+brick1y+brick1y) - brick_height) AND
             (ball_y - bsize/2) <= ((brick1y+brick1y+brick1y) + brick_height) AND brick15present = '1' THEN
                brick15present <= '0';
                IF(ball_y_motion = ball_speed) THEN
                    ball_y_motion <= (NOT ball_speed)+1;
                ELSE
                    ball_y_motion <= ball_speed;
                END IF;
        END IF;
        
        -- allow for bounce off bottom of the bricks
--        IF (ball_x + bsize/2) >= (brick1x - brick_width) AND
--         (ball_x - bsize/2) <= (brick1x + brick_width) AND
--             (ball_y + bsize/2) >= (brick1y + brick_height) AND
--             (ball_y - bsize/2) <= (brick1y - brick_height) AND brick1present = '1' THEN
--                ball_y_motion <= ball_speed; -- set vspeed to (- ball_speed) pixels
--                brick1present <= '0';
--        END IF;
        
        -- compute next ball vertical position
        -- variable temp adds one more bit to calculation to fix unsigned underflow problems
        -- when ball_y is close to zero and ball_y_motion is negative
        temp := ('0' & ball_y) + (ball_y_motion(10) & ball_y_motion);
        IF game_on = '0' THEN
            ball_y <= CONV_STD_LOGIC_VECTOR(440, 11);
        ELSIF temp(11) = '1' THEN
            ball_y <= (OTHERS => '0');
        ELSE ball_y <= temp(10 DOWNTO 0); -- 9 downto 0
        END IF;
        -- compute next ball horizontal position
        -- variable temp adds one more bit to calculation to fix unsigned underflow problems
        -- when ball_x is close to zero and ball_x_motion is negative
        temp := ('0' & ball_x) + (ball_x_motion(10) & ball_x_motion);
        IF temp(11) = '1' THEN
            ball_x <= (OTHERS => '0');
        ELSE ball_x <= temp(10 DOWNTO 0);
        END IF;
    END PROCESS;
END Behavioral;
