module control_unit 
(
    input  wire    [6:0]      opcode     ,
    input  wire    [2:0]      funct3     ,
    input  wire               funct7     ,
    //input  wire               zero       ,

    //output wire               PCSrc      ,
    output wire               RegWrite   ,
    output wire    [1:0]      ResultSrc  ,
    output wire               MemWrite   ,
    output wire               Jump       ,
    output wire               Branch     ,
    output wire    [2:0]      ALUControl ,
    output wire               ALUSrc     ,
    output wire    [1:0]      ImmSrc     
    
);

    wire           [1:0]      ALUOp      ;

//assign PCSrc = (zero & Branch) | Jump    ;

main_decoder U0_main_decoder (
    .opcode     (opcode     ) ,
 
    .ResultSrc  (ResultSrc  ) ,
    .MemWrite   (MemWrite   ) ,
    .ALUSrc     (ALUSrc     ) ,
    .ALUOp      (ALUOp      ) ,
    .ImmSrc     (ImmSrc     ) ,
    .RegWrite   (RegWrite   ) ,
    .Branch     (Branch     ) ,
    .Jump       (Jump       )
);

ALU_decoder U1_ALU_decoder (
    .op5        (opcode[5]  ) ,
    .ALUOp      (ALUOp      ) ,
    .funct3     (funct3     ) ,
    .funct7     (funct7     ) ,
      
    .ALUControl (ALUControl )
);


endmodule