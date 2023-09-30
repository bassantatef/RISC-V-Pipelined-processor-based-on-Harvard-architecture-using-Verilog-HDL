module hazard_unit 
(
    input  wire     [4:0]      Rs1D         ,
    input  wire     [4:0]      Rs2D         ,
    input  wire     [4:0]      RdE          ,
    input  wire     [4:0]      Rs1E         ,
    input  wire     [4:0]      Rs2E         ,
    input  wire                PCSrcE       ,
    input  wire                ResultSrcE   ,
    input  wire     [4:0]      RdM          ,
    input  wire     [4:0]      RdW          ,
    input  wire                RegWriteM    ,
    input  wire                RegWriteW    ,

    output wire                StallF       ,
    output wire                StallD       ,
    output wire                FlushD       , //done
    output wire                FlushE       , //done
    output reg      [1:0]      ForwardAE    ,
    output reg      [1:0]      ForwardBE    
);

wire lwStall ;

always @(*) 
begin
    if(((Rs1E == RdM) && RegWriteM) && (Rs1E != 0))
    begin
        ForwardAE = 10 ;
    end
    else if(((Rs1E == RdW) && RegWriteW) && (Rs1E != 0))
    begin
        ForwardAE = 01 ;
    end
    else
    begin
        ForwardAE = 00 ;
    end

    if(((Rs2E == RdM) && RegWriteM) && (Rs2E != 0))
    begin
        ForwardBE = 10 ;
    end
    else if(((Rs2E == RdW) && RegWriteW) && (Rs2E != 0))
    begin
        ForwardBE = 01 ;
    end
    else
    begin
        ForwardBE = 00 ;
    end
end


assign lwStall = ((Rs1D == RdE) || (Rs2D == RdE)) && ResultSrcE ;

assign StallF = lwStall ;
assign StallD = lwStall ;

assign FlushD = PCSrcE ;
assign FlushE = lwStall | PCSrcE ;

endmodule