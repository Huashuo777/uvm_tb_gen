//----------------------------------------------------------------------------------
// This code is copyrighted by BrentWang and cannot be used for commercial purposes
// The github address:https://github.com/brentwang-lab/uvm_tb_gen                   
// You can refer to the book <UVM Experiment Guide> for learning, this is on this github
// If you have any questions, please contact email:brent_wang@foxmail.com          
//----------------------------------------------------------------------------------
//                                                                                  
// Author  : BrentWang                                                              
// Project : UVM study                                                              
// Date    : Sat Jan 26 06:05:52 WAT 2022                                           
//----------------------------------------------------------------------------------
//                                                                                  
// Description:                                                                     
//     File for dadd_sequence.sv                                                       
//----------------------------------------------------------------------------------
class dadd_rand_sequence extends uvm_sequence;
    `uvm_object_utils(dadd_rand_sequence)
    `uvm_declare_p_sequencer(dadd_sequencer)
    dadd_item item;

    rand bit data_en_rand;

    function new(string name = "dadd_rand_sequence");
        super.new(name);
    endfunction : new
    `ifdef SEND_SEQ
    task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
        repeat(20) 
        begin
            `uvm_do_on_with(item,p_sequencer,{
                item.data_en==  data_en_rand;
            })
        end
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask : body
    `else //SEND_ITEM
    `ifdef START_ITEM
    task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
        repeat(20) 
        begin
            item = new("item");
            start_item(item);
            item.randomize();
            finish_item(item);
        end

        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask : body
    `elsif UVM_CREATE
    task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
        repeat(20) 
        begin
            `uvm_create(item);
            item.randomize();
            `uvm_send(item);
        end
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask : body
    `else//UVM_DO
    task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
        repeat(20) 
        begin
            `uvm_do(item)
        end
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask : body
    `endif
    `endif
endclass : dadd_rand_sequence

class dadd_fixen_sequence extends uvm_sequence;
    `uvm_object_utils(dadd_fixen_sequence)
    `uvm_declare_p_sequencer(dadd_sequencer)
    dadd_rand_sequence seq;
    function new(string name = "dadd_fixen_sequence");
        super.new(name);
    endfunction : new
    

        `ifdef SEND_SEQ
        `ifdef START
        task body();
            if(starting_phase != null)
                starting_phase.raise_objection(this);

            seq = dadd_rand_sequence :: type_id ::create("seq");
            seq.randomize() with {data_en_rand == 1;};

            seq.start(p_sequencer);

            if(starting_phase != null)
                starting_phase.drop_objection(this);
        endtask : body
        `elsif UVM_CREATE
        task body();
            if(starting_phase != null)
                starting_phase.raise_objection(this);

            `uvm_create(seq)
            seq.randomize() with {data_en_rand == 1;};
            `uvm_send(seq)

            if(starting_phase != null)
                starting_phase.drop_objection(this);
        endtask : body
        `else//UVM_DO
        task body();
            if(starting_phase != null)
                starting_phase.raise_objection(this);

            `uvm_do_with(seq,{data_en_rand == 1;})

            if(starting_phase != null)
                starting_phase.drop_objection(this);
        endtask : body
            
        `endif
        `endif
endclass : dadd_fixen_sequence

class dadd_addr_5a5a_sequence extends uvm_sequence;
    `uvm_object_utils(dadd_addr_5a5a_sequence)
    `uvm_declare_p_sequencer(dadd_sequencer)
    dadd_item item;

    function new(string name = "dadd_addr_5a5a_sequence");
        super.new(name);
    endfunction : new
    task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
        repeat(5) 
        begin
            `uvm_do_with(item,{
                item.addr == 32'h5a5a; 
            })
        end
        `ifdef SQR_LOCK
        lock();
        $display("%t,dadd_addr_5a5a_sequence,lock!!!",$time);
        `endif //SQR_LOCK
        `ifdef SQR_GRAB
        grab();
        $display("%t,dadd_addr_5a5a_sequence,grab!!!",$time);
        `endif //SQR_GRAB
        repeat(20) 
        begin
            `uvm_do_with(item,{
                item.addr == 32'h5a5a; 
            })
        end
        `ifdef SQR_LOCK
        unlock();
        $display("%t,dadd_addr_5a5a_sequence,unlock!!!",$time);
        `endif //SQR_LOCK
        `ifdef SQR_GRAB
        ungrab();
        $display("%t,dadd_addr_5a5a_sequence,ungrab!!!",$time);
        `endif //SQR_GRAB
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask : body

endclass : dadd_addr_5a5a_sequence

class dadd_addr_a5a5_sequence extends uvm_sequence;
    `uvm_object_utils(dadd_addr_a5a5_sequence)
    `uvm_declare_p_sequencer(dadd_sequencer)
    dadd_item item;

    function new(string name = "dadd_addr_a5a5_sequence");
        super.new(name);
    endfunction : new
    task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
        repeat(20) 
        begin
            `uvm_do_with(item,{
                item.addr == 32'ha5a5; 
            })
        end
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask : body

endclass : dadd_addr_a5a5_sequence

class dadd_virtual_sequence extends uvm_sequence;
    `uvm_object_utils(dadd_virtual_sequence)
    `uvm_declare_p_sequencer(dadd_virtual_sequencer)

    dadd_rand_sequence seq;

    function new(string name = "dadd_virtual_sequence");
        super.new(name);
    endfunction : new
    task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
        seq = dadd_rand_sequence :: type_id :: create("seq");
        seq.start(p_sequencer.sqr);
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask : body
endclass : dadd_virtual_sequence

class dadd_layer_cfg_sequence extends uvm_sequence;
    `uvm_object_utils(dadd_layer_cfg_sequence)
    `uvm_declare_p_sequencer(cfg_sequencer)
    cfg_item item;

    function new(string name = "dadd_layer_cfg_sequence");
        super.new(name);
    endfunction : new
    task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
        `uvm_create(item);  
        item.randomize();
        $display("cfg info is %h",item.cfg_info);
        p_sequencer.ap.write(item);
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask : body

endclass : dadd_layer_cfg_sequence


class dadd_layer_data_sequence extends uvm_sequence;
    `uvm_object_utils(dadd_layer_data_sequence)
    `uvm_declare_p_sequencer(dadd_sequencer)
    dadd_item data_item;
    cfg_item cfg_item;

    function new(string name = "dadd_layer_data_sequence");
        super.new(name);
    endfunction : new
    task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
        wait(p_sequencer.cfg_que.size() != 0);
        cfg_item = p_sequencer.cfg_que.pop_front();
        if(cfg_item.cfg_info == 32'h5a5a)
        begin
            repeat(5)
            begin
                `uvm_do_with(data_item,{
                    data_item.addr == 32'h5a5a; 
                    data_item.data_en == 1'b1;
                })
            end
        end
        else if(cfg_item.cfg_info == 32'ha5a5)
        begin
            repeat(5)
            begin
                `uvm_do_with(data_item,{
                    data_item.addr == 32'ha5a5; 
                    data_item.data_en == 1'b1;
                })
            end
        end
        else 
        begin
            repeat(5)
            begin
                `uvm_do_with(data_item,{
                    data_item.data_en == 1'b1;
                })
            end
        end

        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask : body

endclass : dadd_layer_data_sequence

class dadd_layer_virtual_sequence extends uvm_sequence;
    `uvm_object_utils(dadd_layer_virtual_sequence)
    `uvm_declare_p_sequencer(dadd_layer_virtual_sequencer)

    dadd_layer_data_sequence data_seq;
    dadd_layer_cfg_sequence cfg_seq;

    function new(string name = "dadd_layer_virtual_sequence");
        super.new(name);
    endfunction : new
    task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
        data_seq = dadd_layer_data_sequence :: type_id :: create("data_seq");
        cfg_seq = dadd_layer_cfg_sequence :: type_id :: create("cfg_seq");
        repeat(10)
        begin
            cfg_seq.start(p_sequencer.cfg_sqr);
            data_seq.start(p_sequencer.data_sqr);
        end
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask : body
endclass : dadd_layer_virtual_sequence
