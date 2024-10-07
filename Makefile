RTL=rtl/glasfaser.v rtl/spiflashro32.v rtl/spdif.v rtl/spdif_core.v

glasfaser_lakritz:
	mkdir -p output
	yosys -DECP5 -q -p "synth_ecp5 -top glasfaser -json output/glasfaser.json" $(RTL)
	nextpnr-ecp5 --25k --package CABGA256 --lpf boards/lakritz.lpf --json output/glasfaser.json --textcfg output/glasfaser_out.config
	ecppack -v --compress --freq 2.4 output/glasfaser_out.config --bit output/glasfaser.bit

prog_lakritz:
	openFPGALoader -c usb-blaster output/glasfaser.bit

prog_riegel:
	ldprog -s output/glasfaser.bin

prog_mozart_ml1:
	openFPGALoader -c dirtyJtag output/glasfaser.bit

gen_sine:
	ffmpeg -f lavfi -i "sine=frequency=1000:duration=5" -ac 2 -ar 48000 -f s16le -c:a pcm_s16le sine.pcm

clean:
	rm -f output/*
