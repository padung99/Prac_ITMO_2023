module lifo_tb;

parameter DWIDTH             = 16;
parameter AWIDTH             = 8;
parameter ALMOST_FULL_VALUE  = 2;
parameter ALMOST_EMPTY_VALUE = 2;


bit                 clk_i_tb;
logic               srst_i_tb;

logic               wrreq_i_tb;
logic  [DWIDTH-1:0] data_i_tb;

logic               rdreq_i_tb;
logic [DWIDTH-1:0]  q_o_tb;

logic               almost_empty_o_tb;
logic               empty_o_tb;
logic               almost_full_o_tb;
logic               full_o_tb;
logic [AWIDTH:0]    usedw_o_tb;


logic               almost_empty_tb;
logic               empty_tb;
logic               almost_full_tb;
logic               full_tb;
logic [DWIDTH-1:0]  q_tb;

logic valid_rd;
logic valid_wr;

int q_error;
int usew_error;
int full_error;
int empty_error;
int almost_full_error;
int almost_empty_error;

typedef enum int {
  FORCE_RQ        = 1,
  RANDOM_RQ       = 2,
  VALID_RANDOM_RQ = 3
} request_type_t;

typedef enum int {
  REPEATE_FORCE_RQ        = 1,
  REPEATE_RANDOM_RQ       = 2,
  REPEATE_VALID_RANDOM_RQ = 3,
  REPEAT_NON_IDLE_RQ      = 4
} repeat_request_type_t;

initial
  forever 
   #5 clk_i_tb = !clk_i_tb;

default clocking cb
  @( posedge clk_i_tb );
endclocking

lifo #(
  .DWIDTH         ( DWIDTH             ),
  .AWIDTH         ( AWIDTH             ),
  .ALMOST_FULL    ( ALMOST_FULL_VALUE  ),
  .ALMOST_EMPTY   ( ALMOST_EMPTY_VALUE )
) lifo_inst (
  .clk_i          ( clk_i_tb          ),
  .srst_i         ( srst_i_tb         ),

  .wrreq_i        ( wrreq_i_tb        ),
  .data_i         ( data_i_tb         ),

  .rdreq_i        ( rdreq_i_tb        ),
  .q_o            ( q_o_tb            ),

  .almost_empty_o ( almost_empty_o_tb ),
  .empty_o        ( empty_o_tb        ),
  .almost_full_o  ( almost_full_o_tb  ),
  .full_o         ( full_o_tb         ),
  .usedw_o        ( usedw_o_tb        )
);

typedef logic [DWIDTH-1:0] rd_data_queue [$];

rd_data_queue lifo_queue;

logic [AWIDTH:0] ptr;
// logic [AWIDTH:0] ptr = {(AWIDTH+1){1'b0}};

task control_ptr();

forever
  begin
    @( posedge clk_i_tb )

    if( q_tb != q_o_tb )
      q_error++;

    if( ptr != usedw_o_tb )
      usew_error++;

    //TEST: full_o
    if( full_o_tb != full_tb )
      full_error++;

    //TEST: almost_full_o
    if( almost_full_o_tb != almost_full_tb )
      almost_full_error++;

    //TEST: almost_empty_o
    if( almost_empty_o_tb != almost_empty_tb )
      almost_empty_error++;

    //TEST: empty_o
    if( empty_o_tb != empty_tb )
      empty_error++;

    if( valid_wr )
      lifo_queue.push_back( data_i_tb );
    if( valid_rd )
      q_tb = lifo_queue.pop_back();

    ptr = lifo_queue.size();

    full_tb         = ( ptr == 2**AWIDTH );
    almost_full_tb  = ( ptr >= ALMOST_FULL_VALUE );
    empty_tb        = ( ptr == 0 );
    almost_empty_tb = ( ptr <= ALMOST_EMPTY_VALUE );
  end
endtask


task rd_and_wr_1clk();

@( posedge clk_i_tb );
wrreq_i_tb <= 1'b1;
data_i_tb  <= $urandom_range( 2**DWIDTH,0 );
rdreq_i_tb <= 1'b1;

endtask

task idle();
@( posedge clk_i_tb );
wrreq_i_tb <= 1'b0;
rdreq_i_tb <= 1'b0;

endtask

task rd_wr_idle( input int _repeat );

repeat( 5 )
  begin
    wr_1clk( FORCE_RQ );
    idle();
  end

repeat( _repeat )
  begin
    rd_and_wr_1clk();
    idle();
  end

repeat( 5 )
  begin
    rd_1clk( FORCE_RQ );
    idle();
  end
endtask


task wr_1clk( input request_type_t _write_type = FORCE_RQ );

@( posedge clk_i_tb );
rdreq_i_tb <= 1'b0;
data_i_tb  <= $urandom_range( 2**DWIDTH,0 );

case( _write_type )
  FORCE_RQ:        wrreq_i_tb <= 1'b1;
  RANDOM_RQ:       wrreq_i_tb <= $urandom_range( 1,0 );
  VALID_RANDOM_RQ: wrreq_i_tb <= ( full_tb ) ? 1'b0 : $urandom_range( 1,0 );
  default:
    begin
      $display("wr_1clk: Wrong argument _write_type: %0d ", _write_type );
      wrreq_i_tb <= 1'b0;
    end
endcase

endtask


task wr_only( input repeat_request_type_t _write_type = REPEATE_FORCE_RQ, int _repeat = 0 );

case( _write_type )
  REPEATE_FORCE_RQ:
    begin
      $display("Start writing until full");
      repeat( _repeat )
        wr_1clk( FORCE_RQ );
      $display("Finish!!!");
      idle();
    end
  REPEATE_RANDOM_RQ:
    begin
      $display("Start writing until full");
      repeat( _repeat )
        wr_1clk( RANDOM_RQ );
      $display("Finish!!!");
      idle();
    end
  REPEATE_VALID_RANDOM_RQ:
    begin
      $display("Start writing until full");
      repeat( _repeat )
        wr_1clk( VALID_RANDOM_RQ );
      $display("Finish!!!");
      idle();
    end
  REPEAT_NON_IDLE_RQ:
    begin
      $display("Start writing until full");
      repeat( _repeat )
        wr_1clk( FORCE_RQ );
      $display("Finish!!!");
    end
  default: 
      $display("wr_only: Wrong argument _write_type: %0d ", _write_type );
  
endcase

endtask

task rd_1clk( input request_type_t _read_type = FORCE_RQ );

@( posedge clk_i_tb );
wrreq_i_tb <= 1'b0;

case( _read_type )
  FORCE_RQ:        rdreq_i_tb <= 1'b1;
  RANDOM_RQ:       rdreq_i_tb <= $urandom_range( 1,0 );
  VALID_RANDOM_RQ: rdreq_i_tb <= ( empty_tb ) ? 1'b0: $urandom_range( 1,0 );
  default:
  begin
    $display("rd_1clk: Wrong argument _read_type: %0d ", _read_type );
    rdreq_i_tb <= 1'b0;
  end
endcase

endtask


task rd_only( input repeat_request_type_t _read_type = REPEATE_FORCE_RQ, int _repeat = 0);

case( _read_type )

  REPEATE_FORCE_RQ:
    begin
      $display("Start reading until empty");
      repeat( _repeat )
        rd_1clk( FORCE_RQ );
      idle();
      $display("Finish!!!");
    end
  REPEATE_RANDOM_RQ:
    begin
      $display("Start reading until empty");
      repeat( _repeat )
        rd_1clk( RANDOM_RQ );
      $display("Finish!!!"); 
    end
  REPEATE_VALID_RANDOM_RQ:
    begin
      $display("Start reading until empty");
      repeat( _repeat )
        rd_1clk( VALID_RANDOM_RQ );
      $display("Finish!!!");
    end
  REPEAT_NON_IDLE_RQ:
    begin
      $display("Start reading until empty");
      repeat( _repeat )
        rd_1clk( FORCE_RQ );
      $display("Finish!!!");
    end

endcase

endtask


task rd_and_wr( input int _delay, int _rd_wr );
repeat( _delay )
  wr_1clk( FORCE_RQ );
repeat( _rd_wr-_delay )
  rd_and_wr_1clk();
repeat( _delay +5 )
  rd_1clk( FORCE_RQ );
endtask

task reset_error_flag();

q_error            = 0;
usew_error         = 0;
full_error         = 0;
empty_error        = 0;
almost_full_error  = 0;
almost_empty_error = 0;

endtask

task reset();

empty_tb          = 1;
full_tb           = 0;
almost_empty_tb   = 1'b1;
almost_full_tb    = 1'b0;
lifo_queue        = {};

srst_i_tb  = 1;
@( posedge clk_i_tb );
srst_i_tb = 0;

endtask


assign valid_wr = wrreq_i_tb && !full_tb;
assign valid_rd = rdreq_i_tb && !empty_tb;

task cnt_error();

if( usew_error == 0 )
  $display("No error on usew_o!!");
else
  $display("usew_o: %0d errors", usew_error);

if( empty_error == 0 )
  $display("No error on empty_o!!");
else
  $display("empty_o: %0d errors", empty_error); 

if( almost_empty_error == 0 )
  $display("No error on almost_empty_o!!");
else
  $display("almost_empty_o: %0d errors", almost_empty_error);

if( full_error == 0 )
  $display("No error on full_o!!");
else
  $display("full_o: %0d errors", full_error);

if( almost_full_error == 0 )
  $display("No error on almost_full_o!!");
else
  $display("almost_full_o: %0d errors", almost_full_error);

if( q_error == 0 )
  $display("No error on q_o!!");
else
  $display("q_o: %0d errors", q_error);

$display("\n");
q_error            = 0;
usew_error         = 0;
full_error         = 0;
empty_error        = 0;
almost_full_error  = 0;
almost_empty_error = 0;

endtask


initial
  begin
    srst_i_tb <= 1;
    @( posedge clk_i_tb );
    srst_i_tb <= 0;
    
    // // // *************************************** Test case 1 *************************************************
    $display("Test case 1: Reading process begins immediately after full");
    fork
      wr_only( REPEATE_FORCE_RQ, 2**AWIDTH );
      control_ptr();
    join_any
    cnt_error();
    reset_error_flag();

    rd_only( REPEATE_FORCE_RQ, 2**AWIDTH );
    cnt_error();

    
    // // // *************************************** Test case 2 *************************************************
    repeat(2)
      idle();
    reset();
    reset_error_flag();

    $display("Test case 2: Write to full");
    wr_only( REPEATE_FORCE_RQ, 2**AWIDTH + 5 );
    cnt_error();


    
    // // // *************************************** Test case 3 *************************************************
    repeat(2)
      idle();
    reset();
    reset_error_flag();

    $display("Test case 3: read from empty");
    rd_only( REPEATE_FORCE_RQ, 32 );
    cnt_error();

 
    // // // *************************************** Test case 4 *************************************************
    repeat(2)
      idle();
    reset();
    reset_error_flag();

    $display("Test case 4: Write some value after full and read out all data");

    wr_only( REPEATE_FORCE_RQ, 2**AWIDTH +5 );
    cnt_error();
    reset_error_flag();

    rd_only( REPEATE_FORCE_RQ, 2**AWIDTH + 5 );
    cnt_error();

    
    // // // *************************************** Test case 5 *************************************************
    repeat(2)
      idle();
    reset();
    reset_error_flag();

    $display("Test case 5: write to half-full and after that, read and write at the same time");
    rd_and_wr( 2**AWIDTH/2, 2**AWIDTH );
    cnt_error();
 
    // // // *************************************** Test case 6 *************************************************
    repeat(2)
      idle();
    reset();
    reset_error_flag();

    $display("Test case 6: Read and write at the same time without delaying at the beginning of reading process");
    rd_and_wr( 0, 100 );
    cnt_error();

    // // // *************************************** Test case 7 *************************************************
    repeat(2)
      idle();
    reset();
    reset_error_flag();

    $display("Test case 7: Alternating read and write processes");
    fork
      wr_only( REPEATE_FORCE_RQ, 2**AWIDTH );
      rd_only( REPEATE_FORCE_RQ, 2**AWIDTH + 2 );
    join
    cnt_error();

    
    // // // *************************************** Test case 8 *************************************************
    repeat(2)
      idle();
    reset();
    reset_error_flag();

    $display("Test case 8: Write to full lifo, and read process (rdreq) begins immediately after wrreq has been deasserted");

    wr_only( REPEAT_NON_IDLE_RQ, 2**AWIDTH + 10 );

    cnt_error();
    reset_error_flag();

    rd_only( REPEATE_FORCE_RQ, 5 );
    cnt_error();


    // // // *************************************** Test case 9 *************************************************
    repeat(2)
      idle();
    reset();
    reset_error_flag();

    $display("Test case 9: Random rdreq and wrreq");
    fork
      wr_only( REPEATE_RANDOM_RQ, 3000 );
      rd_only( REPEATE_RANDOM_RQ, 3000 );
    join

    cnt_error();
    
    // // // *************************************** Test case 10 *************************************************
    repeat(2)
      idle();
    reset();
    reset_error_flag();   

    $display("Test case 10: Write to lifo full twice and read out once (Test write to full )");
    // This test case is used to check if read out values are first 256 values or second 256 values.
    // Because of rule: Don't write to full lifo, correct result of read out data will be first 256 values
    wr_only( REPEATE_FORCE_RQ, 2**AWIDTH );
    idle();

    wr_only( REPEATE_FORCE_RQ, 2**AWIDTH );

    rd_only( REPEATE_FORCE_RQ, 2**AWIDTH  + 2 );
    cnt_error();

    
    // // // *************************************** Test case 11 *************************************************
    repeat(2)
      idle();
    reset();
    reset_error_flag();

    $display("Test case 11:  Write to lifo full once and read out twice (Test read from empty)");

    wr_only( REPEATE_FORCE_RQ, 2**AWIDTH );
    // reset_error_flag();

    rd_only( REPEATE_FORCE_RQ, 2**AWIDTH +2 );

    idle();
    // reset_error_flag();

    rd_only( REPEATE_FORCE_RQ, 2**AWIDTH + 2 );
    cnt_error();


    // // // *************************************** Test case 12 *************************************************
    repeat(2)
      idle();
    reset();
    reset_error_flag();
    
    $display("Test case 12: Write to lifo full and after that read/write at the same time");

    wr_only( REPEATE_FORCE_RQ, 2**AWIDTH );
    cnt_error();
    reset_error_flag();


    rd_and_wr( 0, 2**AWIDTH  );
    cnt_error();


    // // // *************************************** Test case 13 *************************************************
    repeat(2)
      idle();
    reset();
    reset_error_flag();
    
    $display("Test case 13: Write some value, read until empty, and after that, write/read at the same time");

    wr_only( REPEATE_FORCE_RQ, 10 );
    cnt_error();
    reset_error_flag();

    rd_only( REPEATE_FORCE_RQ, 10 + 2 );
    cnt_error();
    reset_error_flag();

    repeat(2)
      idle();

    rd_and_wr( 0, 2**AWIDTH );
    cnt_error();


    // // // *************************************** Test case 14 *************************************************
    repeat(2)
      idle();
    reset();
    reset_error_flag();

    $display("Test case 14: Writing 1 word to lifo, after that  make 100 transactions for simultaneous writing and reading");
    rd_and_wr( 1, 100 );
    cnt_error();


    // // // *************************************** Test case 15 *************************************************  
    repeat(2)
      idle();
    reset();
    reset_error_flag();

    $display("Test case 15: Writing 255 word to lifo, after that  make 100 transactions for simultaneous writing and reading");

    rd_and_wr( 255, 100 );
    cnt_error();


    // // // *************************************** Test case 16 *************************************************
    repeat(2)
      idle();
    reset();
    reset_error_flag();

    repeat(3)
      begin
        $display("Test case 16:  Run to full and back to empty (REPEAT 3 TIMES)");

        wr_only( REPEAT_NON_IDLE_RQ, 2**AWIDTH );
        cnt_error();
        reset_error_flag();

        rd_only( REPEAT_NON_IDLE_RQ, 2**AWIDTH );
        cnt_error();
      end

    // // // *************************************** Test case 17 *************************************************
    repeat(2)
      idle();
    reset();
    reset_error_flag();

    $display("Test case 17: Random rdreq and wrreq (Only valid input)");
    //This random will pass only valid input ( when lifo is empty, no rdreq (rdreq = 0), when lifo is full, no wrreq (wrrep = 0) )
    fork
      wr_only( REPEATE_VALID_RANDOM_RQ, 3000 );
      rd_only( REPEATE_VALID_RANDOM_RQ, 3000 );
    join

    cnt_error();

    $display( "Test done!" );
    $stop();
    
  end

endmodule