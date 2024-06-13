vlib work
vlog dd.sv sipo.v counter.v piso.v spi_under_test.sv spi_wrapper.v spi_wrapper_tb.sv ram.v +cover
vsim -voptargs=+acc work.wrapper_tb -cover
add wave *
coverage save wrapper_tb.ucdb -du spi_wrapper -onexit
run -all
quit -sim
vcover report wrapper_tb.ucdb -all -annotate -details -output wrapper_test.txt