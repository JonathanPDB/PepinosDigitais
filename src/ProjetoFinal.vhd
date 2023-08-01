entity TopLevel is
	Port (
		clk : in std_logic;
		ps2_clk, ps2_data : in std_logic; 
		
	);
end TopLevel;

architecture main of TopLevel is

	component keyboard is
	  port(
		 clk          : IN  STD_LOGIC;                     --system clock
		 ps2_clk      : IN  STD_LOGIC;                     --clock signal from PS/2 keyboard
		 ps2_data     : IN  STD_LOGIC;                     --data signal from PS/2 keyboard
		 --ps2_code_new : OUT STD_LOGIC;                     --flag that new PS/2 code is available on ps2_code bus
		 --ps2_code     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --code received from PS/2
		 upKey	  : OUT STD_LOGIC;
		 downKey	  : OUT STD_LOGIC;
		 leftKey	  : OUT STD_LOGIC;
		 rightKey  : OUT STD_LOGIC;
		 enterKey: OUT STD_LOGIC;
	end component;

	
	
end main;