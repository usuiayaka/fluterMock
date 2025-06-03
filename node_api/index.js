const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");

const app = express();
app.use(cors());

//mysqlの接続設定☆
const connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "Mysqlpass",
  database: "tea",
});

//mysqlとはここで接続するぜ☆
connection.connect((err) => {
  if (err) {
    console.log("接続エラー", err);
    return;
  }
  console.log("接続できた！");
});

//teaテーブルの中身をもらう
app.get("/api/teas", (req, res) => {
  connection.query("SELECT * FROM tea", (err, results) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(results);
  });
});

//サーバー立てるお
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`サーバー立ってるよー ${PORT}`);
});
