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
//     File for bvm_pkg.sv                                                       
//----------------------------------------------------------------------------------
package bvm_pkg;
    `define bvm_component_utils(c) typedef proxy #(c, `"c`") type_id;
    `define bvm_info(msg,veb) bvm_report_info(msg,veb,`__FILE__,`__LINE__);
    `define bvm_error(msg) bvm_report_error(msg,`__FILE__,`__LINE__);
    `define bvm_fatal(msg) bvm_report_fatal(msg,`__FILE__,`__LINE__);

    typedef class factory;
    typedef class bvm_driver;
    typedef class bvm_monitor;
    typedef class bvm_env;
    typedef class bvm_root;
    typedef class bvm_component;
    typedef class bvm_sequencer;
    `include "bvm_global.svh"
    typedef enum {
                BVM_NONE, 
                BVM_LOW,  
                BVM_MEDIUM,
                BVM_HIGH}  
              BVM_INFO_e;
    //bvm_void
    virtual class bvm_void ;
    endclass : bvm_void

    class bvm_sequence_item extends bvm_void;
    endclass : bvm_sequence_item

    static mailbox#(bvm_sequence_item) seq2sqr_box = new();
    static mailbox#(bvm_sequence_item) sqr2drv_box = new();
    static mailbox#(bvm_sequence_item) imon2ref_box = new();
    static mailbox#(bvm_sequence_item) ref2scb_box = new();
    static mailbox#(bvm_sequence_item) omon2scb_box = new();
    //bvm_object
    virtual class bvm_object extends bvm_void;
        local int m_inst_id;
        local string m_leaf_name; 
        static protected int m_inst_count = 0;
        static bit m_phase_all_done = 1;

        extern function new(string name = "");
        extern virtual function void set_name(string name);
        extern virtual function string get_name();
        extern virtual function string get_full_name();
        extern virtual function int get_inst_id();
        extern static  function int get_inst_count(); 
        virtual function bvm_object create (string name=""); return null; endfunction
    endclass : bvm_object

    function bvm_object :: new(string name="");
        m_inst_id = m_inst_count++;
        m_leaf_name = name;
    endfunction : new
    
    function int bvm_object::get_inst_id();
        return m_inst_id;
    endfunction : get_inst_id
    
    function string bvm_object::get_name ();
        return m_leaf_name;
    endfunction : get_name
    
    function string bvm_object::get_full_name ();
        return get_name();
    endfunction : get_full_name
    
    function void bvm_object::set_name (string name);
        m_leaf_name = name;
    endfunction : set_name
    
    function int bvm_object::get_inst_count();
        return m_inst_count;
    endfunction : get_inst_count
    //config_db    
    class bvm_config_db #(type T=int) extends bvm_object;
        static local string blkname = "bvm_config_db";

        static T db[string];
        
        static function void set(input string name, input T value);
           db[name] =value;
        endfunction
        
        static function bit get(input string name,ref T value);
           value = db[name];
           if(value != null)
           begin
                return 1;
           end

        endfunction
    endclass : bvm_config_db
    //bvm_report_object
    class bvm_report_object extends bvm_object; 

        static int bvm_info_count = 0;
        static int bvm_error_count = 0;
        static int bvm_fatal_count = 0;

        static BVM_INFO_e cfg_trace_on=BVM_NONE;
        string typename = "bvm_report_object";
        string instname = "";
        string blkname = typename;
                                  
        factory f; 
        function new(string name="",bvm_report_object parent = null);
            super.new(name);
        endfunction : new

        function void bvm_report_fatal (input string message,input string dfile,input int dline);
            $display("[BVM_FATAL]:%s(%0d) @%0t , %0s",dfile,dline,$realtime, message);
            bvm_fatal_count ++;
            $finish();
        endfunction : bvm_report_fatal

        function void bvm_report_error (input string message,input string dfile,input int dline);
            $display("[BVM_ERROR]:%s(%0d) @%0t , %0s",dfile,dline,$realtime, message);
            bvm_error_count ++;
        endfunction : bvm_report_error

        function void bvm_report_info (input string message,input BVM_INFO_e verbosity,input string dfile,input int dline);
            BVM_INFO_e msg_level;
            bit print = 1'b0;

            msg_level = verbosity;
            if ((msg_level > BVM_NONE) & (cfg_trace_on <= msg_level))
                print = 1'b1;

            if (print)
                $display("[BVM_INFO]:%s(%0d) @%0t , %0s",dfile,dline,$realtime, message);
            bvm_info_count ++;
        endfunction : bvm_report_info

    endclass: bvm_report_object

    virtual class bvm_component extends bvm_report_object; 
        static bvm_root top;
        bit sim_finish = 0;// 1:simulation finish
        bvm_component m_parent;

        bvm_component m_children[string];
        bvm_component m_children_by_handle[bvm_component];
        bvm_component m_parent;
        function new(string name ,bvm_component parent);
            super.new(name);
            if(parent != null)
            begin
                m_parent = parent;
                m_parent.m_children[this.get_name()] = this;
                m_parent.m_children_by_handle[this] = this;
            end
            if(name == "_top_")
            begin
                return;
            end
            top = bvm_root :: get(); 
        endfunction : new

        function int get_first_child(ref string name);
            return m_children.first(name);
        endfunction 

        function int get_next_child(ref string name);
            return m_children.next(name);
        endfunction 

        function bvm_component get_child(string name);
            if (m_children.exists(name))
                return m_children[name];
            return null;
        endfunction

        task raise_objection();
            m_phase_all_done= 1;
        endtask : raise_objection

        task drop_objection();
            m_phase_all_done= 0;
        endtask : drop_objection


        pure virtual function void build_phase();
        pure virtual task run_phase();
    endclass: bvm_component

    virtual class proxy_base;
        pure virtual function bvm_component create_object(input string instname,bvm_component parent);
        pure virtual function string get_typename();
    endclass: proxy_base
  
    class proxy #(type my_type = bvm_component , string typename = "none") extends proxy_base;
        typedef proxy #(my_type, typename) THIS_TYPE_t;
         
        static string blkname = {"proxy.", typename};
        static factory f = factory::get();
        static THIS_TYPE_t me = get();
    
        static function THIS_TYPE_t get();
            string mname = {blkname,".get"};
            if (me == null)
            begin
                me = new();
                f.register(me);
            end
            return me;
        endfunction: get
    
        static function my_type create (input string instname,bvm_component parent=null);
            my_type my_object; 
            $cast(my_object, f.create_object_by_type(me, instname,parent)); 
            return my_object;
        endfunction: create
    
        virtual function bvm_component create_object(input string instname,bvm_component parent);
            string mname;
            my_type my_object = new(instname,parent);
            my_object.typename = typename;
            my_object.instname = instname;
            mname = $sformatf("%s.%s", blkname, my_object.instname); 
            return my_object;
        endfunction: create_object
    
        virtual function string get_typename();
            return typename;
        endfunction: get_typename
    endclass: proxy
  
    class factory;
        static proxy_base registry[string]; 
        static string type_override[string];
        static string inst_override[string];
        static factory me = get();
        static string blkname = "factory";
    
        static function factory get();
            if(me == null)
                me = new();
            return me;
        endfunction: get
    
        function void register(proxy_base proxy);
            registry[proxy.get_typename()] = proxy;
        endfunction: register
    
        function bvm_component create_object_by_type(proxy_base proxy, string instname,bvm_component parent);
            proxy = find_override(proxy, instname);
            return proxy.create_object(instname,parent);
        endfunction: create_object_by_type
    
        static function void set_type_override(string typename, string override_typename);
            type_override[typename] = override_typename;
        endfunction: set_type_override

        static function void set_inst_override(string instname, string override_typename);
            inst_override[instname] = override_typename;
        endfunction: set_inst_override
        
        function proxy_base find_override(proxy_base proxy, input string instname);
            string mname = {blkname, ".find_override"};
            if (inst_override.exists(instname))
            begin
                return registry[inst_override[instname]];
            end
            else if (type_override.exists(proxy.get_typename()))
                begin
                return registry[type_override[proxy.get_typename()]];
                end
            else
                begin
                return proxy;
                end
        endfunction: find_override
    
    
    endclass: factory


    class bvm_root extends  bvm_component;

        static bvm_root m_inst;
        proxy_base pbase;
        bvm_component bvm_test_top;

        function new();
            super.new("_top_",null);
        endfunction : new

        static function bvm_root get();
            if(m_inst == null)
            begin
                m_inst = new();
            end
            return m_inst;
        endfunction : get

        task traverse(bvm_component comp,string phase = "");
            string name ;
            if (phase == "build_phase")
            begin
                comp.build_phase();
            end
            if(phase == "run_phase")
            begin
                fork
                comp.run_phase();
                join_none
            end
            if(comp.get_first_child(name))
            begin
                do
                begin
                    traverse(comp.get_child(name),phase);
                end
                while(comp.get_next_child(name));
            end
        endtask : traverse

        virtual function void build_phase();
            $display(this.get_name," Starting build_phase ...");
        endfunction : build_phase

        virtual task run_phase();
            $display(this.get_name," Starting run_phase ...");
        endtask : run_phase

        task run_test(string instname);
            bvm_component cmp;
            string strace_on;

            if ($value$plusargs("TRACE_ON=%s", strace_on))
            begin
                case (strace_on)
                "BVM_NONE":     cfg_trace_on = BVM_NONE;
                "BVM_LOW":      cfg_trace_on = BVM_LOW;
                "BVM_MEDIUM":   cfg_trace_on = BVM_MEDIUM;
                "BVM_HIGH":     cfg_trace_on = BVM_HIGH;
                endcase
            end

            if(f.registry.exists(instname))
            begin
                pbase = f.registry[instname];
            end
            cmp = pbase.create_object("bvm_test_top",null);
            $cast(bvm_test_top,cmp);
            #0ns;
            traverse(bvm_test_top,"build_phase");
            traverse(bvm_test_top,"run_phase");
            forever 
            begin
              if(m_phase_all_done== 0)
              begin
                report_info();
                $finish;
              end
              #1ns;
            end

        endtask : run_test

        task report_info();
            $display("\n");
            $display("************************");
            $display("---BVM Report Summary---");
            $display("************************");
            $display("[BVM_INFO] : %0d",bvm_info_count);
            $display("[BVM_ERROR] : %0d",bvm_error_count);
            $display("[BVM_FATAL] : %0d",bvm_fatal_count);
            $display("*************************************************************");
            $display("*** This code is copyrighted by WangJianli and cannot be  ***");
            $display("*** used for commercial purposes.If you have any questions***");
            $display("*** ,plsease contact email: brent_wang@foxmail.com        ***");
            $display("*************************************************************");
            $display("\n");
        endtask : report_info


    endclass : bvm_root

    class bvm_sequence extends bvm_sequence_item;
        bvm_sequencer bvm_sqr;

        virtual task body();
        endtask : body

        task start(bvm_sequencer sqr);
            body();
            sqr.wait_for_grant();
        endtask : start


    endclass : bvm_sequence

    class bvm_driver extends bvm_component;
        `bvm_component_utils(bvm_driver)

        function new(string name,bvm_component parent = null);
            super.new(name,parent);
        endfunction : new

        task get_next_item(output bvm_sequence_item data);
            bvm_sequence_item data_tmp;
            sqr2drv_box.get(data_tmp);
            data = data_tmp;
        endtask : get_next_item

        virtual function void build_phase();
            $display(this.get_name," Starting build_phase ...");
        endfunction : build_phase

        virtual task run_phase();
            $display(this.get_name," Starting run_phase ...");
        endtask : run_phase


    endclass : bvm_driver

    class bvm_monitor extends bvm_component;
        `bvm_component_utils(bvm_monitor)

        function new(string name,bvm_component parent = null);
            super.new(name,parent);
        endfunction : new

        virtual function void build_phase();
            $display(this.get_name," Starting build_phase ...");
        endfunction : build_phase

        virtual task run_phase();
            $display(this.get_name," Starting run_phase ...");
        endtask : run_phase

    endclass : bvm_monitor

    class bvm_sequencer extends bvm_component;
        `bvm_component_utils(bvm_sequencer)
        bvm_sequence_item item;
        
        function new(string name,bvm_component parent = null);
            super.new(name,parent);
        endfunction : new
        
        task wait_for_grant();
            for(int i=0;i<seq2sqr_box.num();i++)
            begin

               seq2sqr_box.get(item); 
               sqr2drv_box.put(item);
            end
        endtask : wait_for_grant

        virtual function void build_phase();
            $display(this.get_name," Starting build_phase ...");
        endfunction : build_phase

        virtual task run_phase();
            $display(this.get_name," Starting run_phase ...");
        endtask : run_phase

    endclass : bvm_sequencer

    class bvm_agent extends bvm_component;
        `bvm_component_utils(bvm_agent)

        function new(string name,bvm_component parent = null);
            super.new(name,parent);
        endfunction : new

        virtual function void build_phase();
            $display(this.get_name," Starting build_phase ...");
        endfunction : build_phase

        virtual task run_phase();
            $display(this.get_name," Starting run_phase ...");
        endtask : run_phase
    endclass : bvm_agent

    class bvm_env extends bvm_component;
        `bvm_component_utils(bvm_env)

        function new(string name,bvm_component parent = null);
            super.new(name,parent);
        endfunction : new

        virtual function void build_phase();
            $display(this.get_name," Starting build_phase ...");
        endfunction : build_phase

        virtual task run_phase();
            $display(this.get_name," Starting run_phase ...");
        endtask : run_phase

    endclass : bvm_env

    class bvm_test extends bvm_component;
        `bvm_component_utils(bvm_test)

        function new(string name,bvm_component parent = null);
            super.new(name,parent);
        endfunction : new

        virtual function void build_phase();
            $display(this.get_name," Starting build_phase ...");
        endfunction : build_phase

        virtual task run_phase();
            $display(this.get_name," Starting run_phase ...");
        endtask : run_phase

    endclass : bvm_test

endpackage : bvm_pkg
