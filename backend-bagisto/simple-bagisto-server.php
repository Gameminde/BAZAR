<?php
/**
 * Serveur Bagisto Simplifié pour BAZAR
 * Version sans Composer - API REST basique
 */

// Configuration
$config = [
    'app_name' => 'BAZAR Marketplace',
    'app_url' => 'http://localhost:8000',
    'database' => 'database/bagisto.sqlite',
    'debug' => true
];

// Créer le dossier database s'il n'existe pas
if (!is_dir('database')) {
    mkdir('database', 0755, true);
}

// Créer la base SQLite si elle n'existe pas
if (!file_exists($config['database'])) {
    $pdo = new PDO('sqlite:' . $config['database']);
    
    // Créer les tables de base
    $pdo->exec("
        CREATE TABLE IF NOT EXISTS customers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            first_name VARCHAR(255),
            last_name VARCHAR(255),
            email VARCHAR(255) UNIQUE,
            password VARCHAR(255),
            phone VARCHAR(20),
            status INTEGER DEFAULT 1,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
        
        CREATE TABLE IF NOT EXISTS categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name VARCHAR(255),
            slug VARCHAR(255) UNIQUE,
            description TEXT,
            image VARCHAR(255),
            status INTEGER DEFAULT 1,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
        
        CREATE TABLE IF NOT EXISTS products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name VARCHAR(255),
            slug VARCHAR(255) UNIQUE,
            description TEXT,
            price DECIMAL(10,2),
            special_price DECIMAL(10,2),
            sku VARCHAR(255),
            image VARCHAR(255),
            category_id INTEGER,
            status INTEGER DEFAULT 1,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (category_id) REFERENCES categories(id)
        );
        
        CREATE TABLE IF NOT EXISTS shops (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name VARCHAR(255),
            slug VARCHAR(255) UNIQUE,
            description TEXT,
            logo VARCHAR(255),
            email VARCHAR(255),
            phone VARCHAR(20),
            status VARCHAR(20) DEFAULT 'active',
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
        
        CREATE TABLE IF NOT EXISTS cart_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customer_id INTEGER,
            product_id INTEGER,
            quantity INTEGER DEFAULT 1,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (customer_id) REFERENCES customers(id),
            FOREIGN KEY (product_id) REFERENCES products(id)
        );
        
        CREATE TABLE IF NOT EXISTS orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customer_id INTEGER,
            status VARCHAR(20) DEFAULT 'pending',
            total DECIMAL(10,2),
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (customer_id) REFERENCES customers(id)
        );
    ");
    
    // Insérer des données de test
    $pdo->exec("
        INSERT OR IGNORE INTO categories (name, slug, description) VALUES 
        ('Électronique', 'electronique', 'Appareils électroniques et gadgets'),
        ('Mode', 'mode', 'Vêtements et accessoires de mode'),
        ('Maison', 'maison', 'Articles pour la maison et le jardin');
        
        INSERT OR IGNORE INTO shops (name, slug, description, email) VALUES 
        ('TechStore', 'techstore', 'Boutique spécialisée en électronique', 'contact@techstore.com'),
        ('FashionHub', 'fashionhub', 'Mode et tendances', 'info@fashionhub.com');
        
        INSERT OR IGNORE INTO products (name, slug, description, price, sku, category_id, image) VALUES 
        ('Smartphone BAZAR Pro', 'smartphone-bazar-pro', 'Smartphone haut de gamme avec toutes les fonctionnalités', 299.99, 'SP001', 1, 'smartphone.jpg'),
        ('Laptop BAZAR Ultra', 'laptop-bazar-ultra', 'Laptop performant pour le travail', 899.99, 'LP001', 1, 'laptop.jpg'),
        ('Casque Audio BAZAR', 'casque-audio-bazar', 'Casque audio sans fil avec réduction de bruit', 79.99, 'CA001', 1, 'casque.jpg'),
        ('T-shirt BAZAR', 't-shirt-bazar', 'T-shirt confortable en coton bio', 29.99, 'TS001', 2, 'tshirt.jpg'),
        ('Sac à dos BAZAR', 'sac-a-dos-bazar', 'Sac à dos élégant et fonctionnel', 49.99, 'SB001', 2, 'sac.jpg');
    ");
    
    echo "✅ Base de données SQLite créée avec succès!\n";
}

// Fonction pour envoyer une réponse JSON
function jsonResponse($data, $status = 200) {
    http_response_code($status);
    header('Content-Type: application/json');
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization');
    
    if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        exit(0);
    }
    
    echo json_encode($data, JSON_PRETTY_PRINT);
    exit;
}

// Fonction pour obtenir la méthode HTTP
$method = $_SERVER['REQUEST_METHOD'];
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$path = str_replace('/api/', '', $path);

// Connexion à la base de données
try {
    $pdo = new PDO('sqlite:' . $config['database']);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    jsonResponse(['error' => 'Database connection failed'], 500);
}

// Router simple
switch ($path) {
    case 'health':
        jsonResponse([
            'success' => true,
            'status' => 'OK',
            'app' => $config['app_name'],
            'timestamp' => date('Y-m-d H:i:s')
        ]);
        break;
        
    case 'products':
        if ($method === 'GET') {
            $stmt = $pdo->query("
                SELECT p.*, c.name as category_name, s.name as shop_name 
                FROM products p 
                LEFT JOIN categories c ON p.category_id = c.id 
                LEFT JOIN shops s ON p.shop_id = s.id 
                WHERE p.status = 1
            ");
            $products = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            jsonResponse([
                'success' => true,
                'data' => $products,
                'meta' => ['total' => count($products)]
            ]);
        }
        break;
        
    case 'categories':
        if ($method === 'GET') {
            $stmt = $pdo->query("SELECT * FROM categories WHERE status = 1");
            $categories = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            jsonResponse([
                'success' => true,
                'data' => $categories
            ]);
        }
        break;
        
    case 'shops':
        if ($method === 'GET') {
            $stmt = $pdo->query("SELECT * FROM shops WHERE status = 'active'");
            $shops = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            jsonResponse([
                'success' => true,
                'data' => $shops
            ]);
        }
        break;
        
    case 'customer/auth/login':
        if ($method === 'POST') {
            $input = json_decode(file_get_contents('php://input'), true);
            $email = $input['email'] ?? '';
            $password = $input['password'] ?? '';
            
            $stmt = $pdo->prepare("SELECT * FROM customers WHERE email = ?");
            $stmt->execute([$email]);
            $customer = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($customer && password_verify($password, $customer['password'])) {
                $token = base64_encode(json_encode([
                    'customer_id' => $customer['id'],
                    'email' => $customer['email'],
                    'exp' => time() + 3600
                ]));
                
                jsonResponse([
                    'success' => true,
                    'data' => [
                        'customer' => $customer,
                        'access_token' => $token,
                        'refresh_token' => $token
                    ],
                    'message' => 'Connexion réussie!'
                ]);
            } else {
                jsonResponse([
                    'success' => false,
                    'message' => 'Email ou mot de passe incorrect'
                ], 401);
            }
        }
        break;
        
    case 'customer/auth/register':
        if ($method === 'POST') {
            $input = json_decode(file_get_contents('php://input'), true);
            $email = $input['email'] ?? '';
            $password = $input['password'] ?? '';
            $firstName = $input['first_name'] ?? '';
            $lastName = $input['last_name'] ?? '';
            
            if (empty($email) || empty($password)) {
                jsonResponse([
                    'success' => false,
                    'message' => 'Email et mot de passe requis'
                ], 400);
            }
            
            $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
            
            try {
                $stmt = $pdo->prepare("
                    INSERT INTO customers (first_name, last_name, email, password) 
                    VALUES (?, ?, ?, ?)
                ");
                $stmt->execute([$firstName, $lastName, $email, $hashedPassword]);
                
                $customerId = $pdo->lastInsertId();
                
                $token = base64_encode(json_encode([
                    'customer_id' => $customerId,
                    'email' => $email,
                    'exp' => time() + 3600
                ]));
                
                jsonResponse([
                    'success' => true,
                    'data' => [
                        'customer' => [
                            'id' => $customerId,
                            'first_name' => $firstName,
                            'last_name' => $lastName,
                            'email' => $email
                        ],
                        'access_token' => $token,
                        'refresh_token' => $token
                    ],
                    'message' => 'Inscription réussie!'
                ], 201);
            } catch (PDOException $e) {
                jsonResponse([
                    'success' => false,
                    'message' => 'Email déjà utilisé'
                ], 400);
            }
        }
        break;
        
    case 'cart':
        if ($method === 'GET') {
            $authHeader = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
            $token = str_replace('Bearer ', '', $authHeader);
            
            if (!$token) {
                jsonResponse(['success' => false, 'message' => 'Token requis'], 401);
            }
            
            $tokenData = json_decode(base64_decode($token), true);
            $customerId = $tokenData['customer_id'] ?? null;
            
            if (!$customerId) {
                jsonResponse(['success' => false, 'message' => 'Token invalide'], 401);
            }
            
            $stmt = $pdo->prepare("
                SELECT ci.*, p.name, p.price, p.image 
                FROM cart_items ci 
                JOIN products p ON ci.product_id = p.id 
                WHERE ci.customer_id = ?
            ");
            $stmt->execute([$customerId]);
            $cartItems = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            jsonResponse([
                'success' => true,
                'data' => $cartItems
            ]);
        }
        break;
        
    case 'cart/add':
        if ($method === 'POST') {
            $authHeader = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
            $token = str_replace('Bearer ', '', $authHeader);
            
            if (!$token) {
                jsonResponse(['success' => false, 'message' => 'Token requis'], 401);
            }
            
            $tokenData = json_decode(base64_decode($token), true);
            $customerId = $tokenData['customer_id'] ?? null;
            
            if (!$customerId) {
                jsonResponse(['success' => false, 'message' => 'Token invalide'], 401);
            }
            
            $input = json_decode(file_get_contents('php://input'), true);
            $productId = $input['product_id'] ?? null;
            $quantity = $input['quantity'] ?? 1;
            
            if (!$productId) {
                jsonResponse(['success' => false, 'message' => 'ID produit requis'], 400);
            }
            
            try {
                $stmt = $pdo->prepare("
                    INSERT INTO cart_items (customer_id, product_id, quantity) 
                    VALUES (?, ?, ?)
                ");
                $stmt->execute([$customerId, $productId, $quantity]);
                
                jsonResponse([
                    'success' => true,
                    'message' => 'Produit ajouté au panier!'
                ]);
            } catch (PDOException $e) {
                jsonResponse(['success' => false, 'message' => 'Erreur lors de l\'ajout'], 500);
            }
        }
        break;
        
    default:
        jsonResponse([
            'success' => false,
            'message' => 'Endpoint non trouvé',
            'available_endpoints' => [
                'GET /api/health',
                'GET /api/products',
                'GET /api/categories',
                'GET /api/shops',
                'POST /api/customer/auth/login',
                'POST /api/customer/auth/register',
                'GET /api/cart',
                'POST /api/cart/add'
            ]
        ], 404);
}

// Page d'accueil
if ($path === '' || $path === '/') {
    ?>
    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><?= $config['app_name'] ?> - API</title>
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
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🏪 <?= $config['app_name'] ?></h1>
            <div class="status">
                ✅ Serveur API opérationnel sur <?= $config['app_url'] ?>
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
            
            <h2>🔗 Intégration Flutter</h2>
            <p>Pour connecter votre application Flutter BAZAR :</p>
            <pre style="background: #2c3e50; color: #ecf0f1; padding: 15px; border-radius: 5px;">
// Dans lib/utils/server_configuration.dart
const String baseDomain = "http://localhost:8000";
const String baseUrl = "$baseDomain/api";
            </pre>
        </div>
    </body>
    </html>
    <?php
}
?>
