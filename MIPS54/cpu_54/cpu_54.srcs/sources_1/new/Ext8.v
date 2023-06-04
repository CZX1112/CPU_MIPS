module Ext8(
    input [7:0] data_in,       
    output [31:0] data_out
    );
    assign data_out = {24'b0,data_in};
endmodule