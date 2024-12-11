// 목표 몸무게 설정 API
app.post("/save-target-weight", (req, res) => {
    if (!req.session.username) {
      return res.status(401).json({ message: "로그인이 필요합니다" });
    }
  
    const { targetWeight } = req.body;
    if (!targetWeight) {
      return res.status(400).json({ message: "Invalid target weight" });
    }
  
    const query = "UPDATE users SET target_weight = ? WHERE username = ?";
    db.query(query, [targetWeight, req.session.username], (err, result) => {
      if (err) {
        return res.status(500).json({ message: "Error updating target weight", error: err });
      }
  
      res.status(200).json({ message: "Success" });
    });
  });