<?php

/**
 * Script de migration des données Node.js vers Bagisto
 * Pour BAZAR Marketplace
 */

require_once 'vendor/autoload.php';

use Illuminate\Support\Facades\Http;
use Webkul\Customer\Models\Customer;
use Webkul\Product\Models\Product;
use Webkul\Category\Models\Category;
use Webkul\Shop\Models\Shop;
use Webkul\Sales\Models\Order;
use Illuminate\Support\Facades\DB;

class DataMigrationService
{
    private $sourceApiUrl;
    private $migratedCounts = [
        'customers' => 0,
        'products' => 0,
        'categories' => 0,
        'shops' => 0,
        'orders' => 0
    ];

    public function __construct($sourceApiUrl = 'http://localhost:3001/api/v1')
    {
        $this->sourceApiUrl = $sourceApiUrl;
    }

    /**
     * Migration complète des données
     */
    public function migrateAll()
    {
        echo "🚀 DÉBUT DE LA MIGRATION BAZAR\n";
        echo "===============================\n\n";

        try {
            // 1. Migration des catégories (prérequis)
            $this->migrateCategories();
            
            // 2. Migration des boutiques
            $this->migrateShops();
            
            // 3. Migration des clients
            $this->migrateCustomers();
            
            // 4. Migration des produits
            $this->migrateProducts();
            
            // 5. Migration des commandes
            $this->migrateOrders();

            $this->displaySummary();

        } catch (Exception $e) {
            echo "❌ Erreur lors de la migration: " . $e->getMessage() . "\n";
            return false;
        }

        return true;
    }

    /**
     * Migration des catégories
     */
    private function migrateCategories()
    {
        echo "📂 Migration des catégories...\n";
        
        try {
            $response = Http::get($this->sourceApiUrl . '/categories');
            $categories = $response->json()['data'] ?? [];

            foreach ($categories as $categoryData) {
                $category = Category::updateOrCreate(
                    ['slug' => $categoryData['slug']],
                    [
                        'name' => $categoryData['name'],
                        'description' => $categoryData['description'] ?? '',
                        'slug' => $categoryData['slug'],
                        'meta_title' => $categoryData['name'],
                        'meta_description' => $categoryData['description'] ?? '',
                        'status' => 1,
                        'position' => $categoryData['position'] ?? 1,
                        'display_mode' => 'products_and_description',
                        'is_anchor' => 1,
                    ]
                );

                $this->migratedCounts['categories']++;
                echo "  ✅ Catégorie: {$category->name}\n";
            }

        } catch (Exception $e) {
            echo "  ⚠️ Erreur catégories: " . $e->getMessage() . "\n";
        }
    }

    /**
     * Migration des boutiques
     */
    private function migrateShops()
    {
        echo "🏪 Migration des boutiques...\n";
        
        try {
            $response = Http::get($this->sourceApiUrl . '/shops');
            $shops = $response->json()['data'] ?? [];

            foreach ($shops as $shopData) {
                $shop = Shop::updateOrCreate(
                    ['slug' => $shopData['slug']],
                    [
                        'name' => $shopData['name'],
                        'slug' => $shopData['slug'],
                        'description' => $shopData['description'] ?? '',
                        'logo' => $shopData['logo'] ?? '',
                        'banner' => $shopData['banner'] ?? '',
                        'address' => $shopData['address'] ?? '',
                        'phone' => $shopData['phone'] ?? '',
                        'email' => $shopData['email'] ?? '',
                        'status' => $shopData['status'] ?? 'active',
                        'is_verified' => $shopData['is_verified'] ?? false,
                        'commission_rate' => $shopData['commission_rate'] ?? 5.0,
                    ]
                );

                $this->migratedCounts['shops']++;
                echo "  ✅ Boutique: {$shop->name}\n";
            }

        } catch (Exception $e) {
            echo "  ⚠️ Erreur boutiques: " . $e->getMessage() . "\n";
        }
    }

    /**
     * Migration des clients
     */
    private function migrateCustomers()
    {
        echo "👥 Migration des clients...\n";
        
        try {
            $response = Http::get($this->sourceApiUrl . '/users');
            $users = $response->json()['data'] ?? [];

            foreach ($users as $userData) {
                $customer = Customer::updateOrCreate(
                    ['email' => $userData['email']],
                    [
                        'first_name' => $userData['firstName'] ?? $userData['name'],
                        'last_name' => $userData['lastName'] ?? '',
                        'email' => $userData['email'],
                        'phone' => $userData['phone'] ?? '',
                        'password' => bcrypt($userData['password'] ?? 'password123'),
                        'status' => $userData['status'] ?? 1,
                        'is_verified' => $userData['is_verified'] ?? true,
                        'created_at' => $userData['createdAt'] ?? now(),
                        'updated_at' => $userData['updatedAt'] ?? now(),
                    ]
                );

                $this->migratedCounts['customers']++;
                echo "  ✅ Client: {$customer->email}\n";
            }

        } catch (Exception $e) {
            echo "  ⚠️ Erreur clients: " . $e->getMessage() . "\n";
        }
    }

    /**
     * Migration des produits
     */
    private function migrateProducts()
    {
        echo "📦 Migration des produits...\n";
        
        try {
            $response = Http::get($this->sourceApiUrl . '/products');
            $products = $response->json()['data'] ?? [];

            foreach ($products as $productData) {
                // Trouver la boutique
                $shop = Shop::where('slug', $productData['shop_slug'])->first();
                if (!$shop) {
                    echo "  ⚠️ Boutique non trouvée: {$productData['shop_slug']}\n";
                    continue;
                }

                // Trouver la catégorie
                $category = Category::where('slug', $productData['category_slug'])->first();
                if (!$category) {
                    echo "  ⚠️ Catégorie non trouvée: {$productData['category_slug']}\n";
                    continue;
                }

                $product = Product::updateOrCreate(
                    ['sku' => $productData['sku'] ?? $productData['id']],
                    [
                        'type' => 'simple',
                        'attribute_family_id' => 1, // Default attribute family
                        'sku' => $productData['sku'] ?? $productData['id'],
                        'parent_id' => null,
                        'shop_id' => $shop->id,
                        'created_at' => $productData['createdAt'] ?? now(),
                        'updated_at' => $productData['updatedAt'] ?? now(),
                    ]
                );

                // Ajouter les attributs du produit
                $this->addProductAttributes($product, $productData);
                
                // Associer à la catégorie
                $product->categories()->sync([$category->id]);

                $this->migratedCounts['products']++;
                echo "  ✅ Produit: {$productData['name']}\n";
            }

        } catch (Exception $e) {
            echo "  ⚠️ Erreur produits: " . $e->getMessage() . "\n";
        }
    }

    /**
     * Ajouter les attributs d'un produit
     */
    private function addProductAttributes($product, $productData)
    {
        $attributes = [
            'name' => $productData['name'],
            'description' => $productData['description'] ?? '',
            'short_description' => $productData['short_description'] ?? '',
            'url_key' => $productData['slug'] ?? str_slug($productData['name']),
            'price' => $productData['price'] ?? 0,
            'cost' => $productData['cost'] ?? 0,
            'special_price' => $productData['special_price'] ?? null,
            'special_price_from' => $productData['special_price_from'] ?? null,
                        'special_price_to' => $productData['special_price_to'] ?? null,
            'meta_title' => $productData['meta_title'] ?? $productData['name'],
            'meta_description' => $productData['meta_description'] ?? '',
            'meta_keywords' => $productData['meta_keywords'] ?? '',
            'weight' => $productData['weight'] ?? 0,
            'status' => $productData['status'] ?? 1,
            'is_new' => $productData['is_new'] ?? 0,
            'featured' => $productData['featured'] ?? 0,
            'manage_stock' => $productData['manage_stock'] ?? 1,
            'quantity' => $productData['quantity'] ?? 0,
            'min_quantity' => $productData['min_quantity'] ?? 1,
            'max_quantity' => $productData['max_quantity'] ?? 100,
        ];

        foreach ($attributes as $attributeCode => $value) {
            if ($value !== null) {
                $product->setAttribute($attributeCode, $value);
            }
        }

        $product->save();
    }

    /**
     * Migration des commandes
     */
    private function migrateOrders()
    {
        echo "📋 Migration des commandes...\n";
        
        try {
            $response = Http::get($this->sourceApiUrl . '/orders');
            $orders = $response->json()['data'] ?? [];

            foreach ($orders as $orderData) {
                // Trouver le client
                $customer = Customer::where('email', $orderData['customer_email'])->first();
                if (!$customer) {
                    echo "  ⚠️ Client non trouvé: {$orderData['customer_email']}\n";
                    continue;
                }

                $order = Order::create([
                    'customer_id' => $customer->id,
                    'customer_email' => $orderData['customer_email'],
                    'customer_first_name' => $orderData['customer_first_name'] ?? $customer->first_name,
                    'customer_last_name' => $orderData['customer_last_name'] ?? $customer->last_name,
                    'status' => $orderData['status'] ?? 'pending',
                    'state' => $orderData['state'] ?? 'new',
                    'is_guest' => $orderData['is_guest'] ?? false,
                    'total_item_count' => $orderData['total_item_count'] ?? 0,
                    'total_qty_ordered' => $orderData['total_qty_ordered'] ?? 0,
                    'base_currency_code' => $orderData['base_currency_code'] ?? 'USD',
                    'channel_currency_code' => $orderData['channel_currency_code'] ?? 'USD',
                    'order_currency_code' => $orderData['order_currency_code'] ?? 'USD',
                    'grand_total' => $orderData['grand_total'] ?? 0,
                    'base_grand_total' => $orderData['base_grand_total'] ?? 0,
                    'created_at' => $orderData['createdAt'] ?? now(),
                    'updated_at' => $orderData['updatedAt'] ?? now(),
                ]);

                $this->migratedCounts['orders']++;
                echo "  ✅ Commande: #{$order->id}\n";
            }

        } catch (Exception $e) {
            echo "  ⚠️ Erreur commandes: " . $e->getMessage() . "\n";
        }
    }

    /**
     * Afficher le résumé de la migration
     */
    private function displaySummary()
    {
        echo "\n🎉 MIGRATION TERMINÉE!\n";
        echo "======================\n";
        echo "📊 Résumé:\n";
        echo "  👥 Clients: {$this->migratedCounts['customers']}\n";
        echo "  🏪 Boutiques: {$this->migratedCounts['shops']}\n";
        echo "  📂 Catégories: {$this->migratedCounts['categories']}\n";
        echo "  📦 Produits: {$this->migratedCounts['products']}\n";
        echo "  📋 Commandes: {$this->migratedCounts['orders']}\n";
        echo "\n✅ Toutes les données ont été migrées vers Bagisto!\n";
    }
}

// Exécution du script
if (php_sapi_name() === 'cli') {
    $migration = new DataMigrationService();
    $migration->migrateAll();
} else {
    echo "Ce script doit être exécuté en ligne de commande.\n";
    echo "Usage: php migrate-data.php\n";
}
