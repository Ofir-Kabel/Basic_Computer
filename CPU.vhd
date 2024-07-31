library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity CPU is
Port( clk,rst:     in std_logic;
      address:     out std_logic_vector(11 downto 0);
      WR:          out std_logic;
      to_mem:      out std_logic_vector(15 downto 0);
      from_mem:    in std_logic_vector(15 downto 0));
end CPU;

architecture Behavioral of CPU is

component Bus_system is
port( clk,rst:     in std_logic;      
      ALU_sel:      in std_logic_vector(3 downto 0);--(s3s2s1s0)
      BUS_sel:      in std_logic_vector(2 downto 0);--(M[AR],TR,IR,AC,DR,PC,AR,none)
      Arr:         out std_logic_vector(11 downto 0);
      Irr:         out std_logic_vector(15 downto 0);
      Lvec,Ivec,Cvec :in std_logic_vector(7 downto 0);--(M[AR],TR,IR,AC,DR,PC,AR,0)
      from_mem:     in std_logic_vector(15 downto 0);
      to_mem:       out std_logic_vector(15 downto 0);
      SZC_REG :     out std_logic_vector(2 downto 0));
end component;

component CTR_unit is
port( Lvec,Ivec,Cvec: out std_logic_vector(7 downto 0);
      SZC : in std_logic_vector(2 downto 0);
      IR : in std_logic_vector(15 downto 0);
      AR : in std_logic_vector(11 downto 0);
      Bus_sel:out std_logic_vector(2 downto 0);
      ALU_sel:out std_logic_vector(3 downto 0);
      clk,rst: in std_logic);
end component;

signal IR:               std_logic_vector(15 downto 0);
signal AR:               std_logic_vector(11 downto 0);
signal Lvec,Ivec,Cvec:   std_logic_vector(7 downto 0);--(M[AR],TR,IR,AC,DR,PC,AR,complement E); --LOAD/INC/CLR Vectors
signal Bus_sel:          std_logic_vector(2 downto 0);
signal ALU_sel:          std_logic_vector(3 downto 0);
signal SZC:              std_logic_vector(2 downto 0);--(SIGN,ZERO,CARRY)   

begin
CTR_unit1 :CTR_unit port map(clk=>clk,rst=>rst,SZC=>SZC,ALU_sel=>ALU_sel,AR=>AR,IR=>IR,
                             Bus_sel=>Bus_sel,Lvec=>Lvec,Ivec=>Ivec,Cvec=>Cvec);
Bus_system1 :Bus_system port map(clk=>clk,rst=>rst,from_mem=>from_mem,to_mem=>to_mem,
                                 Irr=>IR,Arr=>AR,ALU_sel=>ALU_sel,BUS_sel=>BUS_sel,Lvec=>Lvec,Ivec=>Ivec,Cvec=>Cvec,SZC_REG=>SZC);

address<=AR;
WR<=Lvec(7);

end Behavioral;
