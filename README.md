# Glasfaser Pmod&trade; compatible module

Glasfaser is a 6-pin Pmod™ compatible module intended for optical audio output.

![Glasfaser](https://github.com/machdyne/glasfaser/blob/c28f46764bddda621d91494f22e8efc8d2f5e074/glasfaser.png)

This repo contains pinouts and example gateware.

## Verilog Demo

The demo plays a loop of 5 seconds of 48KHz 16-bit (LE) signed PCM stereo audio from flash memory. This was tested on [Lakritz](https://github.com/machdyne/lakritz) but can be easily adapted to any board with a PMOD socket.

## Pinout

### PMOD

| Signal | Pin |
| ------ | --- |
| AUDIO\_IN | 1 |
| NC | 2 |
| NC | 3 |
| NC | 4 |
| GND | 5 |
| 3V3 | 6 |

# License

The contents of this repo are released under the [Lone Dynamics Open License](LICENSE.md) with the following exception:

  * The SPDIF encoder (rtl/spdif.v and rtl/spdif\_core.v) are from [https://github.com/ultraembedded/cores](https://github.com/ultraembedded/cores) and were released under GNU General Public License V2.
