----------------------------------------------------------------------------------
-- Company:
-- Engineer:       Jacques Pelletier
--
-- Create Date:    15:58:46 07/16/2024
-- Design Name:
-- Module Name:    intz80 - Behavioral
-- Project Name:    Z80
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- This controler provides 16 vectors corresponding to 16 interrupt inputs
-- A rising edge on the interrupt trigger the interrupt cycle until the Z80 clears
-- it with an INTA cycle.
-- INTE inputs provide enable signals for each interrupt. The user should provide
-- 2 registers to store the enable signals.
----------------------------------------------------------------------------------
-- Implements an interrupt controller which provides vectors in mode 2 to the Z80
--    Copyright (C) 2024  Jacques Pelletier
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <https://www.gnu.org/licenses/>.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity intz80 is
	Port ( int: in  STD_LOGIC_VECTOR (15 downto 0);
          int_o : out  STD_LOGIC;
            clk : in  STD_LOGIC;
          iei : in  STD_LOGIC;
          ieo : out  STD_LOGIC;
          vect : out  STD_LOGIC_VECTOR (7 downto 0);
          m1: in  STD_LOGIC;
			 inta : in  STD_LOGIC;
          reset : in  STD_LOGIC;
          inte : in  STD_LOGIC_VECTOR (15 downto 0));
end intz80;

architecture Behavioral of intz80 is

--signal intr_ff[15..0]: STD_LOGIC_VECTOR (15 downto 0));
signal irq: STD_LOGIC_VECTOR (15 downto 0);
signal ar_irq: STD_LOGIC_VECTOR (15 downto 0);
signal priority: STD_LOGIC_VECTOR (15 downto 0);
signal vreg: STD_LOGIC_VECTOR (4 downto 0);
signal int_valid: STD_LOGIC;
signal ivalid1: STD_LOGIC;
signal ivalid2: STD_LOGIC;
signal my_inta: STD_LOGIC;

begin

int_o <= ivalid2;
ieo <= not int_valid;
my_inta <= iei and inta and int_valid;
vect <= B"111" & vreg(3 downto 0) & '0';

-- For clearing the active interrupt
ar_irq(0)  <= my_inta and vreg(4) and not vreg(3) and not vreg(2) and not vreg(1) and not vreg(0);
ar_irq(1)  <= my_inta and vreg(4) and not vreg(3) and not vreg(2) and not vreg(1) and  vreg(0);
ar_irq(2)  <= my_inta and vreg(4) and not vreg(3) and not vreg(2) and  vreg(1) and not vreg(0);
ar_irq(3)  <= my_inta and vreg(4) and not vreg(3) and not vreg(2) and  vreg(1) and  vreg(0);
ar_irq(4)  <= my_inta and vreg(4) and not vreg(3) and  vreg(2) and not vreg(1) and not vreg(0);
ar_irq(5)  <= my_inta and vreg(4) and not vreg(3) and  vreg(2) and not vreg(1) and  vreg(0);
ar_irq(6)  <= my_inta and vreg(4) and not vreg(3) and  vreg(2) and  vreg(1) and not vreg(0);
ar_irq(7)  <= my_inta and vreg(4) and not vreg(3) and  vreg(2) and  vreg(1) and  vreg(0);
ar_irq(8)  <= my_inta and vreg(4) and  vreg(3) and not vreg(2) and not vreg(1) and not vreg(0);
ar_irq(9)  <= my_inta and vreg(4) and  vreg(3) and not vreg(2) and not vreg(1) and  vreg(0);
ar_irq(10) <= my_inta and vreg(4) and  vreg(3) and not vreg(2) and  vreg(1) and not vreg(0);
ar_irq(11) <= my_inta and vreg(4) and  vreg(3) and not vreg(2) and  vreg(1) and  vreg(0);
ar_irq(12) <= my_inta and vreg(4) and  vreg(3) and  vreg(2) and not vreg(1) and not vreg(0);
ar_irq(13) <= my_inta and vreg(4) and  vreg(3) and  vreg(2) and not vreg(1) and  vreg(0);
ar_irq(14) <= my_inta and vreg(4) and  vreg(3) and  vreg(2) and  vreg(1) and not vreg(0);
ar_irq(15) <= my_inta and vreg(4) and  vreg(3) and  vreg(2) and  vreg(1) and  vreg(0);

-- Select the interrupt by priority
priority(15) <= iei and irq(15);
priority(14) <= iei and not irq(15) and irq(14);
priority(13) <= iei and not irq(15) and not irq(14) and irq(13);
priority(12) <= iei and not irq(15) and not irq(14) and not irq(13) and irq(12);
priority(11) <= iei and not irq(15) and not irq(14) and not irq(13) and not irq(12) and irq(11);
priority(10) <= iei and not irq(15) and not irq(14) and not irq(13) and not irq(12) and not irq(11) and irq(10);
priority(9)  <= iei and not irq(15) and not irq(14) and not irq(13) and not irq(12) and not irq(11) and not irq(10) and irq(9);
priority(8)  <= iei and not irq(15) and not irq(14) and not irq(13) and not irq(12) and not irq(11) and not irq(10) and not irq(9) and irq(8);
priority(7)  <= iei and not irq(15) and not irq(14) and not irq(13) and not irq(12) and not irq(11) and not irq(10) and not irq(9) and not irq(8) and irq(7);
priority(6)  <= iei and not irq(15) and not irq(14) and not irq(13) and not irq(12) and not irq(11) and not irq(10) and not irq(9) and not irq(8) and not irq(7) and irq(6);
priority(5)  <= iei and not irq(15) and not irq(14) and not irq(13) and not irq(12) and not irq(11) and not irq(10) and not irq(9) and not irq(8) and not irq(7) and not irq(6) and irq(5);
priority(4)  <= iei and not irq(15) and not irq(14) and not irq(13) and not irq(12) and not irq(11) and not irq(10) and not irq(9) and not irq(8) and not irq(7) and not irq(6) and not irq(5) and irq(4);
priority(3)  <= iei and not irq(15) and not irq(14) and not irq(13) and not irq(12) and not irq(11) and not irq(10) and not irq(9) and not irq(8) and not irq(7) and not irq(6) and not irq(5) and not irq(4) and irq(3);
priority(2)  <= iei and not irq(15) and not irq(14) and not irq(13) and not irq(12) and not irq(11) and not irq(10) and not irq(9) and not irq(8) and not irq(7) and not irq(6) and not irq(5) and not irq(4) and not irq(3) and irq(2);
priority(1)  <= iei and not irq(15) and not irq(14) and not irq(13) and not irq(12) and not irq(11) and not irq(10) and not irq(9) and not irq(8) and not irq(7) and not irq(6) and not irq(5) and not irq(4) and not irq(3) and not irq(2) and irq(1);
priority(0)  <= iei and not irq(15) and not irq(14) and not irq(13) and not irq(12) and not irq(11) and not irq(10) and not irq(9) and not irq(8) and not irq(7) and not irq(6) and not irq(5) and not irq(4) and not irq(3) and not irq(2) and not irq(1) and irq(0);

-- Update the vector register during the INTA cycle (INTA is M1 and IORQ combined)
proc_vreg: process(m1, reset)
begin
	if reset='1' then
		vreg <= B"00000";
	elsif m1'event and m1='1' then
		vreg(4) <= int_valid;
		vreg(3) <= priority(15) or priority(14) or priority(13) or priority(12) or priority(11) or priority(10) or priority(9) or priority(8);
		vreg(2) <= priority(15) or priority(14) or priority(13) or priority(12) or priority(7) or priority(6) or priority(5) or priority(4);
		vreg(1) <= priority(15) or priority(14) or priority(11) or priority(10) or priority(7) or priority(6) or priority(3) or priority(2);
		vreg(0) <= priority(15) or priority(13) or priority(11) or priority(9) or priority(7) or priority(5) or priority(3) or priority(1);
	end if;
end process proc_vreg;

proc_ivalid: process(priority, inta, reset)
begin
	if reset='1' then
		int_valid <= '0';
	elsif not (priority = X"0000") then
		-- INT_VALID.AP = Or all priority
		int_valid <= '1';
	elsif inta'event and inta='0' then
		-- INT_VALID.D = 'b'0;
		int_valid <= '0';
	end if;
end process proc_ivalid;

-- Generate the interrupt pulse, inta ends it.
proc_ivalid12: process(clk, reset, my_inta, vreg(4))
begin
	if reset='1' or (my_inta='1' and vreg(4)='1') then
		ivalid1 <= '0';
		ivalid2 <= '0';
	elsif clk'event and clk='1' then
		ivalid1 <= int_valid;
		ivalid2 <= ivalid1;
	end if;
end process proc_ivalid12;

-- Each interrupt has its process
proc_irq_0: process(int(0), ar_irq(0), reset)
begin
	if reset='1' or ar_irq(0)='1' then
		irq(0) <= '0';
	elsif int(0)'event and int(0)='1' then
		irq(0) <= inte(0);
	end if;
end process proc_irq_0;

proc_irq_1: process(int(1), ar_irq(1), reset)
begin
	if reset='1' or ar_irq(1)='1' then
		irq(1) <= '0';
	elsif int(1)'event and int(1)='1' then
		irq(1) <= inte(1);
	end if;
end process proc_irq_1;

proc_irq_2: process(int(2), ar_irq(2), reset)
begin
	if reset='1' or ar_irq(2)='1' then
		irq(2) <= '0';
	elsif int(2)'event and int(2)='1' then
		irq(2) <= inte(2);
	end if;
end process proc_irq_2;

proc_irq_3: process(int(3), ar_irq(3), reset)
begin
	if reset='1' or ar_irq(3)='1' then
		irq(3) <= '0';
	elsif int(3)'event and int(3)='1' then
		irq(3) <= inte(3);
	end if;
end process proc_irq_3;

proc_irq_4: process(int(4), ar_irq(4), reset)
begin
	if reset='1' or ar_irq(4)='1' then
		irq(4) <= '0';
	elsif int(4)'event and int(4)='1' then
		irq(4) <= inte(4);
	end if;
end process proc_irq_4;

proc_irq_5: process(int(5), ar_irq(5), reset)
begin
	if reset='1' or ar_irq(5)='1' then
		irq(5) <= '0';
	elsif int(5)'event and int(5)='1' then
		irq(5) <= inte(5);
	end if;
end process proc_irq_5;

proc_irq_6: process(int(6), ar_irq(6), reset)
begin
	if reset='1' or ar_irq(6)='1' then
		irq(6) <= '0';
	elsif int(6)'event and int(6)='1' then
		irq(6) <= inte(6);
	end if;
end process proc_irq_6;

proc_irq_7: process(int(7), ar_irq(7), reset)
begin
	if reset='1' or ar_irq(7)='1' then
		irq(7) <= '0';
	elsif int(7)'event and int(7)='1' then
		irq(7) <= inte(7);
	end if;
end process proc_irq_7;

proc_irq_8: process(int(8), ar_irq(8), reset)
begin
	if reset='1' or ar_irq(8)='1' then
		irq(8) <= '0';
	elsif int(8)'event and int(8)='1' then
		irq(8) <= inte(8);
	end if;
end process proc_irq_8;

proc_irq_9: process(int(9), ar_irq(9), reset)
begin
	if reset='1' or ar_irq(9)='1' then
		irq(9) <= '0';
	elsif int(9)'event and int(9)='1' then
		irq(9) <= inte(9);
	end if;
end process proc_irq_9;

proc_irq_10: process(int(10), ar_irq(10), reset)
begin
	if reset='1' or ar_irq(10)='1' then
		irq(10) <= '0';
	elsif int(10)'event and int(10)='1' then
		irq(10) <= inte(10);
	end if;
end process proc_irq_10;

proc_irq_11: process(int(11), ar_irq(11), reset)
begin
	if reset='1' or ar_irq(11)='1' then
		irq(11) <= '0';
	elsif int(11)'event and int(11)='1' then
		irq(11) <= inte(11);
	end if;
end process proc_irq_11;

proc_irq_12: process(int(12), ar_irq(12), reset)
begin
	if reset='1' or ar_irq(12)='1' then
		irq(12) <= '0';
	elsif int(12)'event and int(12)='1' then
		irq(12) <= inte(12);
	end if;
end process proc_irq_12;

proc_irq_13: process(int(13), ar_irq(13), reset)
begin
	if reset='1' or ar_irq(13)='1' then
		irq(13) <= '0';
	elsif int(13)'event and int(13)='1' then
		irq(13) <= inte(13);
	end if;
end process proc_irq_13;

proc_irq_14: process(int(14), ar_irq(14), reset)
begin
	if reset='1' or ar_irq(14)='1' then
		irq(14) <= '0';
	elsif int(14)'event and int(14)='1' then
		irq(14) <= inte(14);
	end if;
end process proc_irq_14;

proc_irq_15: process(int(15), ar_irq(15), reset)
begin
	if reset='1' or ar_irq(15)='1' then
		irq(15) <= '0';
	elsif int(15)'event and int(15)='1' then
		irq(15) <= inte(15);
	end if;
end process proc_irq_15;

end Behavioral;
