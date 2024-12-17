#!/usr/bin/python3
import os
import time
import gpiod
from subprocess import run, PIPE, CalledProcessError

def main():
    # Check if running on a Raspberry Pi
    if not os.path.exists('/sys/class/gpio/'):
        print("ERROR: only runs on Raspberry Pi")
        exit(1)

    # Get the bitfile from the command line argument
    if len(os.sys.argv) < 2:
        print(f"Usage: {os.sys.argv[0]} BITFILE [SIZE]")
        exit(1)

    bitfile = os.sys.argv[1]
    if not os.path.exists(bitfile):
        print(f"ERROR: bitfile not found: {bitfile}")
        exit(1)

    # Define SPI and GPIO parameters
    spidev = "/dev/spidev0.1"
    spispeed = "20000"
    resetpin = 25  # GPIO25
    flashsize = os.sys.argv[2] if len(os.sys.argv) > 2 else None

    print(f"bitfile: {bitfile} ...")

    # Initialize GPIO pins using gpiod (older API)
    chip = gpiod.Chip("gpiochip4")  # Use the correct gpiochip (usually gpiochip0 on Raspberry Pi)
    reset_line = chip.get_line(resetpin)

    # Configure the reset pin as output
    reset_line.request(consumer="reset_pin", type=gpiod.LINE_REQ_DIR_OUT)

    # Set reset pin low
    reset_line.set_value(0)
    time.sleep(1)  # Wait for 1 second

    # Determine flash size if not provided
    if not flashsize:
        try:
            bitsize = os.path.getsize(bitfile)
            result = run(
                ["flashrom", "-p", f"linux_spi:dev={spidev},spispeed={spispeed}", "--flash-size"],
                stdout=PIPE,
                stderr=PIPE,
                text=True
            )
            flashsize = result.stdout.strip().split('\n')[-1]
            if not flashsize.isdigit() or int(flashsize) < bitsize:
                print(f"ERROR: bitfile is too big for the flash: {flashsize} > {bitsize}")
                exit(1)
        except CalledProcessError as e:
            print(f"ERROR: flashrom command failed: {e}")
            exit(1)

    print(f"  fill bitfile with zeros to reach flashsize: {flashsize}")

    # Create a temporary file filled with zeros
    temp_flash_bin = "/tmp/_flash.bin"
    try:
        with open(temp_flash_bin, 'wb') as f:
            f.seek(int(flashsize) - 1)
            f.write(b'\0')
        with open(temp_flash_bin, 'r+b') as f:
            with open(bitfile, 'rb') as bitf:
                f.write(bitf.read())
    except IOError as e:
        print(f"ERROR: dd can not read/write: {e}")
        exit(1)

    print("  write to flash")
    try:
        result = run(
            ["flashrom", "-p", f"linux_spi:dev={spidev},spispeed={spispeed}", "-w", temp_flash_bin],
            stdout=PIPE,
            stderr=PIPE,
            text=True
        )
        if result.returncode != 0:
            print(f"ERROR: flashrom: {result.stderr}")
            print("   retry..")
            result = run(
                ["flashrom", "-p", f"linux_spi:dev={spidev},spispeed={spispeed}", "-w", temp_flash_bin],
                stdout=PIPE,
                stderr=PIPE,
                text=True
            )
            if result.returncode != 0:
                print(f"ERROR: flashrom: {result.stderr}")
                exit(1)
    except CalledProcessError as e:
        print(f"ERROR: flashrom command failed: {e}")
        exit(1)

    print("reset FPGA")
    reset_line.release()
    reset_line.request(consumer="reset_pin", type=gpiod.LINE_REQ_DIR_IN)
    time.sleep(0.2)  

    print("...done")

if __name__ == "__main__":
    main()