import CAPI::*;

module parity_afu (
  input clock,
  output timebase_request,
  output parity_enabled,
  input JobInterfaceInput job_in,
  output JobInterfaceOutput job_out,
  input CommandInterfaceInput command_in,
  output CommandInterfaceOutput command_out,
  input BufferInterfaceInput buffer_in,
  output BufferInterfaceOutput buffer_out,
  input ResponseInterface response,
  input MMIOInterfaceInput mmio_in,
  output MMIOInterfaceOutput mmio_out);

  always_ff @(posedge clock) begin
    $display("Clock edge!");
  end

endmodule
