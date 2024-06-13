package ram_test;
    class ram_random;
    rand logic [7:0]din;
    rand logic rx_valid;
    rand logic rst_n;
    logic clk;
   rand bit [1:0] temp;
    constraint first{
rx_valid dist {1:=90,0:=10};
rst_n dist {1:=98,0:=2};
    }
    covergroup g @(posedge clk );
    instructions:coverpoint temp { bins read_address_instruction={'b00};
    bins write_address_instruction ={'b10};
    bins read_data_instruction ={'b01};
    bins write_data_instruction={'b11};}
rx_valid: coverpoint rx_valid{
    bins high={1};
    bins low= {0};
    }
din_cp:coverpoint din;
rst_n_cv:coverpoint rst_n{
bins activated={0};
bins non_activated={1};
}
the_normal_operation_but_the_with_activated_rst:cross rx_valid,rst_n_cv;
rx_valid_instruction: cross rx_valid,instructions{
    bins rx_valid_with_read_address=binsof(instructions.read_address_instruction)&&binsof(rx_valid.high);
    bins rx_valid_with_write_address=binsof(instructions.write_address_instruction)&&binsof(rx_valid.high);
    bins rx_valid_with_read_data=binsof(instructions.read_data_instruction)&&binsof(rx_valid.high);
    bins rx_valid_with_write_data=binsof(instructions.write_data_instruction)&&binsof(rx_valid.high);
    bins not_rx_valid_with_read_address=binsof(instructions.read_address_instruction)&&binsof(rx_valid.low);
    bins not_rx_valid_with_write_address=binsof(instructions.write_address_instruction)&&binsof(rx_valid.low);
    bins not_rx_valid_with_read_data=binsof(instructions.read_data_instruction)&&binsof(rx_valid.low);
    bins not_rx_valid_with_write_data=binsof(instructions.write_data_instruction)&&binsof(rx_valid.low);
}
instruction_rst_n: cross instructions,rst_n;
    endgroup
           function new();
            g=new;
        endfunction
    endclass //ram_random
endpackage