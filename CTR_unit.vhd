library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CTR_unit is
port( Lvec,Ivec,Cvec: out std_logic_vector(7 downto 0);--(M[AR],TR,IR,AC,DR,PC,AR,0)
      SZC : in std_logic_vector(2 downto 0);
      IR : in std_logic_vector(15 downto 0);
      AR : in std_logic_vector(11 downto 0);
      Bus_sel:out std_logic_vector(2 downto 0);
      ALU_sel:out std_logic_vector(3 downto 0);
      clk,rst: in std_logic);
end entity;

architecture Behavioral of CTR_unit is


--STR/END
CONSTANT VSTR : STD_LOGIC_VECTOR(15 DOWNTO 0):=x"FF00";--s60
CONSTANT VENDP : STD_LOGIC_VECTOR(15 DOWNTO 0):=x"F000";--s60

--OPCODE
CONSTANT VAND : STD_LOGIC_VECTOR(2 DOWNTO 0):="000";--AND_0
CONSTANT VADD : STD_LOGIC_VECTOR(2 DOWNTO 0):="001";---AND_1
CONSTANT VLDA : STD_LOGIC_VECTOR(2 DOWNTO 0):="010";---ADD_0
CONSTANT VSTA : STD_LOGIC_VECTOR(2 DOWNTO 0):="011";---ADD_1
CONSTANT VBUN : STD_LOGIC_VECTOR(2 DOWNTO 0):="100";---LDA_0
CONSTANT VBSA : STD_LOGIC_VECTOR(2 DOWNTO 0):="101";---LDA_1
CONSTANT VISZ : STD_LOGIC_VECTOR(2 DOWNTO 0):="110";---STA

--AC OPERATIONS
CONSTANT VACOP :STD_LOGIC_VECTOR(2 DOWNTO 0):="111";
CONSTANT VCLA : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"00C";--CLE
CONSTANT VCLE : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"00B";--CLA
CONSTANT VCMA : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"00A";--s29
CONSTANT VCME : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"009";--s28
CONSTANT VCIR : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"008";--s27
CONSTANT VCIL : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"007";--s26
CONSTANT VINC : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"006";--s25
CONSTANT VSPA : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"005";--s24
CONSTANT VSNA : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"004";--ISZ_3
CONSTANT VSZA : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"003";--ISZ_2
CONSTANT VSZE : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"002";--ISZ_1
CONSTANT VHLT : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"001";--ISZ_0

--I/O operations
CONSTANT IO : STD_LOGIC_VECTOR(3 DOWNTO 0):=x"F";
CONSTANT INP : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"006";--s45
CONSTANT OUTA : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"005";--s44
CONSTANT SKI : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"004";--s43
CONSTANT SKO : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"003";--s42
CONSTANT ION : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"002";--HLT
CONSTANT IOF : STD_LOGIC_VECTOR(11 DOWNTO 0):=x"001";--SZE


Type stateType is(FET_0,FET_1,DEC,IND,STR,ENDP,
              AND_0,AND_1,ADD_0,ADD_1,LDA_0,LDA_1,STA,BUN,BSA_0,BSA_1,
              ISZ_0,ISZ_1,ISZ_2,ISZ_3,s24,s25,s26,s27,s28,s29,
              CLA,CLE,CMA,CME,CIR,CIL,INC,SPA,SNA,SZA,
              SZE,HLT,s42,s43,s44,s45);

signal state : stateType:=STR;

begin
process(rst,clk)
variable OPCODE : std_logic_vector(2 downto 0);
begin
if rst='1' then
    Lvec<=(others=>'0');
    Ivec<=(others=>'0');
    Cvec<=(others=>'0');
    ALU_sel<=(others=>'0');
    Bus_sel<=(others=>'0');
    state<=STR;
elsif rising_edge(clk) then
    case state is
        when STR => --initialization
            Lvec  <= "00000000";
            Ivec  <= "00000000";
            Cvec  <= "00000000";
            ALU_sel <= "0000";
            BUS_sel <="000";
            state <= FET_0;
        when FET_0 => --fetch AR<=PC,PC<=PC+1
            Lvec  <= "00000010";
            Ivec  <= "00000100";
            Cvec  <= "00000000";
            ALU_sel <= "0000";
            BUS_sel <="010";
            state <= FET_1;
        when FET_1 => --fetch IR<=M[AR]
            Lvec  <= "00100000";
            Ivec  <= "00000000";
            Cvec  <= "00000000";
            ALU_sel <= "0000";
            BUS_sel <="111";
            state <= DEC;
         when DEC => --Decode OPCODE<=IR(14 DOWNTO 0),AR<=IR(11 DOWNTO 0)
            OPCODE := IR(14 downto 12);
            Lvec <= "00000010";
            Ivec  <= "00000000";
            Cvec  <= "00000000";
            ALU_sel <= "0000";
            BUS_sel <="101";
			if IR(15)='1' then
				state <= IND;
			else
				case OPCODE is
					when VAND => state <=AND_0;
					when VADD => state <=ADD_0;
					when VLDA => state <=LDA_0;
					when VSTA => state <=STA;
					when VBUN => state <=BUN;
					when VBSA => state <=BSA_0;
					when VISZ => state <=ISZ_0;
					when VACOP =>
						case IR(11 downto 0) is
							when VCLA => state <=CLA;
							when VCLE => state <=CLE;
							when VCMA => state <=CMA;
							when VCME => state <=CME;
							when VCIR => state <=CIR;
							when VCIL => state <=CIL;
							when VINC => state <=INC;
							when VSPA => state <=SPA;
							when VSNA => state <=SNA;
							when VSZA => state <=SZA;
							when VSZE => state <=SZE;
							when VHLT => state <=HLT;
							WHEN OTHERS => state <=FET_0;
						end case;
				WHEN OTHERS => state <=FET_0;		
             end case;
         end if;
        when IND => --AR<=M[AR]			
				Lvec <= "00000010";
				Ivec  <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="111";
				case OPCODE is
					when VAND => state <=AND_0;
					when VADD => state <=ADD_0;
					when VLDA => state <=LDA_0;
					when VSTA => state <=STA;
					when VBUN => state <=BUN;
					when VBSA => state <=BSA_0;
					when VISZ => state <=ISZ_0;
					
					when VACOP =>
						case AR is
							when VCLA => state <=CLA;
							when VCLE => state <=CLE;
							when VCMA => state <=CMA;
							when VCME => state <=CME;
							when VCIR => state <=CIR;
							when VCIL => state <=CIL;
							when VINC => state <=INC;
							when VSPA => state <=SPA;
							when VSNA => state <=SNA;
							when VSZA => state <=SZA;
							when VSZE => state <=SZE;
							when VHLT => state <=HLT;
							WHEN OTHERS => state <=FET_0;
						end case;
                    WHEN OTHERS => state <=FET_0;
				end case;
							
			when ENDP => --ENDP
				Lvec  <= "00000000";
				Ivec  <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="000";
				state<=ENDP;
			
			when AND_0 => --VAND DR<=M[AR]
				Lvec  <= "00001000";
				Ivec  <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="111";
				state<=AND_1;
				
			when AND_1 => --VAND AC<=AC^DR,SC<=0
				Lvec <= "00000000";
				Ivec  <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0100";
				BUS_sel <="000";
				state<=FET_0;
			
			when ADD_0 => --VADD DR<=M[AR]
				Lvec <= "00001000";
				Ivec  <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="111";
				state<=ADD_1;
				
			when ADD_1 => --VADD AC<=AC+DR,SC<=0
				Lvec <= "00010000";
				Ivec  <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0011";
				BUS_sel <="000";
				state<=FET_0;
			
			when LDA_0 => --VLDA DR<=M[AR]
				Lvec <= "00001000";
				Ivec  <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="111";
				state<=LDA_1;
				
			when LDA_1 => --VLDA AC<=DR,SC<=0 can be apllied just affter the value is valid
				Lvec <= "00010000";
				Ivec  <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0101";
				BUS_sel <="000";
				state<=FET_0;
			
			when STA => --VSTA M[AR]<=AC,SC<=0
				Lvec <= "10000000";
				Ivec  <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="100";
				state<=FET_0;
			
			when BUN => --VBUN PC<=AR,SC<=0
				Lvec <= "00000100";
				Ivec  <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="001";
				state<=FET_0;
				
			when BSA_0 => --VBSA M[AR]<=PC,AR<=AR+1
				Lvec <= "10000000";
				Ivec  <= "00000010";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="010";
				state<=BSA_1;
			
			when BSA_1 => -- VBSA PC<=AR,SC<=0
				Lvec <= "00000100";
				Ivec  <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="001";
				state<=FET_0;
				
			when ISZ_0 => --VISZ DR<=M[AR]
				Lvec <= "00001000";
				Ivec  <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="111";
				state<=ISZ_1;
				
			when ISZ_1 => --VISZ DR<=DR+1
				Lvec <= "00000000";
				Ivec  <= "00001000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="000";
				state<=ISZ_2;
			
			when ISZ_2 => --VISZ AC<=DR,SC<=0
				Lvec <= "00000000";
				Ivec  <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0111";
				BUS_sel <="000";
				state<=ISZ_3;
				
			when ISZ_3 => --VISZ M[AR]<=AC,SC<=0
				Lvec <= "10000000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="100";
				if SZC = "001" then
					Ivec  <= "00000100";
				else
					Ivec  <= "00000000";
				end if;
				state<=FET_0;
			
            when CLA => --VCLA AC<=0,SC<=0
                Lvec <= "00000000";
                Ivec  <= "00000000";
                Cvec  <= "00010000";
                ALU_sel <= "0000";
                BUS_sel <="000";
                state<=FET_0;
			
                            when CLE => --VCLE E<=0,SC<=0
                                Lvec <= "00000000";
                                Ivec  <= "00000000";
                                Cvec  <= "00000000";
                                ALU_sel <= "0111";
                                BUS_sel <="000";
                                state<=FET_0;
				
			when CMA => --VCMA AC<=not(AC),SC<=0
				Lvec <= "00010000";
				Ivec  <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0111";
				BUS_sel <="000";
				state<=FET_0;
			
            when CME => --VCME E<=not(E),SC<=0
                Lvec <= "00000000";
                Ivec  <= "00000000";
                Cvec  <= "00010000";
                ALU_sel <= "0000";
                BUS_sel <="000";
                --SZC(3)<=not(SZC(3));
                state<=FET_0;
			
									when CIR => --VCIR shr(AC),SC<=0
										Lvec <= "00010000";
										Ivec  <= "00000000";
										Cvec  <= "00000000";
										ALU_sel <= "1000";
										BUS_sel <="000";
										state<=FET_0;
										
									when CIL => --VCIL shl(AC),SC<=0
										Lvec <= "00010000";
										Ivec  <= "00000000";
										Cvec  <= "00000000";
										ALU_sel <= "1001";
										BUS_sel <="000";
										state<=FET_0;
										
			when INC => --VINC AC<=AC+1,SC<=0
				Lvec <= "00000000";
				Ivec  <= "00010000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="000";
				state<=FET_0;
			
			when SPA => --VSPA skip pos AC
				Lvec <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="000";
				if SZC(2) = '0' then
					Ivec  <= "00000100";
				else
					Ivec  <= "00000000";
				end if;
				state<=FET_0;
				
			when SNA => --VSPA skip neg AC
				Lvec <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="000";
				if SZC(2) = '1' then
					Ivec  <= "00000100";
				else
					Ivec  <= "00000000";
				end if;
				state<=FET_0;
			
			when SZA => --VSZA skip pos E
				Lvec <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="000";
				if SZC(1) ='1' then
					Ivec  <= "00000100";
				else
					Ivec  <= "00000000";
				end if;
				state<=FET_0;
				
			when SZE => --VSPA skip neg E
				Lvec <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="000";
				if SZC(0) = '0' then
					Ivec  <= "00000100";
				else
					Ivec  <= "00000000";
				end if;
				state<=FET_0;
			
			when HLT => --VHLT 
				Lvec <= "00000000";
				Cvec  <= "00000000";
				ALU_sel <= "0000";
				BUS_sel <="000";
				state<=ENDP;
            WHEN OTHERS => state <=FET_0;
    end case;
end if;     
end process;
end Behavioral;


        
        

        

        
        