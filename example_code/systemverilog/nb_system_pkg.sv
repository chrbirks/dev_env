package nb_system_pkg;
  // parameter TEST_PARAM = 12;
  int test_int = 14;

  typedef struct packed {
    logic        a;
    logic        b;
  } laydec_sequence_item;

  logic c[$] = {0, 1};

  typedef struct packed {
    logic        bbb;
  } ref_model_t;

  parameter bla = 1;
  function void tt();
    //
  endfunction // tt
  
endpackage
