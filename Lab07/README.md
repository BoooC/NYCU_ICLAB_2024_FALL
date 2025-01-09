## Lab07 注意事項
寫synchronizer前一定要先把FIFO和Handshake_syn的運作邏輯完全搞懂  
由於JG是用窮舉的方式來驗證電路，所以如果JG跑很久都沒跑出結果的話，通常代表電路中synchronizer的某些寫法讓JG在特定區間內瘋狂窮舉無法收斂  
每年的CDC都會用到FIFO和Handshake_syn，可以參考前人的code，但要注意不要抄襲  

---

## Tips
- 資料進來的clk1 domain的時候就可以同時往clk2 domain傳，不需要等到所有資料都進來後才開始傳
- clk2算出結果後可以直接往clk1 domain傳，這樣可以減少latency
- synchronizer的latency也可以優化
- 盡量不要用FSM來寫synchronizer，會變很複雜，針對每個訊號獨立去控制就好

---

## My Perf
- Cycle Time: 47.1 (Fixed)
- Latency: 805000
- Area: 99233.32
- Perf: 7.92704E+15 (Area^2 * Latency)
- Rank: 2


