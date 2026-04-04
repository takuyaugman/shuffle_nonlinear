from flask import Flask, render_template, request, redirect
#import sqlite3
#import shutil
import json

app = Flask(__name__)

DB = "data.db"

def query(sql, params=(), one=False):
    con = sqlite3.connect(DB)
    con.row_factory = sqlite3.Row
    cur = con.execute(sql, params)
    rows = cur.fetchall()
    con.commit()
    con.close()
    return (rows[0] if rows else None) if one else rows

# -------------------------
# Items CRUD
# -------------------------
@app.route("/items")
def items_list():
    items = query("SELECT * FROM items ORDER BY id DESC")
    return render_template("items_list.html", items=items)

@app.route("/items/edit/<int:item_id>", methods=["GET", "POST"])
def items_edit(item_id):
    if request.method == "POST":
        label = request.form["label"]
        detail = request.form["detail"]
        tags = request.form["tags"]
        if item_id == 0:
            query("INSERT INTO items (label, detail, tags) VALUES (?, ?, ?)",
                  (label, detail, tags))
        else:
            query("UPDATE items SET label=?, detail=?, tags=? WHERE id=?",
                  (label, detail, tags, item_id))
        return redirect("/items")

    item = query("SELECT * FROM items WHERE id=?", (item_id,), one=True)
    return render_template("items_edit.html", item=item)

@app.route("/items/delete/<int:item_id>")
def items_delete(item_id):
    query("DELETE FROM items WHERE id=?", (item_id,))
    return redirect("/items")

# -------------------------
# Prompts CRUD
# -------------------------
@app.route("/prompts")
def prompts_list():
    prompts = query("SELECT * FROM prompts ORDER BY id DESC")
    return render_template("prompts_list.html", prompts=prompts)

@app.route("/")
def route_redirect():
    return redirect("/items")

@app.route("/prompts/edit/<int:prompt_id>", methods=["GET", "POST"])
def prompts_edit(prompt_id):
    if request.method == "POST":
        text = request.form["text"]
        item_count = request.form["item_count"]
        if prompt_id == 0:
            query("INSERT INTO prompts (text, item_count) VALUES (?, ?)",
                  (text, item_count))
        else:
            query("UPDATE prompts SET text=?, item_count=? WHERE id=?",
                  (text, item_count, prompt_id))
        return redirect("/prompts")

    prompt = query("SELECT * FROM prompts WHERE id=?", (prompt_id,), one=True)
    return render_template("prompts_edit.html", prompt=prompt)

@app.route("/prompts/delete/<int:prompt_id>")
def prompts_delete(prompt_id):
    query("DELETE FROM prompts WHERE id=?", (prompt_id,))
    return redirect("/prompts")

# Converts sqlite3 to json
#
import sqlite3
import json

def db_to_json(db_path):
    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row
    cur = conn.cursor()

    # 全テーブル名を取得（内部テーブルを除外）
    cur.execute("""
        SELECT name FROM sqlite_master
        WHERE type='table' AND name NOT LIKE 'sqlite_%';
    """)
    tables = [row["name"] for row in cur.fetchall()]

    result = {}

    for table in tables:
        cur.execute(f"SELECT * FROM {table};")
        rows = cur.fetchall()
        result[table] = [dict(row) for row in rows]

    conn.close()

    return json.dumps(result, ensure_ascii=False, indent=2)


# 実行
json_text = db_to_json("data.db")

with open("../godot/data.db", "w", encoding="utf-8") as f:
    f.write(json_text)

print("✔ 完了")



if __name__ == "__main__":
    #shutil.copyfile("../data.db", "../godot/data.db")
    #print("✔ 起動時にコピー完了")
    db_to_json("../data.db")
    app.run()
