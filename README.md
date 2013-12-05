Katamari 塊
========
## 使い方

### テンプレートの導入
```shell
$ cd 任意のディレクトリ
> 任意のディレクトリに移動します

$ git clone https://github.com/tk-ota/katamari.git
> gitからテンプレートをcloneしてきます

$ cd katamari/grunt/
> grunt ディレクトリに移動します

$ npm install
> npm moduleのinstallが始まります

$ grunt
> gruntのwatchが始まります
```
src/以下で作業を行ってください。

### JavaScript Library の導入（任意）
```shell
$ cd katamari/bower/
$ bower install
```
htdocs/shared/scripts/lib/に
bower.jsonに記述されているライブラリがinstallされます
インストール先のディレクトリを変更したい場合は
bower/.bowerrcを編集してください。


## 必要なもの
- grunt
- compass
- coffeescript

## 削除
- .git
- .gitignore
- htdocs/.gitkeep
