# AXI4-Lite Slave UVM Verification

## Overview

This project implements a **UVM-based verification environment for an AXI4-Lite Slave**.

The testbench verifies AXI4-Lite read and write transactions, protocol handshaking, memory operations, error responses, and functional coverage.

## Features

- AXI4-Lite Write and Read transaction verification
- Independent Write Address and Write Data channel testing
- VALID/READY handshake verification
- WSTRB byte-enable verification
- Read-Only and Write-Only register access testing
- Unaligned address testing
- Out-of-range address testing
- SLVERR and DECERR response checking
- Functional coverage
- SystemVerilog Assertions
- UVM Scoreboard-based checking

