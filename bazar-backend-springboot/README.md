# 🏪 BAZAR Marketplace - Spring Boot Backend

## **🎯 Description**

BAZAR Marketplace est une plateforme e-commerce enterprise développée avec Spring Boot, conçue pour supporter **5 millions d'utilisateurs** avec performance optimale et sécurité maximale.

## **🚀 Fonctionnalités Principales**

### **🔐 Sécurité Enterprise**
- **JWT Authentication** avec RS256 et rotation des clés
- **BCrypt Password Encoding** (12 rounds)
- **Rate Limiting** (1000 req/min utilisateur, 100 req/min anonyme)
- **CORS Configuration** restrictive pour l'Algérie
- **Input Validation** complète avec Bean Validation

### **⚡ Performance Optimisée**
- **Cache Redis** distribué pour sessions et données
- **Hibernate Second Level Cache** pour entités
- **Fetch Strategies** optimisées (BatchSize, SUBSELECT)
- **Pagination** obligatoire pour toutes les listes
- **Connection Pooling** HikariCP optimisé

### **🌍 Localisation Algérie**
- **Devise** : DZD (Dinar Algérien)
- **Validation téléphone** : Format algérien (+213 ou 0)
- **CORS** : Domaines .dz autorisés
- **Timezone** : UTC avec support local

### **📊 Monitoring & Observabilité**
- **Prometheus Metrics** exposition
- **Health Checks** personnalisés
- **Structured Logging** avec MDC
- **Error Tracking** centralisé

## **🏗️ Architecture**

### **📂 Structure Projet**
```
src/main/java/com/bazar/marketplace/
├── config/                    # Configuration centralisée
├── controller/                # REST Controllers
├── service/                   # Business Logic
├── repository/                # Data Access Layer
├── entity/                    # JPA Entities
├── dto/                       # Data Transfer Objects
├── mapper/                    # Entity ↔ DTO mapping
├── exception/                 # Error handling
├── security/                  # JWT, OAuth2
├── validation/                # Custom validators
└── util/                      # Utilities
```

### **🔧 Technologies Utilisées**
- **Spring Boot 3.2.1** - Framework principal
- **Spring Security** - Authentification & autorisation
- **Spring Data JPA** - Accès aux données
- **MySQL 8.0** - Base de données principale
- **Redis** - Cache distribué
- **MapStruct** - Mapping entités/DTOs
- **Swagger/OpenAPI** - Documentation API
- **JUnit 5** - Tests unitaires
- **Testcontainers** - Tests d'intégration

## **🚀 Démarrage Rapide**

### **Prérequis**
- Java 17+
- Maven 3.9+
- MySQL 8.0+
- Redis 7.0+

### **Installation**
```bash
# Cloner le repository
git clone https://github.com/Gameminde/BAZAR.git
cd bazar-backend-springboot

# Installer les dépendances
mvn clean install

# Configurer la base de données
mysql -u root -p
CREATE DATABASE bazar_dev;
CREATE USER 'bazar_user'@'localhost' IDENTIFIED BY 'bazar_pass';
GRANT ALL PRIVILEGES ON bazar_dev.* TO 'bazar_user'@'localhost';
FLUSH PRIVILEGES;

# Démarrer Redis
redis-server

# Démarrer l'application
mvn spring-boot:run
```

### **Configuration**
```yaml
# application-dev.yml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/bazar_dev
    username: bazar_user
    password: bazar_pass
  redis:
    host: localhost
    port: 6379
```

## **📚 API Documentation**

### **Endpoints Principaux**
- **Authentication** : `/api/v1/auth/*`
- **Users** : `/api/v1/users/*`
- **Products** : `/api/v1/products/*`
- **Categories** : `/api/v1/categories/*`
- **Cart** : `/api/v1/cart/*`
- **Orders** : `/api/v1/orders/*`

### **Documentation Swagger**
- **URL** : http://localhost:8080/api/swagger-ui.html
- **API Docs** : http://localhost:8080/api/api-docs

## **🧪 Tests**

### **Exécuter les Tests**
```bash
# Tests unitaires
mvn test

# Tests d'intégration
mvn verify

# Coverage report
mvn jacoco:report
```

### **Coverage Cible**
- **Tests Unitaires** : 80% minimum
- **Tests d'Intégration** : 60% minimum
- **Tests E2E** : 40% minimum

## **🔧 Développement**

### **Standards de Code**
- **Google Java Style Guide**
- **SonarQube** score A minimum
- **Checkstyle** validation
- **PMD** code analysis

### **Git Workflow**
```bash
# Feature branch
git checkout -b feature/user-management

# Commit avec message descriptif
git commit -m "feat: add user password validation"

# Push et Pull Request
git push origin feature/user-management
```

## **🚀 Déploiement**

### **Docker**
```bash
# Build image
docker build -t bazar-marketplace .

# Run container
docker run -p 8080:8080 bazar-marketplace
```

### **Kubernetes**
```bash
# Apply manifests
kubectl apply -f k8s/

# Check status
kubectl get pods
kubectl get services
```

## **📊 Monitoring**

### **Métriques Prometheus**
- **URL** : http://localhost:8080/api/actuator/prometheus
- **Grafana** : Dashboard BAZAR Marketplace

### **Health Checks**
- **URL** : http://localhost:8080/api/actuator/health
- **Status** : UP/DOWN avec détails

## **🔒 Sécurité**

### **Configuration Production**
```yaml
# Variables d'environnement obligatoires
JWT_SECRET=your-super-secret-key-256-bits-minimum
DB_PASSWORD=your-secure-database-password
REDIS_PASSWORD=your-secure-redis-password
```

### **Audit Sécurité**
- **OWASP Top 10** compliance
- **Penetration Testing** régulier
- **Dependency Scanning** automatique
- **Security Headers** configurés

## **📈 Performance**

### **Métriques Cibles**
- **Response Time** : < 100ms (P99)
- **Throughput** : > 10,000 req/sec
- **Memory Usage** : < 2GB par instance
- **CPU Usage** : < 70% en charge normale

### **Optimisations**
- **Cache Hit Rate** : > 90%
- **Database Connections** : Pool optimisé
- **Query Performance** : < 50ms moyenne
- **Index Coverage** : 100% des requêtes

## **🌍 Support Algérie**

### **Localisation**
- **Devise** : DZD (Dinar Algérien)
- **Format téléphone** : +213 ou 0 suivi de 9 chiffres
- **Timezone** : UTC avec support local
- **CORS** : Domaines .dz autorisés

### **Conformité**
- **RGPD** : Protection des données
- **Loi algérienne** : Respect des réglementations
- **Accessibilité** : Standards internationaux

## **🤝 Contribution**

### **Comment Contribuer**
1. Fork le repository
2. Créer une feature branch
3. Implémenter les changements
4. Ajouter les tests
5. Soumettre une Pull Request

### **Code Review**
- **Minimum 2 reviewers**
- **Tests obligatoires**
- **Documentation à jour**
- **Performance validée**

## **📞 Support**

### **Contact**
- **Email** : support@bazar-marketplace.dz
- **Téléphone** : +213 XXX XXX XXX
- **Documentation** : https://docs.bazar-marketplace.dz

### **Issues**
- **GitHub Issues** : https://github.com/Gameminde/BAZAR/issues
- **Bug Reports** : Template fourni
- **Feature Requests** : Template fourni

## **📄 Licence**

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## **🙏 Remerciements**

- **Spring Boot Team** pour le framework
- **Algérie** pour l'inspiration
- **Communauté Open Source** pour les contributions

---

**🏪 BAZAR Marketplace - Votre plateforme e-commerce de confiance en Algérie !**
