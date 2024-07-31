library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity computer is
Port (clk,rst: in std_logic);
end computer;

architecture Behavioral of computer is

component CPU is
port( clk,rst:     in std_logic;
      address:     out std_logic_vector(11 downto 0);
      WR:          out std_logic;
      to_mem:      out std_logic_vector(15 downto 0);
      from_mem:    in std_logic_vector(15 downto 0));
end component;

component Memory is
port( clk,rst:     in std_logic;
      AR:     in std_logic_vector(11 downto 0);
      WR:          in std_logic;
      to_mem:      in std_logic_vector(15 downto 0);
      from_mem:    out std_logic_vector(15 downto 0)); 
end component;

signal AR: std_logic_vector(11 downto 0);
signal WR: std_logic;
signal to_mem,from_mem : std_logic_vector(15 downto 0);

begin
cpu1 : CPU port map(clk=>clk,rst=>rst,address=>AR,from_mem=>from_mem,to_mem=>to_mem,WR=>WR);
mem1 : Memory port map(clk=>clk,rst=>rst,AR=>AR,from_mem=>from_mem,to_mem=>to_mem,WR=>WR);

end Behavioral;
