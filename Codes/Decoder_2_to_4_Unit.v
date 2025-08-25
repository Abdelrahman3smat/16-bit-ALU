module Decoder_2_to_4_Unit
(
    input   wire    [3 : 0] alu_fun,    // Will use only the MSBs by using a signal below
    output  reg     arith_En,
    output  reg     logic_En,
    output  reg     cmp_En,
    output  reg     shift_En
);

// Signal assignment
wire    [1:0]   alu_fun_MSBs = alu_fun[3:2];


always @ (*)
    begin
        case (alu_fun_MSBs)
        2'b00 : begin
                    arith_En = 1'b1;   // Arithmetic operation is enabled
                    logic_En = 1'b0;
                    cmp_En = 1'b0;
                    shift_En = 1'b0;
                end 
        2'b01 : begin
                    arith_En = 1'b0;   
                    logic_En = 1'b1;   // Logic operation is enabled
                    cmp_En = 1'b0;
                    shift_En = 1'b0;
                end 
        2'b10 : begin
                    arith_En = 1'b0;   
                    logic_En = 1'b0;
                    cmp_En = 1'b1;     // CMP operation is enabled
                    shift_En = 1'b0;
                end 
        2'b11 : begin
                    arith_En = 1'b0;   
                    logic_En = 1'b0;
                    cmp_En = 1'b0;
                    shift_En = 1'b1;   // Shift operation is enabled
                end 
        endcase
    end


endmodule
