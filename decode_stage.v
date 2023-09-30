module decode_stage 
(
    input  wire                 clk        ,
    input  wire                 rst        ,

    input  wire                 FlushE     , // from hazard unit
    
    input  wire     [31:0]      instrD     , // from previoud stage (fetch)
    input  wire     [31:0]      PCD        , // from previoud stage (fetch)
    input  wire     [31:0]      PCPlus4D   , // from previoud stage (fetch)
    
    input  wire     [4 :0]      RdW        , // from write stage to A3
    input  wire     [31:0]      ResultW    , // from write stage to WD3
    input  wire                 RegWriteW  , // from write stage to WE3
    
    output wire     [31:0]      RD1E       , // out of regfile to next stage
    output wire     [31:0]      RD2E       , // out of regfile to next stage

    output wire     [31:0]      PCE        , // to next stage (Execute)
    output wire     [4 :0]      Rs1E       , // to next stage (Execute)
    output wire     [4 :0]      Rs2E       , // to next stage (Execute)
    output wire     [4 :0]      RdE        , // to next stage (Execute)

    output wire     [31:0]      ExtimmE    , // to next stage (Execute)

    output wire     [31:0]      PCPlus4E   , // to next stage (Execute)
    
    // control signals
    input  wire                 RegWriteD  , // from control unit    
    input  wire     [1 :0]      ResultSrcD , // from control unit 
    input  wire                 MemWriteD  , // from control unit 
    input  wire     [2 :0]      ALUControlD, // from control unit 
    input  wire                 ALUSrcD    , // from control unit 
    input  wire     [1 :0]      ImmSrcD    , // from control unit 
    input  wire                 BranchD    , // from control unit 
    input  wire                 JumpD      , // from control unit 

    output wire                 RegWriteE  , // to next stage (Execute)    
    output wire     [1 :0]      ResultSrcE , // to next stage (Execute)
    output wire                 MemWriteE  , // to next stage (Execute)
    output wire     [2 :0]      ALUControlE, // to next stage (Execute)
    output wire                 ALUSrcE    , // to next stage (Execute) 
    output wire                 BranchE    , // to next stage (Execute)
    output wire                 JumpE        // to next stage (Execute)    
);


    wire    [31:0]      RD1D    ;
    wire    [31:0]      RD2D    ;

    wire    [31:0]      ImmExtD ;

reg_file U0_RegFile(
    .clk            (clk          ) ,
    .rst            (rst          ) ,
    .A1             (instrD[19:15]) ,
    .A2             (instrD[24:20]) ,
    .A3             (RdW          ) ,
    .WE3            (RegWriteW    ) ,
    .WD3            (ResultW      ) ,
        
    .RD1            (RD1D         ) ,
    .RD2            (RD2D         )   
);

extend U1_extend (
    .in             (instrD[31:7] ) ,
    .ImmSrc         (ImmSrcD      ) ,
    .ImmExt         (ImmExtD      ) 
);

Register #(32) U2_RD1E (
    .clk            (clk          ) ,
    .rst            (rst | FlushE ) ,
    .En             (1'b1         ) , // no stall

    .in             (RD1D         ) ,
    .out            (RD1E         )
);

Register #(32) U3_RD2E (
    .clk            (clk          ) ,
    .rst            (rst | FlushE ) ,
    .En             (1'b1         ) , // no stall

    .in             (RD2D         ) ,
    .out            (RD2E         )
);

Register #(32) U4_PCE (
    .clk            (clk          ) ,
    .rst            (rst | FlushE ) ,
    .En             (1'b1         ) , // no stall

    .in             (PCD          ) ,
    .out            (PCE          )
);

Register #(5) U5_Rs1E (
    .clk            (clk          ) ,
    .rst            (rst | FlushE ) ,
    .En             (1'b1         ) , // no stall

    .in             (instrD[19:15]) ,
    .out            (Rs1E         )
);

Register #(5) U6_Rs2E (
    .clk            (clk          ) ,
    .rst            (rst | FlushE ) ,
    .En             (1'b1         ) , // no stall

    .in             (instrD[24:20]) ,
    .out            (Rs2E         )
);

Register #(5) U7_RdE (
    .clk            (clk          ) ,
    .rst            (rst | FlushE ) ,
    .En             (1'b1         ) , // no stall

    .in             (instrD[11:7] ) ,
    .out            (RdE          )
);

Register #(32) U8_ExtImmE (
    .clk            (clk          ) ,
    .rst            (rst | FlushE ) ,
    .En             (1'b1         ) , // no stall

    .in             (ImmExtD      ) ,
    .out            (ExtimmE      )
);

Register #(32) U9_PCPlus4E (
    .clk            (clk          ) ,
    .rst            (rst | FlushE ) ,
    .En             (1'b1         ) , // no stall

    .in             (PCPlus4D     ) ,
    .out            (PCPlus4E     )
);

        // For control Signals

Register #(1) U10_RegWriteE(
    .clk            (clk          ) ,
    .rst            (rst | FlushE ) ,
    .En             (1'b1         ) , // no stall

    .in             (RegWriteD    ) ,
    .out            (RegWriteE    )
);

Register #(2) U11_ResultSrcE(
    .clk            (clk          ) ,
    .rst            (rst | FlushE ) ,
    .En             (1'b1         ) , // no stall

    .in             (ResultSrcD   ) ,
    .out            (ResultSrcE   )
);

Register #(1) U12_MemWriteE(
    .clk            (clk          ) ,
    .rst            (rst | FlushE ) ,
    .En             (1'b1         ) , // no stall

    .in             (MemWriteD    ) ,
    .out            (MemWriteE    )
);

Register #(3) U13_ALUControlE(
    .clk            (clk          ) ,
    .rst            (rst | FlushE ) ,
    .En             (1'b1         ) , // no stall

    .in             (ALUControlD  ) ,
    .out            (ALUControlE  )
);

Register #(1) U14_ALUSrcE(
    .clk            (clk          ) ,
    .rst            (rst | FlushE ) ,
    .En             (1'b1         ) , // no stall

    .in             (ALUSrcD      ) ,
    .out            (ALUSrcE      )
);

Register #(1) U15_BranchE(
    .clk            (clk          ) ,
    .rst            (rst | FlushE ) ,
    .En             (1'b1         ) , // no stall

    .in             (BranchD      ) ,
    .out            (BranchE      )
);

Register #(1) U16_JumpE(
    .clk            (clk          ) ,
    .rst            (rst | FlushE ) ,
    .En             (1'b1         ) , // no stall

    .in             (JumpD        ) ,
    .out            (JumpE        )
);

endmodule