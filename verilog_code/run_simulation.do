# ==========================================================
# Script de Simulação ModelSim (run_simulation.do)
# Projeto: Testbench completo para cordic_9bit_core
# ==========================================================

# Imprime uma mensagem no console
echo "Iniciando script de simulação..."

# 1. Cria a biblioteca de trabalho chamada 'work'
vlib work

# 2. Compila os arquivos Verilog para a biblioteca 'work'
echo "Compilando arquivos Verilog..."
vlog cordic_prop.v
vlog tb_cordic.v

# 3. Inicia o simulador no módulo de topo do testbench
echo "Iniciando simulação..."
vsim -L work -c work.tb_cordic +nowarnTSC

# 4. Roda a simulação até o final ($finish)
run -all

echo "Simulação finalizada."

# 5. Sai do ModelSim
quit
