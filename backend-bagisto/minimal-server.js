const http = require('http');

const server = http.createServer((req, res) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
    
    res.writeHead(200, {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
    });
    
    if (req.url === '/api/health') {
        res.end(JSON.stringify({
            success: true,
            status: 'OK',
            timestamp: new Date().toISOString()
        }));
    } else {
        res.end(JSON.stringify({
            success: false,
            message: 'Endpoint non trouvé',
            url: req.url
        }));
    }
});

const PORT = 8000;
server.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Serveur démarré sur le port ${PORT}`);
    console.log(`📱 Test: http://localhost:${PORT}/api/health`);
});

server.on('error', (err) => {
    console.error('❌ Erreur serveur:', err);
});

// Garder le processus actif
setInterval(() => {
    console.log(`⏰ Serveur actif depuis ${Math.floor(process.uptime())}s`);
}, 30000);
