import CAPI::*;

typedef enum {
  START,
  WAITING_FOR_REQUEST,
  REQUEST_STRIPES,
  WAITING_FOR_STRIPES,
  WRITE_PARITY,
  DONE
} state;

typedef struct {
  longint unsigned size;
  pointer_t stripe1;
  pointer_t stripe2;
  pointer_t parity;
} parity_request;

typedef enum logic [0:7] {
  REQUEST_READ,
  STRIPE1_READ,
  STRIPE2_READ,
  PARITY_WRITE,
  DONE_WRITE
} request_tag;

function logic [0:63] swap_endianness(logic [0:63] in);
  return {in[56:63], in[48:55], in[40:47], in[32:39], in[24:31], in[16:23],
          in[8:15], in[0:7]};
endfunction

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
  parity_request request;

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
          command_out.command <= READ_CL_NA;
          command_out.tag <= REQUEST_READ;
          command_out.size <= 32;
          command_out.address <= wed;
          command_out.valid <= 1;
          current_state = WAITING_FOR_REQUEST;
        end
        WAITING_FOR_REQUEST: begin
          command_out.valid <= 0;
          if (buffer_in.write_valid &&
              buffer_in.write_tag == REQUEST_READ &&
              buffer_in.write_address == 0) begin
            request.size <= swap_endianness(buffer_in.write_data[0:63]);
            request.stripe1 <= swap_endianness(buffer_in.write_data[64:127]);
            request.stripe2 <= swap_endianness(buffer_in.write_data[128:191]);
            request.parity <= swap_endianness(buffer_in.write_data[192:255]);
          end
          if (response.valid && response.tag == REQUEST_READ) begin
            current_state <= REQUEST_STRIPES;
          end
        end
        REQUEST_STRIPES: begin
          $display("Got WED!");
        end
      endcase
    end
  end

endmodule
