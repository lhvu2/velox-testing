# Instructions for a quick build and benchmark execution

**Assuming your folder structure is as follows:**

`cd $HOME/projects/velox-dev`

You have:
```
.
├── presto
├── velox
└── velox-testing
```

And: `cd $HOME/projects/velox-dev/velox-testing`

You have:
```
.
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── benchmark_data_tools
├── benchmark_reporting_tools
├── ci
├── common
├── nate.patch
├── new_docker_image_name.sh
├── presto
├── pyproject.toml
├── scripts
├── spark_gluten
├── template_rendering
└── velox
```

1. `git apply nate.patch`
  
2. `bash new_docker_image_name.sh velox-adapters-build:latest velox-adapters-build:lhvu`
  
where `velox-adapters-build:lhvu` is the new docker image you want to build and `velox-adapters-build:latest` is the default or existing docker image name.

3. `cd velox/scripts`
  
4. `./build_velox.sh --cpu --benchmarks true`

5. `cd $HOME/projects/velox-dev/velox-testing/benchmark_data_tools`
  
7. `conda create -n py313 python=3.13 ; conda activate py313`

8. `pip install -r requirements.txt`
   
10. `python -u generate_data_files.py -b tpch -d output_data -s 0.1 -c -j 32 -v`

11. `cd $HOME/projects/velox-dev; mkdir -p velox-benchmark-data/tpch; mv $HOME/projects/velox-dev/velox-testing/benchmark_data_tools/output_data/* velox-benchmark-data/tpch/`

12. `cd $HOME/projects/velox-dev/velox-testing/velox/scripts; ./benchmark_velox.sh --queries 6 --device-type cpu`

13. `cat  benchmark-results/q06_cpu_32_drivers`

```
Execution time: 21ms
Splits total: 10, finished: 10
-- Aggregation[4][FINAL a0 := sum("a0")] -> a0:DOUBLE
   Output: 1 rows (32B, 1 batches), Cpu time: 169.23us, Wall time: 253.39us, Blocked wall time: 0ns, Peak memory: 64.50KB, Memory allocations: 5, Threads: 1, CPU breakdown: B/I/O/F (52.29us/71.13us/27.40us/18.41us)
  -- LocalPartition[3][GATHER] -> a0:DOUBLE
     Output: 64 rows (3.94KB, 64 batches), Cpu time: 1.08ms, Wall time: 1.46ms, Blocked wall time: 15.70ms, Peak memory: 0B, Memory allocations: 0, CPU breakdown: B/I/O/F (248.14us/492.23us/218.25us/120.93us)
     LocalPartition: Input: 32 rows (1.97KB, 32 batches), Output: 32 rows (1.97KB, 32 batches), Cpu time: 975.77us, Wall time: 1.32ms, Blocked wall time: 0ns, Peak memory: 0B, Memory allocations: 0, Threads: 32, CPU breakdown: B/I/O/F (228.85us/492.23us/134.14us/120.55us)
     LocalExchange: Input: 32 rows (1.97KB, 32 batches), Output: 32 rows (1.97KB, 32 batches), Cpu time: 103.77us, Wall time: 133.32us, Blocked wall time: 15.70ms, Peak memory: 0B, Memory allocations: 0, Threads: 1, CPU breakdown: B/I/O/F (19.29us/0ns/84.11us/378ns)
    -- Aggregation[2][PARTIAL a0 := sum(ROW["p0"])] -> a0:DOUBLE
       Output: 32 rows (1.97KB, 32 batches), Cpu time: 1.74ms, Wall time: 2.56ms, Blocked wall time: 0ns, Peak memory: 64.75KB, Memory allocations: 223, Threads: 32, CPU breakdown: B/I/O/F (249.03us/108.23us/1.25ms/133.97us)
      -- Project[1][expressions: (p0:DOUBLE, multiply(ROW["l_extendedprice"],ROW["l_discount"]))] -> p0:DOUBLE
         Output: 11618 rows (107.46KB, 61 batches), Cpu time: 623.45us, Wall time: 896.79us, Blocked wall time: 0ns, Peak memory: 2.00KB, Memory allocations: 61, Threads: 32, CPU breakdown: B/I/O/F (173.54us/26.87us/339.52us/83.52us)
        -- TableScan[0][table: lineitem, range filters: [(l_discount, DoubleRange: [0.050000, 0.070000] no nulls), (l_quantity, DoubleRange: (-inf, 24.000000) no nulls), (l_shipdate, BigintRange: [8766, 9130] no nulls)]] -> l_shipdate:DATE, l_extendedprice:DOUBLE, l_quantity:DOUBLE, l_discount:DOUBLE
           Input: 11618 rows (3.99MB, 61 batches), Raw Input: 600572 rows (6.03MB), Output: 11618 rows (3.99MB, 61 batches), Cpu time: 17.31ms, Wall time: 27.26ms, Blocked wall time: 0ns, Peak memory: 11.41MB, Memory allocations: 590, Threads: 32, Splits: 10, CPU breakdown: B/I/O/F (65.73us/0ns/17.23ms/18.48us)

```
----------------------------------
