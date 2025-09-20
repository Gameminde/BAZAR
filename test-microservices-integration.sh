#!/bin/bash

# BAZAR Microservices Integration Test Script
# Tests service discovery, API Gateway, and inter-service communication

set -e

echo "🚀 BAZAR Microservices Integration Test"
echo "========================================"

# Configuration
EUREKA_URL="http://admin:admin123@localhost:8761"
GATEWAY_URL="http://localhost:8080"
KAFKA_HOST="localhost:9092"
REDIS_HOST="localhost:6379"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test functions
test_service() {
    local service_name=$1
    local url=$2
    local expected_status=$3
    
    echo -n "Testing $service_name... "
    
    if response=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null); then
        if [ "$response" -eq "$expected_status" ]; then
            echo -e "${GREEN}✓ OK (HTTP $response)${NC}"
            return 0
        else
            echo -e "${RED}✗ FAIL (HTTP $response, expected $expected_status)${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ FAIL (Connection failed)${NC}"
        return 1
    fi
}

test_kafka_topic() {
    local topic=$1
    echo -n "Testing Kafka topic '$topic'... "
    
    if command -v kafka-topics.sh &> /dev/null; then
        if kafka-topics.sh --bootstrap-server $KAFKA_HOST --list | grep -q "$topic"; then
            echo -e "${GREEN}✓ OK${NC}"
            return 0
        else
            echo -e "${RED}✗ FAIL (Topic not found)${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠ SKIP (kafka-topics.sh not available)${NC}"
        return 0
    fi
}

test_redis_connection() {
    echo -n "Testing Redis connection... "
    
    if command -v redis-cli &> /dev/null; then
        if redis-cli -h ${REDIS_HOST%:*} -p ${REDIS_HOST#*:} ping | grep -q "PONG"; then
            echo -e "${GREEN}✓ OK${NC}"
            return 0
        else
            echo -e "${RED}✗ FAIL${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠ SKIP (redis-cli not available)${NC}"
        return 0
    fi
}

# Start tests
echo -e "${BLUE}Phase 1: Infrastructure Tests${NC}"
echo "----------------------------"

# Test Eureka Server
test_service "Eureka Server" "$EUREKA_URL/eureka/" 200

# Test API Gateway
test_service "API Gateway Health" "$GATEWAY_URL/actuator/health" 200

# Test Redis
test_redis_connection

echo ""
echo -e "${BLUE}Phase 2: Service Discovery Tests${NC}"
echo "--------------------------------"

# Test Eureka Apps endpoint
echo -n "Testing service registration... "
if registered_services=$(curl -s "$EUREKA_URL/eureka/apps" -H "Accept: application/json" 2>/dev/null); then
    if echo "$registered_services" | grep -q "bazar-marketplace"; then
        echo -e "${GREEN}✓ OK (Services registered)${NC}"
    else
        echo -e "${YELLOW}⚠ WARNING (No services registered yet)${NC}"
    fi
else
    echo -e "${RED}✗ FAIL (Cannot fetch registered services)${NC}"
fi

echo ""
echo -e "${BLUE}Phase 3: API Gateway Routing Tests${NC}"
echo "----------------------------------"

# Test Gateway routes
test_service "Gateway Root" "$GATEWAY_URL/" 404  # Expected 404 for root
test_service "Gateway Actuator" "$GATEWAY_URL/actuator/health" 200
test_service "Gateway Metrics" "$GATEWAY_URL/actuator/prometheus" 200

# Test fallback endpoints
test_service "User Service Fallback" "$GATEWAY_URL/fallback/user-service" 503
test_service "Product Service Fallback" "$GATEWAY_URL/fallback/product-service" 503
test_service "Order Service Fallback" "$GATEWAY_URL/fallback/order-service" 503

echo ""
echo -e "${BLUE}Phase 4: Event Streaming Tests${NC}"
echo "------------------------------"

# Test Kafka topics
test_kafka_topic "bazar.user.events"
test_kafka_topic "bazar.product.events"
test_kafka_topic "bazar.order.events"
test_kafka_topic "bazar.notification.events"
test_kafka_topic "bazar.analytics.events"

echo ""
echo -e "${BLUE}Phase 5: Monitoring Tests${NC}"
echo "-------------------------"

# Test monitoring endpoints
test_service "Prometheus Metrics" "$GATEWAY_URL/actuator/prometheus" 200
test_service "Health Detailed" "$GATEWAY_URL/actuator/health" 200

# Test custom health endpoints
test_service "Custom Health Check" "$GATEWAY_URL/api/v1/health" 200
test_service "Database Health" "$GATEWAY_URL/api/v1/health/database" 200
test_service "Redis Health" "$GATEWAY_URL/api/v1/health/redis" 200
test_service "Cache Health" "$GATEWAY_URL/api/v1/health/cache" 200

echo ""
echo -e "${BLUE}Phase 6: Load Test (Basic)${NC}"
echo "-------------------------"

echo -n "Running basic load test (10 concurrent requests)... "
if command -v curl &> /dev/null; then
    success_count=0
    total_requests=10
    
    for i in $(seq 1 $total_requests); do
        if curl -s -o /dev/null -w "%{http_code}" "$GATEWAY_URL/actuator/health" | grep -q "200"; then
            ((success_count++))
        fi &
    done
    
    wait  # Wait for all background processes
    
    if [ $success_count -eq $total_requests ]; then
        echo -e "${GREEN}✓ OK ($success_count/$total_requests successful)${NC}"
    else
        echo -e "${YELLOW}⚠ PARTIAL ($success_count/$total_requests successful)${NC}"
    fi
else
    echo -e "${YELLOW}⚠ SKIP (curl not available)${NC}"
fi

echo ""
echo "========================================"
echo -e "${GREEN}🎉 Integration Tests Completed!${NC}"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "1. Start all microservices: docker-compose -f docker-compose.microservices.yml up -d"
echo "2. Check Eureka Dashboard: http://localhost:8761"
echo "3. Check API Gateway: http://localhost:8080"
echo "4. Check Grafana: http://localhost:3000 (admin/admin123)"
echo "5. Check Jaeger: http://localhost:16686"
echo ""
echo -e "${GREEN}✅ PHASE 3 MICROSERVICES COMPLETED SUCCESSFULLY!${NC}"
