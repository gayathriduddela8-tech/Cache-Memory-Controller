# Cache Memory Controller Using Verilog

## 📌 Project Overview

This project implements a simple 4-line direct-mapped cache memory controller using Verilog HDL.

The cache controller provides an interface between a CPU and main memory. It checks whether requested data is available in the cache. If the data is available, a cache hit occurs. Otherwise, a cache miss occurs and the controller obtains the data from main memory and stores it in the cache.

## 🎯 Objectives

The objectives of this project are:

* Understand the basic concept of cache memory.
* Design a direct-mapped cache using Verilog.
* Implement cache hit and cache miss detection.
* Store data and tag information in cache lines.
* Interface the cache with a simple main memory model.
* Verify the design using a Verilog testbench.
* Observe the operation using simulation waveforms.

## 🧠 Cache Architecture

This project uses:

* 8-bit address
* 8-bit data
* 4 cache lines
* Direct-mapped cache
* 5-bit tag
* 2-bit index
* 1-bit unused offset
* Write-through policy

### Address Format

```text
  7             3 2       1 0
 ┌───────────────┬─────────┬─┐
 │      TAG      │  INDEX  │ │
 │    5 bits     │ 2 bits  │ │
 └───────────────┴─────────┴─┘
```

## 🔍 Cache Hit

A cache hit occurs when:

```text
Valid bit = 1
AND
Stored tag = Requested tag
```

When a hit occurs, data is directly supplied from the cache.

## ❌ Cache Miss

A cache miss occurs when:

```text
Valid bit = 0
OR
Stored tag != Requested tag
```

During a miss, the controller requests data from main memory and updates the appropriate cache line.

## ✏️ Write Operation

This project uses a simple write-through policy.

When the CPU writes data:

1. The cache is updated.
2. The same data is written to main memory.
3. The controller indicates that the operation is ready.

## 📁 Project Structure

```text
cache-memory-controller/
│
├── cache_controller.v
├── cache_controller_tb.v
├── README.md
└── simulation/
    └── waveform.vcd
```

## 🛠️ Tools Used

* Verilog HDL
* Icarus Verilog
* GTKWave
* Visual Studio Code
* ModelSim or Vivado

## 🧪 Test Cases

The testbench performs the following operations:

| Test | Operation | Address | Expected Result |
| ---- | --------- | ------- | --------------- |
| 1    | Read      | `10H`   | Cache Miss      |
| 2    | Read      | `10H`   | Cache Hit       |
| 3    | Read      | `20H`   | Cache Miss      |
| 4    | Write     | `30H`   | Cache Update    |
| 5    | Read      | `30H`   | Cache Hit       |

## ▶️ Running the Simulation

### Step 1: Compile

```bash
iverilog -o cache_sim cache_controller.v cache_controller_tb.v
```

### Step 2: Run

```bash
vvp cache_sim
```

### Step 3: Open Waveform

```bash
gtkwave waveform.vcd
```

## 📈 Important Signals to Observe

In GTKWave, observe:

* `clk`
* `reset`
* `cpu_read`
* `cpu_write`
* `cpu_addr`
* `cpu_write_data`
* `cpu_read_data`
* `cpu_ready`
* `cache_hit`
* `mem_read`
* `mem_write`
* `mem_addr`
* `mem_write_data`

## 📊 Expected Behavior

For the first read of address `10H`, the cache does not contain the requested data, so a **cache miss** occurs.

The data `AAH` is obtained from the simulated main memory and placed into the cache.

When address `10H` is read again, the requested data is already present in the cache, resulting in a **cache hit**.

## 🌟 Advantages

* Faster data access compared with accessing main memory for every request.
* Demonstrates the basic operation of cache memory.
* Simple architecture suitable for learning Verilog.
* Easy to simulate and verify.

## ⚠️ Limitations

This is a simplified educational implementation. A practical processor cache can include:

* Multiple-word cache lines
* Multi-level caches
* Set-associative mapping
* Replacement algorithms
* Write-back or write-through policies
* Dirty bits
* Multi-cycle memory transactions
* Cache coherence mechanisms

## 🚀 Future Improvements

The project can be extended by implementing:

1. 2-way set-associative cache.
2. Larger cache capacity.
3. Multi-byte cache lines.
4. LRU replacement.
5. Write-back cache.
6. Dirty-bit support.
7. Multi-cycle memory interface.
8. Separate instruction and data caches.

## 👨‍💻 Author

**Your Name**

B.Tech – Electronics and Communication Engineering

## 📜 License

This project is intended for educational purposes.
