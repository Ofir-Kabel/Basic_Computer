
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Memory is
port( clk,rst:     in std_logic;
      AR:          in std_logic_vector(11 downto 0);
      WR:          in std_logic;
      to_mem:      in std_logic_vector(15 downto 0);
      from_mem:    out std_logic_vector(15 downto 0)); 
end entity;

architecture Behavioral of Memory is

Type memType is array (0 to 100) of std_logic_vector(15 downto 0);

signal MAR : std_logic_vector(15 downto 0);
signal MDIFF : std_logic_vector(15 downto 0);

signal MSL : std_logic_vector(15 downto 0);
signal MSH : std_logic_vector(15 downto 0);

signal MEM : memType:=(x"F00F",x"2008",x"700A",x"7006",x"1009",x"300A",x"700C",x"7001",x"0005",x"000F",x"0000",x"F000",--end 
                       x"F00F",x"201F",x"700A",x"7006",x"101E",x"3022",x"7002",x"4017",x"2024",x"7006",x"3024",x"2021",x"700A",
                       x"7006",x"1020",x"1024",x"3023",x"7001",x"2710",x"4E20",x"2711",x"1388",x"0000",x"0000",x"FFFF",x"F000",others=>x"0000");

--Subtraction between two numbers X-Y=Diff
--\address\--\hexadecimal instruction code\--\code operation\
--(0)  => x"F00F", STR
--(1)  => x"2008", LDA SUB
--(2)  => x"700A", CMA
--(3)  => x"7006", INC
--(4)  => x"1009", ADD MIN
--(5)  => x"300A", STA DIFF
--(6)  => x"700C", CLA
--(7)  => x"7001", HLT 
--(8)  => x"000F", X = 15
--(9)  => x"0005", Y = 5
--(A)  => x"0000", DIFF = 0
--(B)  => x"F000", END;

--16BIT TO 32 BIT
--(C) => x"F00F", STR/ORG
--(D) => x"201F", LDA X
--(E) => x"700A", CMA
--(F) => x"7006", INC
--(10) => x"101E", ADD W	
--(11) => x"3022", STA SL
--(12) => x"7002", SZE
--(13) => x"4017", BUN HI
--(14) => x"2024", LDA BR1
--(15) => x"7006", INC
--(16) => x"3024", STA BR1
--(17) => x"2021",HI: LDA Z
--(18) => x"700A", CMA	
--(19) => x"7006", INC
--(1A) => x"1020", ADD Y 
--(1B) => x"1024", ADD BR1
--(1C) => x"3023", STA SH
--(1D) => x"7001", HLT
--(1E) => x"2710",W DEC 10K
--(1F) => x"4E20",X DEC 20K	
--(20) => x"2711",Y DEC 100001
--(21) => x"1388",Z DEC 5000
--(22) => x"0000",SL DEC 0000
--(23) => x"0000",SH DEC 0000
--(24) => x"FFFF",BR1 HEX FFFF ;
--(25) => x"F000",END ;
begin

process(AR,clk)
begin
if rising_edge(clk) then
    MAR<=MEM(to_integer(unsigned(AR)));
    MDIFF<=MEM(10);
    MSL<=MEM(34);
    MSH<=MEM(35);
end if;
end process;

process(AR,clk)
begin
if rising_edge(clk) then
    if WR='1' then
        MEM(to_integer(unsigned(AR)))<=to_mem;
    else
        from_mem<=MEM(to_integer(unsigned(AR)));
    end if;
end if;
end process;
end Behavioral;
