module Logic_Unit #(parameter Data_In_Width = 16) 
(
    // Inputs
    input   wire    [Data_In_Width-1 : 0]    A_in ,   // n-bits = 16
    input   wire    [Data_In_Width-1 : 0]    B_in ,   // n-bits = 16
    input   wire                  [3 : 0]    alu_fun, // Will use only the MSBs by using a signal below
    input   wire                             CLK_in,
    input   wire                             RST_in,
    input   wire                             logic_En,
    // Outputs
    output  reg    [Data_In_Width-1 : 0]     logic_out, 
    output  reg                              logic_flag
);

// Signal assignment
wire    [1:0]   alu_fun_LSBs = alu_fun[1:0];     // to choose the logic operation by getting the first 2-bits of alu_fun
reg     [Data_In_Width-1 : 0]   logic_out_comb;
reg     logic_flag_comb;


always @ (posedge CLK_in or negedge RST_in)      // Active low Async Reset
    begin
        if (!RST_in)
            begin
                logic_out  <= 'b0;
                logic_flag <= 1'b0;
            end
        else
            begin
                logic_out  <= logic_out_comb;
                logic_flag <= logic_flag_comb;
            end
    end


always @ (*)
    begin
        if (logic_En)
            begin
                logic_flag_comb = 1'b1;

                case (alu_fun_LSBs)
                2'b00 : logic_out_comb = A_in & B_in;   // AND
                2'b01 : logic_out_comb = A_in | B_in;   // OR
                2'b10 : logic_out_comb = ~(A_in & B_in);    // NAND
                2'b11 : logic_out_comb = ~(A_in | B_in);    //NOR
                endcase
            end
        else
            begin
                logic_flag_comb = 1'b0;
                logic_out_comb = 'b0;
            end
    end


endmodule