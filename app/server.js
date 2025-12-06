const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.get('/', (req, res) => {
  console.log('GET /');
  res.send('Hello from private EC2 behind ALB!');
});

app.get('/health', (req, res) => {
  console.log('GET /health');
  res.send('ok');
});

// Bind to 0.0.0.0 so the app is reachable externally (including ALB)
app.listen(port, '0.0.0.0', () => {
  console.log(`Server listening on ${port}`);
});

