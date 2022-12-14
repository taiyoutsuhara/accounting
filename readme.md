# 出納可視化システム
本リポジトリをクローンするか、ZIPでダウンロードしてください。

## 概要
**収入と支出との管理**を**習慣化**するアプリケーションです。**データシート1つ**で項目と月次別との**クロス集計表**、ならびに**時系列グラフ**を出力します。  
  
家計簿アプリは星の数ほどあります。家計簿の自動作成やレシート読み取りによる記録のしやすさなど、取り組みやすくする工夫が種々様々されています。  
  
一方、**出納可視化システム**は**記録する過程の習慣化**に焦点を当てています。**毎日2-3分程度の記録を続ける**ことにより、**収入と支出に対する意識の醸成**を目指します。  


## システム要件
* `R version 4.2.1`以上
* 必要なライブラリは`shiny`, `openxlsx`, `tidyverse`です。


## システムの使い方
1. **メインページ**の`Browse`をクリックし**データシート**を選んでください。
1. `集計結果`タブを開くと、月別(×項目/費目別)**クロス集計表**を見ることができます。フィルタやソートにより、着目したい情報にたどり着きやすくなります。`Download`ボタンを**クリック**すると、各々のクロス集計表を**ダウンロード**できます。
1. `時系列グラフ`タブを開くと、毎月の(項目別)収入や(費目別)費用がプロットされた**グラフ**を確認できます。グラフをダブルクリックすると、プロットデータ情報を取得できます。


## データシート
### ブックの作り方
次のシートから構成される**XLSX形式のエクセルファイル**を用意してください。**1シート**で記録できるのは**1年分**です。
* 項目シート
* 月別の費用
* 収入

### 項目シートの作り方
このシートに固定費用、変動費用の各費目と収入の項目をまとめます。ここでまとめた項目の範囲内で、次のシートの`費目`または`項目`を付けなければなりません。
* [`費目`] 月別の費用の同列
* [`項目`] 収入の同列
  
**見本**
|  固定費用  |  変動費用  |  収入  |
| --------- | --------- | ------ |
|  住居費  |  食費     |  給与      |
|  通信費  |  日用品費  |  ボーナス  |
|  光熱費  |  交通費   |  臨時収入  |
|         |  医療費   |           |
|         |  その他   |           |
  
次のことを満たすようにまとめないと、アプリケーションが正しく動作しません。
* **列順**は上の**書き方通り**です。
* 費目はいずれも複数にわたりますが、**該当列**に**1行1費目**書いてください。
* 収入の項目についても、**1行1項目**記してください。

### 月別の費用の作り方
このシートに固定費用と変動費用を記録します。**1ヶ月に1シート**使いますので、**合計12シート**必要です。シート名は**それぞれ1, 2, …, 12**と付けてください。  
  
**見本**
|  月  |  日  |  固定費用または変動費用  |  費目  |  詳細  |  金額（円）  |
|  --  |  --  |  --------------------  |  ---  |  ---  |  ----------  |
|  1  |  10  |  固定費用  |  住居費  |  家賃  |  x  |
|  1  |  10  |  変動費用  |  日用品費  |  洗剤  |  y  |
|  1  |  25  |  変動費用  |  食費  |  昼飯  |  z  |
  
次のことを満たすように書かないと、アプリケーションが正しく動作しません。
* **列順**は上の**書き方通り**です。
* `固定費用または変動費用`に入力すべきは"固定費用"、"変動費用"のいずれかです。
* 項目シートに記した`費目`の範囲内で付けてください。
* **1行1データ**を守ってください。同じ日に2つ以上のデータが存在する場合、上記の書き方を参考にしてください。

### 収入の作り方
**見本**
|  月  |  日  |  項目  |   金額（円）  |
|  --  |  --  |  ---  | ---------  |
|  1  |  10  |  給与  |   m  |
|  1  |  13  |  臨時収入  | n  |
  
次のことを満たすように記さないと、アプリケーションが正しく動作しません。
* **列順**は上の**書き方通り**です。
* 項目シートに記した`項目`の範囲内で付けてください。
* **1行1データ**を守ってください。