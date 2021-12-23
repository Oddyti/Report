module BranchTest (
    Instruction,
    rs1Data,
    rs2Data,
    Branch
);
    input [31:0] Instruction, rs1Data, rs2Data;
    output Branch;

    wire [31:0] sum;
    adder_32bits adder(
        .a(rs1Data),
        .b(~rs2Data),
        .ci(1'b1),
        .co(),
        .s(sum)
    );

    wire isLT, isLTU;
    assign isLT=rs1Data[31]&&(~rs2Data[31]) || (rs1Data[31]~^rs2Data[31])&& sum[31]; 
    assign isLTU= (~rs1Data[31] )&& rs2Data[31] || (rs1Data[31]~^rs2Data[31]) && sum[31];

    wire SB_type;
    wire [6:0] op;
    wire [2:0] funct3;
    reg Branch;

    parameter SB_type_op=  7'b1100011;
    parameter beq_funct3 = 3'o0;
    parameter bne_funct3 = 3'o1;
    parameter blt_funct3 = 3'o4;
    parameter bge_funct3 = 3'o5;
    parameter bltu_funct3 = 3'o6;
    parameter bgeu_funct3 = 3'o7;

    assign op = Instruction[6:0];
    assign funct3 = Instruction[14:12];
    assign SB_type = (op == SB_type_op);


    always@(*) begin
        if(SB_type) begin
            case(funct3)
                beq_funct3: Branch = ~(|sum[31:0]);
                bne_funct3: Branch = |sum[31:0];
                blt_funct3: Branch = isLT;
                bge_funct3: Branch = ~isLT;
                bltu_funct3: Branch = isLTU;
                bgeu_funct3: Branch = ~isLTU;
                default: Branch = 0;
            endcase
        end
        else Branch = 0;
    end
endmodule