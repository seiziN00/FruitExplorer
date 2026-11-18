import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import fruitRoutes from './routes/fruitRoutes.js';
import logRoutes from './routes/logRoutes.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors());
app.use(express.json());

// Montaje de Rutas
app.use('/api/fruits', fruitRoutes);
app.use('/api/logs', logRoutes);

// Ruta de comprobación de estado
app.get('/', (req, res) => {
  res.json({ message: 'API de FruitExplorer funcionando correctamente 🚀' });
});

app.listen(PORT, () => {
  console.log(`Servidor Express corriendo en el puerto ${PORT}`);
});