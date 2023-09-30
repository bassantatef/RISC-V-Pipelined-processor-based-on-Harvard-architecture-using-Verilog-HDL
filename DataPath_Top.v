module Datapath (
    input  wire                 clk          ,
    input  wire                 rst          ,
    
    // instruction memory 
    input  wire     [31:0]      instrF       , // RD from instr_mem
    output wire     [31:0]      PCF          , // Address to instr_mem

    // control unit
    input  wire                 RegWriteD    ,
    input  wire     [1 :0]      ResultSrcD   ,
    input  wire                 MemWriteD    ,
    input  wire                 JumpD        ,
    input  wire                 BranchD      ,
    input  wire     [2 :0]      ALUControlD  ,
    input  wire                 ALUSrcD      ,
    input  wire     [1 :0]      ImmSrcD      ,

    output wire     [31:0]      instrD       , // inputs to control unit

    // data memory
    input  wire     [31:0]      ReadDataM    , // RD from data_mem
    output wire     [31:0]      ALUResultM   , // Address to data_mem
    output wire     [31:0]      WriteDataM   , // WD of data_mem
    output wire                 MemWriteM    , // WE of data_mem

    // hazard unit
    input  wire                 StallF       ,
    input  wire                 StallD       ,
    input  wire                 FlushD       , 
    input  wire                 FlushE       , 
    input  wire     [1:0]       ForwardAE    ,
    input  wire     [1:0]       ForwardBE    ,

    //output wire     [4 :0]      Rs1D         ,
    //output wire     [4 :0]      Rs2D         ,
    output wire     [4 :0]      RdE          ,
    output wire     [4 :0]      Rs1E         ,
    output wire     [4 :0]      Rs2E         ,
    output wire                 PCSrcE       ,
    output wire     [1:0]       ResultSrcE   ,
    output wire     [4 :0]      RdM          ,
    output wire     [4 :0]      RdW          ,
    output wire                 RegWriteM    ,
    output wire                 RegWriteW    

);

    // Fetch stage signals
    wire    [31:0]     PCTargetE   ;
    wire    [31:0]     PCPlus4D    ;
    //wire    [31:0]     instrD      ;
    wire    [31:0]     PCD         ;

    // Decode stage signals
    wire    [31:0]     ResultW     ;
    wire    [31:0]     RD1E        ;
    wire    [31:0]     RD2E        ;
    wire    [31:0]     PCE         ;
    wire    [31:0]     ExtimmE     ;
    wire    [31:0]     PCPlus4E    ;

    wire               RegWriteE   ;    
    wire               MemWriteE   ; 
    wire    [2 :0]     ALUControlE ; 
    wire               ALUSrcE     ; 
    wire               BranchE     ; 
    wire               JumpE       ; 

    // Execute stage signals
    wire    [31:0]     PCPlus4M    ;
    wire    [1 :0]     ResultSrcM  ;

    // Memory stage signals 
    wire    [31:0]     ALUResultW  ;
    wire    [31:0]     ReadDataW   ;
    wire    [31:0]     PCPlus4W    ;
    wire    [1 :0]     ResultSrcW  ;

fetch_stage U0_fetch (
    .clk            (clk          ) ,
    .rst            (rst          ) ,

    .PCSrcE         (PCSrcE       ) ,
    .StallF         (StallF       ) ,
    .StallD         (StallD       ) ,
    .FlushD         (FlushD       ) ,
    .InstrF         (instrF       ) ,

    .PCTargetE      (PCTargetE    ) ,
    .PCPlus4D       (PCPlus4D     ) ,
    .InstrD         (instrD       ) ,

    .PCF            (PCF          ) ,
    .PCD            (PCD          ) 
);

decode_stage U1_decode (
    .clk            (clk          ) ,
    .rst            (rst          ) ,
      
    .FlushE         (FlushE       ) ,
    .instrD         (instrD       ) ,
    .PCD            (PCD          ) ,
    .PCPlus4D       (PCPlus4D     ) ,
    .RdW            (RdW          ) ,
    .ResultW        (ResultW      ) ,
    .RegWriteW      (RegWriteW    ) ,
    .RD1E           (RD1E         ) ,
    .RD2E           (RD2E         ) ,
    .PCE            (PCE          ) ,
    .Rs1E           (Rs1E         ) ,
    .Rs2E           (Rs2E         ) ,
    .RdE            (RdE          ) ,
    .ExtimmE        (ExtimmE      ) ,
    .PCPlus4E       (PCPlus4E     ) ,

    // control signals
    .RegWriteD      (RegWriteD    ) ,
    .ResultSrcD     (ResultSrcD   ) ,
    .MemWriteD      (MemWriteD    ) ,
    .ALUControlD    (ALUControlD  ) ,
    .ALUSrcD        (ALUSrcD      ) ,
    .ImmSrcD        (ImmSrcD      ) ,
    .BranchD        (BranchD      ) ,
    .JumpD          (JumpD        ) ,

    .RegWriteE      (RegWriteE    ) ,
    .ResultSrcE     (ResultSrcE   ) , 
    .MemWriteE      (MemWriteE    ) ,
    .ALUControlE    (ALUControlE  ) ,
    .ALUSrcE        (ALUSrcE      ) ,
    .BranchE        (BranchE      ) ,
    .JumpE          (JumpE        )
);

execute_stage U2_execute (
    .clk            (clk          ) ,
    .rst            (rst          ) ,
          
    .ForwardAE      (ForwardAE    ) ,
    .ForwardBE      (ForwardBE    ) ,
    .RD1E           (RD1E         ) ,
    .RD2E           (RD2E         ) ,
    .PCE            (PCE          ) ,

    .RdE            (RdE          ) ,
    .ExtimmE        (ExtimmE      ) ,
    .PCPlus4E       (PCPlus4E     ) ,
    .ResultW        (ResultW      ) ,
    .ALUResultM     (ALUResultM   ) ,
    .WriteDataM     (WriteDataM   ) ,
    .RdM            (RdM          ) ,
    .PCPlus4M       (PCPlus4M     ) ,
    .PCTargetE      (PCTargetE    ) ,
    .PCSrcE         (PCSrcE       ) ,

    .RegWriteE      (RegWriteE    ) ,
    .ResultSrcE     (ResultSrcE   ) ,
    .MemWriteE      (MemWriteE    ) ,
    .ALUControlE    (ALUControlE  ) ,
    .ALUSrcE        (ALUSrcE      ) ,
    .BranchE        (BranchE      ) ,
    .JumpE          (JumpE        ) ,
    
    .RegWriteM      (RegWriteM    ) ,
    .ResultSrcM     (ResultSrcM   ) ,
    .MemWriteM      (MemWriteM    ) 
);

memory_stage U3_memory (
    .clk            (clk          ) ,
    .rst            (rst          ) ,
      
    .ALUResultM     (ALUResultM   ) ,
    .WriteDataM     (WriteDataM   ) ,
    .RdM            (RdM          ) ,
    .PCPlus4M       (PCPlus4M     ) ,
    .ReadDataM      (ReadDataM    ) ,
    .ALUResultW     (ALUResultW   ) ,
    .ReadDataW      (ReadDataW    ) ,
    .RdW            (RdW          ) ,
    .PCPlus4W       (PCPlus4W     ) ,

    .RegWriteM      (RegWriteM    ) ,
    .ResultSrcM     (ResultSrcM   ) ,
    .MemWriteM      (MemWriteM    ) ,      
    .RegWriteW      (RegWriteW    ) ,
    .ResultSrcW     (ResultSrcW   ) 
);

WriteBack_stage U4_WriteBack (
    .clk            (clk          ) ,
    .rst            (rst          ) ,
          
    .ALUResultW     (ALUResultW   ) ,
    .ReadDataW      (ReadDataW    ) ,
    .PCPlus4W       (PCPlus4W     ) ,

    //.RegWriteW      (RegWriteW    ) ,
    .ResultSrcW     (ResultSrcW   ) ,
    .ResultW        (ResultW      )
);

endmodule