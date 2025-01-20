# Design Tips (個人經驗，僅供參考)
以下的Tips僅限iclab這堂課追求performance的方法，在真實要下線的晶片設計中，有些方法並不適合使用

## 01_RTL
- 由於Latency計算方式是從in_valid拉下來後才開始算，所以大部分的Lab壓Latency的效益都會是最高的
- 有些reg可以拔掉reset(但要注意，不能導致電路的輸出出現unknown)
- 如果有使用到DRAM並且DRAM的Latency很長的話，design可以盡量切Pipeline壓低CT
- 如果要壓超低CT的話，除法器可以用連減，乘法器可以用連加，加減法器可以切段，拆bit數來做 (要壓到2ns以下才可能會需要這樣做)  
- 如果電路的演算法太複雜的話，可以寫一個超大counter，然後針對每個cycle去控制所有訊號，這樣會好寫很多只是會比較花時間
- 如果SRAM的控制很複雜的話，建議用Excel將SRAM的控制都先規劃好再去寫RTL
- 用多個小counter比直接用一個大counter的timing和area通常都會比較好，但會比較難寫一點
- **大部分**情況，把sequential circuit的else補滿後，面積會比較小 (else a_reg <= a_reg;)
- 如果要把cycle time壓到非常低的話，甚至MUX前後也要插reg打斷data path，有時候大MUX的delay甚至比加減法器的delay還要大
- 用shift register去選資料的面積會比用counter去選的面積還要小
- 如果timing很極限的話，FSM狀態的parameter可以用one-hot encoding，timing會比較好，面積也可能會小一些

### 共用邏輯的方法
1. 下面這種寫法，如果電路簡單的話DC在合成的時候可能會自動幫你共用加法器，但當電路比較複雜的時候就不一定會幫你共用
```verilog
always @(posedge clk) begin
    if(count == 'd1) begin
        out <= in_1 + in_2;
    end
    else if(count == 'd2) begin
        out <= in_3 + in_4;
    end
    else begin
        out <= 'd0;
    end
end
```

2. 要確保DC合成的時候有共用加法器，可以在寫RTL的時候就把邏輯寫成有共用的樣子
```verilog
assign in_1_sel = (count == 'd1) ? in_1 : (count == 'd2) ? in_3 : 'd0;
assign in_2_sel = (count == 'd1) ? in_2 : (count == 'd2) ? in_4 : 'd0;
always @(posedge clk) begin
    out <= in_1_sel + in_2_sel;
end
```

### 切MUX的方法
1. out_addr選資料(MUX)後再做加法
```verilog
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out <= 'd0;
    end
    if(count == 'd10) begin
        out <= buffer[out_addr] + buffer[out_addr + 'd1];
    end
    else begin
        out <= 'd0;
    end
end
```

2. MUX後插入reg，打斷cirtical path
```verilog
always @(posedge clk) begin
    buffer_out1 <= buffer[out_addr];
    buffer_out2 <= buffer[out_addr + 'd1];
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out <= 'd0;
    end
    if(count == 'd10) begin
        out <= buffer_out1 + buffer_out2;
    end
    else begin
        out <= 'd0;
    end
end
```

---

## 02_SYN
- 由於輸入輸出都有0.5*CYCLE的delay，因此in2reg和reg2out都盡量不要經過太複雜的邏輯，或是直接擋一層reg
- 如果critical path太長，DC會用比較高速但面積比較大的cell去滿足timing，所以有時候切一級pipeline，雖然會增加reg的面積，但組合邏輯的面積會降低更多
- 在syn.tcl裡面的report_area後面可以加上參數(report_area -designware -hierarchy)，讓它顯示不同邏輯單元的使用的面積，壓面積的時候會非常方便
- 可以把syn.tcl裡的compile_ultra改成compile，這樣可以保留更多RTL裡的訊號，在Gate level simulation的時候比較好debug
- 記得要08_check，確認有沒有latch

---

## 03_GATE
- 記得使用和syn.tcl相同的cycle time來模擬
- 如果出現unknown的話，可以回去檢查RTL，是否有在in_valid為low的時候不小心把unknown的輸入訊號傳進電路內
- 如果reset的時間太短的話，輸出可能會來不及完成reset，但reset維持2*CYCLE通常就都會沒問題

---

## 04_MEM
- 相同儲存容量的SRAM拆成多顆的面積會比只使用一顆的面積還要大 (8顆128X64的面積 > 1顆1024X64的面積)
- SRAM雖然面積小，但頻寬相對於reg也比較小，要trade-off
- 記得要把**所有**memory的.v / .db / .lef / .lib檔都放進04_MEM資料夾，**包含BC、TC**，少放就直接2de : )

---

## 05_APR
- 流程熟悉後可以直接改助教給的腳本來跑會快很多
- 如果有SRAM並且要壓面積的話，可以將CHIP的寬度控制到和SRAM的長度一樣，然後讓SRAM緊緊貼合CHIP的兩側(可以參考這張圖[Layout](../Lab11/Layout.png))，這樣面積會小一些
- 如果有加上IO PAD的話，cycle time會被core to pad吃掉很多，導致可能02可以跑到3ns，APR卻只能跑到7ns以上
- APR後CHIP area會包含power ring的面積，這部分面積是固定的(如果core to boundary & Core Limit)，所以面積都會變大很多，這時候cycle time和latency低的會比較賺

---

## 06_POST
- 開波型debug的效果不大
- 沒過建議直接重A(或是小改timing violation的reg的邏輯然後重A)，這就很玄= =


