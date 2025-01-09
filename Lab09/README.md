## Lab09 注意事項
先熟習system verilog的語法  
基本上就是組合邏輯把always@(*)改成always_comb，循序邏輯把always @(posedge clk)改成always_ff @(posedge clk)，然後用物件導向的方式去使用一些被包裝好的訊號  

控制DRAM的時候要記得等前一次write response回來後才能發起下一次DRAM的讀取，否則讀寫的位置會有錯  
DRAM每次讀寫的latency會不固定，所以要多調整不同組合的latency去測試，確保任何情況下都能通過模擬  

PATTERN可以先自己寫，因為Lab10也會用到，但記得要寫preliminary spec  
就算Lab10的preliminary spec是放在checker中，在Lab09的時候也要寫，我就是沒有寫preliminary spec，所以才沒發現我拔reset拔到輸出訊號在前兩個cycle會出現unknown，然後就2de了= =  

---

## Tips
- 由於這次DRAM讀寫的latency都很長，所以pipeline可以盡量切來壓低cycle time
- formula中有除法，但由於除完後的結果是和一些常數做比較，所以可以改成把常數都乘以3來代替除法
- 排序的硬體可以共用

---

## My Perf
- Cycle Time: 2.1
- Latency: 846760
- Area: 65339.57
- Perf: 116186562016 (Area * Latency * CT)
- Rank: 1
