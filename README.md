#-RISC-V-Pipelined-processor-based-on-Harvard-architecture-using-Verilog-HDL

The pipelined processor is designed by subdividing the single-cycle processor into five pipeline stages. 
Thus, five instructions can execute simultaneously, one in each stage. Because each stage has only one-fifth of the entire logic, the clock frequency is approximately five times faster. 
So, ideally, the latency of each instruction is unchanged, but the throughput is five times better.

It contains the hazard unit to handle the data hazards and control hazards by:
- Forwarding
- Stalling
- Flushing

__The five stages:__
- Fetch
- Decode
- Execute
- Memory
- Writeback.

![image](https://github.com/bassantatef/4.-RISC-V-Pipelined-processor-based-on-Harvard-architecture-using-Verilog-HDL/assets/82764830/e6028be0-dc4b-40f5-a1a0-fd55f2ee01ad)
