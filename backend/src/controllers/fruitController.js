import pool from '../config/database.js';

// Obtener todas las frutas con su respectiva región
export const getAllFruits = async (req, res) => {
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
};

// Obtener una fruta específica por su ID
export const getFruitById = async (req, res) => {
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
};