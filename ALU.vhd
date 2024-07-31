
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.std_logic_arith.all; 

entity ALU is
Port (A,B :    in std_logic_vector(15 downto 0);
      ALU_sel: in std_logic_vector(3 downto 0);
      ALU_res: out std_logic_vector(15 downto 0);
      SZC_out : out std_logic_vector(2 downto 0));
end ALU;

architecture Behavioral of ALU is

type optype is (reg,and1,or1,add,sub,trans_B,decrement_A,not_A,shl_A,shr_A,asl_A,asr_A,High_Z);
signal ALU : std_logic_vector(16 downto 0):=(OTHERS=>'0');
signal Alu_op : optype :=reg;
signal overflow : std_logic;

begin
process(ALU_sel)
variable Anew,Bnew : std_logic_vector(16 downto 0);
begin
Anew:='0'&A;
Bnew:='0'&B;
    case ALU_sel is
        when "0000" => ALU <= ALU;
                       Alu_op <= reg;
        when "0001" => ALU <= Anew and Bnew;
                       Alu_op <= and1;
        when "0010" => ALU <= Anew or Bnew;
                       Alu_op <= or1;
        when "0011" => ALU <= Anew+Bnew;
                       Alu_op <= add;
        when "0100" => ALU <= Anew-Bnew;
                       Alu_op <= sub;
        when "0101" => ALU <= Bnew;
                       Alu_op <= trans_B;
        when "0110" => ALU <= Anew-1;
                       Alu_op <= decrement_A;
        when "0111" => ALU <= not(Anew);
                       Alu_op <= not_A;
        when "1000" => ALU <= shr(ALU,"1");
                       Alu_op <= shr_A;
        when "1001" => ALU <= shl(ALU,"1");
                       Alu_op <= shl_A;        
        when "1010" => ALU <= ALU(15 downto 0)&ALU(16);
                       Alu_op <= asr_A;
        when "1011" => ALU <= ALU(0)&ALU(16 downto 1);
                       Alu_op <= asl_A;        
        when OTHERS => ALU <= (OTHERS=>'Z');
                       Alu_op <=High_Z;
    end case;
end process;

SZC_OUT(0)<=ALU(15);
SZC_OUT(1)<='1' when ALU(15 downto 0)=x"00" else
            '0';
SZC_OUT(2)<=ALU(15);
ALU_res<=ALU(15 downto 0);
overflow<=ALU(16);

end Behavioral;
