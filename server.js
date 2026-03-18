const express = require('express');
const path = require('path');
const os = require('os');

const app = express();
const PORT = 3000;

app.use(express.static(path.join(__dirname, 'public')));

app.listen(PORT, '0.0.0.0', () => {
  // Trouver l'IP locale pour accès téléphone
  const nets = os.networkInterfaces();
  let localIP = 'localhost';
  for (const name of Object.keys(nets)) {
    for (const net of nets[name]) {
      if (net.family === 'IPv4' && !net.internal) {
        localIP = net.address;
      }
    }
  }

  console.log('\n╔════════════════════════════════════════╗');
  console.log('║     💰 BUDGET FAMILIAL - DÉMARRÉ      ║');
  console.log('╠════════════════════════════════════════╣');
  console.log(`║  💻 PC      : http://localhost:${PORT}     ║`);
  console.log(`║  📱 Tél.    : http://${localIP}:${PORT}  ║`);
  console.log('╠════════════════════════════════════════╣');
  console.log('║  Pour arrêter : appuyez sur CTRL+C     ║');
  console.log('╚════════════════════════════════════════╝\n');
});
