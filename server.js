// 메모 조회 API
app.get('/get-notes', (req, res) => {
    if (!req.session.username) {
        return res.status(401).json({ message: '로그인이 필요합니다' });
    }

    const query = 'SELECT notes.id, notes.title, notes.contents, notes.created_at FROM notes INNER JOIN users ON notes.user_id = users.id WHERE users.username = ?';

    db.query(query, [req.session.username], (err, results) => {
        if (err) {
            return res.status(500).json({ message: 'Error fetching notes', error: err });
        }
        res.status(200).json(results);
    });
});

// 메모 삭제 API
app.delete('/delete-note/:id', (req, res) => {
    if (!req.session.username) {
        return res.status(401).json({ message: '로그인이 필요합니다' });
    }
    
    const noteId = req.params.id;
    const deleteQuery = 'DELETE FROM notes WHERE id = ?';

    db.query(deleteQuery, [noteId], (err, result) => {
        if (err) {
            return res.status(500).json({ message: 'Error deleting note', error: err });
        }
        res.status(200).json({ message: '삭제 완료' });
    });
});

// 메모 수정 API
app.put('/update-notes/:id', (req, res) => {
    const memo_id = req.params.id;
    const { title, content } = req.body;
    const query = 'UPDATE notes SET title = ?, contents = ? WHERE id = ?';

    db.query(query, [title, content, memo_id], (err, result) => {
      if (err) {
        res.status(500).send(err);
      } else {
        res.status(200).send({ message: '수정 완료' });
      }
    });
  });

// 메모 추가 API
app.post('/add-note', (req, res) => {
    if (!req.session.username) {
        return res.status(401).json({ message: '로그인이 필요합니다' });
    }

    const { title, contents } = req.body;
    const query = 'SELECT id FROM users WHERE username = ?';
    
    db.query(query, [req.session.username], (err, results) => {
        if (err || results.length === 0) {
            return res.status(500).json({ message: 'User not found' });
        }

        const userId = results[0].id;
        const insertQuery = 'INSERT INTO notes (user_id, title, contents) VALUES (?, ?, ?)';
        
        db.query(insertQuery, [userId, title, contents], (err, result) => {
            if (err) {
                console.error('Error during INSERT query:', err); // 메모 추가 오류 로그
                return res.status(500).json({ message: 'Error adding note', error: err });
                
            }
            return res.status(200).json({ message: '추가 완료' });
        });
    });
});