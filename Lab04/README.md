## Lab04 注意事項
這次Lab是我覺得整學期最難trade-off的一次
同時需要考慮到要開多少硬體資源和pipeline的級數
要把latency壓到很低的話，data scheduling會變得非常不規則，可以直接使用一個超大counter針對每個cycle去安排輸入的資料
用shift register + systolic array就可以有不錯的performance了

---

## Tips
- 可以先將design ware上會用到的IP先下載下來比較不會Lag
- 這次Lab開始都會非常需要trade-off，在寫之前要先評估好要針對哪個方向優化，大部分情況下壓**latency**的效益都會比較大
- IP盡量共用，但過度共用會導致latency過長，這也需要trade-off
- fp_div的area和delay是最大的，可以改用倒數來替代除法器
- div和exp的面積都非常大，盡量共用
- 在做乘加(MAC)運算的時候做pipeline可以有效減少critical path delay，但pipeline的級數越長，latency也會越長，這部分也需要trade-off
- 如果是使用某些大神寫的PATTERN的話，盡量還是要自己檢查每條SPEC，因為有時候有一些preliminary spec可能會沒檢查到(例如out_valid為0的時候，out_data也必需是0)，我有同學就是因為這樣2de    

---

## My Perf
- Cycle Time: 14.7
- Latency: 338100
- Area: 2255456
- Perf: 762569673600 (Area * Latency * CT)
- Rank: 10

