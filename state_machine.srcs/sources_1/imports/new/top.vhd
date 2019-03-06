 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    Port (  
            clk_8ns     : in  std_logic;
            red         : out std_logic_vector (7 downto 0) := "00000000";
            green       : out std_logic_vector (7 downto 0) := "00000000";
            blue        : out std_logic_vector (7 downto 0) := "00000000";
            row         : out std_logic_vector (7 downto 0) := "00000000";
            led         : out std_logic_vector (3 downto 0) := "0000";
            btn         : in std_logic_vector  (3 downto 0) := "0000"
           );
end top;

architecture Behavioral of top is

  -- Clock prescaler
  signal prescaler            : unsigned(31 downto 0) := x"00000000";
  
  
-- Exercise
constant PRESSED : std_logic := '1';

type state_type is (STOPPED, RUNNING);
signal state, next_state : state_type;

signal counter  : unsigned (3 downto 0) := "0000";

signal start    : std_logic := '0';
signal stop     : std_logic := '0';
signal reset    : std_logic := '0';

begin

prescaling_process: process (clk_8ns)
begin
   if rising_edge(clk_8ns) then
        prescaler <= prescaler + 1;
   end if;
end process;




start   <= btn(0);
stop    <= btn(2);
reset   <= btn(3);
led     <= std_logic_vector(counter);


SYNC_PROC: process (clk_8ns)
begin
    if rising_edge(clk_8ns) then
        state <= next_state;
    end if;
end process;

OUTPUT_DECODE: process (state, prescaler)
begin
    if (state = RUNNING) then 
        -- Count up
        if rising_edge(prescaler(25)) then
            counter <= counter + 1;
        end if;
    
    elsif (state = STOPPED) then
        -- Do nothing
    end if;
    
    -- Reset counter
    if reset = PRESSED then
        counter <= "0000";
    end if;
end process;

NEXT_STATE_DECODE: process (state, start, stop)
begin

  -- Insert default value for next_state
  next_state <= state;
  case (state) is
     
     -- State STOPPED
     when STOPPED =>
        if start = PRESSED then
           next_state <= RUNNING;
        end if;
     
     -- State RUNNING
     when RUNNING =>
        if stop = PRESSED then
           next_state <= STOPPED;
        end if;
     
     -- Others
     when others =>
        next_state <= STOPPED;
  end case;
end process;


end Behavioral;
