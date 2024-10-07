/*
 * GLASFASER DEMO
 * Copyright (c) 2024 Lone Dynamics Corporation. All rights reserved.
 *
 * Expects 48KHz 16-bit (LE) signed PCM stereo audio in SPI flash @ 0x000000.
 *
 */

module glasfaser
(

	input CLK_48,

	output SPI_SS_FLASH,
	input SPI_MISO,
	output SPI_MOSI,
`ifndef ECP5
	output SPI_SCK,
`endif

	output AUD_OPTICAL_OUT,

);

	//localparam FLASH_AUDIO_ADDR = 24'h100000;
	localparam FLASH_AUDIO_ADDR = 24'h000000;
	localparam FLASH_AUDIO_SIZE = 24'h0ea600;

`ifdef ECP5
	wire SPI_SCK;
	USRMCLK usrmclk_i (.USRMCLKI(SPI_SCK), .USRMCLKTS(1'b0));
`endif

	// clocks

	wire clk = CLK_48;

	// reset generator

   reg [11:0] resetn_counter = 0;
   wire resetn = &resetn_counter;

   always @(posedge clk) begin
      if (!resetn)
         resetn_counter <= resetn_counter + 1;
   end

	// flash reader

	reg [23:0] flash_addr;
	reg [31:0] flash_data;

	wire flash_ready;

	spiflashro #() flash_i (
		.clk(clk),
		.resetn(resetn),
		.valid(1'b1),
		.ready(flash_ready),
		.addr(flash_addr),
		.rdata(flash_data),
		.ss(SPI_SS_FLASH),
		.sck(SPI_SCK),
		.mosi(SPI_MOSI),
		.miso(SPI_MISO)
	);

	reg [23:0] audio_addr;
	reg [31:0] audio_data;
	wire sample_req;

	always @(posedge clk) begin

		if (!resetn) begin

			audio_addr <= FLASH_AUDIO_ADDR;

		end else begin

			flash_addr <= audio_addr;

			if (flash_ready) begin
				audio_data <= flash_data;
			end

			if (sample_req) begin

				if (audio_addr >= FLASH_AUDIO_ADDR + FLASH_AUDIO_SIZE) begin
					audio_addr <= FLASH_AUDIO_ADDR;
				end else begin
					audio_addr <= audio_addr + 4;
				end

			end	

		end

	end

	spdif #(
		.AUDIO_RATE(48000),
		.AUDIO_CLK_SRC("INTERNAL"),
		.CLK_RATE_KHZ(48000)
	) spdif_i (
		.clk_i(clk),
		.rst_i(!resetn),
		.spdif_o(AUD_OPTICAL_OUT),
		.sample_i(audio_data),
		.sample_req_o(sample_req)
	);

endmodule
