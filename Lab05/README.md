## Lab05 注意事項
寫之前一定要先想好架構，以及SRAM的規格  
開完SRAM後如果還要再改寫法的話會幾乎整個都要重寫，SRAM一次讀8-bit和一次讀32-bit的讀寫控制會差非常多  
這次Lab要盡量寫好一點，因為後面Lab11通常都會拿Lab05得電路來做APR，所以這次performance好的話，後面APR的Lab的performance也會不錯  
後面做APR的時候我有重寫這次Lab(TMIP_rewrite.v)，原本SRAM是一次讀8-bit，改成一次讀32-bit，performance變好很多  

---

## Tips
- SRAM的輸出一定要擋一層reg，輸入建議也要擋一層reg(但控制會比較複雜)，不然之後APR可能會出問題
- SRAM建議一次讀取8-bit以上，這樣可以極大減少latency，但SRAM的控制會較為複雜
- 可以用excel來規劃不同運算下SRAM的讀寫schedule，這樣在寫電路的時候會順很多
- horizontal flip和negative這兩種運算可以都整合到最後的CONV中，這樣可以減少非常多cycle數
- 如果圖片已經是4x4的話，max pooling就可以直接跳過
- 讀取2筆action後就可以提前開始運算了
- 最後CONV是zero padding，所以可以跳過前4個pixel，省4個cycles
- 用一顆大SRAM(192x32)一次存3種gray img比起用三顆SRAM(64x32)存的面積還要小
- pipeline盡量切來壓cycle time，因為filter運算的latency本身就會比較長

---

## My Perf
- Cycle Time: 9.1
- Latency: 161977
- Area: 371380.8555
- Perf: 2.03298E+17 (Area^2 * Latency * CT)
- Rank: 23

---

## My Perf (Rewrite for Lab11)
- Cycle Time: 3.8
- Latency: 92434
- Area: 342580.321188
- Perf: 4.1223E+16 (Area^2 * Latency * CT)
- Rank: 1

