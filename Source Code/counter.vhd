LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.STD_LOGIC_ARITH.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY counter  IS 
	PORT(  
		i_clk			   	:  IN   STD_LOGIC;
		i_div				:  IN   STD_LOGIC;
		reset			   	:  IN   STD_LOGIC;
		i_inc_row          	:  IN   STD_LOGIC; 
		i_dec_row          	:  IN   STD_LOGIC;
		i_inc_column	   	:  IN   STD_LOGIC;
		i_dec_column		:  IN   STD_LOGIC;
		o_obj_row	       	:  OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		o_obj_column		:  OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		vObs1				:  OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		hObs1				:  OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		vObs2				:  OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		hObs2				:  OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		vObs3				:  OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		hObs3				:  OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		vObs4				:  OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		hObs4				:  OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		vObs5				:  OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		hObs5				:  OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		vObs6				:  OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		hObs6				:  OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		o_clk				:  OUT  STD_LOGIC;
		finish				:  OUT  STD_LOGIC;
		hit_obstacle		:  OUT  STD_LOGIC
		);
END counter; 

ARCHITECTURE behavioral OF counter  IS 

SIGNAL count_row      	: STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := "0010010010"; -- 54
SIGNAL count_column     : STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := "0010000001"; -- 10
SIGNAL obs1_row			: STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := "0000101101"; -- 45
SIGNAL obs1_column		: STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := "0010000001"; -- 129
SIGNAL obs2_row			: STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := "0010000001"; -- 129
SIGNAL obs2_column		: STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := "0011100101"; -- 229
SIGNAL obs3_row			: STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := "0000101101"; -- 45
SIGNAL obs3_column		: STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := "0101001001"; -- 329
SIGNAL obs4_row			: STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := "0001110111"; -- 119
SIGNAL obs4_column		: STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := "0110101101"; -- 429
SIGNAL obs5_row			: STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := "0011000011"; -- 195
SIGNAL obs5_column		: STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := "0110101101"; -- 429
SIGNAL obs6_row			: STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := "0100101001"; -- 297 
SIGNAL obs6_column		: STD_LOGIC_VECTOR( 9 DOWNTO 0 ) := "0010000001"; -- 129
SIGNAL obs3_atas		: STD_LOGIC := '0';
SIGNAL obs4_atas		: STD_LOGIC := '1';
SIGNAL clock_obj		: STD_LOGIC;
SIGNAL clock_obs		: STD_LOGIC;


component CLOCKDIV is port(
	CLK: IN std_logic;
	IN_DIV : IN std_logic;
	O_DIVOUT: OUT std_logic);
end component;

BEGIN  

-- Counter Objek Player --
player_object : PROCESS(clock_obj, reset)
	BEGIN 
	if (reset = '1') then
		count_row <= "0000110110"; 
		count_column <= "0000001010";
	else
		IF(  clock_obj'EVENT  ) AND ( clock_obj  = '1'  ) then
			if (i_inc_row = '0' and i_dec_row = '1') then
				if ((count_row >= 45 and count_row < 179-33) or 
					(count_row >= 195 and count_row < 330-33) or 
					(count_row >= 345 and count_row < 479-33))then
						count_row <= count_row + 1;
				elsif (count_row>=179-33 and count_row <= 195 and count_column >= 505) or 
					  (count_row >= 329-33 and count_row <= 345 and count_column <= 102) then
					count_row <= count_row + 1;
				end if;
			elsif (i_dec_row = '0' and i_inc_row = '1') then
				if ((count_row > 45 and count_row <= 179-33) or 
					(count_row > 195 and count_row <= 330-33) or 
					(count_row > 345 and count_row <= 479-33))then
					count_row <= count_row - 1;
				elsif (count_row>= 179-33 and count_row <= 195 and count_column >= 505) or 
					  (count_row >= 329-33 and count_row <= 345 and count_column <= 102) then
					count_row <= count_row - 1;
				end if;
			end if;
			if (i_inc_column = '0' and i_dec_column = '1') then
				if ((count_row >= 45 and count_row <= 179-33 and count_column < 639-33) or 
				   (count_row >= 195 and count_row <= 330-33 and count_column < 639-33) or 
				   (count_row >= 345 and count_row <= 479-33 and count_column < 639-33))then
					count_column <= count_column + 1;
				elsif (count_row>=179-33 and count_row <= 195 and count_column >= 505 and count_column < 639-33) or 
					  (count_row >= 329-33 and count_row <= 345 and count_column < 135-33) then
					count_column <= count_column + 1;
				end if; 
			elsif (i_dec_column = '0' and i_inc_column = '1') then
				if ((count_row >= 45 and count_row <= 179-33 and count_column > 0) or 
					(count_row >= 195 and count_row <= 330-33 and count_column > 0) or 
					(count_row >= 345 and count_row <= 479-33 and  count_column > 0))then
					count_column <= count_column - 1;
				elsif (count_row >= 179-33 and count_row <= 195 and count_column > 505) or 
					  (count_row >= 329-33 and count_row <= 345 and count_column > 0 and count_column <= 135-33) then
					count_column <= count_column - 1;
				end if;
			end if;
		END IF;
	end if;
END  PROCESS; 

-- Counter Obstacle 3 --
obstacle_3 : PROCESS(clock_obs, reset)
	BEGIN 
	if (reset = '1') then
		obs3_row <= "0010000001"; 
		obs3_column <= "0101001001";
		obs3_atas <= '0';
	else
		IF((  clock_obs'EVENT  ) AND ( clock_obs  = '1'  )) then
			IF (obs3_atas = '1') THEN
				IF (obs3_row > 45) THEN
					obs3_row <= obs3_row - 1;
				ELSE
					obs3_atas <= '0';
				end IF;
			ELSIF (obs3_atas  = '0') THEN
				IF (obs3_row < 119+27) THEN
				obs3_row <= obs3_row + 1;
				ELSE
					obs3_atas <= '1';
				end IF;
			END IF;
		END IF;
	end if;
END  PROCESS;

-- Counter Obstacle 4 --
obstacle_4 : PROCESS(clock_obs, reset)
	BEGIN 
	if (reset = '1') then
		obs4_row <= "0001110111"; 
		obs4_column <= "0110101101";
		obs4_atas <= '1';
	else
		IF((  clock_obs'EVENT  ) AND ( clock_obs  = '1'  )) then
			IF (obs4_atas = '1') THEN
				IF (obs4_row > 45) THEN
					obs4_row <= obs4_row - 1;
				ELSE
					obs4_atas <= '0';
				end IF;
			ELSIF (obs4_atas  = '0') THEN
				IF (obs4_row < 119+27) THEN
				obs4_row <= obs4_row + 1;
				ELSE
					obs4_atas <= '1';
				end IF;
			END IF;
		END IF;
	end if;
END  PROCESS;

-- Counter Obstacle 5 --
obstacle_5 : PROCESS(clock_obs, reset)
	BEGIN 
	if (reset = '1') then
		obs5_row <= "0011000011"; 
		obs5_column <= "0110101101";
	else
		IF(  clock_obs'EVENT  ) AND ( clock_obs  = '1'  ) then
			IF (obs5_row < 330-33 ) AND (obs5_column = 429) THEN
				obs5_row <= obs5_row + 1;
			ELSIF ( obs5_column > 129) AND (obs5_row = 330-33) THEN
				obs5_column <= obs5_column - 1;
			ELSIF ( obs5_row > 195 ) AND ( obs5_column = 129 ) THEN
				obs5_row <= obs5_row - 1;
			ELSIF ( obs5_column < 429 ) AND ( obs5_row = 195 ) THEN
				obs5_column <= obs5_column + 1;
			END IF;
		END IF;
	end if;
END  PROCESS;

-- Counter Obstacle 6 --
obstacle_6 : PROCESS(clock_obs, reset)
	BEGIN 
	if (reset = '1') then
		obs6_row <= "0100101001"; 
		obs6_column <= "0010000001";
	else
		IF(  clock_obs'EVENT  ) AND ( clock_obs  = '1'  ) then
			IF (obs6_row < 330-33 ) AND (obs6_column = 429) THEN
				obs6_row <= obs6_row + 1;
			ELSIF ( obs6_column > 129) AND (obs6_row = 330-33) THEN
				obs6_column <= obs6_column - 1;
			ELSIF ( obs6_row > 195 ) AND ( obs6_column = 129 ) THEN
				obs6_row <= obs6_row - 1;
			ELSIF ( obs6_column < 429 ) AND ( obs6_row = 195 ) THEN
				obs6_column <= obs6_column + 1;
			END IF;
		END IF;
	end if;
END  PROCESS;
	
-- Mengeluarkan output posisi objek dan setiap obstacle --
vObs1 <= obs1_row;
hObs1 <= obs1_column;
vObs2 <= obs2_row;
hObs2 <= obs2_column;
vObs3 <= obs3_row;
hObs3 <= obs3_column;
vObs4 <= obs4_row;
hObs4 <= obs4_column;
vObs5 <= obs5_row;
hObs5 <= obs5_column;
vObs6 <= obs6_row;
hObs6 <= obs6_column;

o_obj_row <= count_row;
o_obj_column <= count_column;

-- Kondisi dimana objek menabrak obstacle --
hit_condition : PROCESS(count_row, count_column, obs1_row, obs2_row, obs3_row, obs4_row, obs5_row, obs6_row,
						obs1_column, obs2_column, obs3_column, obs4_column, obs5_column, obs6_column)
-- Kondisi objek beririsan dengan obstacle (panjang obstacle belum ditentukan) --
BEGIN
	IF ((obs1_row-33 <= count_row AND count_row <= obs1_row+50 AND count_column+33 >= obs1_column AND count_column <= obs1_column+50 ) OR
		(obs2_row-33 <= count_row AND count_row <= obs2_row+50 AND count_column+33 >= obs2_column AND count_column <= obs2_column+50 ) OR
		(obs3_row-33 <= count_row AND count_row <= obs3_row+33 AND count_column+33 >= obs3_column AND count_column <= obs3_column+33 ) OR
		(obs4_row-33 <= count_row AND count_row <= obs4_row+33 AND count_column+33 >= obs4_column AND count_column <= obs4_column+33) OR
		(obs5_row <= count_row+33 AND count_row <= obs5_row+33 AND count_column+33 >= obs5_column AND count_column <= obs5_column+33 ) OR
		(obs6_row <= count_row+33 AND count_row <= obs6_row+33 AND count_column+33 >= obs6_column AND count_column <= obs6_column+33 ) 
) THEN
			hit_obstacle <= '1';
	ELSE
		hit_obstacle <= '0';
	END IF;
END PROCESS;

-- Kondisi dimana objek mencapai finish (garis finish masih belum ditentukan) --
finish_condition : PROCESS(count_row, count_column)
BEGIN
	IF (count_row = 312) THEN
		finish <= '1';
	ELSE
		finish <= '0';
	END IF;
END PROCESS;

-- Keluaran clockdiv --
obj_clock : clockdiv port map(i_clk, i_div, clock_obj);
obs_clock : clockdiv port map(i_clk, '0', clock_obs);
o_clk <= clock_obs;
END behavioral; 
