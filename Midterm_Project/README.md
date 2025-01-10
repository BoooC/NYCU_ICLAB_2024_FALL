## Midterm Project 注意事項
今年MP的演算法很簡單  
不使用SRAM的話，難度就跟Lab04差不多，大概半天內就可以寫完了  
也可以使用SRAM，但SRAM存的資料就不能是一般直接存DRAM裡的資料，因為要把整個DRAM所有資料都存起來的SRAM的面積就超過200W了，這超過SPEC限制的75W  
所以SRAM存的資料必須經過處理，例如針對每筆資料去統計bit數，然後存一些bit相關的資訊，這樣可以在latency遠遠贏過其他人，但面積和CT會比較難壓  
由於這次需要和DRAM溝通，並且讀取的latency非常長，因此要盡可能壓低CT  

---

## Tips
- 除法器可以用多個cycle連續做減法來代替，可以讓CT更低，面積也更小
- 做auto focus時儲存中間的6x6的資料可以用shift register，在計算差值的時候也用shift的方式來取值可以減少很多面積
- 由於auto exposure的ratio縮小pixel intensity的case比放大還要多，所以當測資越多的時候，會有越多張圖片變成全0，全0的圖片可以直接輸出0
- 判斷全0的邏輯有兩種方法
  - 1. 檢查寫回DRAM的資料是否為全0 (面積小，latency長，因為沒辦法跳過這次剛好變成全0的運算)
  - 2. 可以用記錄ratio來實現，如果累積左移8以上的話就代表這張圖必定為全0 (面積大，latency短)
- 不管目前輸入是要左哪個mode，都可以同時計算兩種mode的結果然後存起來，如果遇到同一張圖做auto focus的話就可以直接輸出之前紀錄的結果，如果遇到同一張圖做auto expocure並且ratio為1的話就可以直接輸出之前紀錄的結果
- 盡量切pipeline，甚至MUX前後也可以切 (有時候MUX的delay甚至會比減法器還大)

---

## My Perf
- Cycle Time: 2.2
- Latency: 57495
- Area: 191525.2
- Perf: 3.0643E+15 (Area * Latency^2 * CT)
- Rank: 6

---

## My Perf (Rewrite for Final_Project)
- Cycle Time: 2.2
- Latency: 48251
- Area: 168573.585641
- Perf: 1.8995E+15 (Area * Latency^2 * CT)
- Rank: 1





