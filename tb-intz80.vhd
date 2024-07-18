--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   00:57:14 07/18/2024
-- Design Name:
-- Module Name:   /home/public/Documents/projects/electronique/Xilinx/test-intz80/tb-intz80.vhd
-- Project Name:  test-intz80
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: intz80
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes:
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_intz80 IS
END tb_intz80;

ARCHITECTURE behavior OF tb_intz80 IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT intz80
    PORT(
         int : IN  std_logic_vector(15 downto 0);
         int_o : OUT  std_logic;
         clk : IN  std_logic;
         iei : IN  std_logic;
         ieo : OUT  std_logic;
         vect : OUT  std_logic_vector(7 downto 0);
         m1 : IN  std_logic;
         inta : IN  std_logic;
         reset : IN  std_logic;
         inte : IN  std_logic_vector(15 downto 0)
        );
    END COMPONENT;


   --Inputs
   signal int : std_logic_vector(15 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal iei : std_logic := '1';
   signal m1 : std_logic := '0';
   signal inta : std_logic := '0';
   signal reset : std_logic := '0';
   signal inte : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal int_o : std_logic;
   signal ieo : std_logic;
   signal vect : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: intz80 PORT MAP (
          int => int,
          int_o => int_o,
          clk => clk,
          iei => iei,
          ieo => ieo,
          vect => vect,
          m1 => m1,
          inta => inta,
          reset => reset,
          inte => inte
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;


   -- Stimulus process
   stim_proc: process
   begin
      -- hold reset state for 100 ns.
		-- Setup
		iei <= '1';
		inte <= X"0004";
		int <= X"0000";

      wait for 100 ns;

      wait for clk_period*10;

      -- insert stimulus here

		-- Reset
		reset <= '1';
      wait for 100 ns;
		reset <= '0';
      wait for 100 ns;

		int <= X"0004";
      wait for 500 ns;

		-- Int ack cycle
		m1 <= '1';
      wait for 200 ns;
		inta <= '1';
      wait for 400 ns;
		inta <= '0';
		m1 <= '0';
      wait for 400 ns;


      --wait;
   end process;

END;
