module memory_stage 
(
    input  wire                 clk        ,
    input  wire                 rst        ,

    input  wire     [31:0]      ALUResultM , // from previous stage (execute)
    input  wire     [31:0]      WriteDataM , // from previous stage (execute)
    input  wire     [4 :0]      RdM        , // from previous stage (execute)
    input  wire     [31:0]      PCPlus4M   , // from previous stage (execute)

    input  wire     [31:0]      ReadDataM  , // from data memory


    output wire     [31:0]      ALUResultW , // to next stage (write back)

    output wire     [31:0]      ReadDataW  , // to next stage (write back)
    output wire     [4 :0]      RdW        , // to next stage (write back)
    output wire     [31:0]      PCPlus4W   , // to next stage (write back)

    // control signals
    input  wire                 RegWriteM  , // from previous stage (Execute)    
    input  wire     [1 :0]      ResultSrcM , // from previous stage (Execute) 
    input  wire                 MemWriteM  , // from previous stage (Execute) 

    output wire                 RegWriteW  , // to next stage (write back)    
    output wire     [1 :0]      ResultSrcW   // to next stage (write back)
);

Register #(32) U7_ALUResultW (
    .clk            (clk          ) ,
    .rst            (rst          ) ,
    .En             (1'b1         ) , // no stall

    .in             (ALUResultM   ) ,
    .out            (ALUResultW   )
);

Register #(32) U8_ReadDataW (
    .clk            (clk          ) ,
    .rst            (rst          ) ,
    .En             (1'b1         ) , // no stall

    .in             (ReadDataM    ) ,
    .out            (ReadDataW    )
);

Register #(5) U7_RdW (
    .clk            (clk          ) ,
    .rst            (rst          ) ,
    .En             (1'b1         ) , // no stall

    .in             (RdM          ) ,
    .out            (RdW          )
);

Register #(32) U8_PCPlus4W (
    .clk            (clk          ) ,
    .rst            (rst          ) ,
    .En             (1'b1         ) , // no stall

    .in             (PCPlus4M     ) ,
    .out            (PCPlus4W     )
);

        // For control Signals

Register #(1) U9_RegWriteW(
    .clk            (clk          ) ,
    .rst            (rst          ) ,
    .En             (1'b1         ) , // no stall

    .in             (RegWriteM    ) ,
    .out            (RegWriteW    )
);

Register #(2) U10_ResultSrcW(
    .clk            (clk          ) ,
    .rst            (rst          ) ,
    .En             (1'b1         ) , // no stall

    .in             (ResultSrcM   ) ,
    .out            (ResultSrcW   )
);

endmodule