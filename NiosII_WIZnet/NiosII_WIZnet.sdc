set_time_format -unit ns -decimal_places 3
create_clock -name {CLOCK_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK_50}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK_50}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK_50}]  0.020  
