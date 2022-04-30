-- =============================================================================
--  VHDL instance generated by IPExpress    04/30/2022    20:05:46         
--  Filename: counter_la0_inst.vhd                                          
--  Copyright(c) 2006 Lattice Semiconductor Corporation. All rights reserved.   
-- =============================================================================

-- WARNING - Changes to this file should be performed by re-running IPexpress
-- or modifying the .LPC file and regenerating the core.  Other changes may lead
-- to inconsistent simulation and/or implemenation results */

library IEEE; use IEEE.std_logic_1164.all; use IEEE.numeric_std.all;
PACKAGE counter_la0_pkg IS
    COMPONENT counter_la0
    PORT (
        clk:		IN std_logic;
        reset_n:	IN std_logic;
        jtck:		IN std_logic;
        jrstn:		IN std_logic;
        jce2:		IN std_logic;
        jtdi:		IN std_logic;
        er2_tdo:	BUFFER std_logic;
        jshift:		IN std_logic;
        jupdate:	IN std_logic;
        trigger_din_0:	IN std_logic_vector (0 downto 0);
        trace_din:	IN std_logic_vector (7 downto 0);
        sample_en:	IN std_logic;
        ip_enable:	IN std_logic
    );

    END COMPONENT;

END PACKAGE counter_la0_pkg;
