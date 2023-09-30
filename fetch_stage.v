module fetch_stage 
(
    input  wire                 clk        ,
    input  wire                 rst        ,

    input  wire                 PCSrcE     ,
    input  wire                 StallF     ,
    input  wire                 StallD     ,
    input  wire                 FlushD     ,

    input  wire     [31:0]      InstrF     , // from instr memory

    input  wire     [31:0]      PCTargetE  , 

    output wire     [31:0]      PCPlus4D   ,

    output wire     [31:0]      InstrD     , // to next stage (Decode)
    
    output wire     [31:0]      PCF        , // to instr memory
    output wire     [31:0]      PCD          // to next stage (Decode)
    
);

wire   [31:0]      PCPlus4F ;
wire   [31:0]      PCF_next ;

mux2X1 U0_mux2X1_1 (
    .in_1           (PCPlus4F     ) ,
    .in_2           (PCTargetE    ) ,
    .sel            (PCSrcE       ) ,
            
    .out            (PCF_next     )
);

Register U1_PC_reg (
    .clk            (clk          ) ,
    .rst            (rst          ) ,
    .En             (!StallF      ) ,

    .in             (PCF_next     ) ,
    .out            (PCF          ) 
);

adder U2_PCPlus4 (
    .in_1           (PCF          ) ,
    .in_2           (32'd4        ) ,

    .out            (PCPlus4F     ) 
);

Register #(32) U3_instrD (
    .clk            (clk          ) ,
    .rst            (rst | FlushD ) ,
    .En             (!StallD      ) , // stall

    .in             (InstrF       ) ,
    .out            (InstrD       )
);

Register #(32) U4_PCD (
    .clk            (clk          ) ,
    .rst            (rst | FlushD ) ,
    .En             (!StallD      ) , // stall

    .in             (PCF          ) ,
    .out            (PCD          )
);

Register #(32) U5_PCPlus4D (
    .clk            (clk          ) ,
    .rst            (rst | FlushD ) ,
    .En             (!StallD      ) , // stall

    .in             (PCPlus4F     ) ,
    .out            (PCPlus4D     )
);

endmodule