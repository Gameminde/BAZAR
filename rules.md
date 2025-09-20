# 🛡️ **RÈGLES DE MIGRATION SPRING BOOT - BAZAR MARKETPLACE**

## **🎯 MISSION CRITIQUE**
Migrer BAZAR Marketplace de Laravel/Bagisto vers Spring Boot pour supporter **5 millions d'utilisateurs** avec performance enterprise et sécurité maximale.

---

## **📋 RÈGLES GÉNÉRALES**

### **🚨 PRIORITÉS ABSOLUES**
1. **SÉCURITÉ FIRST** - Aucun compromis sur la sécurité
2. **PERFORMANCE** - Optimisation pour 500K+ utilisateurs simultanés  
3. **SCALABILITÉ** - Architecture microservices ready
4. **MAINTENABILITÉ** - Code propre, testé, documenté
5. **ZÉRO DOWNTIME** - Migration sans interruption de service

### **🔒 STANDARDS DE QUALITÉ**
- **Test Coverage** : Minimum 80% pour tout nouveau code
- **Performance** : API response < 100ms (99th percentile)
- **Security** : OWASP Top 10 compliance obligatoire
- **Documentation** : Swagger/OpenAPI pour tous les endpoints
- **Code Quality** : SonarQube score A minimum

---

## **🏗️ ARCHITECTURE OBLIGATOIRE**

### **📂 STRUCTURE PROJET STRICTE**
```
bazar-backend-springboot/
├── src/main/java/com/bazar/marketplace/
│   ├── BazarMarketplaceApplication.java
│   ├── config/                    # Configuration centralisée
│   ├── controller/                # REST Controllers uniquement
│   ├── service/                   # Business Logic
│   ├── repository/                # Data Access Layer
│   ├── entity/                    # JPA Entities
│   ├── dto/                       # Data Transfer Objects
│   ├── mapper/                    # Entity ↔ DTO mapping
│   ├── exception/                 # Error handling
│   ├── security/                  # JWT, OAuth2
│   ├── validation/                # Custom validators
│   └── util/                      # Utilities
├── src/main/resources/
│   ├── application.yml            # Configuration principale
│   ├── application-dev.yml        # Environnement dev
│   ├── application-prod.yml       # Environnement prod
│   ├── db/migration/             # Flyway migrations
│   └── static/                    # Assets statiques
└── src/test/java/                # Tests (structure miroir)
```

### **🎨 PATTERNS OBLIGATOIRES**
- **Repository Pattern** : Spring Data JPA repositories
- **Service Layer** : Business logic séparée des controllers
- **DTO Pattern** : Jamais exposer les entities directement
- **Mapper Pattern** : MapStruct pour entity ↔ DTO
- **Exception Handling** : @ControllerAdvice global
- **Validation** : Bean Validation (JSR-303)

---

## **🔐 SÉCURITÉ ENTERPRISE**

### **🛡️ AUTHENTIFICATION & AUTORISATION**
```java
// JWT obligatoire pour toutes les APIs privées
@PreAuthorize("hasRole('USER')")
@PostAuthorize("returnObject.userId == authentication.name")

// Rate limiting obligatoire
@RateLimited(requests = 100, window = "PT1M")

// Input validation systématique
@Valid @RequestBody CreateProductRequest request
```

### **🔒 RÈGLES SÉCURITÉ STRICTES**
1. **Passwords** : BCrypt avec salt minimum 12 rounds
2. **JWT** : RS256 avec rotation automatique des clés
3. **HTTPS** : Obligatoire partout, HSTS activé
4. **CORS** : Configuration restrictive par origine
5. **Rate Limiting** : 1000 req/min par utilisateur authentifié, 100 req/min anonyme
6. **Input Validation** : Sanitization automatique contre XSS/SQL Injection
7. **Secrets** : Jamais hardcodés, utiliser Spring Vault ou Variables d'environnement

### **🚨 INTERDICTIONS ABSOLUES**
- ❌ **Pas de HTTP** en production (HTTPS obligatoire)
- ❌ **Pas de secrets hardcodés** dans le code
- ❌ **Pas de SQL raw** sans paramètres bindés
- ❌ **Pas de données sensibles** dans les logs
- ❌ **Pas de certificats auto-signés** en production

---

## **⚡ PERFORMANCE & SCALABILITÉ**

### **📊 MÉTRIQUES OBLIGATOIRES**
- **Response Time** : < 100ms (P99), < 50ms (P95)
- **Throughput** : > 10,000 req/sec par instance
- **Memory Usage** : < 2GB par instance
- **CPU Usage** : < 70% en charge normale
- **Database Connections** : Pool size optimisé (20-50)

### **🚀 OPTIMISATIONS REQUISES**
```java
// Cache obligatoire pour données fréquentes
@Cacheable(value = "products", key = "#id")
public ProductDTO getProduct(Long id);

// Pagination obligatoire pour toutes les listes
@GetMapping
public PagedResponse<ProductDTO> getProducts(
    @RequestParam(defaultValue = "0") int page,
    @RequestParam(defaultValue = "20") int size);

// Lazy loading pour relations JPA
@ManyToOne(fetch = FetchType.LAZY)
@JoinColumn(name = "category_id")
private Category category;

// Connection pooling optimisé
spring.datasource.hikari.maximum-pool-size=20
spring.datasource.hikari.minimum-idle=5
```

### **🔧 CACHE STRATEGY**
- **Redis** : Cache distribué pour sessions et données partagées
- **Application Cache** : @Cacheable pour données statiques
- **Database Query Cache** : Hibernate second level cache
- **CDN** : CloudFlare pour assets statiques

---

## **🧪 TESTS & QUALITÉ**

### **📋 COUVERTURE TESTS OBLIGATOIRE**
```java
// Tests unitaires (80% minimum)
@ExtendWith(MockitoExtension.class)
class ProductServiceTest {
    @Mock private ProductRepository repository;
    @InjectMocks private ProductService service;
}

// Tests d'intégration (endpoints critiques)
@SpringBootTest
@AutoConfigureTestDatabase
@Transactional
class ProductControllerIntegrationTest {
    @Autowired private TestRestTemplate restTemplate;
}

// Tests de performance (load testing)
@Test
void shouldHandleConcurrentRequests() {
    // JMeter/Gatling integration
}
```

### **🎯 QUALITÉ CODE**
- **SonarQube** : Score A obligatoire
- **SpotBugs** : Zéro bug critique
- **Checkstyle** : Google Java Style Guide
- **PMD** : Détection code smell
- **JaCoCo** : Coverage report automatique

---

## **📊 MONITORING & OBSERVABILITÉ**

### **📈 MÉTRIQUES BUSINESS**
```java
// Metrics custom obligatoires
@Timed(name = "product.search", description = "Product search time")
@Counted(name = "cart.add", description = "Items added to cart")

// Health checks personnalisés
@Component
public class DatabaseHealthIndicator implements HealthIndicator {
    public Health health() {
        // Vérification connexion DB
    }
}
```

### **🔍 LOGGING STRUCTURE**
```java
// Structured logging avec MDC
MDC.put("userId", user.getId());
MDC.put("requestId", UUID.randomUUID().toString());
log.info("User {} added product {} to cart", userId, productId);
```

### **📊 DASHBOARDS OBLIGATOIRES**
- **Grafana** : Métriques application et infrastructure
- **Kibana** : Logs centralisés et alertes
- **Sentry** : Error tracking et performance
- **Prometheus** : Métriques système et JVM

---

## **🚀 DÉPLOIEMENT & DEVOPS**

### **🐳 CONTAINERISATION**
```dockerfile
# Multi-stage build obligatoire
FROM openjdk:17-jdk-slim as builder
COPY . /app
WORKDIR /app
RUN ./mvnw clean package -DskipTests

FROM openjdk:17-jre-slim
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

### **☸️ KUBERNETES READY**
```yaml
# Resources limits obligatoires
resources:
  requests:
    memory: "1Gi"
    cpu: "500m"
  limits:
    memory: "2Gi"
    cpu: "1000m"

# Health checks
livenessProbe:
  httpGet:
    path: /actuator/health
    port: 8080
```

---

## **🔄 MIGRATION STRATEGY**

### **📋 PHASES OBLIGATOIRES**
1. **Phase 1** : Setup + Core Entities (Semaine 1-2)
2. **Phase 2** : REST API + Security (Semaine 3-4)
3. **Phase 3** : Performance + Cache (Semaine 5-6)
4. **Phase 4** : Production + Monitoring (Semaine 7-8)

### **🔀 STRATÉGIE BLUE-GREEN**
- **Environnement Blue** : Laravel actuel
- **Environnement Green** : Spring Boot nouveau
- **Switch progressif** : Par feature/endpoint
- **Rollback plan** : Retour immédiat possible

### **📊 CRITÈRES DE SUCCÈS**
- ✅ **Performance** : 2x plus rapide que Laravel
- ✅ **Scalabilité** : Support 100K users simultanés
- ✅ **Uptime** : 99.9% minimum
- ✅ **Security** : Zéro vulnérabilité critique
- ✅ **Tests** : 80% coverage minimum

---

## **⚠️ RÈGLES DE SÉCURITÉ CRITIQUE**

### **🚨 AVANT CHAQUE COMMIT**
1. **Scan sécurité** : OWASP ZAP + Snyk
2. **Tests automatiques** : Unit + Integration
3. **Code review** : Minimum 2 reviewers
4. **Performance check** : Pas de régression
5. **Documentation** : Swagger à jour

### **🛡️ AVANT CHAQUE DÉPLOIEMENT**
1. **Backup complet** : Base de données + configuration
2. **Health checks** : Tous les endpoints critiques
3. **Load testing** : Simulation charge production
4. **Security scan** : Penetration testing
5. **Rollback plan** : Procédure testée et documentée

---

## **📞 ESCALATION MATRIX**

### **🚨 NIVEAUX D'ALERTE**
- **P0 - CRITIQUE** : Service down, sécurité compromise
- **P1 - URGENT** : Performance dégradée >50%
- **P2 - IMPORTANT** : Feature non fonctionnelle
- **P3 - NORMAL** : Bug mineur, amélioration

### **👥 RESPONSABILITÉS**
- **Tech Lead** : Architecture, code review, décisions techniques
- **DevOps** : Infrastructure, monitoring, déploiement
- **Security** : Audit sécurité, penetration testing
- **QA** : Tests automatisés, validation performance

---

**⚡ CES RÈGLES SONT NON-NÉGOCIABLES POUR LE SUCCÈS DE LA MIGRATION !**

*Dernière mise à jour : Janvier 2025*

