# 1. Defina um clock de 10ns (100MHz)
create_clock -name {meu_clk} -period 10.0 [get_ports {clk}]
