package com.bazar.marketplace.metrics;

import io.micrometer.core.instrument.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.concurrent.atomic.AtomicLong;

/**
 * Professional Business Metrics Collection
 * Tracks key business KPIs and performance indicators for BAZAR Marketplace
 */
@Component
@Slf4j
public class BusinessMetrics {

    private final MeterRegistry meterRegistry;
    
    // Business Counters
    private final Counter userRegistrations;
    private final Counter userLogins;
    private final Counter productViews;
    private final Counter cartAdditions;
    private final Counter orderCreations;
    private final Counter orderCompletions;
    private final Counter paymentSuccesses;
    private final Counter paymentFailures;
    private final Counter searchQueries;
    
    // Performance Counters
    private final Counter cacheHits;
    private final Counter cacheMisses;
    private final Counter databaseQueries;
    private final Counter apiRequests;
    
    // Performance Timers
    private final Timer orderProcessingTime;
    private final Timer searchResponseTime;
    private final Timer databaseQueryTime;
    private final Timer cacheResponseTime;
    private final Timer apiResponseTime;
    
    // Business Gauges (atomic values for thread safety)
    private final AtomicLong activeUsers = new AtomicLong(0);
    private final AtomicLong totalProducts = new AtomicLong(0);
    private final AtomicLong totalOrders = new AtomicLong(0);
    private final AtomicLong totalRevenue = new AtomicLong(0);
    private final AtomicLong cartItems = new AtomicLong(0);

    public BusinessMetrics(MeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
        
        // Initialize business counters with proper tags
        this.userRegistrations = Counter.builder("bazar.users.registrations.total")
            .description("Total number of user registrations")
            .tag("type", "business")
            .tag("component", "user-service")
            .register(meterRegistry);
            
        this.userLogins = Counter.builder("bazar.users.logins.total")
            .description("Total number of successful user logins")
            .tag("type", "business")
            .tag("component", "auth-service")
            .register(meterRegistry);
            
        this.productViews = Counter.builder("bazar.products.views.total")
            .description("Total number of product page views")
            .tag("type", "business")
            .tag("component", "product-service")
            .register(meterRegistry);
            
        this.cartAdditions = Counter.builder("bazar.cart.additions.total")
            .description("Total number of items added to cart")
            .tag("type", "business")
            .tag("component", "cart-service")
            .register(meterRegistry);
            
        this.orderCreations = Counter.builder("bazar.orders.created.total")
            .description("Total number of orders created")
            .tag("type", "business")
            .tag("component", "order-service")
            .register(meterRegistry);
            
        this.orderCompletions = Counter.builder("bazar.orders.completed.total")
            .description("Total number of orders completed successfully")
            .tag("type", "business")
            .tag("component", "order-service")
            .register(meterRegistry);
            
        this.paymentSuccesses = Counter.builder("bazar.payments.success.total")
            .description("Total number of successful payments")
            .tag("type", "business")
            .tag("component", "payment-service")
            .register(meterRegistry);
            
        this.paymentFailures = Counter.builder("bazar.payments.failure.total")
            .description("Total number of failed payments")
            .tag("type", "business")
            .tag("component", "payment-service")
            .register(meterRegistry);
            
        this.searchQueries = Counter.builder("bazar.search.queries.total")
            .description("Total number of search queries executed")
            .tag("type", "business")
            .tag("component", "search-service")
            .register(meterRegistry);
            
        // Initialize performance counters
        this.cacheHits = Counter.builder("bazar.cache.hits.total")
            .description("Total number of cache hits")
            .tag("type", "performance")
            .tag("component", "cache-service")
            .register(meterRegistry);
            
        this.cacheMisses = Counter.builder("bazar.cache.misses.total")
            .description("Total number of cache misses")
            .tag("type", "performance")
            .tag("component", "cache-service")
            .register(meterRegistry);
            
        this.databaseQueries = Counter.builder("bazar.database.queries.total")
            .description("Total number of database queries executed")
            .tag("type", "performance")
            .tag("component", "database")
            .register(meterRegistry);
            
        this.apiRequests = Counter.builder("bazar.api.requests.total")
            .description("Total number of API requests received")
            .tag("type", "performance")
            .tag("component", "api-gateway")
            .register(meterRegistry);
        
        // Initialize performance timers with SLA targets
        this.orderProcessingTime = Timer.builder("bazar.orders.processing.duration")
            .description("Time taken to process orders from creation to completion")
            .tag("type", "performance")
            .tag("component", "order-service")
            .tag("sla", "5s")
            .register(meterRegistry);
            
        this.searchResponseTime = Timer.builder("bazar.search.response.duration")
            .description("Time taken for search queries to return results")
            .tag("type", "performance")
            .tag("component", "search-service")
            .tag("sla", "100ms")
            .register(meterRegistry);
            
        this.databaseQueryTime = Timer.builder("bazar.database.query.duration")
            .description("Time taken for database queries to execute")
            .tag("type", "performance")
            .tag("component", "database")
            .tag("sla", "50ms")
            .register(meterRegistry);
            
        this.cacheResponseTime = Timer.builder("bazar.cache.response.duration")
            .description("Time taken for cache operations to complete")
            .tag("type", "performance")
            .tag("component", "cache-service")
            .tag("sla", "10ms")
            .register(meterRegistry);
            
        this.apiResponseTime = Timer.builder("bazar.api.response.duration")
            .description("Time taken for API requests to complete")
            .tag("type", "performance")
            .tag("component", "api-gateway")
            .tag("sla", "200ms")
            .register(meterRegistry);
        
        // Initialize business gauges with proper registration
        Gauge.builder("bazar.users.active.current", this, BusinessMetrics::getActiveUsersValue)
            .description("Number of currently active users in the system")
            .tag("type", "business")
            .tag("component", "user-service")
            .register(meterRegistry);
            
        Gauge.builder("bazar.products.total.current", this, BusinessMetrics::getTotalProductsValue)
            .description("Total number of products in the catalog")
            .tag("type", "business")
            .tag("component", "product-service")
            .register(meterRegistry);
            
        Gauge.builder("bazar.orders.total.current", this, BusinessMetrics::getTotalOrdersValue)
            .description("Total number of orders in the system")
            .tag("type", "business")
            .tag("component", "order-service")
            .register(meterRegistry);
            
        Gauge.builder("bazar.revenue.total.current", this, BusinessMetrics::getTotalRevenueValue)
            .description("Total revenue generated (in cents)")
            .tag("type", "business")
            .tag("component", "payment-service")
            .register(meterRegistry);
            
        Gauge.builder("bazar.cart.items.current", this, BusinessMetrics::getCartItemsValue)
            .description("Total number of items currently in all carts")
            .tag("type", "business")
            .tag("component", "cart-service")
            .register(meterRegistry);
            
        log.info("BusinessMetrics initialized with {} counters, {} timers, and {} gauges", 
                 9, 5, 5);
    }

    // Business Counter Methods
    public void incrementUserRegistrations() {
        userRegistrations.increment();
        log.debug("User registration metric incremented");
    }

    public void incrementUserLogins() {
        userLogins.increment();
        log.debug("User login metric incremented");
    }

    public void incrementProductViews() {
        productViews.increment();
        log.debug("Product view metric incremented");
    }

    public void incrementCartAdditions() {
        cartAdditions.increment();
        log.debug("Cart addition metric incremented");
    }

    public void incrementOrderCreations() {
        orderCreations.increment();
        log.debug("Order creation metric incremented");
    }

    public void incrementOrderCompletions() {
        orderCompletions.increment();
        log.debug("Order completion metric incremented");
    }

    public void incrementPaymentSuccesses() {
        paymentSuccesses.increment();
        log.debug("Payment success metric incremented");
    }

    public void incrementPaymentFailures() {
        paymentFailures.increment();
        log.warn("Payment failure metric incremented");
    }

    public void incrementSearchQueries() {
        searchQueries.increment();
        log.debug("Search query metric incremented");
    }

    // Performance Counter Methods
    public void incrementCacheHits() {
        cacheHits.increment();
        log.debug("Cache hit metric incremented");
    }

    public void incrementCacheMisses() {
        cacheMisses.increment();
        log.debug("Cache miss metric incremented");
    }

    public void incrementDatabaseQueries() {
        databaseQueries.increment();
        log.debug("Database query metric incremented");
    }

    public void incrementApiRequests() {
        apiRequests.increment();
        log.debug("API request metric incremented");
    }

    // Timer Methods with Professional Error Handling
    public Timer.Sample startOrderProcessingTimer() {
        return Timer.start(meterRegistry);
    }

    public void recordOrderProcessingTime(Timer.Sample sample) {
        if (sample != null) {
            sample.stop(orderProcessingTime);
            log.debug("Order processing time recorded");
        }
    }

    public Timer.Sample startSearchTimer() {
        return Timer.start(meterRegistry);
    }

    public void recordSearchTime(Timer.Sample sample) {
        if (sample != null) {
            sample.stop(searchResponseTime);
            log.debug("Search response time recorded");
        }
    }

    public Timer.Sample startDatabaseTimer() {
        return Timer.start(meterRegistry);
    }

    public void recordDatabaseTime(Timer.Sample sample) {
        if (sample != null) {
            sample.stop(databaseQueryTime);
            log.debug("Database query time recorded");
        }
    }

    public Timer.Sample startCacheTimer() {
        return Timer.start(meterRegistry);
    }

    public void recordCacheTime(Timer.Sample sample) {
        if (sample != null) {
            sample.stop(cacheResponseTime);
            log.debug("Cache response time recorded");
        }
    }

    public Timer.Sample startApiTimer() {
        return Timer.start(meterRegistry);
    }

    public void recordApiTime(Timer.Sample sample) {
        if (sample != null) {
            sample.stop(apiResponseTime);
            log.debug("API response time recorded");
        }
    }

    // Gauge Update Methods with Validation
    public void updateActiveUsers(long count) {
        if (count >= 0) {
            activeUsers.set(count);
            log.debug("Active users updated to: {}", count);
        } else {
            log.warn("Attempted to set negative active users count: {}", count);
        }
    }

    public void updateTotalProducts(long count) {
        if (count >= 0) {
            totalProducts.set(count);
            log.debug("Total products updated to: {}", count);
        } else {
            log.warn("Attempted to set negative products count: {}", count);
        }
    }

    public void updateTotalOrders(long count) {
        if (count >= 0) {
            totalOrders.set(count);
            log.debug("Total orders updated to: {}", count);
        } else {
            log.warn("Attempted to set negative orders count: {}", count);
        }
    }

    public void updateTotalRevenue(long amountInCents) {
        if (amountInCents >= 0) {
            totalRevenue.set(amountInCents);
            log.debug("Total revenue updated to: {} cents", amountInCents);
        } else {
            log.warn("Attempted to set negative revenue: {} cents", amountInCents);
        }
    }

    public void updateCartItems(long count) {
        if (count >= 0) {
            cartItems.set(count);
            log.debug("Cart items updated to: {}", count);
        } else {
            log.warn("Attempted to set negative cart items count: {}", count);
        }
    }

    // Gauge Value Getter Methods (for registration)
    private double getActiveUsersValue() {
        return activeUsers.get();
    }

    private double getTotalProductsValue() {
        return totalProducts.get();
    }

    private double getTotalOrdersValue() {
        return totalOrders.get();
    }

    private double getTotalRevenueValue() {
        return totalRevenue.get();
    }

    private double getCartItemsValue() {
        return cartItems.get();
    }

    // Professional Metrics Summary
    public void logMetricsSummary() {
        log.info("=== BAZAR MARKETPLACE METRICS SUMMARY ===");
        log.info("Business Metrics:");
        log.info("  - Active Users: {}", activeUsers.get());
        log.info("  - Total Products: {}", totalProducts.get());
        log.info("  - Total Orders: {}", totalOrders.get());
        log.info("  - Total Revenue: ${}", totalRevenue.get() / 100.0);
        log.info("  - Cart Items: {}", cartItems.get());
        log.info("Performance Metrics:");
        log.info("  - Cache Hit Rate: {}%", calculateCacheHitRate());
        log.info("==========================================");
    }

    private double calculateCacheHitRate() {
        double hits = cacheHits.count();
        double misses = cacheMisses.count();
        double total = hits + misses;
        return total > 0 ? (hits / total) * 100 : 0.0;
    }
}
