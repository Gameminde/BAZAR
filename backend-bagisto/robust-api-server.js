const http = require('http');
const url = require('url');

// Configuration
const config = {
    appName: 'BAZAR Marketplace',
    port: 8000,
    baseUrl: `http://localhost:8000`
};

// Données mock simplifiées
const mockData = {
    products: [
        {
            id: 1,
            name: 'Smartphone BAZAR Pro',
            slug: 'smartphone-bazar-pro',
            description: 'Smartphone haut de gamme avec toutes les fonctionnalités',
            price: 299.99,
            special_price: 249.99,
            sku: 'SP001',
            image: 'smartphone.jpg',
            category_id: 1,
            category_name: 'Électronique',
            shop_name: 'TechStore',
            status: 1
        },
        {
            id: 2,
            name: 'Laptop BAZAR Ultra',
            slug: 'laptop-bazar-ultra',
            description: 'Laptop performant pour le travail et les loisirs',
            price: 899.99,
            special_price: null,
            sku: 'LP001',
            image: 'laptop.jpg',
            category_id: 1,
            category_name: 'Électronique',
            shop_name: 'TechStore',
            status: 1
        }
    ],
    categories: [
        {
            id: 1,
            name: 'Électronique',
            slug: 'electronique',
            description: 'Appareils électroniques et gadgets',
            image: 'electronique.jpg',
            status: 1
        },
        {
            id: 2,
            name: 'Mode',
            slug: 'mode',
            description: 'Vêtements et accessoires de mode',
            image: 'mode.jpg',
            status: 1
        }
    ]
};

// Fonction pour envoyer une réponse JSON
function sendJsonResponse(res, data, statusCode = 200) {
    res.writeHead(statusCode, {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization'
    });
    res.end(JSON.stringify(data, null, 2));
}

// Fonction pour parser le body de la requête
function parseBody(req) {
    return new Promise((resolve) => {
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        req.on('end', () => {
            try {
                resolve(JSON.parse(body));
            } catch (e) {
                resolve({});
            }
        });
    });
}

// Créer le serveur
const server = http.createServer(async (req, res) => {
    const parsedUrl = url.parse(req.url, true);
    const path = parsedUrl.pathname;
    const method = req.method;
    const query = parsedUrl.query;

    console.log(`${new Date().toISOString()} - ${method} ${path}`);

    // Gérer les requêtes OPTIONS (CORS)
    if (method === 'OPTIONS') {
        res.writeHead(200, {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization'
        });
        res.end();
        return;
    }

    // Router
    switch (path) {
        case '/api/health':
            sendJsonResponse(res, {
                success: true,
                status: 'OK',
                app: config.appName,
                timestamp: new Date().toISOString(),
                version: '1.0.0',
                uptime: process.uptime()
            });
            break;

        case '/api/products':
            if (method === 'GET') {
                sendJsonResponse(res, {
                    success: true,
                    data: mockData.products,
                    meta: {
                        total: mockData.products.length,
                        page: 1,
                        limit: 20
                    }
                });
            }
            break;

        case '/api/categories':
            if (method === 'GET') {
                sendJsonResponse(res, {
                    success: true,
                    data: mockData.categories
                });
            }
            break;

        case '/api/customer/auth/login':
            if (method === 'POST') {
                const body = await parseBody(req);
                const { email, password } = body;

                // Utilisateurs de test
                const testUsers = {
                    'admin@bazar.com': 'admin123',
                    'user@bazar.com': 'user123',
                    'test@bazar.com': 'test123'
                };

                if (testUsers[email] && testUsers[email] === password) {
                    const token = Buffer.from(JSON.stringify({
                        customer_id: Math.floor(Math.random() * 1000) + 1,
                        email: email,
                        exp: Date.now() + 3600000
                    })).toString('base64');

                    sendJsonResponse(res, {
                        success: true,
                        data: {
                            customer: {
                                id: Math.floor(Math.random() * 1000) + 1,
                                first_name: 'Utilisateur',
                                last_name: 'Test',
                                email: email
                            },
                            access_token: token,
                            refresh_token: token
                        },
                        message: 'Connexion réussie!'
                    });
                } else {
                    sendJsonResponse(res, {
                        success: false,
                        message: 'Email ou mot de passe incorrect'
                    }, 401);
                }
            }
            break;

        case '/api/cart':
            if (method === 'GET') {
                // Panier mock
                const cartItems = [
                    {
                        id: 1,
                        product_id: 1,
                        quantity: 2,
                        name: 'Smartphone BAZAR Pro',
                        price: 299.99,
                        image: 'smartphone.jpg'
                    }
                ];

                sendJsonResponse(res, {
                    success: true,
                    data: cartItems
                });
            }
            break;

        case '/':
        case '':
            // Page d'accueil HTML
            res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
            res.end(`
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${config.appName} - API</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; text-align: center; }
        .status { text-align: center; margin: 20px 0; padding: 20px; background: #d5f4e6; border-radius: 5px; color: #27ae60; }
        .test-users { background: #fff3cd; padding: 15px; border-radius: 5px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🏪 ${config.appName}</h1>
        <div class="status">
            ✅ Serveur API opérationnel sur ${config.baseUrl}
        </div>
        
        <div class="test-users">
            <h3>👥 Utilisateurs de Test</h3>
            <p><strong>Admin:</strong> admin@bazar.com / admin123</p>
            <p><strong>User:</strong> user@bazar.com / user123</p>
            <p><strong>Test:</strong> test@bazar.com / test123</p>
        </div>
        
        <h2>📡 Endpoints Disponibles</h2>
        <ul>
            <li><a href="/api/health" target="_blank">GET /api/health</a></li>
            <li><a href="/api/products" target="_blank">GET /api/products</a></li>
            <li><a href="/api/categories" target="_blank">GET /api/categories</a></li>
        </ul>
        
        <h2>🔗 Intégration Flutter</h2>
        <p>Backend URL: <code>${config.baseUrl}/api</code></p>
    </div>
</body>
</html>
            `);
            break;

        default:
            sendJsonResponse(res, {
                success: false,
                message: 'Endpoint non trouvé',
                path: path,
                available_endpoints: [
                    'GET /api/health',
                    'GET /api/products',
                    'GET /api/categories',
                    'POST /api/customer/auth/login',
                    'GET /api/cart'
                ]
            }, 404);
    }
});

// Démarrer le serveur
server.listen(config.port, '0.0.0.0', () => {
    console.log(`🚀 Serveur ${config.appName} démarré sur le port ${config.port}`);
    console.log(`📱 API disponible sur: ${config.baseUrl}/api`);
    console.log(`🌐 Interface web: ${config.baseUrl}`);
    console.log(`\n📡 Endpoints disponibles:`);
    console.log(`   GET  ${config.baseUrl}/api/health`);
    console.log(`   GET  ${config.baseUrl}/api/products`);
    console.log(`   GET  ${config.baseUrl}/api/categories`);
    console.log(`   POST ${config.baseUrl}/api/customer/auth/login`);
    console.log(`   GET  ${config.baseUrl}/api/cart`);
    console.log(`\n👥 Utilisateurs de test:`);
    console.log(`   admin@bazar.com / admin123`);
    console.log(`   user@bazar.com / user123`);
    console.log(`   test@bazar.com / test123`);
    console.log(`\n⏰ Serveur démarré à: ${new Date().toISOString()}`);
});

// Gestion des erreurs
server.on('error', (err) => {
    console.error('❌ Erreur serveur:', err);
});

// Arrêt propre
process.on('SIGINT', () => {
    console.log('\n🛑 Arrêt du serveur...');
    server.close(() => {
        console.log('✅ Serveur arrêté');
        process.exit(0);
    });
});

// Garder le processus actif
process.on('uncaughtException', (err) => {
    console.error('❌ Exception non gérée:', err);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('❌ Promesse rejetée non gérée:', reason);
});
