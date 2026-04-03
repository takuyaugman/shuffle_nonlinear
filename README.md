## 簡易フラッシュカード

会議で話すことを覚えるために自分用に作ったアプリです
Godotで作成しました

## フラッシュカードの編集

フラッシュカードの編集は Python + Flask で行います。
flask と sqlite3 パッケージが必要なので pip でインストールしてください。

+ Windowsの場合

```bash
python -m pip install flask sqlite3
```

+ サーバーの実行

```bash
cd flask
python app.py
```

http://localhost:5000
から編集画面を見ることが出来ます。
