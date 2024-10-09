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
//     File for tb_dadd.sv                                                       
//----------------------------------------------------------------------------------
`ifndef TB_DADD__SV
`define TB_DADD__SV
 interface dadd_interface
 (
     input logic clk,
     input logic reset_n
  );
    logic         dadd_in_en  ; 
    logic [31:0]  dadd_in_addr; 
    logic [31:0]  dadd_in; 
    logic [31:0]  dadd_out_addr;    
    logic [31:0]  dadd_out;    
    logic         dadd_out_en;  
    // master mode
    clocking mcb @ (posedge clk);
        output dadd_in_en;
        output dadd_in;
        output dadd_in_addr;
        input  dadd_out;
        input  dadd_out_addr;
        input  dadd_out_en;
    endclocking: mcb
    // passive mode
    clocking pcb @ (posedge clk);
        input dadd_in_en;
        input dadd_in;
        input dadd_in_addr;
        input dadd_out;
        input dadd_out_addr;
        input dadd_out_en;
    endclocking: pcb

 endinterface: dadd_interface

module tb_dadd;
    real  clk_period = 10;
    logic clk;
    logic reset_n;

    dadd_interface dadd_if(clk,reset_n);

    initial
        $timeformat(-9, 2,"ns", 10);

    initial
    begin
        clk = 1'b0;
        wait(clk_period > 0);
        forever
            clk = #(clk_period/2.0) ~ clk;
    end

    initial
    begin
        reset_n = 0;
        #10ns;
        reset_n = 1;
    end

    initial begin
        $vcdplusautoflushon;
        $vcdpluson();
    end

    dadd dadd_inst
    (
        .clk       (dadd_if.clk),
        .rst_n     (dadd_if.reset_n),
        .dadd_in_en    (dadd_if.dadd_in_en ),
        .dadd_in_addr  (dadd_if.dadd_in_addr),
        .dadd_in       (dadd_if.dadd_in),
        .dadd_out      (dadd_if.dadd_out   ),
        .dadd_out_addr (dadd_if.dadd_out_addr),
        .dadd_out_en   (dadd_if.dadd_out_en)
    );

    test my_test(dadd_if);

endmodule: tb_dadd


program test(dadd_interface inf);
    mailbox driver_to_checker = new();
    mailbox monitor_to_checker = new();

    class item;
        rand bit        en;
        rand bit [31:0] data;
        rand bit [31:0] addr;
    endclass : item

    class driver;
        virtual dadd_interface vif;
        function new(virtual dadd_interface vif);
            this.vif = vif;
        endfunction : new

        task reset_signal();
            vif.dadd_in_en      <= 0 ;
            vif.dadd_in_addr    <= 0 ;
            vif.dadd_in         <= 0 ;
        endtask : reset_signal

        task driver_bus();
            item driver_itm;
            item checker_itm;
            driver_itm = new();
            repeat(100)
            begin
                @(vif.mcb);
                driver_itm.randomize();
                if(driver_itm.en)
                begin
                    vif.mcb.dadd_in_en  <=  driver_itm.en;
                    vif.mcb.dadd_in_addr<=  driver_itm.addr;
                    vif.mcb.dadd_in     <=  driver_itm.data;
                    checker_itm= new driver_itm;
                    driver_to_checker.put(checker_itm);
                end
                else
                begin
                    vif.mcb.dadd_in_en  <=  0;
                    vif.mcb.dadd_in_addr<=  0;
                    vif.mcb.dadd_in     <=  0;
                end
            end
        endtask : driver_bus
    endclass : driver

    class monitor;
        virtual dadd_interface vif;
        function new(virtual dadd_interface vif);
            this.vif = vif;
        endfunction : new

        task monitor_bus();
            item monitor_itm;
            while(1)
            begin
                @(vif.pcb);
                if(vif.pcb.dadd_out_en)
                begin
                    monitor_itm = new();
                    monitor_itm.addr = vif.pcb.dadd_out_addr;
                    monitor_itm.data = vif.pcb.dadd_out     ;
                    monitor_to_checker.put(monitor_itm);
                end
            end
        endtask : monitor_bus
    endclass : monitor

    class checker;
        task check_data();
            item driver_itm;
            item monitor_itm;
            while(1)
            begin
                wait((monitor_to_checker.num() > 0) && (driver_to_checker.num() >0));
                begin
                    driver_to_checker.get(driver_itm);
                    monitor_to_checker.get(monitor_itm); 
                    if(((driver_itm.data+1) != monitor_itm.data) && (driver_itm.addr != monitor_itm.addr))
                    begin
                        $display("FAIL,driver data =%h, monitor data = %h",driver_itm.data,monitor_itm.data); 
                    end
                    else
                    begin
                        $display("PASS"); 
                    end
                end
            end
        endtask : check_data
    endclass : checker
    
    driver my_driver;
    monitor my_monitor;
    checker my_checker;
    initial 
    begin
        my_driver = new(inf);
        my_monitor = new(inf);
        my_checker = new();
        fork
        begin
            my_driver.reset_signal();
            #100ns;
            my_driver.driver_bus();
        end
        begin
            my_monitor.monitor_bus();
        end
        begin
           my_checker.check_data();
        end
        join_any
    end
endprogram : test
`endif // TB_DADD__SV
