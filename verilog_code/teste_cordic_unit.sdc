# 1. Defina seu clock de 100MHz (período de 10ns)
create_clock -name {meu_clk} -period 10.0 [get_ports {clk}]
