module song_reader_controller (
    clk, 
    reset, 
    play, 
    note_done, 
    new_note
);
    input clk, reset, play, note_done;
    output reg new_note;
    parameter RESET = 0, NEW_NOTE = 1, WAIT = 2, NEXT_NOTE = 3;
    reg [1:0] state, nextstate;

    //状态寄存器
    always @(posedge clk ) begin
        if(reset) state = RESET;
        else state = nextstate;
    end

    //下一状态和输出
    always @(*) begin
        new_note = 0;
        case(state)
            RESET:
                begin
                    if(play) nextstate = NEW_NOTE;
                    else nextstate = RESET;
                end
            NEW_NOTE:
                begin
                   new_note = 1;
                   nextstate = WAIT; 
                end
            WAIT:
                begin
                    if(play) 
                        begin
                            if(note_done) nextstate = NEXT_NOTE;
                            else nextstate = WAIT;
                        end
                    else nextstate = RESET;
                end
            NEXT_NOTE:
                begin
                    nextstate = NEW_NOTE;
                end
            default: nextstate = RESET;
        endcase
    end
endmodule