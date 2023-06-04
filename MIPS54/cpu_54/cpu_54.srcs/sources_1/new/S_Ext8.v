module S_Ext8(
    input [7:0] data_in,       
    output [31:0] data_out
    );
    assign data_out = {{24{data_in[7]}},data_in};
endmodule