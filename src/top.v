/////////////////////////// INCLUDE /////////////////////////////

////////////////////////////////////////////////////////////////
//
//  Module  : top
//  Designer: Hoki
//  Company : HWorks
//  Date    : 2016/2/23 11:23:20
//
////////////////////////////////////////////////////////////////
// 
//  Description: Top module of BST
//
////////////////////////////////////////////////////////////////
// 
//  Revision: 1.0
 
/////////////////////////// MODULE //////////////////////////////
module top
(
`ifdef DEBUF
   CLK2,
`endif
   IO_A8,
   IO_B8,
   IO_C8,
   IO_D8
);
 
   ////////////////// PORT ////////////////////
`ifdef DEBUF
   input CLK2;
`endif
   inout IO_A8;
   inout IO_B8;
   inout IO_C8;
   inout IO_D8;

   ////////////////// ARCH ////////////////////
`ifdef DEBUF
   clk_pll	clk_gen (
   	.inclk0 ( CLK2 ),
   	.c0 (  )
   	);   
`endif
   	
   ////////////////// Virtual JTAG
   wire tdi;
   reg  tdo;
   wire tck;
   
   wire vjtag_cdr;
   wire vjtag_sdr;
   wire vjtag_udr;
   
   vjtag u0 (
      .tdi                (tdi),
      .tdo                (tdo),
      .ir_in              (),
      .ir_out             (0),
      .virtual_state_cdr  (vjtag_cdr),
      .virtual_state_sdr  (vjtag_sdr),
      .virtual_state_udr  (vjtag_udr),
      .tck                (tck) 
   );
   
   ////////////////// Capture Phase
   wire [`VBSC_NUM-1:0] inj;
   wire [`VBSC_NUM-1:0] oej  = {`VBSC_NUM{1'b1}};
   wire [`VBSC_NUM-1:0] outj = {`VBSC_NUM{1'b0}};
   reg  [`VBSC_NUM-1:0] inj_capture_reg ;
   reg  [`VBSC_NUM-1:0] oej_capture_reg ;
   reg  [`VBSC_NUM-1:0] outj_capture_reg;
   generate
   genvar i;
      for(i=0;i<`VBSC_NUM;i=i+1)
      begin: cp
         // load pin, OEJ & OUTJ to Capture Register
         always@(posedge tck) begin
            if(vjtag_cdr) begin
               inj_capture_reg [i] <= iobuf_out[i];
               oej_capture_reg [i] <= oej[i];
               outj_capture_reg[i] <= outj[i];
            end
            else if(prev_vjtag_sdr&~vjtag_sdr) begin
               inj_capture_reg [i] <= cr_shift_in[i*`VBSC_NBIT+0];
               oej_capture_reg [i] <= cr_shift_in[i*`VBSC_NBIT+1];
               outj_capture_reg[i] <= cr_shift_in[i*`VBSC_NBIT+2];
            end
         end
         // previously retained data in Update Registers drives the IOC input, INJ, and
         // allows the I/O pin to tri-state or drive a signal out
         assign inj[i]       = inj_update_reg[i];
         assign iobuf_oe[i]  = oej_update_reg[i];
         assign iobuf_din[i] = outj_update_reg[i];
      end
   endgenerate
   
   ////////////////// Shift & Update Phase
   reg                            prev_vjtag_sdr;
   reg [`VBSC_NUM_LOG-1:0]        vbsc_num;
   reg [`VBSC_NBIT_LOG-1:0]       shift_cnt;
   reg [`VBSC_NUM*`VBSC_NBIT-1:0] cr_shift_in; // tdi --> capture register
   reg [`VBSC_NUM-1:0]            inj_update_reg ;
   reg [`VBSC_NUM-1:0]            oej_update_reg ;
   reg [`VBSC_NUM-1:0]            outj_update_reg;
   always@(posedge tck) begin
      prev_vjtag_sdr <= vjtag_sdr;

      // shift
      if(vjtag_sdr) begin
         shift_cnt <= shift_cnt + 1'b1;
         if(shift_cnt==`VBSC_NBIT-1) begin
            shift_cnt <= 0;
            vbsc_num  <= vbsc_num + 1'b1;
            if(vbsc_num==`VBSC_NUM-1)
               vbsc_num <= 0;
         end         
         cr_shift_in <= {tdi, cr_shift_in[`VBSC_NUM*`VBSC_NBIT-1:1]};
      end
      else begin
         shift_cnt   <= 0;
         vbsc_num    <= 0;
      end
      
      if(vjtag_cdr)
         cr_shift_in <= 0;
   end

   always@* begin
      if(vjtag_sdr) begin         
         if(shift_cnt==`VBSC_NBIT_LOG'h0)
            tdo <= inj_capture_reg[vbsc_num];
         else if(shift_cnt==`VBSC_NBIT_LOG'h1)
            tdo <= oej_capture_reg[vbsc_num];
         else if(shift_cnt==`VBSC_NBIT_LOG'h2)
            tdo <= outj_capture_reg[vbsc_num];
         else
            tdo <= cr_shift_in[0];
      end
      else begin
         tdo <= `LOW;
      end
   end
   
   // update: data is transferred from capture register 
   //                             to update register
   generate
   genvar j;
      for(j=0;j<`VBSC_NUM;j=j+1)
      begin: up
         always@(posedge vjtag_udr) begin
            inj_update_reg [j] <= inj_capture_reg [j];
            oej_update_reg [j] <= oej_capture_reg [j];
            outj_update_reg[j] <= outj_capture_reg[j];
         end
      end
   endgenerate

   ////////////////// IO Buffer
   wire [`VBSC_NUM-1:0] iobuf_din;
   wire [`VBSC_NUM-1:0] iobuf_oe;
   wire [`VBSC_NUM-1:0] iobuf_out;
   
   altio	iobuf_0 (
   	.datain (iobuf_din[0]),  // out
   	.oe     (~iobuf_oe[0] ), // out
   	.dataio (IO_A8       ),  // inout
   	.dataout(iobuf_out[0] )  // in
   	);         

   altio	iobuf_1 (
   	.datain (iobuf_din[1]),  // out
   	.oe     (~iobuf_oe[1] ), // out
   	.dataio (IO_B8       ),  // inout
   	.dataout(iobuf_out[1] )  // in
   	);         

   altio	iobuf_2 (
   	.datain (iobuf_din[2]),  // out
   	.oe     (~iobuf_oe[2] ), // out
   	.dataio (IO_C8       ),  // inout
   	.dataout(iobuf_out[2] )  // in
   	);         

   altio	iobuf_3 (
   	.datain (iobuf_din[3]),  // out
   	.oe     (~iobuf_oe[3] ), // out
   	.dataio (IO_D8       ),  // inout
   	.dataout(iobuf_out[3] )  // in
   	);         

endmodule