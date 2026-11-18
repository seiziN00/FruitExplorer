import express from 'express';
import pool from '../config/database.js';

const router = express.Router();

// POST /api/logs - Registrar una consulta de usuario
router.post('/', async (req, res) => {
  try {
    const { fruit_id, detection_method, used_tts, location_zone } = req.body;

    if (!fruit_id || !detection_method) {
      return res.status(400).json({ error: 'Faltan campos obligatorios (fruit_id, detection_method)' });
    }

    const query = `
      INSERT INTO query_logs (fruit_id, detection_method, used_tts, location_zone) 
      VALUES (?, ?, ?, ?)
    `;
    
    const [result] = await pool.execute(query, [
      fruit_id, 
      detection_method, 
      used_tts || false, 
      location_zone || 'Desconocida'
    ]);

    res.status(201).json({ 
      message: 'Consulta registrada exitosamente', 
      logId: result.insertId 
    });
  } catch (error) {
    console.error('Error al registrar la consulta:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

export default router;