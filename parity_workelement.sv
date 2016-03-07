import CAPI::*;

typedef enum {
  START,
  WAITING_FOR_REQUEST,
  REQUEST_STRIPES,
  WAITING_FOR_STRIPES,
  WRITE_PARITY,
  DONE
} state;

module parity_workelement (
  input logic clock,
  input logic enabled,
  input logic reset,
  input pointer_t wed,
  input BufferInterfaceInput buffer_in,
  input ResponseInterface response,
  output CommandInterfaceOutput command_out,
  output BufferInterfaceOutput buffer_out
);

  state current_state;

  assign command_out.abt = 0,
         command_out.context_handle = 0,
         buffer_out.read_latency = 1,
         command_out.command_parity = ~^command_out.command,
         command_out.address_parity = ~^command_out.address,
         command_out.tag_parity = ~^command_out.tag,
         buffer_out.read_parity = ~^buffer_out.read_data;

  always_ff @ (posedge clock) begin
    if (reset) begin
      current_state <= START;
    end else if (enabled) begin
      case(current_state)
        START: begin
          $display("Started!");
        end
      endcase
    end
  end

endmodule
