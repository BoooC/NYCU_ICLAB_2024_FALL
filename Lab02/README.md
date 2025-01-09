## Lab02 注意事項
演算法非常簡單並且固定cycle time，所有人都在用很玄的方法爆卷面積(包含我)，感覺很很意義...

---

## Tips
- 盡量簡化簡Base轉換的狀態的邏輯  
- 某些訊號可以拔掉reset  
- Lab02有給PATTERN並且沒有隱藏測資，所以可以根據測資砍bit數...  
- **大部分**情況，把sequential circuit的else補滿後，面積會比較小 (else a_reg <= a_reg;)  

---

## My Perf
- Cycle Time: 10 (Fixed)
- Latency: 99
- Area: 2597.918
- Perf: 257193.882 (Area * Latency)
- Rank: 13
