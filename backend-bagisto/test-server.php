<?php
// Test serveur ultra-simple
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
$path = $_SERVER['REQUEST_URI'] ?? '/';

if ($method === 'OPTIONS') {
    exit(0);
}

if ($path === '/api/health' || $path === '/api/health/') {
    echo json_encode([
        'success' => true,
        'status' => 'OK',
        'app' => 'BAZAR Marketplace',
        'timestamp' => date('Y-m-d H:i:s'),
        'message' => 'Serveur opérationnel!'
    ]);
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Endpoint non trouvé',
        'path' => $path,
        'available' => ['/api/health']
    ]);
}
?>
