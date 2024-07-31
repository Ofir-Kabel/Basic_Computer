
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Bus_system is
port( clk,rst:     in std_logic;      
      ALU_sel:     in std_logic_vector(3 downto 0);--(s3s2s1s0)
      BUS_sel:     in std_logic_vector(2 downto 0);--(M[AR],TR,IR,AC,DR,PC,AR,none)
      ARR:          out std_logic_vector(11 downto 0);
      IRR:          out std_logic_vector(15 downto 0);
      Lvec,Ivec,Cvec :in std_logic_vector(7 downto 0);--(M[AR],TR,IR,AC,DR,PC,AR,0)
      from_mem:    in std_logic_vector(15 downto 0);
      to_mem:      out std_logic_vector(15 downto 0);
      SZC_REG : out std_logic_vector(2 downto 0));
end Bus_system;

architecture Behavioral of Bus_system is

signal AR : std_logic_vector(11 downto 0):=x"000";
signal PC : std_logic_vector(11 downto 0):=x"001";
signal DR,AC,IR,TR : std_logic_vector(15 downto 0);
signal SZC1 : std_logic_vector(2 downto 0);      --(negative,zero,carry)
signal Bus1 : std_logic_vector(15 downto 0); 
signal ALU_res : std_logic_vector(15 downto 0);

component ALU is
Port (A,B : in std_logic_vector(15 downto 0);
      ALU_sel: in std_logic_vector(3 downto 0);
      ALU_res : out std_logic_vector(15 downto 0);
      SZC_out : out std_logic_vector(2 downto 0));
end component;

type Bus_reg is (High_Z,AR_reg,PC_reg,DR_reg,AC_reg,IR_reg,TR_reg,Memory);
signal on_Bus: Bus_reg:=High_Z;

begin
ALU1 : ALU port map(A=>AC,B=>DR,ALU_sel=>ALU_sel,ALU_res=>ALU_res,SZC_out=>SZC1);

Bus_control: process(Bus_sel,from_mem,AR,PC,DR,AC,IR,TR)
begin
case Bus_sel is
    when "000" => Bus1 <=(others=>'Z');
                  on_Bus <= High_Z;
    when "001" => Bus1 <=x"0"&AR;
                  on_Bus <= AR_reg;
    when "010" => Bus1 <=x"0"&PC;
                  on_Bus <= PC_reg;
    when "011" => Bus1 <=DR;
                  on_Bus <= DR_reg;
    when "100" => Bus1 <=AC;
                  on_Bus <= AC_reg;
    when "101" => Bus1 <=IR;
                  on_Bus <= IR_reg;
    when "110" => Bus1 <=TR;
                  on_Bus <= TR_reg;
    when "111" => Bus1 <=from_mem;
                  on_Bus <= Memory;
    when others=> Bus1 <=(others=>'Z');
                  on_Bus <= High_Z;
end case;
end process;

--------------------------------
--Registers control
--------------------------------

Instruction_Register:process(clk,rst)
begin
if rst='1' then
    IR<=(others=>'0');
elsif falling_edge(clk) then
    if Lvec(5)='1' then
        IR<=Bus1;
    elsif Ivec(5)='1' then
        IR<=std_logic_vector(unsigned(IR)+1);
    elsif Cvec(5)='1' then
        IR<=(others=>'0');
    end if;
end if;
end process;

IRR<=IR;

Program_Counter:process(clk,rst)
begin
if rst='1' then
    PC<=x"001";             --SUB PROGRAM PC<=x"001" , 16BIT - 32BIT : PC<=x"00D"
elsif falling_edge(clk) then
    if Lvec(2)='1' then
        PC<=Bus1(11 downto 0);
    elsif Cvec(2)='1' then
        PC<=(others=>'0');
    end if;
    if Ivec(2)='1' then
        PC<=std_logic_vector(unsigned(PC)+1);
    end if;
end if;
end process;

Address_Register:process(clk,rst)
begin
if rst='1' then
    AR<=(others=>'0');
elsif falling_edge(clk) then
    if Lvec(1)='1' then
        AR<=Bus1(11 downto 0);
    elsif Ivec(1)='1' then
        AR<=std_logic_vector(unsigned(AR)+1);
    elsif Cvec(1)='1' then
        AR<=(others=>'0');
    end if;
end if;
end process;    

ARR<=AR;

Data_Register:process(clk,rst)
begin
if rst='1' then
    DR<=(others=>'0');
elsif falling_edge(clk) then
    if Lvec(3)='1' then
        DR<=Bus1;
    elsif Lvec(3)='1' then
        DR<=std_logic_vector(unsigned(DR)+1);
    elsif Cvec(3)='1' then
        DR<=(others=>'0');
    end if;
end if;
end process;  

Accumulator:process(clk,rst)
begin
if rst='1' then
    AC<=(others=>'0');
elsif falling_edge(clk) then
    if Lvec(4)='1' then
        AC<=ALU_res;
    elsif Ivec(4)='1' then
        AC<=std_logic_vector(unsigned(AC)+1);
    elsif Cvec(4)='1' then
        AC<=(others=>'0');
    end if;
end if;
end process;

Temp_Register:process(clk,rst)
begin
if rst='1' then
    TR<=(others=>'0');
elsif falling_edge(clk) then
    if Lvec(6)='1' then
        TR<=Bus1;
    elsif Ivec(6)='1' then
        TR<=std_logic_vector(unsigned(AC)+1);
    elsif Cvec(6)='1' then
        TR<=(others=>'0');
    end if;
end if;
end process;

to_mem<=Bus1 when Lvec(7)='1' else
        (others=>'Z');
--process(clk,address)
--begin
--    if rising_edge(clk) then
--        if WR='1' then
--            to_mem<=Bus1;
--        end if;
--    end if;
--end process;

FLAGS_SZC:process(clk,rst)
begin
if rst='1' then
    SZC_REG<=(others=>'0');
elsif falling_edge(clk) then
    if Lvec(4)='1' then       --Lvec for SZC is store the value when AC is update
        SZC_REG<=SZC1;
    elsif Ivec(0)='1' then    --Ivec for SZC is complement SZC=~SZC
        SZC_REG(0)<=not(SZC1(0));
    elsif Cvec(0)='1' then
        SZC_REG(0)<='0';      --Cvec for SZC is CLR SZC='0'
    end if;
end if;
    SZC_REG(2 downto 1)<=SZC1(2 downto 1);
end process;

end Behavioral;


