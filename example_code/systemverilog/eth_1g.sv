//-----------------------------------------------------------------------------
// Title         : 1G Transcevier, MAC/PCS
// Project       : Cambridge IO ring
//-----------------------------------------------------------------------------
// File          : eth_1g.sv
// Author        : Christian Birk Sørensen <cbs@napablaze.com>
//-----------------------------------------------------------------------------
// Description:
// MAC/PCS/PMA and DRP for Cambridge 1G frontend
//-----------------------------------------------------------------------------
// Copyright (c) 2018 by Napablaze A/S This model is the confidential and
// proprietary property of Napablaze A/S and the possession or use of this
// file requires a written license from Napablaze A/S.
//-----------------------------------------------------------------------------  
module eth_1g
  // import nb_ca_ioring_pkg::*;
  // import common_macpcs_pkg::*;
  // import nb_eye_scan_ctrl_pkg::*;
  // import nb_system_pkg::*;
  #(
    parameter integer TGT_ID_GTY      [3:0]  = '{default:'0},
    parameter integer TGT_ID_DRP      [15:0] = '{default:'0},
    parameter integer TGT_ID_STAT     [15:0] = '{default:'0},
    parameter integer TGT_ID_EYE_SCAN [15:0] = '{default:'0}
  ) (
  // Freerunning clock and reset (DRP)
  input logic drp_clk_i,
  input logic drp_rst_i,

  // 50 MHz init and CPLL calibration clock
  input logic config_clk_i,
  input logic config_rst_i,
  
  // Transcevier clocks - one per QUAD
  input logic gt_refclk_n[0:3],
  input logic gt_refclk_p[0:3],
    
  // Transceiver RX/TX pins
  input logic  [3:0] gt_rx_n[0:3],
  input logic  [3:0] gt_rx_p[0:3],
  output logic [3:0] gt_tx_n[0:3],
  output logic [3:0] gt_tx_p[0:3],

  // MAC Rx Interfaces
  output logic [NB_NUM_GMII_IF-1:0] mac_rx_clk_o,
  output logic [NB_NUM_GMII_IF-1:0] mac_rx_rst_o,
  (* mark_debug = "true", keep = "true" *)nb_gmii_if.mac_rx                 mac_rx_if[NB_NUM_GMII_IF-1:0],

  // MAC Tx Interfaces
  output logic [NB_NUM_GMII_IF-1:0] mac_tx_clk_o,
  output logic [NB_NUM_GMII_IF-1:0] mac_tx_rst_o,
  (* mark_debug = "true", keep = "true" *)nb_gmii_if.mac_tx                 mac_tx_if[NB_NUM_GMII_IF-1:0],

  // Common register access (DRP clock)
  nb_reg_access_if.slave_reg_acc_ser reg_access
  );

  localparam NUMB_QSFP           = 4;
  localparam NUMB_GT_PER_QSFP    = 4;

  localparam RESET_TIMER_MAX    =   1350000;   //  ~10ms @ 135MHz DRP clock
  localparam ENABLE_TIMER_MAX   =  62500000;   // ~500ms @ 125MHz clock
  localparam FRAME_TIMER_MAX    =      5000;   // Amount of clock periods to receive a 16kB packet plus overhead for invalid cycles

  // AXI struct
  typedef struct packed {
    logic        tready;
    logic        tvalid;
    logic [7:0]  tdata;
    logic        tlast;
    logic        tuser;
  } axis_t;

  ////////////////////////////////////////////////////////////////////////////////
  // Register access
  // Main hub 0: DRP
  //          1: MAC
  //          2: Statistics
  //          3: Eye scan control
  nb_reg_access_if reg_acc_main_hub[4]();
  nb_reg_acc_hub #(
    .PAR                 (0),
    .FANOUT              (4)
    ) i_nb_reg_acc_hub_main (
    .clk_i               (drp_clk_i),
    .rst_i               (drp_rst_i),
    .reg_acc_master_side (reg_access),
    .reg_acc_slave_side  (reg_acc_main_hub.master_reg_acc_ser)
    );  


  ////////////////////////////////////////////////////////////////////////////////
  // DRP connectivity for each MAC
  nb_reg_access_if reg_acc_main_drp_hub[NUMB_QSFP]();
  nb_reg_access_if reg_acc_main_mac_hub[NUMB_QSFP]();
  nb_reg_access_if reg_acc_main_statistics_hub[NUMB_QSFP](); 
  nb_reg_access_if reg_acc_main_eye_scan_hub[NUMB_QSFP](); 
  
  nb_reg_acc_hub #(
    .PAR                 (0),
    .FANOUT              (NUMB_QSFP)
    ) i_nb_reg_acc_hub_main_drp (
    .clk_i               (drp_clk_i),
    .rst_i               (drp_rst_i),
    .reg_acc_master_side (reg_acc_main_hub[0]),
    .reg_acc_slave_side  (reg_acc_main_drp_hub.master_reg_acc_ser)
    );
  
  nb_reg_acc_hub #(
    .PAR                 (0),
    .FANOUT              (NUMB_QSFP)
    ) i_nb_reg_acc_hub_mac (
    .clk_i               (drp_clk_i),
    .rst_i               (drp_rst_i),
    .reg_acc_master_side (reg_acc_main_hub[1]),
    .reg_acc_slave_side  (reg_acc_main_mac_hub.master_reg_acc_ser)
    );
  
  nb_reg_acc_hub #(
    .PAR                 (0),
    .FANOUT              (NUMB_QSFP)
    ) i_nb_reg_acc_hub_statistics (
    .clk_i               (drp_clk_i),
    .rst_i               (drp_rst_i),
    .reg_acc_master_side (reg_acc_main_hub[2]),
    .reg_acc_slave_side  (reg_acc_main_statistics_hub.master_reg_acc_ser)
    );

  nb_reg_acc_hub #(
    .PAR                 (0),
    .FANOUT              (NUMB_QSFP)
    ) i_nb_reg_acc_hub_eye_scan (
    .clk_i               (drp_clk_i),
    .rst_i               (drp_rst_i),
    .reg_acc_master_side (reg_acc_main_hub[3]),
    .reg_acc_slave_side  (reg_acc_main_eye_scan_hub.master_reg_acc_ser)
    );

  // Shared clocking between QSFPs
  logic [NUMB_QSFP-1:0][NUMB_GT_PER_QSFP-1:0] rx_user_reset;
  logic [NUMB_QSFP-1:0][NUMB_GT_PER_QSFP-1:0] tx_user_reset;
  logic [NUMB_QSFP-1:0][NUMB_GT_PER_QSFP-1:0] tx_core_clk;
  logic [NUMB_QSFP-1:0][NUMB_GT_PER_QSFP-1:0] rx_core_clk;

  
  ////////////////////////////////////////////////////////////////////////////////
  // For eqch QSFP
  generate
    for (genvar index_qsfp = 0; index_qsfp < NUMB_QSFP; index_qsfp = index_qsfp+1 ) begin: qsfp_inst

      // Data signals
      axis_t [NUMB_GT_PER_QSFP-1:0] rx_axis;
      axis_t [NUMB_GT_PER_QSFP-1:0] tx_axis;
      
      // DRP signals   
      logic [NUMB_GT_PER_QSFP-1:0][ 9:0] drpaddr_in;
      logic [NUMB_GT_PER_QSFP-1:0][ 0:0] drpen_in;
      logic [NUMB_GT_PER_QSFP-1:0][ 0:0] drpwe_in;
      logic [NUMB_GT_PER_QSFP-1:0][15:0] drpdi_in;
      logic [NUMB_GT_PER_QSFP-1:0][15:0] drpdo_out;
      logic [NUMB_GT_PER_QSFP-1:0][ 0:0] drprdy_out;

      // Shared logic
      logic [NUMB_GT_PER_QSFP-1:0]      gtwiz_reset_all;
      logic [NUMB_GT_PER_QSFP-1:0]      gtwiz_reset_tx_datapath_int;  // Reg target
      logic [NUMB_GT_PER_QSFP-1:0]      gtwiz_reset_tx_datapath;
      logic [NUMB_GT_PER_QSFP-1:0]      gtwiz_reset_rx_datapath_int;  // Reg target
      logic [NUMB_GT_PER_QSFP-1:0]      gtwiz_reset_rx_datapath;
      logic [NUMB_GT_PER_QSFP-1:0]      rx_ext_reset;
      logic [NUMB_GT_PER_QSFP-1:0]      tx_ext_reset;
      logic [NUMB_GT_PER_QSFP-1:0][1:0] int_rxpd, int_txpd; // power down from core to transceivers unused
      logic [NUMB_GT_PER_QSFP-1:0][0:0] ext_rxpd, ext_txpd;
      logic [NUMB_GT_PER_QSFP-1:0]      rxcdrhold;

      // FIXME: loopback should be configured for all transceivers in a quad and not individual transceivers
      logic [NUMB_GT_PER_QSFP-1:0][2:0] gt_loopback_mode; // 0: normal operation
                                                          // 1: Near-end PCS loopback
                                                          // 2: Near-end PMA loopback
                                                          // 3: Reserved
                                                          // 4: Far-end PMA loopback
                                                          // 5: Reserved
                                                          // 6: Far-end PCS loopback

            
      //// Statistics
      nb_reg_access_if reg_acc_sub_statistics_hub[NUMB_GT_PER_QSFP]();
      eth_stat_if      ethernet_stat_if[NUMB_GT_PER_QSFP]();

      //// MAC register target
      common_macpcs_t ctrl_reg;
      common_macpcs_next_t stat_reg;

      common_macpcs_fault_condition_ctrl_t [NUMB_GT_PER_QSFP-1:0] fault_condition_ctrl;
      (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0] rx_link_activity;
      logic [NUMB_GT_PER_QSFP-1:0] rx_local_fault; 
      logic [NUMB_GT_PER_QSFP-1:0] rx_remote_fault; 
      (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0] link_up_status_old; // To detect link change 
      (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0] link_change_detect; 
      logic [NUMB_GT_PER_QSFP-1:0] rx_error_led; 

      // Node
      nb_reg_target_if mac_reg_target();
      nb_reg_acc_node #(
        .PAR    (0),
        .TGT_ID (TGT_ID_GTY[index_qsfp])
        ) i_nb_reg_acc_node_eth_gt (
        .clk_i   (drp_clk_i),
        .rst_i   (drp_rst_i),
        .reg_acc (reg_acc_main_mac_hub[index_qsfp].slave_reg_acc_ser),
        .reg_target (mac_reg_target)
        );

      common_macpcs_target i_common_macpcs_target (
        .clk_i(drp_clk_i),
        .nb_reg_struct(ctrl_reg),
        .nb_reg_struct_next(stat_reg),
        .reg_target(mac_reg_target)
        );

      // assign stat_reg.mcu_led_status[index_qsfp].activity      = |rx_link_activity; // For LED use
      // assign stat_reg.mcu_led_status[index_qsfp].link_change   = |link_change_detect; // For LED use
      // assign stat_reg.mcu_led_status[index_qsfp].down          = ~|link_up_status_old;  // For LED use
      // assign stat_reg.mcu_led_status[index_qsfp].error         = |rx_error_led; // For LED use
      assign stat_reg.mcu_led_status[0].activity      = |rx_link_activity; // For LED use
      assign stat_reg.mcu_led_status[0].link_change   = |link_change_detect; // For LED use
      assign stat_reg.mcu_led_status[0].down          = ~|link_up_status_old;  // For LED use
      assign stat_reg.mcu_led_status[0].error         = |rx_error_led; // For LED use

      // for (index_gt=0; index_gt<NUMB_GT_PER_QSFP; index_gt++) begin
      //   assign stat_reg.mcu_led_status[index_gt].activity      = rx_link_activity[index_gt]; // For LED use
      //   assign stat_reg.mcu_led_status[index_gt].link_change   = link_change_detect[index_gt]; // For LED use
      //   assign stat_reg.mcu_led_status[index_gt].down          = !link_up_status_old[index_gt]; // For LED use
      //   assign stat_reg.mcu_led_status[index_gt].error         = rx_error_led[index_gt]; // For LED use
      //   // assign stat_reg.rx_path_status[index_gt].link_activity = '0;
      //   // assign stat_reg.rx_path_status[index_gt].link_has_been_down = '0;
      //   // assign stat_reg.tx_path_status[index_gt].invalid_tx_packet = '0;
      //   // assign stat_reg.tx_mcu_led_status[index_gt].tx_link_change = '0;
      //   // assign stat_reg.tx_mcu_led_status[index_gt].tx_down = '0;
      //   // assign stat_reg.tx_mcu_led_status[index_gt].tx_activity = '0;
      //   // assign stat_reg.tx_mcu_led_status[index_gt].tx_error = '0;
      // end
             
      // Mapping control and status signals
      for (genvar index_gt = 0; index_gt < NUMB_GT_PER_QSFP; index_gt++ ) begin: reg_mapping
        
        // Control
        assign gt_loopback_mode[index_gt]        = ctrl_reg.gt_ctrl.loopback[index_gt];
        assign gtwiz_reset_tx_datapath[index_gt] = gtwiz_reset_tx_datapath_int[index_gt] | tx_ext_reset[index_gt];
        assign gtwiz_reset_rx_datapath[index_gt] = gtwiz_reset_rx_datapath_int[index_gt] | rx_ext_reset[index_gt];
        assign rxcdrhold[index_gt] = gt_loopback_mode[index_gt] == 3'b001 ? 1'b1 : 1'b0; // assert rxcdrhold in Near-end PCS Loopback mode

        always @(posedge drp_clk_i) begin
          link_up_status_old[index_gt] <= stat_reg.rx_path_status[index_gt].link_up;
          link_change_detect[index_gt] <= link_up_status_old[index_gt] ^ stat_reg.rx_path_status[index_gt].link_up; 
        end
                
        always @(*) begin
          stat_reg.rx_path_status[index_gt].link_activity = rx_link_activity[index_gt];

          if (drp_rst_i) begin
            stat_reg.rx_path_status[index_gt].link_activity = 0;
          end
        end
        
        // Move external RX/TX power down to tx_clk domain
        nb_cdc_reg #(
          .WIDTH     (1),
          .INITVALUE (1'b1)
          ) i_nb_cdc_reg_txpd (
          .sdata_i   (ctrl_reg.gt_ctrl.tx_pwrdn[index_gt]),
          .dclk_i    (tx_core_clk[index_qsfp][index_gt]),
          .ddata_o   (ext_txpd[index_gt])
          );
        nb_cdc_reg #(
          .WIDTH     (1),
          .INITVALUE (1'b1)
          ) i_nb_cdc_reg_rxpd (
          .sdata_i   (ctrl_reg.gt_ctrl.rx_pwrdn[index_gt]),
          .dclk_i    (tx_core_clk[index_qsfp][index_gt]),
          .ddata_o   (ext_rxpd[index_gt])
          );
        
        // Move external fault condition ctrl to tx_clk domain
        nb_cdc_reg #(
          .WIDTH     (9),
          .INITVALUE ('0)
          ) i_nb_cdc_reg_fault_condition_ctrl (
          .sdata_i   (ctrl_reg.fault_condition_ctrl[index_gt]),
          .dclk_i    (tx_core_clk[index_qsfp][index_gt]),
          .ddata_o   (fault_condition_ctrl[index_gt])
          );
        
        // Move external RX/TX reset to tx_clk domain
        nb_cdc_reg #(.WIDTH(1)) i_nb_cdc_reg_tx_reset (
          .sdata_i   (ctrl_reg.gt_ctrl.tx_reset[index_gt]),
          .dclk_i    (tx_core_clk[index_qsfp][index_gt]),
          .ddata_o   (tx_ext_reset[index_gt])
          );
        nb_cdc_reg #(.WIDTH(1)) i_nb_cdc_reg_rx_reset (
          .sdata_i   (ctrl_reg.gt_ctrl.rx_reset[index_gt]),
          .dclk_i    (tx_core_clk[index_qsfp][index_gt]),
          .ddata_o   (rx_ext_reset[index_gt])
          );
      end // block: reg_mapping

      //// Eye scan control, register hub and register targets
      nb_reg_access_if reg_acc_sub_eye_scan_hub[NUMB_GT_PER_QSFP]();
      nb_reg_acc_hub #(
        .PAR                 (0),
        .FANOUT              (NUMB_GT_PER_QSFP)
        ) i_nb_reg_acc_hub_sub_eye_scan (
        .clk_i               (drp_clk_i),
        .rst_i               (drp_rst_i),
        .reg_acc_master_side (reg_acc_main_eye_scan_hub[index_qsfp]),
        .reg_acc_slave_side  (reg_acc_sub_eye_scan_hub.master_reg_acc_ser)
        );
      
      logic [NUMB_GT_PER_QSFP-1:0] eyescan_reset;
      logic [NUMB_GT_PER_QSFP-1:0] rx_lpm_en;
      logic [NUMB_GT_PER_QSFP-1:0] rx_dfe_lpm_reset;
      logic [NUMB_GT_PER_QSFP-1:0] rx_pma_reset;

      for (genvar index_gt = 0; index_gt < NUMB_GT_PER_QSFP; index_gt++ ) begin: eye_scan_inst
        // Register node
        nb_reg_target_if eye_scan_reg_target();
        nb_reg_acc_node #(
          .PAR    (0),
          .TGT_ID (TGT_ID_EYE_SCAN[index_qsfp*4+index_gt])
          ) i_nb_reg_acc_node_eye_scan (
          .clk_i      (drp_clk_i),
          .rst_i      (drp_rst_i),
          .reg_acc    (reg_acc_sub_eye_scan_hub[index_gt].slave_reg_acc_ser),
          .reg_target (eye_scan_reg_target)
          );

        // Register target
        nb_eye_scan_ctrl_t eye_scan_ctrl_reg;
        nb_eye_scan_ctrl_target i_eye_scan_ctrl_target (
          .clk_i         (drp_clk_i),
          .nb_reg_struct (eye_scan_ctrl_reg),
          .reg_target    (eye_scan_reg_target)
          );
        
        // Mapping
        assign eyescan_reset[index_gt]    = eye_scan_ctrl_reg.eyescan_reset;
        assign rx_lpm_en[index_gt]        = eye_scan_ctrl_reg.rx_lpm_en;
        assign rx_dfe_lpm_reset[index_gt] = eye_scan_ctrl_reg.rx_dfe_lpm_reset;
        assign rx_pma_reset[index_gt]     = eye_scan_ctrl_reg.rx_pma_reset;
      end // block: eye_scan_inst
      
      ///////////////////////////////////////////////////      
      // MAC Enable/Disable Controller
      logic [NUMB_GT_PER_QSFP-1:0] rx_status;
      (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0] rx_status_sync;
      logic [NUMB_GT_PER_QSFP-1:0] rx_reset_gt;
      (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0] rx_enable;
      (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0] stat_enable;
      (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0] rx_sop_valid;
      (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0] tx_valid;

      for(genvar index_gt = 0; index_gt < NUMB_GT_PER_QSFP; index_gt++) begin : timer_mapping
        // rx_status to tx_clk domain
        nb_cdc_reg #(.WIDTH(1)) i_nb_cdc_reg_rx_status (
        .sdata_i   (rx_status[index_gt]),
        .dclk_i    (tx_core_clk[index_qsfp][index_gt]),
        .ddata_o   (rx_status_sync[index_gt])
          );
        
        eth_mac_ctrl_10g #( 
          .RESET_TIMER_MAX  (RESET_TIMER_MAX),
          .ENABLE_TIMER_MAX (ENABLE_TIMER_MAX),
          .FRAME_TIMER_MAX  (FRAME_TIMER_MAX)
          ) i_eth_mac_ctrl_1g (
          // Signals in DRP clock domain
          .drp_clk_i        (drp_clk_i),
          .drp_rst_i        (drp_rst_i),
	        .rx_path_ctrl_i   (ctrl_reg.rx_path_ctrl[index_gt]),
	        .tx_path_ctrl_i   (ctrl_reg.tx_path_ctrl[index_gt]),
          .rx_reset_o       (rx_reset_gt[index_gt]),
          // Signals in RX clock domain
          .rx_clk_i         (rx_core_clk[index_qsfp][index_gt]),
          .rx_rst_i         (rx_user_reset[index_qsfp][index_gt]),
          .rx_status_i      (rx_status_sync[index_gt]),
          .rx_enable_o      (rx_enable[index_gt]),
          .stat_enable_o    (stat_enable[index_gt]),
          .rx_sop_valid_o   (rx_sop_valid[index_gt]),
          // Signals in TX clock domain
          .tx_clk_i         (tx_core_clk[index_qsfp][index_gt]),
          .tx_sop_i         (mac_tx_if[index_qsfp*4 + index_gt].sop[0]),
          .tx_eop_i         (mac_tx_if[index_qsfp*4 + index_gt].eop[0]),
          .tx_valid_i       (mac_tx_if[index_qsfp*4 + index_gt].data_valid[0]),
          .tx_valid_o       (tx_valid[index_gt])
          );

        // Set register flags
        always @(posedge drp_clk_i ) begin
          stat_reg.rx_path_status[index_gt].link_has_been_down <= rx_reset_gt[index_gt];
        end

        nb_cdc_reg #(
          .WIDTH     (1),
          .INITVALUE (1'b0)
          ) i_nb_cdc_reg_rx_link_up (
          .sdata_i   (stat_enable[index_gt]),
          .dclk_i    (drp_clk_i),
          .ddata_o   (stat_reg.rx_path_status[index_gt].link_up)
          );
      end // block: timer_mapping
      

      ////////////////////////////////////////////////////////////////////////////////
      // REMOTE / LOCAL FAULT HANDLER
      logic [3:0] tx_local_fault; 
      logic [3:0] tx_remote_fault; 
      (* mark_debug = "true" *)logic [3:0] tx_idle; 

      for(genvar index_gt = 0; index_gt < NUMB_GT_PER_QSFP; index_gt++) begin : local_remote_fault_mapping
        always @(posedge tx_core_clk[index_qsfp][index_gt] ) begin
          tx_local_fault[index_gt]  <= fault_condition_ctrl[index_gt].send_local_fault | 
                                       rx_local_fault[index_gt] & fault_condition_ctrl[index_gt].send_local_fault_on_local_fault | 
                                       rx_remote_fault[index_gt] & fault_condition_ctrl[index_gt].send_local_fault_on_remote_fault;

          tx_remote_fault[index_gt] <= fault_condition_ctrl[index_gt].send_remote_fault | 
                                       rx_local_fault[index_gt] & fault_condition_ctrl[index_gt].send_remote_fault_on_local_fault | 
                                       rx_remote_fault[index_gt] & fault_condition_ctrl[index_gt].send_remote_fault_on_remote_fault;

          tx_idle[index_gt]         <= fault_condition_ctrl[index_gt].send_idle | 
                                       rx_local_fault[index_gt] & fault_condition_ctrl[index_gt].send_idle_on_local_fault | 
                                       rx_remote_fault[index_gt] & fault_condition_ctrl[index_gt].send_idle_on_remote_fault;
        end
      end // block: local_remote_fault_mapping


      ////////////////////////////////////////////////////////////////////////////////
      // Shared logic 
      // logic gtref_clk;
      // logic [NUMB_GT_PER_QSFP-1:0] txoutclk;
      // logic userclk;
      // logic userclk2;
      // logic [NUMB_GT_PER_QSFP-1:0] rxoutclk;
      // logic [NUMB_GT_PER_QSFP-1:0] rxuserclk, rxuserclk2;
      // logic [NUMB_GT_PER_QSFP-1:0] rxuserclk_out, rxuserclk2_out;
      // logic mmcm_locked;
      // logic mmcm_rst;
      logic [NUMB_GT_PER_QSFP-1:0] gtpowergood;
      logic gtpowergood_all;
      assign gtpowergood_all = &gtpowergood;

      // kup_macpcs_1g_support_clocks i_axi_ethernet_support_clocking
      //   (
      //   // GT ref clock
      //   .mgt_clk_p  (gt_refclk_p[index_qsfp]), // input wire
      //   .mgt_clk_n  (gt_refclk_n[index_qsfp]), // input wire
      //   .gtref_clk  (gtref_clk),              // output wire, 125 MHz GT ref clk routed through an IBUFG
      //   // GT txoutclk
      //   .txoutclk   (txoutclk[0]), // input wire, 125 MHz GT0 generated clock
      //   .userclk    (userclk),                // output wire, 62.5 MHz GT PMA ref clock
      //   .userclk2   (userclk2),               // output wire, 125 MHz core ref clock
      //   // GT rxoutclk (unused, generated below for each port)
      //   .rxoutclk   (1'b0), // input wire, 125 MHz GT0 generated clock
      //   .rxuserclk  (),     // output wire, 62.5 MHz GT PMA ref clock
      //   .rxuserclk2 (),     // output wire, 125 MHz core ref clock
      //   // Ctrl and status
      //   .locked     (mmcm_locked),                          // output wire
      //   .reset      (mmcm_rst | !gtpowergood_all) // input wire
      //     );
      logic gtref_clk;
      IBUFDS_GTE4 ibufds_gtrefclk (.I (gt_refclk_p[index_qsfp]), .IB (gt_refclk_n[index_qsfp]), .CEB (1'b0), .O (gtref_clk));

      logic pma_reset;
      logic sys_rst_int; 
      assign sys_rst_int = drp_rst_i | ctrl_reg.core.reset;
      kup_macpcs_1g_support_resets i_axi_ethernet_support_resets // TODO: rename here and in eth_1g.xdc
        (
        .ref_clk      (drp_clk_i),   // input wire
        .locked       (1'b1), // input wire
        .resetn       (~sys_rst_int),//~s_axi_lite_reset), // input wire
        .mmcm_rst_out (),    // output wire
        .pma_reset    (pma_reset)    // output wire
          );

      
      logic [3:0] rx_bad_fcs; // TODO
      // (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0] gtwiz_reset_rx_done_in;
      // (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0]        gtwiz_reset_rx_pll_and_datapath_out;
      // (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0] gtwiz_userclk_rx_active_out;
      // (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0] [15:0] gtwiz_userdata_rx_in;
      // (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0]        gtwiz_buffbypass_rx_reset_out;
      // (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0]        gtwiz_buffbypass_rx_start_user_out;
      // (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0] gtwiz_buffbypass_rx_done_in;
      // logic [NUMB_GT_PER_QSFP-1:0] rxcommadeten_out;
      // (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0] rxresetdone_in;
      // (* mark_debug = "true" *)logic [NUMB_GT_PER_QSFP-1:0] rxpmaresetdone_in;
      // logic [NUMB_GT_PER_QSFP-1:0] rx8b10ben_out;
      // logic [NUMB_GT_PER_QSFP-1:0] rxmcommaalignen_out;
      // logic [NUMB_GT_PER_QSFP-1:0] rxpcommaalignen_out;
      // logic [NUMB_GT_PER_QSFP-1:0][15:0] rxctrl0_in, rxctrl1_in;
      // logic [NUMB_GT_PER_QSFP-1:0][7:0]  rxctrl2_in, rxctrl3_in;


      //---------------------------------------------------------------------
      // For each transceiver generate the following:
      // - RX clocks from gtref_clk
      // - Transceiver wrapper
      // - MAC and PCS/PMA cores
      // - Eth statistics module
      //---------------------------------------------------------------------
      for (genvar index_gt=0; index_gt<NUMB_GT_PER_QSFP; index_gt=index_gt+1) begin : macpcs_inst

        logic txoutclk;
        logic userclk, userclk2;
        BUFG_GT usrclk2_bufg_inst   (.I (txoutclk ), .CE (1'b1     ), .O   (userclk2));
        BUFG_GT usrclk_bufg_inst    (.I (txoutclk ), .CE (1'b1     ), .DIV (3'b001  ), .O (userclk  ));
        logic rxoutclk, rxoutclk_buf;
        logic rxuserclk, rxuserclk2;
        BUFG_GT rxrecclk_bufg   ( .I(rxoutclk), .O(rxoutclk_buf), .CE(1'b1));
        assign rxuserclk2 = rxoutclk_buf;
        assign rxuserclk  = rxoutclk_buf;

        logic mmcm_rst;
        logic mmcm_locked;
        assign mmcm_locked = 1'b1;

        // RX clocks
        // logic rxoutclk_buf;
        // BUFG_GT i_rxrecclk_bufg (.I(rxoutclk[NUMB_GT_PER_QSFP-1 - index_gt]), .O(rxoutclk_buf), .CE(1'b1), .DIV(3'b000));
        // assign rxuserclk2[NUMB_GT_PER_QSFP-1 - index_gt] = rxoutclk_buf;
        // assign rxuserclk[NUMB_GT_PER_QSFP-1 - index_gt]  = rxoutclk_buf;

        // logic userclk_out, userclk2_out;
        
        // Internal signals for Core/Transceiver connections
        // logic gtwiz_reset_clk_freerun_out;
        // (* mark_debug = "true" *)logic gtwiz_reset_tx_done_in;
        // logic gtwiz_reset_tx_pll_and_datapath_out;
        // (* mark_debug = "true" *)logic gtwiz_userclk_tx_active_out;
        // logic [15:0] gtwiz_userdata_tx_out;
        // logic        tx8b10ben_out;
        // logic        txelecidle_out;
        // (* mark_debug = "true" *)logic        txresetdone_in;
        // logic [1:0]  txbufstatus_in;
        // logic        cplllock;
        // logic [15:0] txctrl0_out, txctrl1_out;
        // logic [7:0]  txctrl2_out;

        logic phy_rst_n; 
        logic signal_detect; 

        // PCS/PMA core status vector (PG047 v16.1 table 2-41)
        // [0]: Link Status
        // [1]: Link Synchronization
        (* mark_debug = "true" *)logic [15:0] pcs_pma_status_vec; // Only bit [6:0] are driven
        (* dont_touch = "true" *)logic [15:0] debug_vec;
        assign debug_vec[15:0] = pcs_pma_status_vec[15:0];

        // Transceiver wrapper
        // kup_macpcs_1g_support_gt i_kup_macpcs_1g_gt_wrapper
        //   (
        //   // GT ref clock
        //   .gtrefclk0_in                       (gtref_clk), // input wire, 125 MHz GT ref clk from IBUFDS used when cpllrefclksel_in = 3'b001
        //   .gtrefclk1_in                       (1'b0),      // input wire, unused 
        //   .cpllrefclksel_in                   (3'b001), // use gtrefclk0_in as source clock (see UG578)
        //   .cplllock_out                       (cplllock), // output wire

        //   // External data pins
        //   .gtyrxn_in                          (gt_rx_n[index_qsfp][NUMB_GT_PER_QSFP-1 - index_gt]), // input wire
        //   .gtyrxp_in                          (gt_rx_p[index_qsfp][NUMB_GT_PER_QSFP-1 - index_gt]), // input wire
        //   .gtytxn_out                         (gt_tx_n[index_qsfp][index_gt]), // output wire
        //   .gtytxp_out                         (gt_tx_p[index_qsfp][index_gt]), // output wire

        //   // TX/RX clocks to clock buffers
        //   .txoutclk_out                       (txoutclk[index_gt]), // output wire, 125 MHz generated clock from gtrefclk
        //   .rxoutclk_out                       (rxoutclk[NUMB_GT_PER_QSFP-1 - index_gt]), // output wire, 125 MHz generated clock from gtrefclk

        //   // TX/RX user clocks from clock buffers
        //   .txusrclk_in                        (userclk_out), // input wire (expects 62.5 MHz clock)
        //   .txusrclk2_in                       (userclk_out), // input wire (expects 62.5 MHz clock)

        //   .rxusrclk_in                        (rxuserclk_out[NUMB_GT_PER_QSFP-1 - index_gt]), // input wire (expects 62.5 MHz clock)
        //   .rxusrclk2_in                       (rxuserclk2_out[NUMB_GT_PER_QSFP-1 - index_gt]), // input wire (expects 62.5 MHz clock)

        //   // DRP
        //   .drpclk_in                          (config_clk_i),
        //   .drpaddr_in                         (drpaddr_in[index_gt]),
        //   .drpdi_in                           (drpdi_in[index_gt]),
        //   .drpen_in                           (drpen_in[index_gt]),
        //   .drpwe_in                           (drpwe_in[index_gt]),
        //   .drpdo_out                          (drpdo_out[index_gt]),
        //   .drprdy_out                         (drprdy_out[index_gt]),

        //   // Eyescan
        //   .eyescanreset_in                    (eyescan_reset[index_gt]),
        //   .eyescantrigger_in                  (1'b0),

        //   .gtwiz_reset_all_in                 (gtwiz_reset_all[index_gt]),
        //   .gtwiz_reset_clk_freerun_in         (gtwiz_reset_clk_freerun_out),
        //   .gtwiz_reset_rx_datapath_in         (gtwiz_reset_rx_datapath[NUMB_GT_PER_QSFP-1 - index_gt] | rx_reset_gt[index_gt]),
        //   .gtwiz_reset_rx_done_out            (gtwiz_reset_rx_done_in[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .gtwiz_reset_rx_pll_and_datapath_in (gtwiz_reset_rx_pll_and_datapath_out[NUMB_GT_PER_QSFP-1 - index_gt] | ~gtpowergood_all),
        //   .gtwiz_reset_tx_datapath_in         (gtwiz_reset_tx_datapath[index_gt]),
        //   .gtwiz_reset_tx_done_out            (gtwiz_reset_tx_done_in),
        //   .gtwiz_reset_tx_pll_and_datapath_in (gtwiz_reset_tx_pll_and_datapath_out | ~gtpowergood_all),
        //   .gtwiz_userclk_rx_active_in         (gtwiz_userclk_rx_active_out[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .gtwiz_userclk_tx_active_in         (gtwiz_userclk_tx_active_out),
        //   .gtwiz_userclk_tx_reset_in          (gtwiz_reset_tx_datapath[index_gt]),
        //   .gtwiz_userdata_rx_out              (gtwiz_userdata_rx_in[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .gtwiz_userdata_tx_in               (gtwiz_userdata_tx_out),
        //   .txpmaresetdone_out                 (),
        //   .gtwiz_buffbypass_rx_reset_in       (gtwiz_buffbypass_rx_reset_out[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .gtwiz_buffbypass_rx_start_user_in  (gtwiz_buffbypass_rx_start_user_out[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .gtwiz_buffbypass_rx_done_out       (gtwiz_buffbypass_rx_done_in[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .txbufstatus_out                    (txbufstatus_in),
        //   .loopback_in                        (gt_loopback_mode[index_gt]),
        //   .pcsrsvdin_in                       (16'h0000),
        //   .rx8b10ben_in                       (rx8b10ben_out[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .rxcdrhold_in                       (rxcdrhold[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .rxcommadeten_in                    (rxcommadeten_out[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .rxctrl0_out                        (rxctrl0_in[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .rxctrl1_out                        (rxctrl1_in[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .rxctrl2_out                        (rxctrl2_in[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .rxctrl3_out                        (rxctrl3_in[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .rxdfelpmreset_in                   (rx_dfe_lpm_reset[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .rxlpmen_in                         (rx_lpm_en[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .rxmcommaalignen_in                 (rxmcommaalignen_out[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .rxpcommaalignen_in                 (rxpcommaalignen_out[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .rxpcsreset_in                      (1'b0),
        //   .rxpd_in                            ({2{ext_rxpd[index_gt]}}), // input wire [1:0]
        //   .rxpmareset_in                      (pma_reset | rx_pma_reset[index_gt]),
        //   .rxpmaresetdone_out                 (rxpmaresetdone_in[NUMB_GT_PER_QSFP-1 - index_gt]),
        //   .rxpolarity_in                      (1'b0),
        //   .rxprbscntreset_in                  (1'b0),
        //   .rxprbssel_in                       (3'b000),
        //   .rxrate_in                          (2'b00),
        //   .rxresetdone_out                    (rxresetdone_in[NUMB_GT_PER_QSFP-1 - index_gt]),
          
        //   .tx8b10ben_in                       (tx8b10ben_out),
        //   .txctrl0_in                         (txctrl0_out),
        //   .txctrl1_in                         (txctrl1_out),
        //   .txctrl2_in                         (txctrl2_out),
        //   .txdiffctrl_in                      (5'b11000),
        //   .txelecidle_in                      (txelecidle_out),
        //   .txinhibit_in                       (1'b0),
        //   .txpcsreset_in                      (1'b0),
        //   .txpd_in                            ({2{ext_txpd[index_gt]}}), // input wire [1:0]
        //   .txpmareset_in                      (pma_reset),
        //   .txpolarity_in                      (1'b0),
        //   .txpostcursor_in                    (5'b00000),
        //   .txprbsforceerr_in                  (1'b0),
        //   .txprbssel_in                       (3'b000),
        //   .txprecursor_in                     (5'b00000),
        //   .txresetdone_out                    (txresetdone_in),
        //   .gtpowergood_out                    (gtpowergood[index_gt])
        // );

        //---------------------------------------------------------------------
        // Instantiate the MAC/PCS core, if not disabled by NB_ETHPORT_DISABLE
        //---------------------------------------------------------------------
        if(NB_ETHPORT_DISABLE[index_qsfp] == 0) begin

          if (NB_DISABLE_ETH_STAT == 0) begin
            eth_stat #(
              .TGT_ID (TGT_ID_STAT[index_qsfp*4+index_gt])
              ) i_eth_stat (
              .reg_clk_i (drp_clk_i),
              .reg_rst_i (drp_rst_i),
              .reg_access (reg_acc_sub_statistics_hub[index_gt]),
              .tx_clk_i   (tx_core_clk[index_qsfp][index_gt]),
              .tx_rst_i   (tx_user_reset[index_qsfp][index_gt]),
              .rx_clk_i   (rx_core_clk[index_qsfp][index_gt]),
              .rx_rst_i   (rx_user_reset[index_qsfp][index_gt]),
              .stat_if    (ethernet_stat_if[index_gt])
              );
          end
 
          assign ethernet_stat_if[index_gt].rx_packet_bad_fcs = rx_bad_fcs[index_gt];
          assign ethernet_stat_if[index_gt].rx_enable = stat_enable[index_gt];
          assign ethernet_stat_if[index_gt].tx_enable = 1'b1;

          assign ethernet_stat_if[index_gt].rx_block_lock = pcs_pma_status_vec[0]; // Link Status
          // ethernet_stat_if[0].rx_framing_err_valid[0]
          // ethernet_stat_if[0].rx_framing_err[0][0]
          // ethernet_stat_if[0].rx_hi_ber
          // ethernet_stat_if[0].rx_bad_code
          // ethernet_stat_if[0].rx_total_packets
          // ethernet_stat_if[0].rx_total_good_packets
          // ethernet_stat_if[0].rx_total_bytes
          // ethernet_stat_if[0].rx_total_good_bytes
          // ethernet_stat_if[0].rx_packet_small
          // ethernet_stat_if[0].rx_jabber
          // ethernet_stat_if[0].rx_packet_large
          // ethernet_stat_if[0].rx_oversize
          // ethernet_stat_if[index_gt].rx_undersize
          // ethernet_stat_if[0].rx_fragment
          // ethernet_stat_if[0].rx_local_fault
          assign ethernet_stat_if[index_gt].rx_local_fault = !pcs_pma_status_vec[0] | // Link status
                                                             !pcs_pma_status_vec[1] | // Link synchronization
                                                              pcs_pma_status_vec[4] | // RUDI(INVALID)
                                                              pcs_pma_status_vec[5] | // RXDISPERR
                                                              pcs_pma_status_vec[6];  // RXNOTINTABLE
          // ethernet_stat_if[0].rx_remote_fault
          assign ethernet_stat_if[index_gt].rx_remote_fault = pcs_pma_status_vec[13]; // Remote Fault
          // ethernet_stat_if[0].rx_int_local_fault
          // ethernet_stat_if[0].rx_rcv_local_fault
          // ethernet_stat_if[0].tx_underflow
          // ethernet_stat_if[0].tx_total_packets
          // ethernet_stat_if[0].tx_total_bytes
          // ethernet_stat_if[0].tx_packet_small
          // ethernet_stat_if[0].tx_packet_large
          // ethernet_stat_if[0].tx_bad_fcs
          // ethernet_stat_if[0].tx_frame_error
          // ethernet_stat_if[0].tx_local_fault

          assign rx_status[index_gt] = pcs_pma_status_vec[0]; // Link Status
          
          nb_cdc_reg #(
            .WIDTH(1),
            .INITVALUE ('0)
            ) i_nb_cdc_reg_rx_remote_fault (
            .sdata_i   (ethernet_stat_if[index_gt].rx_remote_fault),
            .dclk_i    (tx_core_clk[index_qsfp][index_gt]),
            .ddata_o   (rx_remote_fault[index_gt])
            );
          
          nb_cdc_reg #(
            .WIDTH(1),
            .INITVALUE ('0)
            ) i_nb_cdc_reg_rx_local_fault (
            .sdata_i   (ethernet_stat_if[index_gt].rx_local_fault),
            .dclk_i    (tx_core_clk[index_qsfp][index_gt]),
            .ddata_o   (rx_local_fault[index_gt])
            );


          // // Instantiate 1G MAC and PCS/PMA core
          // kup_macpcs_1g 
          //   #(.IMPL_NB_MAC_CORE(NB_USE_NB_1G_MAC_CORE))
          //   i_kup_macpcs_1g (   
          //   .tx_mac_aclk         (tx_core_clk[index_qsfp][index_gt]), // output wire, user logic clock from userclk2 input
          //   .rx_mac_aclk         (rx_core_clk[index_qsfp][index_gt]), // output wire, user logic clock from rxuserclk2 input
          //   .glbl_rst            (sys_rst_int), // input wire
          //   .tx_ifg_delay        (8'h0), // custom interframe gap delay
          //   .pma_reset           (pma_reset | rx_pma_reset[index_gt]), // input wire
          //   .tx_reset            (tx_user_reset[index_qsfp][index_gt]), // output wire
          //   .rx_reset            (rx_user_reset[index_qsfp][index_gt]), // output wire
            
          //   // Clock outputs to transceiver
          //   .txusrclk_out          (userclk_out), // output wire, from userclk input
          //   .txusrclk2_out         (userclk2_out), // output wire, from userclk input
          //   .rxusrclk_out          (rxuserclk_out[index_gt]), // output wire, from rxuserclk input
          //   .rxusrclk2_out         (rxuserclk2_out[index_gt]), // output wire, from rxuserclk input
            
          //   // User clock inputs from shared support clocking block
          //   .userclk               (userclk), // input wire (expects 62.5 MHz clock)
          //   .userclk2              (userclk2), // input wire (expects 125 MHz clock)
          //   .rxuserclk             (rxuserclk[index_gt]),// input wire (expects 62.5 MHz clock)
          //   .rxuserclk2            (rxuserclk2[index_gt]),// input wire (expects 62.5 MHz clock)
            
          //   .rxpmaresetdone_in     (rxpmaresetdone_in[index_gt]),
          //   .rxresetdone_in        (rxresetdone_in[index_gt]),
          //   .txresetdone_in        (txresetdone_in),
          //   .phy_rst_n             (),
          //   .mmcm_locked           (1'b1), // input wire
          //   .ref_clk               (config_clk_i), // input wire, independent init and CPLL calibration clk
            
          //   .cplllock_in                         (cplllock),
          //   .gtwiz_reset_all_out                 (gtwiz_reset_all[index_gt]),
          //   .gtwiz_reset_clk_freerun_out         (gtwiz_reset_clk_freerun_out), // output wire, identical to ref_clk input
          //   .gtwiz_reset_rx_datapath_out         (gtwiz_reset_rx_datapath_int[index_gt]),
          //   .gtwiz_reset_rx_done_in              (gtwiz_reset_rx_done_in[index_gt]),
          //   .gtwiz_reset_rx_pll_and_datapath_out (gtwiz_reset_rx_pll_and_datapath_out[index_gt]),
          //   .gtwiz_reset_tx_datapath_out         (gtwiz_reset_tx_datapath_int[index_gt]),
          //   .gtwiz_reset_tx_done_in              (gtwiz_reset_tx_done_in),
          //   .gtwiz_reset_tx_pll_and_datapath_out (gtwiz_reset_tx_pll_and_datapath_out),
          //   .gtwiz_userclk_rx_active_out         (gtwiz_userclk_rx_active_out[index_gt]),
          //   .gtwiz_userclk_tx_active_out         (gtwiz_userclk_tx_active_out),
          //   .gtwiz_userdata_rx_in                (gtwiz_userdata_rx_in[index_gt]),
          //   .gtwiz_userdata_tx_out               (gtwiz_userdata_tx_out),
            
          //   .gtwiz_buffbypass_rx_reset_out       (gtwiz_buffbypass_rx_reset_out[index_gt]),
          //   .gtwiz_buffbypass_rx_start_user_out  (gtwiz_buffbypass_rx_start_user_out[index_gt]),
          //   .gtwiz_buffbypass_rx_done_in         (gtwiz_buffbypass_rx_done_in[index_gt]),
          //   .rxbufstatus_in                      (3'b0),
          //   .txbufstatus_in                      (txbufstatus_in),
            
          //   .s_axis_pause_tdata  (16'b0),
          //   .s_axis_pause_tvalid (1'b0),
          
          //   // TX clocked with tx_mac_aclk
          //   .s_axis_tx_tdata     (tx_axis[index_gt].tdata),
          //   .s_axis_tx_tlast     (tx_axis[index_gt].tlast),
          //   .s_axis_tx_tready    (tx_axis[index_gt].tready),
          //   .s_axis_tx_tuser     (tx_axis[index_gt].tuser),
          //   .s_axis_tx_tvalid    (tx_axis[index_gt].tvalid),
          //   // RX clocked with rx_mac_aclk
          //   .m_axis_rx_tdata     (rx_axis[index_gt].tdata),
          //   .m_axis_rx_tlast     (rx_axis[index_gt].tlast),
          //   .m_axis_rx_tuser     (rx_axis[index_gt].tuser),
          //   .m_axis_rx_tvalid    (rx_axis[index_gt].tvalid),
            
          //   .signal_detect         (1'b1), // SFP module cable pull detect input. 1=unused
          //   .status_vector         (pcs_pma_status_vec), // Only bit [6:0] are driven
            
          //   .mdio_mdc              (),     // output wire, optional PCS management
          //   .mdio_mdio_i           (1'b0), // input wire , optional PCS management
          //   .mdio_mdio_o           (),     // output wire, optional PCS management
          //   .mdio_mdio_t           (),     // output wire, optional PCS management
            
          //   .rx8b10ben_out         (rx8b10ben_out[index_gt]),
          //   .rxclkcorcnt_in        (2'b0),
          //   .rxcommadeten_out      (rxcommadeten_out[index_gt]),
          //   .rxctrl0_in            (rxctrl0_in[index_gt]),
          //   .rxctrl1_in            (rxctrl1_in[index_gt]),
          //   .rxctrl2_in            (rxctrl2_in[index_gt]),
          //   .rxctrl3_in            (rxctrl3_in[index_gt]),
          //   .rxmcommaalignen_out   (rxmcommaalignen_out[index_gt]),
          //   .rxpcommaalignen_out   (rxpcommaalignen_out[index_gt]),
          //   .rxpd_out              (int_rxpd[index_gt]), // output wire [1:0]
          //   .tx8b10ben_out         (tx8b10ben_out),
          //   .txctrl0_out           (txctrl0_out),
          //   .txctrl1_out           (txctrl1_out),
          //   .txctrl2_out           (txctrl2_out),
          //   .txelecidle_out        (txelecidle_out),
          //   .txpd_out              (int_txpd[index_gt]), // output wire [1:0]
            
          //   // TX statistics
          //   .tx_statistics_statistics_data  (), // output wire [31:0], clocked with tx_mac_aclk
          //   .tx_statistics_statistics_valid (), // output wire, clocked with tx_mac_aclk
          //   // RX statistics
          //   .rx_statistics_statistics_data  (), // output wire [27:0]
          //   .rx_statistics_statistics_valid (), // output wire
            
          //   // Unused AXI Lite management
          //   .s_axi_araddr      (12'h0), // input wire [11:0]
          //   .s_axi_awaddr      (12'h0), // input wire [11:0]
          //   .s_axi_arready     (),      // output wire
          //   .s_axi_arvalid     (1'b0),  // input wire
          //   .s_axi_awready     (),      // output wire
          //   .s_axi_awvalid     (1'b0),  // input wire
          //   .s_axi_bready      (1'b0),  // input wire
          //   .s_axi_bresp       (),      // output wire [1:0]
          //   .s_axi_bvalid      (),      // output wire
          //   .s_axi_rdata       (),      // output wire [31:0]
          //   .s_axi_rready      (1'b0),  // input wire
          //   .s_axi_rresp       (),      // output wire [1:0]
          //   .s_axi_rvalid      (),      // output wire
          //   .s_axi_wdata       (32'h0), // input wire [31:0]
          //   .s_axi_wready      (),      // output wire
          //   .s_axi_wvalid      (1'b0),  // input wire
          //   .s_axi_lite_clk    (config_clk_i),  // input wire
          //   .s_axi_lite_resetn (1'b0)   // input wire
          //   );
        end // if (NB_ETHPORT_DISABLE[index_qsfp] == 0)


        kup_macpcs_1g
          #(.IMPL_NB_MAC_CORE(NB_USE_NB_1G_MAC_CORE))
        i_kup_macpcs_1g
          (
          .s_axi_lite_resetn (1'b0),   // input wire
          .s_axi_lite_clk    (config_clk_i),  // input wire
          .mac_irq(),
          .tx_mac_aclk(tx_core_clk[index_qsfp][index_gt]), // output wire, user logic clock from userclk2 input
          .rx_mac_aclk(rx_core_clk[index_qsfp][index_gt]), // output wire, user logic clock from rxuserclk2 input
          .tx_reset(tx_user_reset[index_qsfp][index_gt]),
          .rx_reset(rx_user_reset[index_qsfp][index_gt]),
          .glbl_rst(sys_rst_int), // input wire
          .tx_ifg_delay(8'h0),
          .signal_detect         (1'b1), // SFP module cable pull detect input. 1=unused
          .status_vector         (pcs_pma_status_vec),
          .gtpowergood(gtpowergood[index_gt]),
          .s_axi_araddr      (12'h0), // input wire [11:0]
          .s_axi_awaddr      (12'h0), // input wire [11:0]
          .s_axi_arready     (),      // output wire
          .s_axi_arvalid     (1'b0),  // input wire
          .s_axi_awready     (),      // output wire
          .s_axi_awvalid     (1'b0),  // input wire
          .s_axi_bready      (1'b0),  // input wire
          .s_axi_bresp       (),      // output wire [1:0]
          .s_axi_bvalid      (),      // output wire
          .s_axi_rdata       (),      // output wire [31:0]
          .s_axi_rready      (1'b0),  // input wire
          .s_axi_rresp       (),      // output wire [1:0]
          .s_axi_rvalid      (),      // output wire
          .s_axi_wdata       (32'h0), // input wire [31:0]
          .s_axi_wready      (),      // output wire
          .s_axi_wvalid      (1'b0),  // input wire
          // TX clocked with tx_mac_aclk
          .s_axis_tx_tdata     (tx_axis[index_gt].tdata),
          .s_axis_tx_tlast     (tx_axis[index_gt].tlast),
          .s_axis_tx_tready    (tx_axis[index_gt].tready),
          .s_axis_tx_tuser     (tx_axis[index_gt].tuser),
          .s_axis_tx_tvalid    (tx_axis[index_gt].tvalid),
          // RX clocked with rx_mac_aclk
          .m_axis_rx_tdata     (rx_axis[index_gt].tdata),
          .m_axis_rx_tlast     (rx_axis[index_gt].tlast),
          .m_axis_rx_tuser     (rx_axis[index_gt].tuser),
          .m_axis_rx_tvalid    (rx_axis[index_gt].tvalid),
          .s_axis_pause_tdata(16'h0),
          .s_axis_pause_tvalid(1'b0),
          .rx_statistics_statistics_data(),
          .rx_statistics_statistics_valid(),
          .tx_statistics_statistics_data(),
          .tx_statistics_statistics_valid(),

          .sfp_rxn             (gt_rx_n[index_qsfp][NUMB_GT_PER_QSFP-1 - index_gt]),
          .sfp_rxp             (gt_rx_p[index_qsfp][NUMB_GT_PER_QSFP-1 - index_gt]),
          .sfp_txn             (gt_tx_n[index_qsfp][index_gt]),
          .sfp_txp             (gt_tx_p[index_qsfp][index_gt]),
          .pma_reset             (pma_reset | rx_pma_reset[index_gt]),
          .userclk               (userclk           ),
          .userclk2              (userclk2          ),
          .rxuserclk             (rxuserclk         ),
          .rxuserclk2            (rxuserclk2        ),
          .gtref_clk             (gtref_clk         ),
          .txoutclk              (txoutclk          ),
          .rxoutclk              (rxoutclk          ),
          .mmcm_locked           (mmcm_locked       ),
          .mmcm_reset_out        (mmcm_rst),
          .ref_clk               (config_clk_i),

          // DRP ports
          .drp_clk            (config_clk_i), // input wire
          .gt_drp_daddr       (drpaddr_in[index_gt]),//(10'h0 ), // input wire [9:0]
          // .gt_drp_daddr       (10'h0 ), // input wire [9:0]
          .gt_drp_den         (drpen_in[index_gt]),//(1'b0 ), // input wire
          // .gt_drp_den         (1'b0 ), // input wire
          .gt_drp_di          (drpdi_in[index_gt]),//(16'h0), // input wire [15:0]
          // .gt_drp_di          (16'h0), // input wire [15:0]
          .gt_drp_dwe         (drpwe_in[index_gt]),//(1'b0 ), // input wire
          // .gt_drp_dwe         (1'b0 ), // input wire
          .gt_drp_do          (drpdo_out[index_gt]),//(), // output wire [15:0]
          // .gt_drp_do          (), // output wire [15:0]
          .gt_drp_drdy        (drprdy_out[index_gt]),//(), // output wire
          // .gt_drp_drdy        (), // output wire

          // Transceiver debug ports
          .transceiver_debug_txdiffctrl      (5'b11000),// input wire [4:0] - driver swing control, copied from ex design
          .transceiver_debug_eyescantrigger  (1'h0 ), // input wire
          .transceiver_debug_rxbufreset      (1'h0 ), // input wire
          .transceiver_debug_rxpcsreset      (1'h0),  // input wire
          .transceiver_debug_rxpolarity      (1'h0 ), // input wire
          .transceiver_debug_rxprbscntreset  (1'h0 ), // input wire
          .transceiver_debug_rxprbssel       (3'h0 ), // input wire [2:0]
          .transceiver_debug_txinhibit       (1'h0 ), // input wire
          .transceiver_debug_txpcsreset      (1'h0 ), // input wire
          .transceiver_debug_txpolarity      (1'h0 ), // input wire
          .transceiver_debug_txpostcursor    (5'h0 ), // input wire [4:0]
          .transceiver_debug_txprbsforceerr  (1'h0 ), // input wire
          .transceiver_debug_txprbssel       (3'h0 ), // input wire [2:0]
          .transceiver_debug_txprecursor     (5'h0 ), // input wire [4:0]
          .transceiver_debug_rxrate          (3'h0 ), // input wire [2:0]
          .transceiver_debug_cpllrefclksel   (3'h1 ), // input wire [2:0]
          .transceiver_debug_gtrefclk1       (1'b0 ), // input wire
          .transceiver_debug_pcsrsvdin       (16'h0), // input wire [15:0]
          .transceiver_debug_dmonitorout     (), // output wire [15:0]
          .transceiver_debug_eyescandataerror(), // output wire 
          .transceiver_debug_rxbufstatus     (), // output wire [2:0]
          .transceiver_debug_rxcommadet      (), // output wire 
          .transceiver_debug_rxdisperr       (), // output wire [1:0]
          .transceiver_debug_rxnotintable    (), // output wire [1:0]
          .transceiver_debug_rxpmaresetdone  (), // output wire 
          .transceiver_debug_rxprbserr       (), // output wire 
          .transceiver_debug_rxresetdone     (), // output wire 
          .transceiver_debug_txbufstatus     (), // output wire [1:0]
          .transceiver_debug_txresetdone     (), // output wire 
          // Loopback
          .transceiver_debug_loopback        (gt_loopback_mode[index_gt]),// input wire [2:0]
          .transceiver_debug_rxcdrhold       (rxcdrhold[index_gt]),       // input wire
          // Eye scan control
          .transceiver_debug_eyescanreset    (eyescan_reset[index_gt]),    // input wire 
          .transceiver_debug_rxpmareset      (rx_pma_reset[index_gt]),     // input wire
          // .transceiver_debug_rxpmareset      (pma_reset | rx_pma_reset[index_gt]),     // input wire
          .transceiver_debug_txpmareset      (1'h0),                       // input wire
          // .transceiver_debug_txpmareset      (pma_reset),                       // input wire
          .transceiver_debug_rxdfelpmreset   (rx_dfe_lpm_reset[index_gt]), // input wire
          .transceiver_debug_rxlpmen         (1'h1) // input wire, setting this to 1'h0 (DFE mode) causes RXDISPERR in the 8b10b decoding
          // .transceiver_debug_rxlpmen         (rx_lpm_en[index_gt]) // input wire
            );

      end // block: macpcs_inst

      // DRP nodes and hubs      
      nb_reg_access_if reg_acc_main_drp_hub_cdc();
      nb_reg_acc_cdc #(
        .PAR(0)
        ) i_nb_reg_acc_hub_sub_drp_cdc (
        .master_clk_i(drp_clk_i),
        .master_rst_i(drp_rst_i),
        .reg_acc_master_side(reg_acc_main_drp_hub[index_qsfp]),
        .slave_clk_i(config_clk_i),
        .slave_rst_i(config_rst_i),
        .reg_acc_slave_side(reg_acc_main_drp_hub_cdc.master_reg_acc_ser)
        );

      nb_reg_access_if reg_acc_sub_drp_hub[NUMB_GT_PER_QSFP]();
      nb_reg_acc_hub #(
        .PAR                 (0),
        .FANOUT              (NUMB_GT_PER_QSFP)
        ) i_nb_reg_acc_hub_sub_drp (
        .clk_i               (config_clk_i),
        .rst_i               (config_rst_i),
        .reg_acc_master_side (reg_acc_main_drp_hub_cdc[index_qsfp]),
        .reg_acc_slave_side  (reg_acc_sub_drp_hub.master_reg_acc_ser)
        );

              
      for (genvar index_gt = 0; index_gt < NUMB_GT_PER_QSFP; index_gt++ ) begin: drp_mac_gt_inst
        nb_reg_acc_node_drp #(
        .PAR            (0),
        .TGT_ID         (TGT_ID_DRP[ index_qsfp*NUMB_GT_PER_QSFP + index_gt ]),
        .DRP_ADDR_WIDTH (10)
          ) i_nb_reg_acc_mac_drp_node (
        .clk_i          (config_clk_i),
        .rst_i          (config_rst_i),
        .reg_acc        (reg_acc_sub_drp_hub[index_gt].slave_reg_acc_ser),
        .drp_addr_o     (drpaddr_in [index_gt]),//10
        .drp_data_o     (drpdi_in   [index_gt]),//16
        .drp_en_o       (drpen_in   [index_gt]),//1
        .drp_wr_o       (drpwe_in   [index_gt]),//1
        .drp_data_i     (drpdo_out  [index_gt]),//16
        .drp_data_rdy_i (drprdy_out [index_gt])//1
          );
      end // block: drp_mac_gt_inst

      //// Ethernet statistics, register hubs etc.
      nb_reg_acc_hub #(
        .PAR                 (0),
        .FANOUT              (NUMB_GT_PER_QSFP)
        ) i_nb_reg_acc_hub_sub_statistics (
        .clk_i               (drp_clk_i),
        .rst_i               (drp_rst_i),
        .reg_acc_master_side (reg_acc_main_statistics_hub[index_qsfp]),
        .reg_acc_slave_side  (reg_acc_sub_statistics_hub.master_reg_acc_ser)
        );

      
      // Map AXI data to GMII interface
      for (genvar index_gt = 0; index_gt < NUMB_GT_PER_QSFP; index_gt++ ) begin: axi_to_if_mapping
        //// Map TX part - non-clocking due to backpressure
        assign mac_tx_clk_o[index_qsfp*4 + index_gt] = tx_core_clk[index_qsfp][index_gt];
        assign mac_tx_rst_o[index_qsfp*4 + index_gt] = tx_user_reset[index_qsfp][index_gt];
        
        assign mac_tx_if[index_qsfp*4 + index_gt].data_stall[0] = ~tx_axis[index_gt].tready;
        // assign tx_axis[index_gt].tvalid = mac_tx_if[index_qsfp*4 + index_gt].data_valid[0] & tx_valid[index_gt];
        assign tx_axis[index_gt].tvalid = mac_tx_if[index_qsfp*4 + index_gt].data_valid[0]; //FIXME
        assign tx_axis[index_gt].tdata  = {<<byte{mac_tx_if[index_qsfp*4 + index_gt].data[0]}};
        assign tx_axis[index_gt].tlast  = mac_tx_if[index_qsfp*4 + index_gt].eop[0];
        assign tx_axis[index_gt].tuser  = mac_tx_if[index_qsfp*4 + index_gt].error[0];
        
        //// Map RX part
        // assign mac_rx_clk_o[index_qsfp*4 + index_gt] = rx_core_clk[index_qsfp][index_gt];
        assign mac_rx_clk_o[index_qsfp*4 + index_gt] = rx_core_clk[index_qsfp][NUMB_GT_PER_QSFP-1 - index_gt];
        // assign mac_rx_rst_o[index_qsfp*4 + index_gt] = rx_user_reset[index_qsfp][index_gt];
        assign mac_rx_rst_o[index_qsfp*4 + index_gt] = rx_user_reset[index_qsfp][NUMB_GT_PER_QSFP-1 - index_gt];

        logic sop;
        always @(posedge rx_core_clk[index_qsfp][index_gt]) begin
          // On every tvalid, delay tlast into sop which will then be 
          // high on the first tvalid after tlast.
          // Only set sop when enabled determined by link_up status
          // if(rx_axis[NUMB_GT_PER_QSFP-1 - index_gt].tvalid && stat_enable[index_gt]) begin
          if(rx_axis[index_gt].tvalid && stat_enable[index_gt]) begin
            // sop <= rx_axis[NUMB_GT_PER_QSFP-1 - index_gt].tlast;
            sop <= rx_axis[index_gt].tlast;
          end

          if( rx_sop_valid[index_gt] ) begin
            sop <= 1;
          end

          // mac_rx_if[index_qsfp*4 + index_gt].data_valid[0] <= rx_axis[NUMB_GT_PER_QSFP-1 - index_gt].tvalid;
          // mac_rx_if[index_qsfp*4 + index_gt].data[0]       <= {<<byte{rx_axis[NUMB_GT_PER_QSFP-1 - index_gt].tdata}};
          // mac_rx_if[index_qsfp*4 + index_gt].eop[0]        <= rx_axis[NUMB_GT_PER_QSFP-1 - index_gt].tlast;
          // mac_rx_if[index_qsfp*4 + index_gt].sop[0]        <= sop;
          // mac_rx_if[index_qsfp*4 + index_gt].error[0]      <= rx_axis[NUMB_GT_PER_QSFP-1 - index_gt].tuser;
          mac_rx_if[index_qsfp*4 + (NUMB_GT_PER_QSFP-1 - index_gt)].data_valid[0] <= rx_axis[index_gt].tvalid;
          mac_rx_if[index_qsfp*4 + (NUMB_GT_PER_QSFP-1 - index_gt)].data[0]       <= {<<byte{rx_axis[index_gt].tdata}};
          mac_rx_if[index_qsfp*4 + (NUMB_GT_PER_QSFP-1 - index_gt)].eop[0]        <= rx_axis[index_gt].tlast;
          mac_rx_if[index_qsfp*4 + (NUMB_GT_PER_QSFP-1 - index_gt)].sop[0]        <= sop;
          mac_rx_if[index_qsfp*4 + (NUMB_GT_PER_QSFP-1 - index_gt)].error[0]      <= rx_axis[index_gt].tuser;
        end // always @ (posedge rx_core_clk[index_qsfp][index_gt])
        

        // Transfer SOP signals to DRP clock domain to set sticky bit in register
        nb_cdc_reg_pulse i_nb_cdc_reg_rx_link_activity (
          .sclk_i    (rx_core_clk[index_qsfp][index_gt]),
          // .sdata_i   (sop & rx_axis[NUMB_GT_PER_QSFP-1 - index_gt].tvalid),
          .sdata_i   (sop & rx_axis[index_gt].tvalid),
          .dclk_i    (drp_clk_i),
          .ddata_o   (rx_link_activity[index_gt])
          );

        // Transfer error signals to DRP clock domain to set sticky bit in register
        nb_cdc_reg_pulse i_nb_cdc_reg_rx_error_led (
          .sclk_i    (rx_core_clk[index_qsfp][index_gt]),
          // .sdata_i   (rx_axis[NUMB_GT_PER_QSFP-1 - index_gt].tuser),
          .sdata_i   (rx_axis[index_gt].tuser),
          .dclk_i    (drp_clk_i),
          .ddata_o   (rx_error_led[index_gt])
          );

      end // block: axi_to_if_mapping
    end // block: qsfp_inst
    
  endgenerate
  
endmodule  

