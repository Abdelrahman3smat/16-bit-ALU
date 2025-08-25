module CMP_Unit #(parameter Data_In_Width = 16)
(
    // Inputs
    input   wire    signed  [Data_In_Width-1 : 0]    A_in ,     // n-bits = 16
    input   wire    signed  [Data_In_Width-1 : 0]    B_in ,     // n-bits = 16
    input   wire                          [3 : 0]    alu_fun,   // Will use only the MSBs by using a signal below
    input   wire                                     CLK_in,
    input   wire                                     RST_in,
    input   wire                                     cmp_En,
    // Outputs
    output  reg             [1 : 0]                  cmp_out,
    output  reg                                      cmp_flag
);

// Signal assignment
wire    [1 : 0]   alu_fun_LSBs = alu_fun[1:0];     // to choose the CMP operation by getting the first 2-bits of alu_fun
reg     [1 : 0]   cmp_out_comb;
reg     cmp_flag_comb;


always @ (posedge CLK_in or negedge RST_in)
    begin
        if (!RST_in)
            begin
                cmp_out  <= 'sb0;
                cmp_flag <= 1'b0;
            end
        else
            begin
                cmp_out  <= cmp_out_comb;
                cmp_flag <= cmp_flag_comb;
            end
    end


always @ (*)
    begin
        if (cmp_En)
            begin
                case (alu_fun_LSBs)
                2'b00 : begin
                            cmp_flag_comb = 1'b0;
                            cmp_out_comb = 'sb0;
                        end
                2'b01 : begin
                            cmp_flag_comb = 1'b1;
                            cmp_out_comb = (A_in == B_in) ? 'sd1 : 'sd0;
                        end
                2'b10 : begin
                            cmp_flag_comb = 1'b1;
                            cmp_out_comb = (A_in > B_in) ?  'sd2 : 'sd0;
                        end
                2'b11 : begin   
                            cmp_flag_comb = 1'b1;
                            cmp_out_comb = (A_in < B_in) ?  'sd3 : 'sd0;
                        end
                endcase
            end
        else
            begin
                cmp_flag_comb = 1'b0;
                cmp_out_comb = 'sb0;
            end
    end


endmodule