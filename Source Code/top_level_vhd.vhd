LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.STD_LOGIC_ARITH.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY top_level_vhd  IS 
	PORT(
	i_div		: IN STD_LOGIC;
	reset		: IN STD_LOGIC;
	CLOCK_50   	: IN STD_LOGIC;
	i_inc_row	: IN STD_LOGIC;
	i_dec_row	: IN STD_LOGIC;
	i_inc_column: IN STD_LOGIC;
	i_dec_column: IN STD_LOGIC;
	VGA_R      	: OUT STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	VGA_G      	: OUT STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	VGA_B      	: OUT STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	VGA_HS     	: OUT STD_LOGIC;
	VGA_VS     	: OUT STD_LOGIC;
	VGA_CLK    	: OUT STD_LOGIC;
	VGA_BLANK  	: OUT STD_LOGIC;
	GPIO_0     	: OUT STD_LOGIC_VECTOR( 35 DOWNTO 0 );
	LEDR       	: OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 ));
END top_level_vhd; 

ARCHITECTURE behavioral OF top_level_vhd  IS 
   

SIGNAL  hPos : STD_LOGIC_VECTOR ( 9 DOWNTO 0 );
SIGNAL  vPos : STD_LOGIC_VECTOR ( 9 DOWNTO 0 ); 
SIGNAL  v_Obs1,v_Obs2,v_Obs3,v_Obs4,v_Obs5,v_Obs6,h_Obs1,h_Obs2,h_Obs3,h_Obs4,h_Obs5,h_Obs6 : STD_LOGIC_VECTOR (9 DOWNTO 0);
SIGNAL  z_signal : STD_LOGIC_VECTOR ( 4 DOWNTO 0 );  
SIGNAL finish_signal, hit_obstacle_signal, resetcounter_signal,clk : STD_LOGIC;
          

COMPONENT display_vhd  IS 
	PORT( 
	i_clk           : IN STD_LOGIC;
	reset			: IN STD_LOGIC;
	i_hPos			: IN STD_LOGIC_VECTOR ( 9 DOWNTO 0 );
	i_vPos			: IN STD_LOGIC_VECTOR ( 9 DOWNTO 0 );
	z				: IN STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	vObs1				:  IN  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	hObs1				:  IN  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	vObs2				:  IN  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	hObs2				:  IN  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	vObs3				:  IN  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	hObs3				:  IN  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	vObs4				:  IN  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	hObs4				:  IN  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	vObs5				:  IN  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	hObs5				:  IN  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	vObs6				:  IN  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	hObs6				:  IN  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	VGA_R           : OUT STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	VGA_G           : OUT STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	VGA_B           : OUT STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	VGA_HS          : OUT STD_LOGIC;
	VGA_VS          : OUT STD_LOGIC;
	VGA_CLK         : OUT STD_LOGIC;
	VGA_BLANK       : OUT STD_LOGIC);
END COMPONENT; 

COMPONENT counter IS
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
	hit_obstacle		:  OUT  STD_LOGIC);
END COMPONENT; 

COMPONENT maze IS 
	PORT(
	i_clk			: IN  STD_LOGIC; 
	reset			: IN  STD_LOGIC;
	finish			: IN  STD_LOGIC;
	hit_obstacle	: IN STD_LOGIC;
	z				: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	resetcounter	: OUT STD_LOGIC);
END COMPONENT; 

	
BEGIN 

module_vga : display_vhd 
	PORT MAP (
	i_clk			=> CLOCK_50,
	reset			=> reset,
	i_hPos			=> hPos,
	i_vPos			=> vPos,
	z				=> z_signal,
	vObs1			=> v_Obs1,
	hObs1			=> h_Obs1,
	vObs2			=> v_Obs2,
	hObs2			=> h_Obs2,
	vObs3			=> v_Obs3,
	hObs3			=> h_Obs3,
	vObs4			=> v_Obs4,
	hObs4			=> h_Obs4,
	vObs5			=> v_Obs5,
	hObs5			=> h_Obs5,
	vObs6			=> v_Obs6,
	hObs6			=> h_Obs6,  
	VGA_R			=> VGA_R,  
	VGA_G			=> VGA_G,  
	VGA_B			=> VGA_B,
	VGA_HS			=> VGA_HS,  
	VGA_VS			=> VGA_VS,
	VGA_CLK			=> VGA_CLK,
	VGA_BLANK		=> VGA_BLANK);
	
pos_counter : counter 
	PORT MAP (
	i_clk			=> CLOCK_50,
	i_div			=> i_div,
	reset			=> resetcounter_signal,
	i_inc_row		=> i_inc_row, 
	i_dec_row		=> i_dec_row,
	i_inc_column	=> i_inc_column,
	i_dec_column	=> i_dec_column,
	o_obj_row		=> vPos,
	o_obj_column	=> hPos,
	vObs1			=> v_Obs1,
	hObs1			=> h_Obs1,
	vObs2			=> v_Obs2,
	hObs2			=> h_Obs2,
	vObs3			=> v_Obs3,
	hObs3			=> h_Obs3,
	vObs4			=> v_Obs4,
	hObs4			=> h_Obs4,
	vObs5			=> v_Obs5,
	hObs5			=> h_Obs5,
	vObs6			=> v_Obs6,
	hObs6			=> h_Obs6,
	o_clk			=> clk,
	finish			=> finish_signal,
	hit_obstacle	=> hit_obstacle_signal);

fsm : maze 
	PORT MAP (
	i_clk			=> clk,
	reset			=> reset,
	finish			=> finish_signal,
	hit_obstacle	=> hit_obstacle_signal,
	z				=> z_signal,
	resetcounter	=> resetcounter_signal);
	
END behavioral; 