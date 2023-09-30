module RISCV_pipelined_top (
    input wire                  clk,
    input wire                  rst
);

    // instruction memory 
    wire     [31:0]      instrF       ; // RD from instr_mem
    wire     [31:0]      PCF          ; // Address to instr_mem

    // control unit
    wire                 RegWriteD    ;
    wire     [1 :0]      ResultSrcD   ;
    wire                 MemWriteD    ;
    wire                 JumpD        ;
    wire                 BranchD      ;
    wire     [2 :0]      ALUControlD  ;
    wire                 ALUSrcD      ;
    wire     [1 :0]      ImmSrcD      ;

    wire     [31:0]      instrD       ; // inputs to control unit

    // data memory
    wire     [31:0]      ReadDataM    ; // RD from data_mem
    wire     [31:0]      ALUResultM   ; // Address to data_mem
    wire     [31:0]      WriteDataM   ; // WD of data_mem
    wire                 MemWriteM    ; // WE of data_mem

    // hazard unit
    wire                 StallF       ;
    wire                 StallD       ;
    wire                 FlushD       ; 
    wire                 FlushE       ; 
    wire     [1:0]       ForwardAE    ;
    wire     [1:0]       ForwardBE    ;

    wire     [4 :0]      Rs1D         ;
    wire     [4 :0]      Rs2D         ;
    wire     [4 :0]      RdE          ;
    wire     [4 :0]      Rs1E         ;
    wire     [4 :0]      Rs2E         ;
    wire                 PCSrcE       ;
    wire     [1:0]       ResultSrcE   ;
    wire     [4 :0]      RdM          ;
    wire     [4 :0]      RdW          ;
    wire                 RegWriteM    ;
    wire                 RegWriteW    ;


Datapath U_datapath (
    .clk          (clk          ) ,
    .rst          (rst          ) ,

    // instruction memory 
    .instrF       (instrF       ) ,
    .ReadDataM    (ReadDataM    ) ,
    .PCF          (PCF          ) ,  

    // control unit
    .RegWriteD    (RegWriteD    ) ,
    .ResultSrcD   (ResultSrcD   ) ,
    .MemWriteD    (MemWriteD    ) ,
    .JumpD        (JumpD        ) ,
    .BranchD      (BranchD      ) ,
    .ALUControlD  (ALUControlD  ) ,
    .ALUSrcD      (ALUSrcD      ) ,
    .ImmSrcD      (ImmSrcD      ) ,
    .instrD       (instrD       ) ,

    // data memory
    .ALUResultM   (ALUResultM   ) ,
    .WriteDataM   (WriteDataM   ) ,  
    .MemWriteM    (MemWriteM    ) ,

    // hazard unit
    .StallF       (StallF       ) ,
    .StallD       (StallD       ) ,
    .FlushD       (FlushD       ) ,
    .FlushE       (FlushE       ) ,
    .ForwardAE    (ForwardAE    ) ,
    .ForwardBE    (ForwardBE    ) ,
     
    //.Rs1D         (Rs1D         ) ,
    //.Rs2D         (Rs2D         ) ,
    .RdE          (RdE          ) ,
    .Rs1E         (Rs1E         ) ,
    .Rs2E         (Rs2E         ) ,
    .PCSrcE       (PCSrcE       ) ,
    .ResultSrcE   (ResultSrcE   ) ,
    .RdM          (RdM          ) ,
    .RdW          (RdW          ) ,
    .RegWriteM    (RegWriteM    ) ,
    .RegWriteW    (RegWriteW    ) 
);

instr_memory U1_instr_mem (
    .address      (PCF          ) ,
    .instr        (instrF       )
);

data_memory U2_data_mem (
    .clk          (clk          ) ,
    .rst          (rst          ) ,
    .WE           (MemWriteM    ) ,
    .address      (ALUResultM   ) ,
    .WD           (WriteDataM   ) ,
    .RD           (ReadDataM    ) 
);

control_unit U3_control_unit (
    .opcode       (instrD[6:0]  ) ,
    .funct3       (instrD[14:12]) ,
    .funct7       (instrD[30]   ) ,
    
    .RegWrite     (RegWriteD    ) ,
    .ResultSrc    (ResultSrcD   ) ,
    .MemWrite     (MemWriteD    ) ,
    .Jump         (JumpD        ) ,
    .Branch       (BranchD      ) ,
    .ALUControl   (ALUControlD  ) ,
    .ALUSrc       (ALUSrcD      ) ,
    .ImmSrc       (ImmSrcD      ) 
);

hazard_unit U4_hazard_unit (
    .Rs1D         (instrD[19:15]) ,
    .Rs2D         (instrD[24:20]) ,
    .RdE          (RdE          ) ,
    .Rs1E         (Rs1E         ) ,
    .Rs2E         (Rs2E         ) ,
    .PCSrcE       (PCSrcE       ) ,
    .ResultSrcE   (ResultSrcE[1]) ,
    .RdM          (RdM          ) ,
    .RdW          (RdW          ) ,
    .RegWriteM    (RegWriteM    ) ,
    .RegWriteW    (RegWriteW    ) ,
     
    .StallF       (StallF       ) ,
    .StallD       (StallD       ) ,
    .FlushD       (FlushD       ) ,
    .FlushE       (FlushE       ) ,
    .ForwardAE    (ForwardAE    ) ,
    .ForwardBE    (ForwardBE    ) 
);
endmodule