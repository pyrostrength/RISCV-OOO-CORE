set_property PACKAGE PIN W5 [get_ports {CLK}]
create_clock -name clk -period 10 [get_ports {CLK}]
          

set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports RESET]
   	 
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]