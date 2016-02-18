import CAPI::*;

module mmio (
  input logic clock,
  input MMIOInterfaceInput mmio_in,
  output MMIOInterfaceOutput mmio_out);

  logic ack;
  logic [0:63] data;

  shift_register ack_shift(
    .clock(clock),
    .in(ack),
    .out(mmio_out.ack));

  shift_register #(64) data_shift(
    .clock(clock),
    .in(data),
    .out(mmio_out.data));

  // Set parity bit for MMIO output
  assign mmio_out.data_parity = ~^mmio_out.data;

  always_ff @(posedge clock) begin
    if(mmio_in.valid) begin
      if(mmio_in.cfg) begin
        if(mmio_in.read) begin
          ack <= 1;
          data <= 1;
        end
      end
    end else begin
      ack <= 0;
      data <= 0;
    end
  end

endmodule
