library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity brick is
    Port ( brick_x : in INTEGER;
           brick_y : in INTEGER;
           ball_x1 : in STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
           ball_y1 : in STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
           bsize1 : in INTEGER;
           present : out STD_LOGIC;
           v_sync : IN STD_LOGIC);
end brick;

architecture Behavioral of brick is
    --SIGNAL active : STD_LOGIC := '1';
    CONSTANT width : INTEGER := 60;
    CONSTANT height : INTEGER := 15;
begin
--    hit_detection : PROCESS
--    BEGIN
--    WAIT UNTIL rising_edge(v_sync);
--    IF(present = '1') AND
--        (ball_x1 + bsize1/2) >= (brick_x - width) AND
--         (ball_x1 - bsize1/2) <= (brick_x + width) AND
--          (ball_y1 + bsize1/2) >= (brick_y - height) AND
--          (ball_y1 - bsize1/2) <= (brick_y + height) THEN
--                active <= '0';    
--     END IF;
--     END PROCESS;
     --present <= active;
end Behavioral;
--IF (ball_x + bsize/2) >= (bat_x - bat_w) AND
--         (ball_x - bsize/2) <= (bat_x + bat_w) AND
--             (ball_y + bsize/2) >= (bat_y - bat_h) AND
--             (ball_y - bsize/2) <= (bat_y + bat_h) THEN
--                ball_y_motion <= (NOT ball_speed) + 1; -- set vspeed to (- ball_speed) pixels