import express from 'express';
import pool from '../config/database.js';

const router = express.Router();

// GET /api/fruits - Obtener todas las frutas con su región
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT f.*, r.name as region_name 
      FROM fruits f 
      JOIN regions r ON f.region_id = r.id
    `);
    res.json(rows);
  } catch (error) {
    console.error('Error al obtener frutas:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// GET /api/fruits/:id - Obtener una fruta específica por ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query(`
      SELECT f.*, r.name as region_name 
      FROM fruits f 
      JOIN regions r ON f.region_id = r.id 
      WHERE f.id = ?
    `, [id]);

    if (rows.length === 0) {
      return res.status(404).json({ error: 'Fruta no encontrada' });
    }

    res.json(rows[0]);
  } catch (error) {
    console.error('Error al obtener la fruta:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

export default router;