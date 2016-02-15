module shift_register (
  input logic clock,
  input logic in,
  output logic out);

  always_ff @ (posedge clock) begin
    out <= in;
  end
endmodule
