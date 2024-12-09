module fsm (
  input clk,rst,
  input wire [2:0] conf,
  output wire sel,
  output wire [4:0] i,
  output wire [4:0] k, //max = 31
  output wire [4:0] j, //max = 31
  output wire [2:0] p, //max = 2
  output wire iwen,
  output wire iren,
  output wire ien,
  output wire [1:0] done_flag);
  
  parameter IDLE = 3'b000;
  parameter RADIX2 = 3'b001;
  parameter RADIX4 = 3'b010;
  parameter DONE_RADIX2 = 3'b011;
  parameter DONE_RADIX4 = 3'b100;

  wire clk_en;
  assign clk_en = clk & (~sel);

  wire clk_c;
  assign clk_c = clk & (sel);

  reg sel_reg;
  reg iwen_reg,iren_reg,ien_reg;
  wire iwen_s,ien_reg_q_s;
  wire iwen_i,ien_reg_q_i;
  wire ien_reg_q,ien_reg_q_tmp;
  reg [2:0] conf_state;
  reg [4:0] i_reg;
  reg [7:0] k_reg,j_reg;
  reg [2:0] p_reg;
  reg [3:0] done_reg;
  wire [1:0] end_stage,begin_stage;
  wire [3:0] p_shift;
  
  assign i = i_reg;
  assign j = j_reg;
  assign k = k_reg;
  assign p = p_reg;
  assign done_flag = done_reg;


  assign ien = ((conf == DONE_RADIX4) || (conf == DONE_RADIX2)) ? ien_reg_q : ien_reg_q_tmp;

  shift_8 #(.data_width(1)) shif_iwen_s(.clk(clk_en),.rst(rst),.din(iwen_reg),.dout(iwen_s));
  shift_7 #(.data_width(1)) shif_ien_s(.clk(clk_en),.rst(rst),.din(ien_reg_q_tmp),.dout(ien_reg_q_s));

  shift_14 #(.data_width(1)) shif_iwen_i(.clk(clk_c),.rst(rst),.din(iwen_reg),.dout(iwen_i));
  shift_13 #(.data_width(1)) shif_ien_i(.clk(clk_c),.rst(rst),.din(ien_reg_q_tmp),.dout(ien_reg_q_i));
  
  DFF #(.data_width(1)) dff_ien(.clk(clk),.rst(rst),.d(ien_reg),.q(ien_reg_q_tmp));
  DFF #(.data_width(1)) dff_iren(.clk(clk),.rst(rst),.d(iren_reg),.q(iren));

  assign iwen = sel == 0 ? iwen_s : iwen_i;
  assign ien_reg_q = sel == 0 ? ien_reg_q_s : ien_reg_q_i;

  // 生成控制信号
  DFF #(.data_width(1)) dff_sel(.clk(clk),.rst(rst),.d(sel_reg),.q(sel));
  always@(posedge clk or posedge rst)
  begin
    if(rst)
      conf_state <= IDLE;
    else
      conf_state <= conf;
  end
  
  always@(*)
  begin
    sel_reg = 0;
    ien_reg = 0; 
    iwen_reg = 0;
    iren_reg = 0; 
    done_reg = 4'b0;
    case(conf_state)
    IDLE:begin 
        sel_reg = 0;
        ien_reg = 0; 
        iwen_reg = 0;
        iren_reg = 0; 
        done_reg = 4'b0;
        end

    RADIX2:begin
        sel_reg = 0;
        ien_reg = 1; 
        iwen_reg = 1;
        iren_reg = 1;
         if(i_reg == 5'd31)
           done_reg = 2'b01;
         else
           done_reg = 2'b0;
        end

    RADIX4:begin 
         sel_reg = 1;
         ien_reg = 1; 
         iwen_reg = 1;
         iren_reg = 1;
         if((p_reg == 0)&&(k_reg == 31)&&(j_reg == 0))begin
           done_reg = 2'b10; end
         else begin
           done_reg = 4'b0; end
         end

    DONE_RADIX2:begin 
         sel_reg = 0;
         ien_reg = 0;
         iwen_reg = 0;
         iren_reg = 0; 
         p_reg <= 3'b0;
        end

    DONE_RADIX4:begin 
         sel_reg = 1;
         ien_reg = 0;
         iwen_reg = 0;
         iren_reg = 0; 
        p_reg <= 3'b0;
        end

    default:begin 
         sel_reg = 0;
         done_reg = 2'b0;
         ien_reg = 0;
         iwen_reg = 0;
         iren_reg = 0; 
         end
     endcase
  end
 
 assign end_stage = conf == RADIX4 ? 0 : 2;
 assign begin_stage = conf == RADIX4 ? 2 : 3;
 assign p_shift = p_reg << 1;
 
  always@(posedge clk or posedge rst)
  begin 
     if(rst)
     begin
         p_reg <= begin_stage;
         j_reg <= 0;
         k_reg <= 0;
         i_reg <= 0;
     end
     else if((conf_state == RADIX2))
     begin
         i_reg <= i_reg + 1;
     end

     else if((conf_state == RADIX4))
     begin
        if(j_reg == (1 << (p_shift)) - 1)
        begin
           j_reg <= 0;
           if(k_reg == (32 >> p_shift) - 1)
           begin
              k_reg <= 0;
              if(p_reg == end_stage)
                   p_reg <= begin_stage;
              else
                   p_reg <= p_reg - 1;
           end
           else
              k_reg <= k_reg + 1;
         end
         else
            j_reg <= j_reg + 1;
     end
     else
     begin
       p_reg <= begin_stage;
       j_reg <= 0;
       k_reg <= 0;
       i_reg <= 0;
     end
   end
endmodule