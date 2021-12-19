`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//////////////////////////////////////////////////////////////////////////////////
module ID(clk,Instruction_id, PC_id, RegWrite_wb, rdAddr_wb, RegWriteData_wb, MemRead_ex, 
          rdAddr_ex, MemtoReg_id, RegWrite_id, MemWrite_id, MemRead_id, ALUCode_id, 
			 ALUSrcA_id, ALUSrcB_id,  Stall, Branch, Jump, IFWrite,  JumpAddr, Imm_id,
			 rs1Data_id, rs2Data_id,rs1Addr_id,rs2Addr_id,rdAddr_id);
    input clk;
    input [31:0] Instruction_id;
    input [31:0] PC_id;
    input RegWrite_wb;
    input [4:0] rdAddr_wb;
    input [31:0] RegWriteData_wb;
    input MemRead_ex;
    input [4:0] rdAddr_ex;
    output MemtoReg_id;
    output RegWrite_id;
    output MemWrite_id;
    output MemRead_id;
    output [3:0] ALUCode_id;
    output ALUSrcA_id;
    output [1:0]ALUSrcB_id;
    output Stall;
    output Branch;
    output Jump;
    output IFWrite;
    output [31:0] JumpAddr;
    output [31:0] Imm_id;
    output [31:0] rs1Data_id;
    output [31:0] rs2Data_id;
	output[4:0] rs1Addr_id,rs2Addr_id,rdAddr_id;

    wire [31:0] offset;
 
    // Decode
    Decode Decode1(
        .Instruction(Instruction_id),	// current instruction
        .MemtoReg(MemtoReg_id),		// use memory output as into register
        .RegWrite(RegWrite_id),		// enable writing back to 
        .MemWrite(MemWrite_id),		// write to memory
        .MemRead(MemRead_id),
        .ALUCode(ALUCode_id),         // ALU operation select
        .ALUSrcA(ALUSrcA_id),
        .ALUSrcB(ALUSrcB_id),
        .Jump(JUMP),
        .JALR(JALR),
        .Imm(Imm_id),
        .offset(offset)
    );


    // Registers 
    Registers Registers1(
        .ReadRegister1(rs1Addr_id),
        .ReadRegister2(rs2Addr_id),
        .WriteData(RegWriteDate_wb),    // 待写入数据
        .WriteRegister(edAddr_wb),   //目标寄存器号
        .clk(clk),
        .RegWrite(RegWrite_wb),     // 写允许信号
        .ReadData1(rs1Data_id),
        .ReadDate2(rs2Data_id)
    ); 

    // Hazard Detector
    assign Stall = ((reAddr_ex == rs1Addr_id)||(rdAddr_ex == rs2Addr_id))&&MemRead_ex;
    assign IFWrite = ~Stall;

    // BranchTest 
    BranchTest BranchTest1(
        .Instruction(Instruction_id), 
        .rs1Data(rs1Data_id), 
        .rs2Data(rs2Data_id), 
        .Branch(Branch)
    );

    wire JALR;
    wire [31:0] JALR_Addr;
    // 二路选择器
    mux_2to1 mux1(
        .addr(JALR),
        .in0(PC_id),
        .in1(rs1Data_id);
        .out(JALR_Addr)
    );

endmodule
