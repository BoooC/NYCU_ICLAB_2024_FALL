## Lab08 注意事項
先寫出一版wocg的電路並優化，然後再做wcg，因為如果做完wcg後才優化，就需要同時改wcy和wocg的電路，因為JG會驗這兩個電路是否等效  
做clock gating的時候要用generate來產生多個被gated後的clk，因為被**gated後的clk無法trigger多顆registers**  
如果power無法降到規定的比例的話通常是因為組合邏輯的power太大導致循序邏輯做clock gating在整體power中下降的比例太低，這時候可以嘗試做data gating來降低組合邏輯的power  

---

## Tips
- 這次一樣盡量1個cycle輸出，就算要多開很多組乘加器也非常值得
- 除了做clock gating以外也要做data gating (不需要運算的時候把進入算術邏輯的資料拉為0)
```verilog
always @(*) begin
	if(count == 'd1) begin
		mac_in_1 = buffer_1[idx];
		mac_in_2 = buffer_2[idx];
	end
	else begin
		mac_in_1 = 'd0; // data gating
		mac_in_2 = 'd0; // data gating
	end
end
```

- 因為self attention中有ReLU，會產生很多0，這些0做乘法的結果也會是0，所以可以在資料進入乘法器之前，將另一個數字做zero-gating以減少power
```verilog
always @(*) begin
	if (count == 'd1) begin
		mac_in_1 = buffer_1[idx];
		mac_in_2 = (buffer_1[idx] != 'd0) ? buffer_2[idx] : 'd0; // zero gating
	end
	else begin
		mac_in_1 = 'd0; // data gating
		mac_in_2 = 'd0; // data gating
	end
end
```

- JG如果跑超過3分鐘都沒結果的話，很有可能是clock gating的條件和對應的那個always中的if-else沒有完全重疊，導致JG在這段沒有重疊的區間內瘋狂窮舉
- 就算某些區間訊號不會變也要做clock gating

---

## My Perf
- Cycle Time: 50 (Fixed)
- Latency: 10000
- Area: 1681423.649
- Power_wocg: 0.0152
- Power_wcg: 0.007889
- Perf: 132647511.7 (Area * Latency * Power_wcg)
- Rank: 9


