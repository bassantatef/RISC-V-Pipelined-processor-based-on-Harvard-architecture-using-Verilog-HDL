module Register #(parameter WIDTH = 32)
(
    input wire               clk    ,
    input wire               rst    ,
    input wire               En     ,
    input wire  [WIDTH-1:0]  in     ,

    output reg  [WIDTH-1:0]  out
);

always @(posedge clk)
begin
    if(rst)
    begin
        out <= {WIDTH{1'b0}} ;
    end
    else if(En)
    begin
        out <= in ;
    end
end

endmodule