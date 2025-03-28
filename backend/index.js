const express = require("express");
const cors = require("cors");
const { Pool } = require("pg");

const app = express();
const port = process.env.PORT || 5000; // Use environment variable for port

// Set up CORS if needed
const corsOptions = {
  origin: "http://yourfrontenddomain.com", // Update with your frontend URL
};
app.use(cors(corsOptions));

const pool = new Pool({
  connectionString: process.env.CONNECTION_STRING, // Database connection string
});

// Check database connection on startup
pool.connect((err) => {
  if (err) {
    console.error("Database connection error:", err.stack);
  } else {
    console.log("Connected to the database");
  }
});

app.get("/data", (req, res) => {
  pool.query("SELECT movie, hero FROM movie_hero", [], (err, result) => {
    if (err) {
      return res.status(500).json({ error: "Internal Server Error" });
    }
    return res.status(200).json({ data: result.rows });
  });
});

app.listen(port, () => console.log(`Backend API running on port ${port}`));
