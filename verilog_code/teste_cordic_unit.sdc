# 1. Defina seu clock de 100MHz (período de 10ns)
create_clock -name {meu_clk} -period 10.0 [get_ports {clk}]

# 2. Crie o relatório de timing específico para a lógica do init_cordic
#    Este comando será executado automaticamente no final da compilação.
report_timing -from [get_registers {st2_bubble_reg | st2_color_reg[*] | st2_pixel_x_reg[*] | st2_pixel_y_reg[*] | ref_point_x_reg[*] | ref_point_y_reg[*] | angle_reg[*] | form_reg | size_reg[*]}] \
              -to [get_registers {init_cordic_inst|*}] \
              -setup \
              -npaths 100 \
              -detail full_path \
              -panel_name "Pior Caminho Logica init_cordic"