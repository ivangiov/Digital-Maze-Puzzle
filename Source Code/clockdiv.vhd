LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE  IEEE.STD_LOGIC_ARITH.ALL; 
USE  IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CLOCKDIV is port(
	CLK: IN std_logic;
	IN_DIV : IN std_logic;
	O_DIVOUT: OUT std_logic);
end CLOCKDIV;

architecture behavioral of CLOCKDIV is
signal DIVOUT : std_logic;
	begin
		PROCESS(CLK, IN_DIV)
			variable count: integer:=0;
			variable div: integer;		
		begin
			IF (IN_DIV = '0') THEN
				div := 200000;
			ELSIF (IN_DIV = '1') THEN
				div := 100000;
			END IF;
	
			if CLK'event and CLK='1' then
				if(count < div) then
					count := count+1;						
					if(DIVOUT = '0') then
						DIVOUT <= '0';
					elsif(DIVOUT = '1') then
						DIVOUT <= '1';
					end if;
				else
					if(DIVOUT = '0') then
						DIVOUT <= '1';
					elsif(DIVOUT = '1') then
						DIVOUT <= '0';
					end if;
				count := 0;
				end if;

			end if;
		end process;
		O_DIVOUT <= DIVOUT;
end behavioral;