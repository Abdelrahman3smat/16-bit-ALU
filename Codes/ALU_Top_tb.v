`timescale 1us/1ns
module ALU_Top_tb #(parameter Data_In_Width = 16) ();

// tb signals

// Inputs
reg    signed  [Data_In_Width-1 : 0]     A_tb;     // n-bits = 16
reg    signed  [Data_In_Width-1 : 0]     B_tb;     // n-bits = 16
reg                          [3 : 0]     ALU_FUN_tb;   
reg                                      CLK_tb;
reg                                      RST_tb;
// Outputs
wire    signed  [(2*Data_In_Width)-1 : 0]    Arith_OUT_tb;  
wire                                         Arith_Flag_tb;
wire                [Data_In_Width-1 : 0]    Logic_OUT_tb; 
wire                                         Logic_Flag_tb;
wire                              [1 : 0]    CMP_OUT_tb;
wire                                         CMP_Flag_tb;
wire    signed      [Data_In_Width-1 : 0]    Shift_OUT_tb; 
wire                                         Shift_Flag_tb;

// DUT instantiation

ALU_Top DUT
( 
    // Inputs
    .A (A_tb),
    .B (B_tb),
    .ALU_FUN (ALU_FUN_tb),
    .CLK (CLK_tb),
    .RST (RST_tb),
    // Outputs
    .Arith_OUT (Arith_OUT_tb),
    .Arith_Flag (Arith_Flag_tb),
    .Logic_OUT (Logic_OUT_tb),
    .Logic_Flag (Logic_Flag_tb),
    .CMP_OUT (CMP_OUT_tb),
    .CMP_Flag (CMP_Flag_tb),
    .Shift_OUT (Shift_OUT_tb),
    .Shift_Flag (Shift_Flag_tb)
);

initial
    begin
        CLK_tb = 1'b0;
    end

// Clock generation
always #(CLK_tb ? 6 : 4) CLK_tb = ~CLK_tb;      // clock frequency 100 KHz with duty cycle 40% low and 60% high

// Intialization
initial
    begin
        $monitor("Time = %0t, ALU_FUN = %0b, A = %0d, B = %0d, Arith_Enable = %b, Logic_Enable = %b, CMP_Enable = %b, Shift_Enable = %b",
        $time, ALU_FUN_tb, A_tb, B_tb, DUT.Arith_Enable, DUT.Logic_Enable, DUT.CMP_Enable, DUT.Shift_Enable);
        $dumpfile ("ALU_Top.vcd");
        $dumpvars;
        RST_tb = 1'b0;
        A_tb = 'd0;
        B_tb = 'd0;
        ALU_FUN_tb = 4'b0000;
        
// Arithmetic operations tb
// Addition

    // Test Case_1 (Sum with A is Negative & B is Negative) Check
        $display ("** Test Case_1 (Sum with A is Negative & B is Negative Check) **");
        #20
        RST_tb = 1'b1;
        ALU_FUN_tb = 4'b0000;   // Arithmatic Operations (MSBs) , Addition Operation (LSBs)
        A_tb = -'d60;   // -ve A
        B_tb = -'d50;   // -ve B
        #10
        if (Arith_OUT_tb == 'shFFFFFF92 && Arith_Flag_tb == 1'b1 )   // Arith_OUT_tb = -110  
            $display ("** Test Case_1 Passed at time: %0t with Arith_OUT = %0d , Arith_Flag = %0b , Over_Flow = %0b **" , $time, Arith_OUT_tb, Arith_Flag_tb, DUT.Over_Flow);
        else
            $display ("** Test Case_1 Failed at time: %0t **", $time);


    // Test Case_2 (Sum with A is Positive & B is Negative) Check
        $display ("** Test Case_2 (Sum with A is Positive & B is Negative Check) **");
        #20
        ALU_FUN_tb = 4'b0000;   // Arithmatic Operations (MSBs) , Addition Operation (LSBs)
        A_tb =  'd60;   // +ve A
        B_tb = -'d50;   // -ve B
        #10
        if (Arith_OUT_tb == 'sh000A && Arith_Flag_tb == 1'b1 )    // Arith_OUT_tb = 10 
            $display ("** Test Case_2 Passed at time: %0t with Arith_OUT = %0d , Arith_Flag = %0b , Over_Flow = %0b **" , $time, Arith_OUT_tb, Arith_Flag_tb, DUT.Over_Flow);
        else
            $display ("** Test Case_2 Failed at time: %0t **", $time);

    
    // Test Case_3 (Sum with A is Negative & B is Positive) Check
        $display ("** Test Case_3 (Sum with A is Negative & B is Positive Check) **");
        #20
        ALU_FUN_tb = 4'b0000;   // Arithmatic Operations (MSBs) , Addition Operation (LSBs)
        A_tb = -'d60;   // -ve A
        B_tb =  'd50;   // +ve B
        #10
        if (Arith_OUT_tb == 'shFFFFFFF6 && Arith_Flag_tb == 1'b1 )    // Arith_OUT_tb = -10 
            $display ("** Test Case_3 Passed at time: %0t with Arith_OUT = %0d , Arith_Flag = %0b , Over_Flow = %0b **" , $time, Arith_OUT_tb, Arith_Flag_tb, DUT.Over_Flow);
        else
            $display ("** Test Case_3 Failed at time: %0t **", $time);

    
    // Test Case_4 (Sum with A is Positive & B is Positive) Check
        $display ("** Test Case_4 (Sum with A is Positive & B is Positive Check) **");
        #20
        ALU_FUN_tb = 4'b0000;   // Arithmatic Operations (MSBs) , Addition Operation (LSBs)
        A_tb = 'd60;   // +ve A
        B_tb = 'd50;   // +ve B
        #10
        if (Arith_OUT_tb == 'sh006E && Arith_Flag_tb == 1'b1 )     // Arith_OUT_tb = 110
            $display ("** Test Case_4 Passed at time: %0t with Arith_OUT = %0d , Arith_Flag = %0b , Over_Flow = %0b **" , $time, Arith_OUT_tb, Arith_Flag_tb, DUT.Over_Flow);
        else
            $display ("** Test Case_4 Failed at time: %0t **", $time);

// Subtraction

    // Test Case_5 (Subtraction with A is Negative & B is Negative) Check
        $display ("** Test Case_5 (Subtraction with A is Negative & B is Negative Check) **");
        #20
        ALU_FUN_tb = 4'b0001;   // Arithmatic Operations (MSBs) , Subtraction Operation (LSBs)
        A_tb = -'d60;   // -ve A
        B_tb = -'d50;   // -ve B
        #10
        if (Arith_OUT_tb == 'shFFFFFFF6 && Arith_Flag_tb == 1'b1 )   // Arith_OUT_tb = -10  
            $display ("** Test Case_5 Passed at time: %0t with Arith_OUT = %0d , Arith_Flag = %0b , Over_Flow = %0b **" , $time, Arith_OUT_tb, Arith_Flag_tb, DUT.Over_Flow);
        else
            $display ("** Test Case_5 Failed at time: %0t **", $time);


    // Test Case_6 (Subtraction with A is Positive & B is Negative) Check
        $display ("** Test Case_6 (Subtraction with A is Positive & B is Negative Check) **");
        #20
        ALU_FUN_tb = 4'b0001;   // Arithmatic Operations (MSBs) , Subtraction Operation (LSBs)
        A_tb =  'd60;   // +ve A
        B_tb = -'d50;   // -ve B
        #10
        if (Arith_OUT_tb == 'sh006E && Arith_Flag_tb == 1'b1 )    // Arith_OUT_tb = 110 
            $display ("** Test Case_6 Passed at time: %0t with Arith_OUT = %0d , Arith_Flag = %0b , Over_Flow = %0b **" , $time, Arith_OUT_tb, Arith_Flag_tb, DUT.Over_Flow);
        else
            $display ("** Test Case_6 Failed at time: %0t **", $time);

    
    // Test Case_7 (Subtraction with A is Negative & B is Positive) Check
        $display ("** Test Case_7 (Subtraction with A is Negative & B is Positive Check) **");
        #20
        ALU_FUN_tb = 4'b0001;   // Arithmatic Operations (MSBs) , Subtraction Operation (LSBs)
        A_tb = -'d60;   // -ve A
        B_tb =  'd50;   // +ve B
        #10
        if (Arith_OUT_tb == 'shFFFFFF92 && Arith_Flag_tb == 1'b1 )    // Arith_OUT_tb = -110 
            $display ("** Test Case_7 Passed at time: %0t with Arith_OUT = %0d , Arith_Flag = %0b , Over_Flow = %0b **" , $time, Arith_OUT_tb, Arith_Flag_tb, DUT.Over_Flow);
        else
            $display ("** Test Case_7 Failed at time: %0t **", $time);

    
    // Test Case_8 (Subtraction with A is Positive & B is Positive) Check
        $display ("** Test Case_8 (Subtraction with A is Positive & B is Positive Check) **");
        #20
        ALU_FUN_tb = 4'b0001;   // Arithmatic Operations (MSBs) , Subtraction Operation (LSBs)
        A_tb = 'd60;   // +ve A
        B_tb = 'd50;   // +ve B
        #10
        if (Arith_OUT_tb == 'sh000A && Arith_Flag_tb == 1'b1 )     // Arith_OUT_tb = 10
            $display ("** Test Case_8 Passed at time: %0t with Arith_OUT = %0d , Arith_Flag = %0b , Over_Flow = %0b **" , $time, Arith_OUT_tb, Arith_Flag_tb, DUT.Over_Flow);
        else
            $display ("** Test Case_8 Failed at time: %0t **", $time);

// Multiplication

    // Test Case_9 (Multiplication with A is Negative & B is Negative) Check
        $display ("** Test Case_9 (Multiplication with A is Negative & B is Negative Check) **");
        #20
        ALU_FUN_tb = 4'b0010;   // Arithmatic Operations (MSBs) , Multiplication Operation (LSBs)
        A_tb = -'d60;   // -ve A
        B_tb = -'d50;   // -ve B
        #10
        if (Arith_OUT_tb == 'sh0BB8 && Arith_Flag_tb == 1'b1 )   // Arith_OUT_tb = 3000  
            $display ("** Test Case_9 Passed at time: %0t with Arith_OUT = %0d , Arith_Flag = %0b , Over_Flow = %0b **" , $time, Arith_OUT_tb, Arith_Flag_tb, DUT.Over_Flow);
        else
            $display ("** Test Case_9 Failed at time: %0t **", $time);


    // Test Case_10 (Multiplication with A is Positive & B is Negative) Check
        $display ("** Test Case_10 (Multiplication with A is Positive & B is Negative Check) **");
        #20
        ALU_FUN_tb = 4'b0010;   // Arithmatic Operations (MSBs) , Multiplication Operation (LSBs)
        A_tb =  'd60;   // +ve A
        B_tb = -'d50;   // -ve B
        #10
        if (Arith_OUT_tb == 'shFFFFF448 && Arith_Flag_tb == 1'b1 )    // Arith_OUT_tb = -3000 
            $display ("** Test Case_10 Passed at time: %0t with Arith_OUT = %0d , Arith_Flag = %0b , Over_Flow = %0b **" , $time, Arith_OUT_tb, Arith_Flag_tb, DUT.Over_Flow);
        else
            $display ("** Test Case_10 Failed at time: %0t **", $time);

    
    // Test Case_11 (Multiplication with A is Negative & B is Positive) Check
        $display ("** Test Case_11 (Multiplication with A is Negative & B is Positive Check) **");
        #20
        ALU_FUN_tb = 4'b0010;   // Arithmatic Operations (MSBs) , Multiplication Operation (LSBs)
        A_tb = -'d30;   // -ve A
        B_tb =  'd15;   // +ve B
        #10
        if (Arith_OUT_tb == 'shFFFFFE3E && Arith_Flag_tb == 1'b1 )    // Arith_OUT_tb = -450 
            $display ("** Test Case_11 Passed at time: %0t with Arith_OUT = %0d , Arith_Flag = %0b , Over_Flow = %0b **" , $time, Arith_OUT_tb, Arith_Flag_tb, DUT.Over_Flow);
        else
            $display ("** Test Case_11 Failed at time: %0t **", $time);

    
    // Test Case_12 (Multiplication with A is Positive & B is Positive) Check
        $display ("** Test Case_12 (Multiplication with A is Positive & B is Positive Check) **");
        #20
        ALU_FUN_tb = 4'b0010;   // Arithmatic Operations (MSBs) , Multiplication Operation (LSBs)
        A_tb = 'd30;   // +ve A
        B_tb = 'd15;   // +ve B
        #10
        if (Arith_OUT_tb == 'sh01C2 && Arith_Flag_tb == 1'b1 )     // Arith_OUT_tb = 450
            $display ("** Test Case_12 Passed at time: %0t with Arith_OUT = %0d , Arith_Flag = %0b , Over_Flow = %0b **" , $time, Arith_OUT_tb, Arith_Flag_tb, DUT.Over_Flow);
        else
            $display ("** Test Case_12 Failed at time: %0t **", $time);


// Division

    // Test Case_13 (Division with A is Negative & B is Negative) Check
        $display ("** Test Case_13 (Division with A is Negative & B is Negative Check) **");
        #20
        ALU_FUN_tb = 4'b0011;   // Arithmatic Operations (MSBs) , Division Operation (LSBs)
        A_tb = -'d1000;   // -ve A
        B_tb = -'d50;   // -ve B
        #10
        if (Arith_OUT_tb == 'sh0014 && Arith_Flag_tb == 1'b1 )   // Arith_OUT_tb = 20  
            $display ("** Test Case_13 Passed at time: %0t with Arith_OUT = %0d , Arith_Flag = %0b , Over_Flow = %0b **" , $time, Arith_OUT_tb, Arith_Flag_tb, DUT.Over_Flow);
        else
            $display ("** Test Case_13 Failed at time: %0t **", $time);


    // Test Case_14 (Division with A is Positive & B is Negative) Check
        $display ("** Test Case_14 (Division with A is Positive & B is Negative Check) **");
        #20
        ALU_FUN_tb = 4'b0011;   // Arithmatic Operations (MSBs) , Division Operation (LSBs)
        A_tb =  'd1000;   // +ve A
        B_tb = -'d50;   // -ve B
        #10
        if (Arith_OUT_tb == 'shFFFFFFEC && Arith_Flag_tb == 1'b1 )    // Arith_OUT_tb = -20 
            $display ("** Test Case_14 Passed at time: %0t with Arith_OUT = %0d , Arith_Flag = %0b , Over_Flow = %0b **" , $time, Arith_OUT_tb, Arith_Flag_tb, DUT.Over_Flow);
        else
            $display ("** Test Case_14 Failed at time: %0t **", $time);

    
    // Test Case_15 (Division with A is Negative & B is Positive) Check
        $display ("** Test Case_15 (Division with A is Negative & B is Positive Check) **");
        #20
        ALU_FUN_tb = 4'b0011;   // Arithmatic Operations (MSBs) , Division Operation (LSBs)
        A_tb = -'d30;   // -ve A
        B_tb =  'd15;   // +ve B
        #10
        if (Arith_OUT_tb == 'shFFFFFFFE && Arith_Flag_tb == 1'b1 )    // Arith_OUT_tb = -2 
            $display ("** Test Case_15 Passed at time: %0t with Arith_OUT = %0d , Arith_Flag = %0b , Over_Flow = %0b **" , $time, Arith_OUT_tb, Arith_Flag_tb, DUT.Over_Flow);
        else
            $display ("** Test Case_15 Failed at time: %0t **", $time);

    
    // Test Case_16 (Division with A is Positive & B is Positive) Check
        $display ("** Test Case_16 (Division with A is Positive & B is Positive Check) **");
        #20
        ALU_FUN_tb = 4'b0011;   // Arithmatic Operations (MSBs) , Division Operation (LSBs)
        A_tb = 'd30;   // +ve A
        B_tb = 'd15;   // +ve B
        #10
        if (Arith_OUT_tb == 'sh0002 && Arith_Flag_tb == 1'b1 )     // Arith_OUT_tb = 2
            $display ("** Test Case_16 Passed at time: %0t with Arith_OUT = %0d , Arith_Flag = %0b , Over_Flow = %0b **" , $time, Arith_OUT_tb, Arith_Flag_tb, DUT.Over_Flow);
        else
            $display ("** Test Case_16 Failed at time: %0t **", $time);


// Logic Operations

    // Test Case_17 (AND Logic) Check
        $display ("** Test Case_17 (AND Logic Check) **");
        #20
        ALU_FUN_tb = 4'b0100;   // Logic Operations (MSBs) , AND Logic Operation (LSBs)
        A_tb = 'h0F0F;   // 0000 1111 0000 1111
        B_tb = 'hF0FF;   // 1111 0000 1111 1111
        #10
        if (Logic_OUT_tb == 16'h000F && Logic_Flag_tb == 1'b1 )   // Logic_OUT_tb = h000F  
            $display ("** Test Case_17 Passed at time: %0t with Logic_OUT = %0h , Logic_Flag = %0b **" , $time, Logic_OUT_tb, Logic_Flag_tb);
        else
            $display ("** Test Case_17 Failed at time: %0t **", $time);


    // Test Case_18 (OR Logic) Check
        $display ("** Test Case_18 (OR Logic Check) **");
        #20
        ALU_FUN_tb = 4'b0101;   // Logic Operations (MSBs) , OR  Operation (LSBs)
        A_tb = 'h0F0F;   // 0000 1111 0000 1111
        B_tb = 'hF0FF;   // 1111 0000 1111 1111
        #10
        if (Logic_OUT_tb == 16'hFFFF && Logic_Flag_tb == 1'b1 )    // Logic_OUT_tb = hFFFF 
            $display ("** Test Case_18 Passed at time: %0t with Logic_OUT = %0h , Logic_Flag = %0b **" , $time, Logic_OUT_tb, Logic_Flag_tb);
        else
            $display ("** Test Case_18 Failed at time: %0t **", $time);

    
    // Test Case_19 (NAND Logic) Check
        $display ("** Test Case_19 (NAND Logic Check) **");
        #20
        ALU_FUN_tb = 4'b0110;   // Logic Operations (MSBs) , NAND Operation (LSBs)
        A_tb = 'h0F0F;   // 0000 1111 0000 1111
        B_tb = 'hF0FF;   // 1111 0000 1111 1111
        #10
        if (Logic_OUT_tb == 16'hFFF0 && Logic_Flag_tb == 1'b1 )    // Logic_OUT_tb = hFFF0 
            $display ("** Test Case_19 Passed at time: %0t with Logic_OUT = %0h , Logic_Flag = %0b **" , $time, Logic_OUT_tb, Logic_Flag_tb);
        else
            $display ("** Test Case_19 Failed at time: %0t **", $time);

    
    // Test Case_20 (NOR Logic) Check
        $display ("** Test Case_20 (NOR Logic Check) **");
        #20
        ALU_FUN_tb = 4'b0111;   // Logic Operations (MSBs) , NOR Operation (LSBs)
        A_tb = 'h0F0F;   // 0000 1111 0000 1111
        B_tb = 'hF0FF;   // 1111 0000 1111 1111
        #10
        if (Logic_OUT_tb == 16'h0000 && Logic_Flag_tb == 1'b1 )     // Logic_OUT_tb = 2
            $display ("** Test Case_20 Passed at time: %0t with Logic_OUT = %0h , Logic_Flag = %0b **" , $time, Logic_OUT_tb, Logic_Flag_tb);
        else
            $display ("** Test Case_20 Failed at time: %0t **", $time);


// Comparison Operations

    // Test Case_21 (If A equal B) Check
        $display ("** Test Case_21 (If A equal B) **");
        #20
        ALU_FUN_tb = 4'b1001;   // CMP Operations (MSBs) , Equal Operation (LSBs)
        A_tb = -'d100;   // -ve A
        B_tb = -'d100;   // -ve B
        #10
        if (CMP_OUT_tb == 'sd1 && CMP_Flag_tb == 1'b1 )   // CMP_OUT_tb = 1  
            $display ("** Test Case_21 Passed at time: %0t with CMP_OUT = %0d , CMP_Flag = %0b **" , $time, CMP_OUT_tb, CMP_Flag_tb);
        else
            $display ("** Test Case_21 Failed at time: %0t **", $time);


    // Test Case_22 (If A greater than B) Check
        $display ("** Test Case_22 (If A greater than B) **");
        #20
        ALU_FUN_tb = 4'b1010;   // CMP Operations (MSBs) , Greater than Operation (LSBs)
        A_tb = -'d50;   // -ve A = -50
        B_tb = -'d100;   // -ve B = -100
        #10
        if (CMP_OUT_tb == 'sd2 && CMP_Flag_tb == 1'b1 )   // CMP_OUT_tb = 2  
            $display ("** Test Case_22 Passed at time: %0t with CMP_OUT = %0d , CMP_Flag = %0b **" , $time, CMP_OUT_tb, CMP_Flag_tb);
        else
            $display ("** Test Case_22 Failed at time: %0t **", $time);


    // Test Case_23 (If A Less than B) Check
        $display ("** Test Case_23 (If A Less than B) **");
        #20
        ALU_FUN_tb = 4'b1011;   // CMP Operations (MSBs) , Less than Operation (LSBs)
        A_tb = -'d100;   // -ve A
        B_tb = -'d30;   // -ve B
        #10
        if (CMP_OUT_tb == 'sd3 && CMP_Flag_tb == 1'b1 )   // CMP_OUT_tb = 3  
            $display ("** Test Case_23 Passed at time: %0t with CMP_OUT = %0d , CMP_Flag = %0b **" , $time, CMP_OUT_tb, CMP_Flag_tb);
        else
            $display ("** Test Case_23 Failed at time: %0t **", $time);


    // Test Case_24 (No Operation) Check
        $display ("** Test Case_24 (No Operation) **");
        #20
        ALU_FUN_tb = 4'b1000;   // CMP Operations (MSBs) , NOP Operation (LSBs)
        A_tb = -'d100;   // -ve A
        B_tb = -'d100;   // -ve B
        #10
        if (CMP_OUT_tb == 'sd0 && CMP_Flag_tb == 1'b0 )   // CMP_OUT_tb = 0  
            $display ("** Test Case_24 Passed at time: %0t with CMP_OUT = %0d , CMP_Flag = %0b **" , $time, CMP_OUT_tb, CMP_Flag_tb);
        else
            $display ("** Test Case_24 Failed at time: %0t **", $time);


// Shift Operations tb

    // Test Case_25 (Shift_Right A) Check
        $display ("Test Case_25 (Shift_Right (A) Check)");
        #20
        ALU_FUN_tb = 4'b1100;   // Shift Operations (MSBs) , Shift_Right A Operation (LSBs)
        A_tb = 'h0F0F;   // 0000 1111 0000 1111
        #10
        if (Shift_OUT_tb == A_tb >> 1)
            $display ("** Test Case_25 Passed at time: %0t with Shift_OUT = h %h, Shift_Flag = %0b **", $time, Shift_OUT_tb, Shift_Flag_tb);
        else
            $display ("** Test Case_25 Failed at time: %0t **", $time);


    // Test Case_25 (Shift_Left A) Check
        $display ("Test Case_26 (Shift_Left (A) Check)");
        #20
        ALU_FUN_tb = 4'b1101;   // Shift Operations (MSBs) , Shift_Left A Operation (LSBs)
        A_tb = 'h0F0F;   // 0000 1111 0000 1111
        #10
        if (Shift_OUT_tb == A_tb << 1)
            $display ("** Test Case_26 Passed at time: %0t with Shift_OUT = h %h, Shift_Flag = %0b **", $time, Shift_OUT_tb, Shift_Flag_tb);
        else
            $display ("** Test Case_26 Failed at time: %0t **", $time);


    // Test Case_27 (Shift_Right B) Check
        $display ("Test Case_27 (Shift_Right (B) Check)");
        #20
        ALU_FUN_tb = 4'b1110;   // Shift Operations (MSBs) , Shift_Right B Operation (LSBs)
        B_tb = 'h0F0F;   // 0000 1111 0000 1111
        #10
        if (Shift_OUT_tb == B_tb >> 1)
            $display ("** Test Case_27 Passed at time: %0t with Shift_OUT = h %h, Shift_Flag = %0b **", $time, Shift_OUT_tb, Shift_Flag_tb);
        else
            $display ("** Test Case_27 Failed at time: %0t **", $time);


    // Test Case_28 (Shift_Left B) Check
        $display ("Test Case_28 (Shift_Left (B) Check)");
        #20
        ALU_FUN_tb = 4'b1111;   // Shift Operations (MSBs) , Shift_Left B Operation (LSBs)
        B_tb = 'h0F0F;   // 0000 1111 0000 1111
        #10
        if (Shift_OUT_tb == B_tb << 1)
            $display ("** Test Case_28 Passed at time: %0t with Shift_OUT = h %h, Shift_Flag = %0b **", $time, Shift_OUT_tb, Shift_Flag_tb);
        else
            $display ("** Test Case_28 Failed at time: %0t **", $time);


    #50
    $finish;


    end 

endmodule























