---
title: "pandocでmarkdownから日本語pdf出力 in vscode"
subtitle: ""
author: "Akiyama Hiroki"
date: "2020-06-12"
geometry: "left=3cm,right=3cm,top=2cm,bottom=2cm"
output:
  pdf_document: 
    latex_engine: xelatex 
header-includes: 
#  - \usepackage{indentfirst} # first paragraphのインデントを有効化（英文はインデントが不要のため）
#  - \parindent = 1em         # インデント（字下げ）を1文字に設定
  - \usepackage{xltxtra} # 日本語pdf用
  - \usepackage{zxjatype} # 日本語pdf用
  - \usepackage[ipaex]{zxjafont}  
---

## 目次

[**はじめに**](#vspd_start)  
[**目的**](#vspd_purpose)  
[**方法**](#vspd_method)  
[**サンプルmd**](#vspd_sample)

## はじめに {#vspd_start}

対象読者は、次の3つを満たしている人を想定しています。

1. vscodeがインストール済み
2. Rstudioがインストール済み
3. markdownを書いたことがある

## 目的{#vspd_purpose}

<font color="red">
vscodeでmarkdownを快適に編集して、日本語pdfを出力すること。
</font>

vscodeでmarkdownを編集される方は多いと思います。
なぜなら、markdownのプレビューを簡単に表示できるからです。
しかし、日本語pdfの出力がうまくいかなかったり、数式の出力ができなかったりする問題がよくあります。
その問題を解消するために、pandocを使用します。


## 方法{#vspd_method}

次の6つの手順を踏んで目的を達成します。

1. Rstudioのpandocにpathを通す
2. vscodeの拡張機能をいろいろ追加する
3. 簡易版TeX環境を作る
4. ipaexフォントをインストールする
5. front matter yamlを書く
6. 出力のコマンド


### Rstudioのpandocにpathを通す{#tejun_1}

<font color="red">
ココがこの記事でのキモです。
</font>
本来ならばpandocをインストールするところから始まりますが、ここではRstudioに組み込まれているpandocを使用することでインストール作業をスキップします。

Rstudioのpandocへのpathは、自分で設定する必要があります。Rstudioのpandocは、以下のようにbinの下にあります。

```
~環境依存/Rstudio/bin/pandoc
```

pathが通ったかどうかの確認として、プロンプトで次のコマンドを入力してください。

```
pandoc --version
```

以下のようにpandocのバージョンが出力されたら、pathの設定は完了です。

```
pandoc 2.7.2
Compiled with pandoc-types 1.17.5.4, texmath 0.11.2.2, skylighting 0.7.7
Default user data directory: C:\Users\AkiyamaHiroki\AppData\Roaming\pandoc
Copyright (C) 2006-2019 John MacFarlane
Web:  http://pandoc.org
This is free software; see the source for copying conditions.
There is no warranty, not even for merchantability or fitness
for a particular purpose.
```


### vscodeの拡張をいろいろ追加していく{#tejun_2}

vscodeで拡張を追加する方法と、追加するいくつかの拡張について説明します。CUIで追加することもできますが、ここではGUIを使って拡張を追加します。

<br>
**拡張機能リスト**

|拡張機能|必須/補助|内容|
| :---: | :---: | :--- |
|vscode-pandoc|必須|markdownをpandocでレンダリングするのに必要|
|Pandoc Markdown Preview|必須|shift + ctrl + rで、フロントマターyamlを含めたプレビューが表示できる|
|Markdown All in One|補助|markdownの書式サポート、ほぼ必須([公式link](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one))|
|Markdown+Math|補助|数式のサポートいろいろ(こちらも[公式link](https://marketplace.visualstudio.com/items?itemName=goessner.mdmath)で)|


<br>

**拡張機能を追加する方法**  


vscodeの左端っこにある、テトリスみたいなアイコンを押します。アイコンをクリックしたら、検索欄(Search Extensions in ...)で追加したい拡張機能を検索します。

![](https://github.com/rene-hiroki/my_trivial/blob/master/picture/04pic/kakucho.png?raw=true)

<br>

まずは「vscode-pandoc」と検索してみましょう。検索したら、vscode-pandoc をクリックします(私はバージョン0.0.8の方を使用しています)。あとはinstallボタンをクリックして少し待てば、インストール完了です。


![](https://github.com/rene-hiroki/my_trivial/blob/master/picture/04pic/vscode-pandoc.png?raw=true)


拡張機能のインストールの仕方を説明しました。vscode-pandocの他にも、Pandoc Markdown Previewという拡張を必須として挙げています。先ほどと同様にインストールしましょう。

今インストールした2つの拡張以外にも便利な拡張機能がたくさんあるので、是非いろいろ試してみてください。
そして便利そうなやつは共有してください！


### 簡易版TeX環境を作る{#tejun_3}

TeX環境がすでに構築済みである方は[手順4](#tejun_4)へ進んでください。

なぜTeX？と思われる方もいるかもしれません。
ここでTeXが必要な理由は、次のような理由からです。pandoc markdownをpdfに変換するときには、markdown → TeX → pdfという変換を行っています。したがって、TeXの環境が必要になるという訳です。

でも、TeXliveのインストールには労力がかかるのでやりません（私もTeXLiveはインストールしていません）。ではどうするかというとTinyTeXというものを使います。

TinyTeXとは、Rユーザー向けに作成された簡易TeX環境構築パッケージです。詳細はこちら（https://yihui.org/tinytex/）を参照ください。Rユーザー向けではありますが、vscodeでも十分に使えています（所感）。

ではTinyTeXをインストールしましょう。以下の2行のコマンドをRで実行するだけです。少々時間がかかると思います。コーヒーでも飲んで休憩して待ちましょう。

```
install.packages('tinytex')
tinytex::install_tinytex()
```


### ipaexフォントをインストールする{#tejun_4}

ここでは日本語pdfの作成に必要なフォントをインストールします。
もちろんipaexフォント以外でもpdfの作成はできますが、少々込み入った話になってくるので今回はipaexフォントを使用します。

こちらのlink(https://ipafont.ipa.go.jp/old/
)よりipaexフォントをダウンロードして、PCにインストールします。
フォントインストールの手順はOSに依存します。


### YAML front matter{#tejun_5}

さて、ここが少しだけ込み入った話になります。
pandoc markdown（pandocを使うmarkdown）では、yamlフロントマターというのをmarkdownの先頭に記述します。
3つのハイフン---で上下を囲ったやつです。
たとえばpandocでmarkdownからpdf出力するときはこんな感じのyamlフロントマターを書きます。

```
---
title: "pandocでmarkdownから日本語pdf出力 in vscode"
subtitle: ""
author: "Akiyama Hiroki"
date: "yyyy-mm-dd"
geometry: "left=3cm,right=3cm,top=2cm,bottom=2cm"
output:
  pdf_document: 
    latex_engine: xelatex 
header-includes: 
  - \usepackage{xltxtra} # 日本語pdf用
  - \usepackage{zxjatype} # 日本語pdf用
  - \usepackage[ipaex]{zxjafont}  # フォント指定
---
```

|引数|意味|
| :--- | :--- |
|title|タイトル|
|subtitle|サブタイトル|
|author|著者|
|date|日付|
|geometry|文書の余白|
|output|出力形式|
|header-includes以下|TeXパッケージ指定|

これらのyaml内容は。大体どの文書にも共通して記述するものになっています。
header-includes以下に関しては、今回の日本語pdf作成用になっています。この他にもyamlフロントマターへの記述で設定できることはとてもたくさんありますが、それらはまた今度紹介します。たぶん。

vscodeの便利な点として、pdfやhtml出力をする際のpandocの引数を、設定に保存しておくことができる点があります。

「ctrl + ,」で設定画面を開きます。pandocと検索すると、次のような画面が出てきます。

<img src="https://github.com/rene-hiroki/my_trivial/blob/master/picture/04pic/setting-pandoc.png?raw=true" width="50%">

![setting-pandoc]()

ここのPdf Opt Stringに、

```
--pdf-engine xelatex -V geometry:margin=1in
```

などと記述しておくことで、レンダリングする際のpandocの引数を保存しておくことができます。
こうすると、yamlの該当部分は省略して書くことができます。

### 出力のコマンド{#tejun_6} 

準備は整いました。「ctrl + k」を押した後に、「p」を押して、pdfを選択すればpdf出力が完了します！



## サンプルmd{#vspd_sample}

[ここ](https://github.com/rene-hiroki/my_trivial/tree/master/code)に04_sample.mdを置きました。中身に書いてあることは本記事とほぼ同じものです。これをvscodeで開き、ここまで説明してきた準備を終えていれば、「ctrl + k」を押した後に「p」を押して、pdf出力ができるはずです。

(数式もTeXで書けます)  

$$
f(x)={\displaystyle\sum_{k=0}^{\infty}}f^{(k)}(0)\dfrac{x^k}{k!}\\=f(0)+f'(0)x+\dfrac{f”(0)}{2!}x^2+\dfrac{f^{(3)}(0)}{3!}x^3\cdots
$$

<br><br><br>

enjoy!
