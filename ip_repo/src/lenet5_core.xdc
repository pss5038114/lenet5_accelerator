# ============================================================
# Constraint for lenet5_axi_wrapper standalone synthesis
# Target clock: 100 MHz
# ============================================================

create_clock -period 10.000 -name s_axi_aclk [get_ports s_axi_aclk]

# Active-low async reset path
set_false_path -from [get_ports s_axi_aresetn]


# 만약 lenet5_top 단독 합성을 하고 싶으면 그때는 XDC를 아래 주석 처리한 거로 돌리고 위쪽을 주석처리하면 됨
# create_clock -period 10.000 -name clk [get_ports clk]
# set_false_path -from [get_ports reset_n]