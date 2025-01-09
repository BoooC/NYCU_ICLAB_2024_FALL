# NYCU_ICLAB_2024_FALL

## NYCU 2024 FALL Integrated Circuit Design Laboratory (ICLAB)
- 課程名稱 : 積體電路設計實驗 Integrated Circuit Design Laboratory 
- 修課學期 : 2024 FALL
- 學期初修課人數 : 170
- 退選人數 : 32
- 全班平均 : 81.27

---

## Lab Descriptions
- Process: U18
- Simulation: VCS
- Synthesis: Design Compiler
- APR: Innovus

|  Lab  | Topic                                | Name                                           |  W  |
|-------|--------------------------------------|------------------------------------------------|-----|
| Lab01 | Combinational Circuit                | Snack Shopping Calculator (SSC)                |  5% |
| Lab02 | Sequential Circuit                   | Three-Inning Baseball Game (BB)                |  5% |
| Lab03 | Pattern                              | Tetris (+Pattern)                              |  5% |
| Lab04 | Designware IP                        | Convolution Neural Network (CNN)               |  5% |
| Lab05 | Memory                               | Template Matching with Image Processing (TMIP) |  5% |
| Lab06 | Design Compiler & Soft IP            | Matrix Determinant Calculator (MMC)            |  5% |
| Lab07 | Cross Domain Clock                   | Convolution with Clock Domain Crossing (CONV)  |  5% |
| Lab08 | Low Power Design                     | Self-attention (SA)                            |  5% |
| Lab09 | SystemVerilog Design                 | Stock Trading Program                          |  5% |
| Lab10 | SystemVerilog Verification           | Verification: From Lab09                       |  5% |
| Lab11 | APR flow with Innovus                | APR I: From Lab05                              |  5% |
| Lab12 | IR Drop after APR                    | APR II: From Lab03                             |  5% |
| Bonus | Formal Verification                  | Formal Verification                            |  3% |
| OT    | Online Test                          | Ramen                                          |  5% |
| MP    | DRAM with AXI-4                      | Image Signal Processing (ISP)                  | 10% |
| FP    | APR with MP                          | Image Signal Processing (ISP)                  | 10% |
| ME    | Focus on front-end design            | iclab midterm exam (written exam)              |  8% |
| FE    | Focus on back-end design             | iclab final   exam (written exam)              |  8% |

---

## Demo Result
- Total Score : 102.91 (104%)
- Total Rank : 2 / 138 (1.45%)
- Best_code * 3
- No.1 * 3
- No.2 * 3
- 2nd_demo * 3

| Lab                      | Demo | Rank | Score | 1de | 2de |
|--------------------------|------|------|-------|-----|-----|
| [Lab01](./Lab01/)        | 1st  |   2  | 99.81 | 154 |  0  |
| [Lab02](./Lab02/)        | 1st  |  13  | 97.66 | 145 |  9  |
| [Lab03](./Lab03/)        | 1st  |   7  | 98.57 | 119 | 26  |
| [Lab03_PAT](./Lab03/)    | 2nd  |  -   | -     | 108 | 28  |
| [Lab04](./Lab04/)        | 1st  |  10  | 98.09 | 119 | 22  |
| [Lab05](./Lab05/)        | 1st  |  23  | 94.63 |  93 | 31  |
| [Lab06](./Lab06/)        | 1st  |  32  | 93.50 | 128 | 15  |
| [Lab07](./Lab07/)        | 1st  |   2  | 99.96 | 133 |  7  |
| [Lab08](./Lab08/)        | 1st  |   9  | 98.30 | 135 |  6  |
| [Lab09](./Lab09/)        | 2nd  |   1  | 70    | 108 | 27  |
| [Lab10](./Lab10/)        | 1st  |   1  | 100   | 127 |  9  |
| [Lab11](./Lab11/)        | 2nd  |   2  | 69.83 | 107 | 27  |
| [Lab12](./Lab12/)        | 1st  |   -  | 100   | 136 |  0  |
| [Bonus](./Bonus/)        | 1st  |   -  | 100   | 137 |  0  |
| [MP](./Midterm_Project/) | 1st  |   6  | 98.94 | 135 |  6  |
| [FP](./Final_Project/)   | 1st  |   1  | 100   | 131 |  2  |
| [OT](./Bonus/)           | 1st  |   -  | 100   | 122 | 21  |
| ME                       | -    |   -  | 100   | 144 |  -  |
| FE                       | -    |   -  | 100   | 136 |  -  |

---

## 資料結構
├── Lab01  
- **├── Exercise**：包含所有模擬與合成相關腳本檔案  
    - **├── 01_RTL**：RTL Simulation  
    - **├── 02_STN**：Logic Synthesis  
    - **├── 03_GATE**：Gate Level Simulation  
    - **├── 04_MEM**：SRAM hard macro  
    - **├── 05_APR**：APR  
    - **├── 06_POST**：Post-Simulation  
    - **├── Memory**：Memory Compiler  
- **├── Spec**：包含Lab的題目說明及相關文檔  
- **├── RTL.v**：Demo的RTL code  
- **├── README.md**：Lab相關說明、Tips及Performance  

├── Lab02  
├── Lab03  
.
.
.  
├── Lab12  
├── PATTERN_template.v：通用 PATTERN 範本  
├── [Design_Tips](./Design_Tips/)：01~06 的優化技巧與注意事項

---

## PATTERN
管神PATTERN: https://github.com/aelog134256/iclab2024fall/tree/main

