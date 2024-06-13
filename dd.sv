package spi_protocol_random;
typedef enum  {IDLE,CHK_CMD,WRITE,READ_ADD,READ_DATA} state_e;
 class wrapper_testing;
 rand logic MISO,MOSI;
 rand logic [10:0]data_holder ;
 logic SS_n;
 rand logic rst_n;
 constraint rst_n_c{
    rst_n dist{1:=998,0:=2};
 }
 constraint data_holder_c{
if(const'(data_holder[10:8])==3'b110)
{
   data_holder[10:8] inside{3'b111,3'b001,3'b000}; 
}
else
{
    data_holder[10:8] inside{3'b110,3'b001,3'b000};
}
 }
covergroup g;
the_command_cover:coverpoint data_holder[10:8] {
bins write_addr={3'b000};
bins write_data={3'b001};
bins read_address={3'b110};
bins read_data={3'b111};
ignore_bins invalid_data={3'b101,3'b100,3'b010,3'b011};
}
reset_coverage: coverpoint rst_n;
reset_and_instructions: cross reset_coverage,the_command_cover;
endgroup 
    function new();
       g=new;
       SS_n=0;
       data_holder=0; 
    endfunction 
 endclass
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
class spi_slave_rand;
   rand logic SS_n;
   rand logic  [10:0] data;
   rand logic rst_n;
   logic [9:0]rx_data;
   logic rx_valid;
   logic MISO;
constraint c{
SS_n dist{0:=90,1:=10};
rst_n dist{1:=98,0:=2};
data[10:8] inside{3'b111,3'b110,3'b000,3'b001};
}
   covergroup gr;
   SS_N_cp:coverpoint SS_n{
      bins high={1};
      bins low={0};
   }
   rst_n_cp:coverpoint rst_n{
      bins active={0};
      bins non_active={1};
   }
   rx_data_cp:coverpoint rx_data[9:8]
   {
bins write_address={2'b00};
bins write_data={2'b01};
bins read_addr={2'b10};
bins read_data={2'b11};
   }

   rx_valid_cp:coverpoint rx_valid{
      bins high={1};
      bins low={0};
   }
rx_valid_with_rst: cross rx_valid_cp,rst_n_cp{   ignore_bins rx_valid_activated_rst=binsof(rx_valid_cp.high)&&binsof(rst_n_cp.active);

}

rx_data_with_rst: cross  rx_data_cp,rst_n_cp{
      ignore_bins rx_data_with_activated_rst=binsof(rx_data_cp)&&binsof(rst_n_cp.active);

}
rx_data_with_SS_N: cross rx_data_cp,SS_N_cp;
rx_valid_with_SS_N: cross rx_valid_cp,SS_N_cp
{
    ignore_bins rx_data_with_activated_SS_n = binsof(rx_valid_cp.high)  && binsof(SS_N_cp.high);  
}

   endgroup
   function new();
      gr=new;
   endfunction 
endclass 
endpackage