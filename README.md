# 🧮cale-d
D言語で書かれたBrainfuxkの処理系です。    
なんだかんだ作ったことがなかったので作ってみた第二弾です。    
[第一弾](https://github.com/PenguinCabinet/Brainfuxk-D)。   

# ✅特徴

# 🏗ビルド
```
dub build
```

## 🔨使い方
```bash
/project>calc-d.exe
>1+2+3*(4+5*2)
tokenized expr:1 + 2 + 3 * ( 4 + 5 * 2 )  
RPB expr:1 2 + 3 4 5 2 * + * +
45
>q
```
式を入力すると、順に字句解析した結果、逆ポーランド法に変換した式、計算結果を表示します。   
qキーで終了です。   

### ⚠️注意
* 「-1」のマイナスの単項演算子には対応しておりません。「0-1」等で代用して下さい。
* 浮動小数点数には対応しておりません。現在整数のみです。

~~Done is better than perfect.~~    
近いうちに対応します。
## 📃テスト
```
dub test
```

## 🎫LICENSE

[MIT](./LICENSE)

## ✍Author

[PenguinCabinet](https://github.com/PenguinCabinet)