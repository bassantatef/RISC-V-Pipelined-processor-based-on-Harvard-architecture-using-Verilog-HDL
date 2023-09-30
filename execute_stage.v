module execute_stage 
(
    input  wire                 clk        ,
    input  wire                 rst        ,

    input  wire     [1 :0]      ForwardAE  , // from hazard unit
    input  wire     [1 :0]      ForwardBE  , // from hazard unit
    
    input  wire     [31:0]      RD1E       , // from previous stage (decode)
    input  wire     [31:0]      RD2E       , // from previous stage (decode)
    input  wire     [31:0]      PCE        , // from previous stage (decode)
// momkn nshelhom mn el module da   
//    input  wire     [4 :0]      Rs1E       , // from previous stage (decode)
//    input  wire     [4 :0]      Rs2E       , // from previous stage (decode)
    input  wire     [4 :0]      RdE        , // from previous stage (decode)
    input  wire     [31:0]      ExtimmE    , // from previous stage (decode)
    input  wire     [31:0]      PCPlus4E   , // from previous stage (decode)

    input  wire     [31:0]      ResultW    , // from write stage to ALU SrcA or SrcB


    output wire     [31:0]      ALUResultM , // to next stage (Memory) & to ALU SrcA or SrcB
    output wire     [31:0]      WriteDataM , // to next stage (Memory)

    output wire     [4 :0]      RdM        , // to next stage (Memory)
    output wire     [31:0]      PCPlus4M   , // to next stage (Memory)

    output wire     [31:0]      PCTargetE  , // to previous stage (decode)

    output wire                 PCSrcE     , // to fetch stage

    // control signals
    input  wire                 RegWriteE  , // from previous stage (decode)    
    input  wire     [1 :0]      ResultSrcE , // from previous stage (decode) 
    input  wire                 MemWriteE  , // from previous stage (decode) 
    input  wire     [2 :0]      ALUControlE, // from previous stage (decode) 
    input  wire                 ALUSrcE    , // from previous stage (decode) 
    input  wire                 BranchE    , // from previous stage (decode) 
    input  wire                 JumpE      , // from previous stage (decode) 

    output wire                 RegWriteM  , // to next stage (Memory)    
    output wire     [1 :0]      ResultSrcM , // to next stage (Memory)
    output wire                 MemWriteM    // to next stage (Memory)
);

    wire   [31:0]      SrcAE ;
    wire   [31:0]      SrcBE ;

    wire   [31:0]      WriteDataE ;

    wire   [31:0]      ALUResultE ; // ALU output before reg

    wire               zeroE ;

assign PCSrcE = (zeroE & BranchE) | JumpE    ;

mux3X1 U0_mux3X1 (
    .in_1           (RD1E         ) ,
    .in_2           (ResultW      ) ,
    .in_3           (ALUResultM   ) ,
    .sel            (ForwardAE    ) ,
        
    .out            (SrcAE        )
);

mux3X1 U1_mux3X1 (
    .in_1           (RD2E         ) ,
    .in_2           (ResultW      ) ,
    .in_3           (ALUResultM   ) ,
    .sel            (ForwardBE    ) ,

    .out            (WriteDataE   )
);

mux2X1 U2_mux2X1 (
    .in_1           (WriteDataE   ) ,
    .in_2           (ExtimmE      ) ,
    .sel            (ALUSrcE      ) ,

    .out            (SrcBE        )
);

adder U3_PCTarget (
    .in_1           (PCE          ) ,
    .in_2           (ExtimmE      ) ,

    .out            (PCTargetE    ) 
);

ALU U4_ALU (
    .ALUControl     (ALUControlE  ) ,
    .A              (SrcAE        ) ,
    .B              (SrcBE        ) ,

    .result         (ALUResultE   ) , // ALUResult & Address of Data Memory
    .zero           (zeroE        ) 
);


Register #(32) U5_ALUResultM (
    .clk            (clk          ) ,
    .rst            (rst          ) ,
    .En             (1'b1         ) , // no stall

    .in             (ALUResultE   ) ,
    .out            (ALUResultM   )
);

Register #(32) U6_WriteDataM (
    .clk            (clk          ) ,
    .rst            (rst          ) ,
    .En             (1'b1         ) , // no stall

    .in             (WriteDataE   ) ,
    .out            (WriteDataM   )
);

Register #(5) U7_RdM (
    .clk            (clk          ) ,
    .rst            (rst          ) ,
    .En             (1'b1         ) , // no stall

    .in             (RdE          ) ,
    .out            (RdM          )
);

Register #(32) U8_PCPlus4E (
    .clk            (clk          ) ,
    .rst            (rst          ) ,
    .En             (1'b1         ) , // no stall

    .in             (PCPlus4E     ) ,
    .out            (PCPlus4M     )
);

        // For control Signals

Register #(1) U9_RegWriteM(
    .clk            (clk          ) ,
    .rst            (rst          ) ,
    .En             (1'b1         ) , // no stall

    .in             (RegWriteE    ) ,
    .out            (RegWriteM    )
);

Register #(2) U10_ResultSrcM(
    .clk            (clk          ) ,
    .rst            (rst          ) ,
    .En             (1'b1         ) , // no stall

    .in             (ResultSrcE   ) ,
    .out            (ResultSrcM   )
);

Register #(1) U11_MemWriteM(
    .clk            (clk          ) ,
    .rst            (rst          ) ,
    .En             (1'b1         ) , // no stall

    .in             (MemWriteE    ) ,
    .out            (MemWriteM    )
);

endmodule