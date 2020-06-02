---
title: "pandocでmarkdownから日本語pdf出力 in vscode"
subtitle: ""
author: "Akiyama Hiroki"
date: "2020-05-15"
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
[**おわりに**](#vspd_end)

## はじめに {#vspd_start}

pandocとは何か、これに関しては今回説明しません。
なぜなら筆者も理解が浅いからです。。。。。
とりあえず、markdownからhtmlやpdfなどに変換してくれるツールがpandocだと思ってください(本当はもっとすごいyo! [公式](https://pandoc-doc-ja.readthedocs.io/ja/latest/users-guide.html))。

対象読者は、次の3つを満たしている人を想定しています。

1. vscodeがインストール済み
2. Rstudioがインストール済み
3. markdownを書いたことがある

こんな感じの.mdから

個々に画像が入る

こんな感じのpdfが出せるようになります

ここに画像が入る  

## 目的{#vspd_purpose}

<font color="red">
vscodeでmarkdownを快適に編集して、日本語pdfを出力すること。
</font>

markdownの編集をvscodeで行うと快適です。
なぜなら、markdownのプレビューを簡単に表示できるからです。
しかし、日本語pdfの出力がうまくいかなかったり、数式の出力ができなかったりする問題があります。
その問題を解消するために、pandocを使用します。


## 方法{#vspd_method}

次の4つの手順を踏んで目的を達成します。

1. Rstudioのpandocにpathを通す
2. vscodeの拡張機能をいろいろ追加する
3. front matter yamlの書き方

### 1. Rstudioのpandocにpathを通す{#tejun_1}

<font color="red">
ココがこの記事でのキモです。
</font>
本来ならばpandocをインストールするところから始まりますが、ここではRstudioに組み込まれているpandocを使用します。

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

### 2. vscodeの拡張をいろいろ追加していく{#tejun_2}

vscodeで拡張を追加する方法と、追加するいくつかの拡張について説明します。

#### 拡張機能リスト

|拡張機能|必須/補助|内容|
| :---: | :---: | :--- |
|vscode-pandoc|必須|markdownをpandocでレンダリングするのに必要|
|Pandoc Markdown Preview|必須|shift + ctrl + rでプレビューが表示できる<br>フロントマターyamlも表示してくれる|
|Markdown+Math|補助|数式のサポートいろいろ(こちらも[公式](https://marketplace.visualstudio.com/items?itemName=goessner.mdmath)で)|
|Markdown All in One|補助|markdownの書式サポート、ほぼ必須([公式](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one))|



#### 拡張機能を追加する方法  


vscodeの左端っこにある、テトリスみたいなアイコンを押します。アイコンをクリックしたら、検索欄(Search Extensions in ...)で追加したい拡張機能を検索します。

![](https://github.com/rene-hiroki/my_trivial/blob/master/picture/04pic/kakucho.png?raw=true)


まずは「vscode-pandoc」と検索してみましょう。検索したら、vscode-pandoc をクリックします(私はバージョン0.0.8の方を使用しています)。あとはinstallボタンをクリックして少し待てば、インストール完了です。


![](https://github.com/rene-hiroki/my_trivial/blob/master/picture/04pic/vscode-pandoc.png?raw=true)


拡張機能のインストールの仕方を説明しました。vscode-pandocの他にも、pandoc markdown previewという拡張を必須として挙げています。先ほどと同様にインストールしましょう。

まずはテトリスアイコンをクリックして、検索欄に「pandoc markdown preview」と打ち込みます。

![](https://github.com/rene-hiroki/my_trivial/blob/master/picture/04pic/kakucho.png?raw=true)


私はすでにインストール済みなのでこのように表示されますが、先ほどと同様にインストールボタンをクリックしてください。

![](https://github.com/rene-hiroki/my_trivial/blob/master/picture/04pic/pandoc-markdown-preview.png?raw=true)


今インストールした2つの拡張以外にも便利な拡張機能がわんさかあるので、是非いろいろ試してみてください。
そして便利そうなやつは共有してください！



### 3. YAML front matter{#tejun_3}

さあ、ここが少しだけ込み入った話になります。
pandoc markdown（pandocを使うmarkdown）では、yaml フロントマターというのをmarkdownの一番最初に書きます。
3つのハイフン---で上下を囲ったやつです。
たとえばpandocでmarkdownからpdf出力するときはこんな感じのyamlフロントマターを書きます。

```
---
title: "pandocでmarkdownから日本語pdf出力 in vscode"
subtitle: ""
author: "Akiyama Hiroki"
date: "2020-05-15"
---


```


* マージンの設定。
  * front matter でいじるか、pandocの引数に入れる。
aa


## おわりに{#vspd_end}

aa

