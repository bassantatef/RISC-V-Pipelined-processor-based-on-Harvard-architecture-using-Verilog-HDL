module RISCV_pipelined_tb ();

reg                 clk_tb    ;
reg                 rst_tb    ;       


initial begin
    clk_tb = 1'b0 ;
    rst_tb = 1'b0 ;
    #5
    rst_tb = 1'b1 ;
    #10
    rst_tb = 1'b0 ;
    
    #31
    
    // addi x6,  x0,  B       00B00313       --> I-Type
    if(DUT.U_datapath.U1_decode.U0_RegFile.WE3) begin
        if(DUT.U_datapath.U1_decode.U0_RegFile.A3 === 32'h6 & DUT.U_datapath.U1_decode.U0_RegFile.WD3 === 32'hB) begin
            $display("PASSED : addi instruction");
        end 
        else begin
            $display("FAILED : addi instruction");
        end 
    end

    #10 

    // addi x7,  x0,  5       00500393       --> I-Type
    if(DUT.U_datapath.U1_decode.U0_RegFile.WE3) begin
        if(DUT.U_datapath.U1_decode.U0_RegFile.A3 === 32'h7 & DUT.U_datapath.U1_decode.U0_RegFile.WD3 === 32'h5) begin
            $display("PASSED : addi instruction 2 ");
        end 
        else begin
            $display("FAILED : : addi instruction 2");
        end 
    end 

    #10

    // addi x8,  x0,  3       00300413       --> I-Type
    if(DUT.U_datapath.U1_decode.U0_RegFile.WE3) begin
        if(DUT.U_datapath.U1_decode.U0_RegFile.A3 === 32'h8 & DUT.U_datapath.U1_decode.U0_RegFile.WD3 === 32'h3) begin
            $display("PASSED : addi instruction 3");
        end 
        else begin
            $display("FAILED : addi instruction 3");
        end 
    end

    #10

    // or   x9,  x6,  x8     008364B3   --> R-Type
    if(DUT.U_datapath.U1_decode.U0_RegFile.WE3) begin
        if(DUT.U_datapath.U1_decode.U0_RegFile.A3 === 32'h9 & DUT.U_datapath.U1_decode.U0_RegFile.WD3 === 32'hB) begin
            $display("PASSED : or instruction");
        end 
        else begin
            $display("FAILED : or instruction");
        end 
    end 

    #10

    // and  x10, x7,  x8     0083F533   --> R-Type
    if(DUT.U_datapath.U1_decode.U0_RegFile.WE3) begin
        if(DUT.U_datapath.U1_decode.U0_RegFile.A3 === 32'hA & DUT.U_datapath.U1_decode.U0_RegFile.WD3 === 32'h1) begin
            $display("PASSED : and instruction");
        end 
        else begin
            $display("FAILED : and instruction");
        end 
    end

    // beq  x8,  x7,  L2       02740263   --> B-Type
    // will not branch
    if(DUT.U_datapath.U2_execute.PCSrcE == 0 && DUT.U_datapath.U2_execute.BranchE) begin
        $display("PASSED : branch instruction 1");
    end
    else begin
        $display("FAILED : branch instruction 1");
    end

    #10

    // add  x11, x10, x9     009505B3   --> R-Type
    if(DUT.U_datapath.U1_decode.U0_RegFile.WE3) begin
        if(DUT.U_datapath.U1_decode.U0_RegFile.A3 === 32'hB & DUT.U_datapath.U1_decode.U0_RegFile.WD3 === 32'hC) begin
            $display("PASSED : add instruction");
        end 
        else begin
            $display("FAILED : add instruction");
        end 
    end

    #10
    #10 // wait another cycle as the branch that not taken
    // slt  x12, x9,  x11     00B4A633   --> R-Type
    if(DUT.U_datapath.U1_decode.U0_RegFile.WE3) begin
        if(DUT.U_datapath.U1_decode.U0_RegFile.A3 === 32'hC & DUT.U_datapath.U1_decode.U0_RegFile.WD3 === 32'h1) begin
            $display ("PASSED : slt instruction");
        end 
        else begin
            $display("FAILED : slt instruction");
        end 
    end

    #40 // as there is a branch occurs

    // and  x13, x11, x7      0075F6B3   --> R-Type 
    if(DUT.U_datapath.U1_decode.U0_RegFile.WE3) begin
        if(DUT.U_datapath.U1_decode.U0_RegFile.A3 === 32'hD & DUT.U_datapath.U1_decode.U0_RegFile.WD3 === 32'h4) begin
            $display("PASSED : and instruction 2");
        end 
        else begin
            $display("FAILED : and instruction 2");
        end 
    end 

    #10

    // sw   x14, 8(x12)  --> [9] = x14 = 16   00E62423  --> S-Type

    if(DUT.MemWriteM) begin
        if(DUT.ALUResultM === 32'h9 & DUT.U_datapath.U4_WriteBack.ResultW === 32'h10) begin
            $display("PASSED : store instruction");
        end 
        else begin
            $display("FAILED : store instruction");
        end 
    end 

    #20


    // lw   x15, -2(x9)       ffe32503   --> I-Type
    if(DUT.U_datapath.U1_decode.U0_RegFile.WE3) begin
        if(DUT.U_datapath.U1_decode.U0_RegFile.A3 === 32'hf & DUT.U_datapath.U1_decode.U0_RegFile.WD3 === 32'h10) begin
            $display("PASSED : load instruction");
        end 
        else begin
            $display("FAILED : load instruction");
        end 
    end 

    #40

    // add  x5, x10, x9
    if(DUT.U_datapath.U1_decode.U0_RegFile.WE3) begin
        if(DUT.U_datapath.U1_decode.U0_RegFile.A3 === 32'h5 & DUT.U_datapath.U1_decode.U0_RegFile.WD3 === 32'hC) begin
            $display("PASSED : add instruction 2");
        end 
        else begin
            $display("FAILED : add instruction 2");
        end  
    end 

    #100

    $finish;
    
  
end


// GENERATE CLOCK
always #5 clk_tb = ~clk_tb ;

// DUT instantiation

RISCV_pipelined_top DUT (
    .clk  (clk_tb) ,
    .rst  (rst_tb) 
);

endmodule