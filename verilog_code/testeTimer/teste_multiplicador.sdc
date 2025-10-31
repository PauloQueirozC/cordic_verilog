# 1. Defina um clock de 10ns (100MHz)
create_clock -name {meu_clk} -period 10.0 [get_ports {clk}]

# 2. Comando para criar um relatório medindo EXATAMENTE o atraso
#    do multiplicador (o 'assign p_next = a_in * b_in;')
report_timing -from [get_registers {a_reg[*] | b_reg[*]}] \
              -to [get_registers {inst_mult|p_out[*]}] \
              -setup \
              -npaths 10 \
              -detail full_path \
              -panel_name "Atraso do Multiplicador"