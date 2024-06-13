import spi_protocol_random::*;
module wrapper_tb();
logic MOSI,MISO,SS_n,clk,rst_n;
wrapper_testing x;
//state_e states;
logic [7:0] mem [255:0];
logic [7:0] wr_addr;
logic [7:0] rd_addr;
logic [7:0] tx_data_ref;
bit u;
initial begin
 clk=0;
 forever #1 clk=~clk;
end
spi_wrapper DUT (MOSI, MISO, SS_n, clk, rst_n); 
initial begin
x=new();
x.rst_n=0;
rst_n=0;
refrence_model(x);
@(negedge clk);
rst_n=1;
x.rst_n=1;
SS_n=1;
x.SS_n=1;
refrence_model(x);
@(negedge clk);
repeat(10000)
begin
    SS_n=1;
    x.SS_n=1;
    @(negedge clk);
x.randomize();
x.g.sample();
x.SS_n=0;
SS_n=0;
refrence_model(x);
rst_n=x.rst_n;
for (int i =0 ;i<=10 ;i++) begin
    MOSI=x.data_holder[10-i];
    @(negedge clk);
end
@(negedge clk);// clock to load din into the memory
@(negedge clk);// clock to load tx_data if exist
 @(negedge clk);// clock to load tx_data into dout for piso
   @(negedge clk);// clock to get dout to MISO
if(x.data_holder[10:8]==3'b111)
begin
    for (int i =0 ;i<=7 ;i++) begin
     @(negedge clk);
    if(MISO!==tx_data_ref[7-i])
    begin
    $display("error ! in at %0d ",i);
    $stop;
    end
end
end else begin
     for (int i =0 ;i<=7 ;i++) 
     @(negedge clk);
end
SS_n=1; 
end
@(negedge clk) ; SS_n=0; x.SS_n =0 ; refrence_model(x);

@(negedge clk) ; SS_n=1; x.SS_n =1 ; refrence_model(x);

repeat (2) @(negedge clk) ;

$stop;
end
task refrence_model(input wrapper_testing x);
if(!x.rst_n)
begin
    for (int i = 0; i < 256; i=i+1) 	mem [i] = 1'b0;
    tx_data_ref=0;
    wr_addr=0;
    rd_addr=0;
    u=0;
end
else begin

    if(x.data_holder[10:8]==3'b000)
wr_addr= x.data_holder[7:0];
    if(x.data_holder[10:8]==3'b001)
mem[wr_addr]= x.data_holder[7:0];
 if(x.data_holder[10:8]==3'b110)
begin
rd_addr= x.data_holder[7:0];
u=1;
end
if((x.data_holder[10:8]==3'b111)&&(u))
 begin
    tx_data_ref= mem[rd_addr];
    u=0;   end
  
  end
endtask
endmodule