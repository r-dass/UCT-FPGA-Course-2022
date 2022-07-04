-- =============================================================================
--  VHDL instance generated by IPExpress    07/04/2022    16:33:44         
--  Filename: counter_la0_inst.vhd                                          
--  Copyright(c) 2006 Lattice Semiconductor Corporation. All rights reserved.   
-- =============================================================================

-- WARNING - Changes to this file should be performed by re-running IPexpress
-- or modifying the .LPC file and regenerating the core.  Other changes may lead
-- to inconsistent simulation and/or implemenation results */

counter_la0_inst: counter_la0
   port map (
       clk		=> clk,
       reset_n		=> reset_n,
       jtck		=> jtck,
       jrstn		=> jrstn,
       jce2		=> jce2,
       jtdi		=> jtdi,
       er2_tdo		=> er2_tdo,
       jshift		=> jshift,
       jupdate		=> jupdate,
       trigger_din_0	=> trigger_din_0(0 downto 0),
       trace_din	=> trace_din(7 downto 0),
       sample_en	=> sample_en,
       ip_enable        => ip_enable
)

object /* synthesis GSR=DISABLED */
object /* synthesis UGROUP=�counter_la0_core� */
pragma // attribute UGROUP �counter_la0_core� 
;
