
/*Test bench for pipeline reset
arbitrer*/
module pipeline_reset_tb #(parameter W = 31,ROB = 32, I = 7) 
    (

    );
    
    //Inputs
    logic[$clog2(ROB):0] jalr_rob,branch_rob,read_ptr;
    logic is_jalr,is_branch;
    logic clk,reset;
    logic[I:0] branch_ghr_checkpoint,jalr_ghr_checkpoint;
    logic[W:0] jalr_address,branch_address;
    logic misprediction;
    logic taken_branch;
    
    //Outputs
    logic[W:0] reset_addr;
    logic[I:0] ghr_recovered;
    logic reset_pipeline;
    logic conditional_taken;
    logic update_ghr;
    
    always begin
        #5; clk = ~clk;
    end
    
    
    pipeline_reset_arbitrer arbitrer(.*);
    
    /*Function to determine relative ages of entloades in a circular
     buffer with a defined head*/
     function automatic int relative_age(input logic[$clog2(ROB):0] head,
        input logic[$clog2(ROB):0] rob1, input logic[$clog2(ROB):0]rob2);
        if(rob1 == rob2) begin
            return 1;
        end
        else begin
            if(rob1[$clog2(ROB)] == head[$clog2(ROB)])begin
                if((rob2[$clog2(ROB)] != rob1[$clog2(ROB)]) || (rob2[$clog2(ROB)] == rob1[$clog2(ROB)]) 
                         & (rob2[$clog2(ROB)-1:0] > rob1[$clog2(ROB) - 1:0]))begin
                            return 2;
                end
            end
            else begin
                if((rob2[$clog2(ROB)] == rob1[$clog2(ROB)]) && 
                        (rob2[$clog2(ROB)-1:0] > rob1[$clog2(ROB) - 1:0]))begin
                            return 2;
                end
            end
        end    
        return 0;
    endfunction
    
    
    /*Randomize the inputs subject to 
    constraints*/
    class Rand_Inputs;
        static rand logic[$clog2(ROB):0] read_ptr;
        rand logic[$clog2(ROB):0] jalr_rob;
        rand logic[$clog2(ROB):0] branch_rob;
        rand logic is_jalr,is_branch;
        rand logic[I:0] branch_ghr_checkpoint,jalr_ghr_checkpoint;
        rand logic[W:0] jalr_address,branch_address;
        rand logic misprediction;
        rand logic taken_branch;
        
        /*constraints on the ages of rob entries*/
        constraint correct_ages{
            
            relative_age(read_ptr,read_ptr,jalr_rob) == 2;
            
            relative_age(read_ptr,read_ptr,branch_rob) == 2;
            
            relative_age(read_ptr,branch_rob,jalr_rob != 0);    
        }   
    endclass
    
    logic[$clog2(ROB):0] reset_rob;
    logic was_reset;
    
    initial begin
        was_reset = '0;
    end
    
    task automatic run_arbitrer();
        Rand_Inputs inputs1;
        Rand_Inputs inputs2;
        logic branch_older;
        logic jalr_older;
        inputs1 = new();
        inputs2 = new();
        read_ptr = inputs1.read_ptr;
        jalr_rob = inputs1.jalr_rob;
        branch_rob = inputs1.branch_rob;
        is_jalr = inputs1.is_jalr;
        is_branch = inputs1.is_branch;
        branch_ghr_checkpoint = inputs1.branch_ghr_checkpoint;
        jalr_ghr_checkpoint = inputs1.jalr_ghr_checkpoint;
        jalr_address = inputs1.jalr_address;
        branch_address = inputs1.branch_address;
        misprediction = inputs1.misprediction;
        taken_branch = inputs1.taken_branch;
        reset = '0;
        #2;
        
        /*Branch can only reset pipeline
        if current jalr instruction is younger*/
        if(is_branch)begin
            if(is_jalr)begin
                /*If jalr instruction is older, reset is by jalr instruction*/
                if(relative_age(read_ptr,jalr_rob,branch_rob) == 2)begin
                    reset_rob = jalr_rob;
                    was_reset = '1;
                    #8;
                    assert(reset_addr == jalr_address) 
                    else $display("older jalr instruction losing pipeline reset war");
                    assert(ghr_recovered == jalr_ghr_checkpoint) 
                    else $display("older jalr instruction not sending out its ghr in reset war");
                    assert(reset_pipeline == '1)
                    else $display("older jalr instruction not resetting pipeline");
                    assert(update_ghr == '1)
                    else $display("If a branch instruction is there default is to send update to ghr"); 
                end
                
                /*Branch instruction is older but if it doesn't
                reset then jalr instruction may do so instead*/
                else begin
                    reset_rob = (misprediction & is_branch) ? branch_rob : jalr_rob;
                    was_reset = (misprediction & is_branch) | is_jalr;
                    #8;
                    if(misprediction & is_branch) begin
                        assert(reset_addr == branch_address) 
                        else $display("older branch instruction losing pipeline reset war");
                        assert(ghr_recovered == branch_ghr_checkpoint) 
                        else $display("older branch instruction not sending out its ghr in reset war");
                        assert(reset_pipeline == '1)
                        else $display("older branch instruction not resetting pipeline/inappropriately setting it");
                        assert(update_ghr == '1)
                        else $display("branch instruction isn't updating ghr");
                        assert(conditional_taken == taken_branch)
                        else $display("Default output");
                    end
                    
                    else begin
                        assert(reset_addr == jalr_address) 
                        else $display("jalr instruction address is default if branch gives up its spot");
                        assert(ghr_recovered == jalr_ghr_checkpoint) 
                        else $display("jalr ghr checkpoint is default if branch gives up its spot");
                        assert(reset_pipeline == is_jalr)
                        else $display("jalr instruction should reset pipeline if branch gives up its spot");
                        assert(update_ghr == '1)
                        else $display("Branch instruction updates ghr even if it gives up its spot");
                        assert(conditional_taken == taken_branch)
                        else $display("Default output");  
                    end   
                end      
            end
            
            /*No jalr instruction*/
            else begin
                reset_rob = branch_rob;
                was_reset = (misprediction);
                #8;
                assert(reset_addr == branch_address) 
                else $display("branch instruction not sending out address");
                assert(ghr_recovered == branch_ghr_checkpoint) 
                else $display("branch instruction not sending out its ghr");
                assert(reset_pipeline == misprediction)
                else $display("branch instruction not resetting pipeline/inappropriately setting it");
                assert(update_ghr == '1)
                else $display("branch instruction isn't updating ghr");
                assert(conditional_taken == taken_branch)
                else $display("Incorrect ghr update");  
            end
        end
        
        /*No branch instruction*/
        else begin
            if(is_jalr)begin
                reset_rob = jalr_rob;
                was_reset = '1;
                #8;
                assert(reset_addr == jalr_address) 
                else $display("jalr instruction not sending out its address");
                assert(ghr_recovered == jalr_ghr_checkpoint) 
                else $display("jalr instruction not sending out its ghr");
                assert(reset_pipeline == '1)
                else $display("jalr instruction not resetting pipeline");
                assert(update_ghr == '0)
                else $display("jalr instruction shouldn't update ghr if no branch instruction exist");        
            end
            else begin
                /*No jalr, no branch instruction*/
                reset_rob = jalr_rob;
                was_reset = '0;
                #8;
                assert(reset_addr == jalr_address) 
                else $display("Default isn't jalr's address");
                assert(ghr_recovered == jalr_ghr_checkpoint) 
                else $display("Default isn't jalr ghr checkpoint");
                assert(reset_pipeline == '0)
                else $display("No reset should be possible");
                assert(update_ghr == '0)
                else $display("No update on ghr should be possible");
            end
        end
        
        /*Second iteration where we check to see if previous
        older pipeline resets are respected*/
        jalr_rob = inputs2.jalr_rob;
        branch_rob = inputs2.branch_rob;
        is_jalr = inputs2.is_jalr;
        is_branch = inputs2.is_branch;
        branch_ghr_checkpoint = inputs2.branch_ghr_checkpoint;
        jalr_ghr_checkpoint = inputs2.jalr_ghr_checkpoint;
        jalr_address = inputs2.jalr_address;
        branch_address = inputs2.branch_address;
        misprediction = inputs2.misprediction;
        taken_branch = inputs2.taken_branch;
        
        #2;
        jalr_older = is_jalr & relative_age(read_ptr,jalr_rob,reset_rob) == 2;
        branch_older = is_branch & relative_age(read_ptr, branch_rob, reset_rob) == 2;
        
        if(!jalr_older & !branch_older & was_reset)begin
            #8;
            assert(reset_addr == jalr_address) 
            else $display("If none older, reset address is jalr's");
            assert(ghr_recovered == jalr_ghr_checkpoint) 
            else $display("If none older, reset checkpoint is jalr's");
            assert(update_ghr == '0)
            else $display("If none older no ghr update"); 
            assert(reset_pipeline == '0)
            else $display("If none are older they cannot reset the pipeline");  
        end
        
        else if(!jalr_older & branch_older & was_reset)begin
            #8;
            assert(reset_addr == branch_address) 
            else $display("If branch older, reset address is branch's");
            assert(ghr_recovered == branch_ghr_checkpoint) 
            else $display("If branch older, reset checkpoint is branch's");
            assert(reset_pipeline == misprediction)
            else $display("If branch older, reset only on misprediction");
            assert(update_ghr == '1)
            else $display("If branch older send ghr update");
        end
        
        else if(jalr_older & !branch_older & was_reset)begin
            #8;
            assert(reset_addr == jalr_address) 
            else $display("If jalr older, reset address is jalr's");
            assert(ghr_recovered == jalr_ghr_checkpoint) 
            else $display("If jalr older, reset checkpoint is jalr's");
            assert(reset_pipeline == '1)
            else $display("If jalr older, reset should be signalled");
            assert(update_ghr == '0)
            else $display("If jalr older no ghr update");
        end
        
        else if(jalr_older & branch_older & was_reset)begin
            #8;
            //Jalr is older
            if(relative_age(read_ptr,jalr_rob,branch_rob) == 2)begin
                assert(reset_addr == jalr_address) 
                else $display("If jalr older than all, reset address is jalr's");
                assert(ghr_recovered == jalr_ghr_checkpoint) 
                else $display("If jalr older than all, reset checkpoint is jalr's");
                assert(reset_pipeline == '1)
                else $display("If jalr older than all, reset should be signalled");
                assert(update_ghr == is_branch)
                else $display("If jall is older than all ghr update depends on branch's presence");    
            end
            
            //Branch is older
            else begin
                assert(reset_addr == branch_address) 
                else $display("If branch older than all, reset address is branch's");
                assert(ghr_recovered == branch_ghr_checkpoint) 
                else $display("If branch older than all, reset checkpoint is branch's");
                assert(reset_pipeline == misprediction)
                else $display("If branch older than all, reset only on misprediction");
                assert(update_ghr == '1)
                else $display("If branch older than all send ghr update");       
            end
        end
        
        /*No previous reset*/
        else if(!was_reset)begin
            #8;
            //If jalr is older
            if((relative_age(read_ptr,jalr_rob,branch_rob) == 2) & is_jalr)begin
                assert(reset_addr == jalr_address) 
                else $display("Jalr oldest in absence of prev reset, so reset address is jalr's");
                assert(ghr_recovered == jalr_ghr_checkpoint) 
                else $display("Jalr oldest in absence of prev reset, so reset ghr is jalr's");
                assert(reset_pipeline == '1)
                else $display("Jalr oldest in absence of prev reset, so reset possible if jalr exists");;
                assert(update_ghr == is_branch)
                else $display("If branch exists updates to ghr should happen");    
            end
            //If branch is older
            else begin
                if(is_branch & misprediction)begin
                    assert(reset_addr == branch_address) 
                    else $display("Branch oldest in absence of prev reset, so reset address is branch's");
                    assert(ghr_recovered == branch_ghr_checkpoint) 
                    else $display("Branch oldest in absence of prev reset, so reset ghr is branch's");
                    assert(reset_pipeline == '1)
                    else $display("Branch oldest in absence of prev reset, so reset possible for mispredictions");;
                    assert(update_ghr == '1)
                    else $display("If branch exists updates to ghr should happen");
                end
               
                else begin
                    assert(reset_addr == jalr_address) 
                    else $display("Branch gives up reset position, so reset address is jalr's");
                    assert(ghr_recovered == jalr_ghr_checkpoint) 
                    else $display("Branch gives up reset position, so reset checkpoint is jalr's");
                    assert(reset_pipeline == is_jalr)
                    else $display("Branch gives up reset position, so reset if jalr's exists");;
                    assert(update_ghr == is_branch)
                    else $display("If branch exists updates to ghr should happen");
                end
            end
        end
        
        //Clear out entries
        reset = '1;
        was_reset = '0;
        reset_rob = '0;
        #10;       
    endtask
    
    initial begin
        #100;
        clk = '1;
        while($time < 1000000)begin
            run_arbitrer();
        end
    end
     
endmodule
