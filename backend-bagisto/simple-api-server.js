const http = require('http');
const url = require('url');

// Configuration
const config = {
    appName: 'BAZAR Marketplace',
    port: 8000,
    baseUrl: `http://localhost:8000`
};

// Données mock
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
        },
        {
            id: 3,
            name: 'Casque Audio BAZAR',
            slug: 'casque-audio-bazar',
            description: 'Casque audio sans fil avec réduction de bruit',
            price: 79.99,
            special_price: 59.99,
            sku: 'CA001',
            image: 'casque.jpg',
            category_id: 1,
            category_name: 'Électronique',
            shop_name: 'TechStore',
            status: 1
        },
        {
            id: 4,
            name: 'T-shirt BAZAR',
            slug: 't-shirt-bazar',
            description: 'T-shirt confortable en coton bio',
            price: 29.99,
            special_price: null,
            sku: 'TS001',
            image: 'tshirt.jpg',
            category_id: 2,
            category_name: 'Mode',
            shop_name: 'FashionHub',
            status: 1
        },
        {
            id: 5,
            name: 'Sac à dos BAZAR',
            slug: 'sac-a-dos-bazar',
            description: 'Sac à dos élégant et fonctionnel',
            price: 49.99,
            special_price: 39.99,
            sku: 'SB001',
            image: 'sac.jpg',
            category_id: 2,
            category_name: 'Mode',
            shop_name: 'FashionHub',
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
        },
        {
            id: 3,
            name: 'Maison',
            slug: 'maison',
            description: 'Articles pour la maison et le jardin',
            image: 'maison.jpg',
            status: 1
        }
    ],
    shops: [
        {
            id: 1,
            name: 'TechStore',
            slug: 'techstore',
            description: 'Boutique spécialisée en électronique',
            logo: 'techstore-logo.jpg',
            email: 'contact@techstore.com',
            phone: '+33 1 23 45 67 89',
            status: 'active'
        },
        {
            id: 2,
            name: 'FashionHub',
            slug: 'fashionhub',
            description: 'Mode et tendances',
            logo: 'fashionhub-logo.jpg',
            email: 'info@fashionhub.com',
            phone: '+33 1 98 76 54 32',
            status: 'active'
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

    console.log(`${method} ${path}`);

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
                version: '1.0.0'
            });
            break;

        case '/api/products':
            if (method === 'GET') {
                const page = parseInt(query.page) || 1;
                const limit = parseInt(query.limit) || 20;
                const category = query.category;
                const search = query.search;

                let products = [...mockData.products];

                // Filtrer par catégorie
                if (category) {
                    products = products.filter(product => 
                        product.category_id == category || product.category_name === category
                    );
                }

                // Filtrer par recherche
                if (search) {
                    products = products.filter(product => 
                        product.name.toLowerCase().includes(search.toLowerCase()) ||
                        product.description.toLowerCase().includes(search.toLowerCase())
                    );
                }

                // Pagination
                const total = products.length;
                const offset = (page - 1) * limit;
                const paginatedProducts = products.slice(offset, offset + limit);

                sendJsonResponse(res, {
                    success: true,
                    data: paginatedProducts,
                    meta: {
                        total,
                        page,
                        limit,
                        pages: Math.ceil(total / limit)
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

        case '/api/shops':
            if (method === 'GET') {
                sendJsonResponse(res, {
                    success: true,
                    data: mockData.shops
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

        case '/api/customer/auth/register':
            if (method === 'POST') {
                const body = await parseBody(req);
                const { email, password, first_name, last_name } = body;

                if (!email || !password) {
                    sendJsonResponse(res, {
                        success: false,
                        message: 'Email et mot de passe requis'
                    }, 400);
                    return;
                }

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
                            first_name: first_name || 'Utilisateur',
                            last_name: last_name || 'Test',
                            email: email
                        },
                        access_token: token,
                        refresh_token: token
                    },
                    message: 'Inscription réussie!'
                }, 201);
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
                    },
                    {
                        id: 2,
                        product_id: 3,
                        quantity: 1,
                        name: 'Casque Audio BAZAR',
                        price: 79.99,
                        image: 'casque.jpg'
                    }
                ];

                sendJsonResponse(res, {
                    success: true,
                    data: cartItems
                });
            }
            break;

        case '/api/cart/add':
            if (method === 'POST') {
                const body = await parseBody(req);
                const { product_id, quantity } = body;

                if (!product_id) {
                    sendJsonResponse(res, {
                        success: false,
                        message: 'ID produit requis'
                    }, 400);
                    return;
                }

                sendJsonResponse(res, {
                    success: true,
                    message: 'Produit ajouté au panier!'
                });
            }
            break;

        case '/api/search':
            if (method === 'GET') {
                const query_term = query.q || '';
                const page = parseInt(query.page) || 1;
                const limit = parseInt(query.limit) || 20;

                let products = [...mockData.products];

                if (query_term) {
                    products = products.filter(product => 
                        product.name.toLowerCase().includes(query_term.toLowerCase()) ||
                        product.description.toLowerCase().includes(query_term.toLowerCase())
                    );
                }

                const total = products.length;
                const offset = (page - 1) * limit;
                const paginatedProducts = products.slice(offset, offset + limit);

                sendJsonResponse(res, {
                    success: true,
                    data: paginatedProducts,
                    meta: {
                        total,
                        query: query_term,
                        page,
                        limit
                    }
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
        .endpoint { background: #ecf0f1; padding: 15px; margin: 10px 0; border-radius: 5px; }
        .method { display: inline-block; padding: 5px 10px; border-radius: 3px; color: white; font-weight: bold; }
        .get { background: #27ae60; }
        .post { background: #3498db; }
        .url { font-family: monospace; color: #2c3e50; }
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
        
        <div class="endpoint">
            <span class="method get">GET</span>
            <span class="url">/api/health</span>
            <p>Vérification de l'état du serveur</p>
        </div>
        
        <div class="endpoint">
            <span class="method get">GET</span>
            <span class="url">/api/products</span>
            <p>Liste des produits disponibles</p>
        </div>
        
        <div class="endpoint">
            <span class="method get">GET</span>
            <span class="url">/api/categories</span>
            <p>Liste des catégories</p>
        </div>
        
        <div class="endpoint">
            <span class="method get">GET</span>
            <span class="url">/api/shops</span>
            <p>Liste des boutiques</p>
        </div>
        
        <div class="endpoint">
            <span class="method post">POST</span>
            <span class="url">/api/customer/auth/login</span>
            <p>Connexion utilisateur</p>
        </div>
        
        <div class="endpoint">
            <span class="method post">POST</span>
            <span class="url">/api/customer/auth/register</span>
            <p>Inscription utilisateur</p>
        </div>
        
        <div class="endpoint">
            <span class="method get">GET</span>
            <span class="url">/api/cart</span>
            <p>Panier de l'utilisateur connecté</p>
        </div>
        
        <div class="endpoint">
            <span class="method post">POST</span>
            <span class="url">/api/cart/add</span>
            <p>Ajouter un produit au panier</p>
        </div>
        
        <div class="endpoint">
            <span class="method get">GET</span>
            <span class="url">/api/search?q=terme</span>
            <p>Recherche de produits</p>
        </div>
        
        <h2>🔗 Intégration Flutter</h2>
        <p>Pour connecter votre application Flutter BAZAR :</p>
        <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px;">
// Dans lib/utils/server_configuration.dart
const String baseDomain = "http://localhost:8000";
const String baseUrl = "\$baseDomain/api";
        </pre>
        
        <h2>🧪 Tests Rapides</h2>
        <p>Testez les endpoints directement :</p>
        <ul>
            <li><a href="/api/health" target="_blank">Health Check</a></li>
            <li><a href="/api/products" target="_blank">Produits</a></li>
            <li><a href="/api/categories" target="_blank">Catégories</a></li>
            <li><a href="/api/shops" target="_blank">Boutiques</a></li>
        </ul>
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
                    'GET /api/shops',
                    'POST /api/customer/auth/login',
                    'POST /api/customer/auth/register',
                    'GET /api/cart',
                    'POST /api/cart/add',
                    'GET /api/search'
                ]
            }, 404);
    }
});

// Démarrer le serveur
server.listen(config.port, () => {
    console.log(`🚀 Serveur ${config.appName} démarré sur le port ${config.port}`);
    console.log(`📱 API disponible sur: ${config.baseUrl}/api`);
    console.log(`🌐 Interface web: ${config.baseUrl}`);
    console.log(`\n📡 Endpoints disponibles:`);
    console.log(`   GET  ${config.baseUrl}/api/health`);
    console.log(`   GET  ${config.baseUrl}/api/products`);
    console.log(`   GET  ${config.baseUrl}/api/categories`);
    console.log(`   GET  ${config.baseUrl}/api/shops`);
    console.log(`   POST ${config.baseUrl}/api/customer/auth/login`);
    console.log(`   POST ${config.baseUrl}/api/customer/auth/register`);
    console.log(`   GET  ${config.baseUrl}/api/cart`);
    console.log(`   POST ${config.baseUrl}/api/cart/add`);
    console.log(`   GET  ${config.baseUrl}/api/search`);
    console.log(`\n👥 Utilisateurs de test:`);
    console.log(`   admin@bazar.com / admin123`);
    console.log(`   user@bazar.com / user123`);
    console.log(`   test@bazar.com / test123`);
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
