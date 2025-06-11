const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json()); // ここでJSONのボディをパース

require("dotenv").config();

// MySQL接続設定
const connection = mysql.createConnection({
  host: process.env.HOST,
  user: process.env.USER,
  password: process.env.PASSWORD,
  database: process.env.DATABASE,
});

connection.connect((err) => {
  if (err) {
    console.log("接続エラー", err);
    return;
  }
  console.log("接続できた！");
});

// GET /api/teas
app.get("/api/teas", (req, res) => {
  connection.query("SELECT * FROM tea", (err, results) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(results);
  });
});

// POST /api/teas
app.post("/api/teas", (req, res) => {
  const { name, image, description, tasteType, aroma, color } = req.body;

  if (!name || !image || !description || !tasteType || !aroma || !color) {
    return res.status(400).json({ message: "すべての項目を入力してください" });
  }

  const query = `INSERT INTO tea (name,image,description
,tasteType,aroma,color)VALUES(?,?,?,?,?,?)`;

  const values = [name, image, description, tasteType, aroma, color];

  connection.query(query, values, (err, result) => {
    if (err) {
      console.error("DBエラー", err);
      return res.status(500).json({
        message: "DB登録に失敗しました。",
      });
    }
    res.status(201).json({
      message: "登録完了",
      id: result.insertId,
    });
  });
});

app.post("/api/login", (req, res) => {
  const { name, password } = req.body;

  if (!name || !password) {
    return res
      .status(400)
      .json({ message: "ニックネームとパスワードは必須です" });
  }

  const query = "SELECT * FROM users WHERE name = ?";
  connection.query(query, [name], (err, results) => {
    if (err) {
      console.error("DBエラー", err);
      return res.status(500).json({ message: "サーバーエラー" });
    }

    if (results.length === 0) {
      return res.status(401).json({ message: "ユーザーが存在しません" });
    }

    const user = results[0];

    if (user.pass === password) {
      // ログイン成功
      res.status(200).json({
        message: "ログイン成功",
        userId: user.id,
        name: user.name,
        pass: user.pass,
        img: user.img,
      });
    } else {
      res.status(401).json({ message: "パスワードが違います" });
    }
  });
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`サーバー立ってるよー ${PORT}`);
});
