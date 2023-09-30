module WriteBack_stage 
(
    input  wire                 clk        ,
    input  wire                 rst        ,

    input  wire     [31:0]      ALUResultW , // to next stage (Memory) & to ALU SrcA or SrcB

    input  wire     [31:0]      ReadDataW  , // to next stage (Memory)
    //input  wire     [31:0]      RdW        , // to next stage (Memory)
    input  wire     [31:0]      PCPlus4W   , // to previous stage (fetch)

    // control signals
    //input  wire                 RegWriteW  , 
    input  wire     [1 :0]      ResultSrcW , // to next stage (Memory)

    output wire     [31:0]      ResultW
);

mux3X1 U0_mux3X1 (
    .in_1       (ALUResultW   ) ,
    .in_2       (ReadDataW    ) ,
    .in_3       (PCPlus4W     ) ,
    .sel        (ResultSrcW   ) ,
      
    .out        (ResultW      )
);


endmodule