## Lab03 注意事項
這次Lab要自己寫PATTERN，題目有規定不能一次display多個SPEC FAIL  
在偵測到某些違反某些SPEC後如果加上repeat(3) @(negedge clk); $finish;就可能會在這三個cycle之間跳出其他的SPEC FAIL導致違反PATTERN的SPEC(這我)  
但這次PATTERN 2de只會針對violated的那項SPEC去打折而已  

---

## Tips
- 建議一個cycle輸出，壓latency的效益比壓cycle以及area的效益還要大很多
- 在寫register的時，大部分情況補滿else的面積會比較小或是和不寫else的面積一樣
- 有時候加上一寫無效的邏輯面積反而會變低  
- 可以自己寫個腳本自動找出不同CT下最好的performance  
- 透過4x4的mask來掃整個column，使用generate來描述可以複製多份相同邏輯的硬體
- 可以和朋友交換PATTERN交互驗證(記得加密)

---

## My Perf
- Cycle Time: 7.3
- Latency: 11824
- Area: 27316.4
- Perf: 2357820529 (Area * Latency * CT)
- Rank: 7

