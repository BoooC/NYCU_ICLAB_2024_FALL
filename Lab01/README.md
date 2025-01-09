## Lab01 注意事項
單純的組合邏輯電路，固定 **cycle time**   
由於所有的運算都需在 **一個 cycle** 內完成，因此 **critical path** 會很長  
在使用 Design Compiler 進行合成時，若電路的 **critical path** 過長，工具會選擇延遲較小但面積較大的 cell 來實現電路  
因此，除了硬體共用之外，還需要儘量縮短 **critical path**  

---

## Tips
- 使用查表實現 `mod 10`
- 將 `-5'd9` 替換為 `+5'd23`，這樣可以避免減法運算，改用加法運算實現。
- 大多數人都使用 **merge sort**，可以改用 **窮舉法** 來運算某些級，例如：4個數字排序會有`4! = 24`種cases，如下
```verilog
always @(*) begin
    case(1) // synopsys parallel_case
        ((in_0 >= in_1 & in_0 >= in_2 & in_0 <= in_3) | (in_0 >= in_2 & in_0 >= in_3 & in_0 <= in_1) | (in_0 >= in_1 & in_0 >= in_3 & in_0 <= in_2)) : out_1 = in_0;
        //((in_1 >= in_0 & in_1 >= in_2 & in_1 <= in_3) | (in_1 >= in_2 & in_1 >= in_3 & in_1 <= in_0) | (in_1 >= in_0 & in_1 >= in_3 & in_1 <= in_2)) : out_1 = in_1;
        ((in_2 >= in_0 & in_2 >= in_1 & in_2 <= in_3) | (in_2 >= in_1 & in_2 >= in_3 & in_2 <= in_0) | (in_2 >= in_0 & in_2 >= in_3 & in_2 <= in_1)) : out_1 = in_2;
        ((in_3 >= in_0 & in_3 >= in_1 & in_3 <= in_2) | (in_3 >= in_0 & in_3 >= in_2 & in_3 <= in_1) | (in_3 >= in_1 & in_3 >= in_2 & in_3 <= in_0)) : out_1 = in_3;
        default : out_1 = in_1;
    endcase
end
```

- case有兩種寫法，一種是case()裡面放訊號名稱，另一種則是case()裡面放1，case(1)和多層的if-else的描述等效，但如果在後面加上// synopsys parallel_case，DC會自動用平行的方式來實現，但要注意這樣的寫法中case底下的分支不能存在優先級衝突，如下
```verilog
always @(*) begin
    case(1) // synopsys parallel_case
        condition_1 : out = 'd0;
        condition_2 : out = 'd1;
        condition_3 : out = 'd2;
        default : out = 'd3;
    endcase
end
```

---

## My Perf
- Cycle Time: 20 (fixed)
- Latency: -
- Area: 40422.41336
- Perf: 40422.41336 (Area)
- Rank: 2


