module ALU_Top #(parameter Data_In_Width = 16)
(
    // Inputs
    input   wire            [Data_In_Width-1 : 0]    A ,     // n-bits = 16
    input   wire            [Data_In_Width-1 : 0]    B ,     // n-bits = 16
    input   wire                          [3 : 0]    ALU_FUN,   
    input   wire                                     CLK,
    input   wire                                     RST,
    // Outputs
    output  wire      [(2*Data_In_Width)-1 : 0]      Arith_OUT,  // size is Data_In_Width not Data_In_Width-1 bec. (n-bits) + (n-bits) = (n-bits + 1), extra bit for carry
    output  wire                                     Arith_Flag,

    output  wire            [Data_In_Width-1 : 0]    Logic_OUT, 
    output  wire                                     Logic_Flag,

    output  wire                          [1 : 0]    CMP_OUT,
    output  wire                                     CMP_Flag,

    output  wire            [Data_In_Width-1 : 0]    Shift_OUT, 
    output  wire                                     Shift_Flag

);

// Internal Connetions
wire    Arith_Enable;
wire    Logic_Enable;
wire    CMP_Enable;
wire    Shift_Enable;
wire    Over_Flow;
// Instantiation

// Decoder
Decoder_2_to_4_Unit ins_Decoder_2_to_4_Unit (
    .alu_fun (ALU_FUN),
    .arith_En (Arith_Enable),
    .logic_En (Logic_Enable),
    .cmp_En (CMP_Enable),
    .shift_En (Shift_Enable)
);

// Arithmetic Unit
Arithmetic_Unit ins_Arithmetic_Unit (
    .A_in (A),
    .B_in (B),
    .alu_fun (ALU_FUN),
    .CLK_in (CLK),
    .RST_in (RST),
    .arith_En (Arith_Enable),
    .arith_out (Arith_OUT),
    .arith_flag (Arith_Flag),
    .over_flow (Over_Flow)
);

// Logic_Unit
Logic_Unit ins_Logic_unit (
    .A_in (A),
    .B_in (B),
    .alu_fun (ALU_FUN),
    .CLK_in (CLK),
    .RST_in (RST),
    .logic_En (Logic_Enable),
    .logic_out (Logic_OUT),
    .logic_flag (Logic_Flag)
);

// CMP Unit
CMP_Unit ins_CMP_Unit (
    .A_in (A),
    .B_in (B),
    .alu_fun  (ALU_FUN),
    .CLK_in (CLK),
    .RST_in (RST),
    .cmp_En (CMP_Enable),
    .cmp_out (CMP_OUT),
    .cmp_flag (CMP_Flag)
);

// Shift Unit
Shift_unit ins_Shift_Unit (
    .A_in (A),
    .B_in (B),
    .alu_fun  (ALU_FUN),
    .CLK_in (CLK),
    .RST_in (RST),
    .shift_En (Shift_Enable),
    .shift_out (Shift_OUT),
    .shift_flag (Shift_Flag)
);

endmodule
