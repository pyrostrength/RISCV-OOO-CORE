/*Package fo functions to be
used in design*/

package functions;
    localparam ROB = 32;
    /*
    Function determines relative age 
    between two rob entries. With head of buffer as
    "head" function returns relative age between
    rob1 and rob2. If same age 1 is returned. If
    rob1 is older then 2 is returned. If rob1 is younger
    then 0 is returned
    */
    function automatic int relative_age(input logic[$clog2(ROB):0] head,
        input logic[$clog2(ROB):0] rob1, input logic[$clog2(ROB):0]rob2);
        int age; 
        if(rob1 == rob2) begin
            age = 1;
        end
        else begin
            if(rob1[$clog2(ROB)] == head[$clog2(ROB)])begin
                if(rob1[$clog2(ROB)] == rob2[$clog2(ROB)])begin
                    //Rob1 is older
                    if(rob2 > rob1)begin
                        age = 2;
                    end
                    //Rob1 is younger
                    else begin
                        age = 0;
                    end
                end
                else begin
                    //Rob1 is older
                    age = 2;
                end
            end
            else begin
                if(rob1[$clog2(ROB)] == rob2[$clog2(ROB)])begin
                    //Rob1 is older
                    if(rob2 > rob1)begin
                        age = 2; 
                    end
                    
                    else begin
                        age = 0;
                    end
                end
                else begin
                    //Rob2 is older
                    age = 0;
                end
            end
        end
        return age;
    endfunction
endpackage
