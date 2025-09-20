package com.bazar.marketplace.database;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;

import javax.sql.DataSource;
import java.util.Properties;

/**
 * Multi-Database Configuration for BAZAR Microservices
 * 
 * Implements Database-per-Service pattern with separate databases
 * for different bounded contexts and microservices
 * 
 * @author BAZAR Development Team
 * @version 1.0.0
 */
@Configuration
@EnableJpaRepositories(
    basePackages = "com.bazar.marketplace.repository",
    entityManagerFactoryRef = "primaryEntityManagerFactory",
    transactionManagerRef = "primaryTransactionManager"
)
public class DatabaseConfiguration {

    /**
     * Primary Database Configuration (Main Marketplace)
     * Used for core marketplace entities and cross-service data
     */
    @Primary
    @Bean(name = "primaryDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.primary")
    public DataSource primaryDataSource() {
        HikariConfig config = new HikariConfig();
        
        // Connection settings
        config.setJdbcUrl(System.getProperty("spring.datasource.url", 
            "jdbc:postgresql://localhost:5432/bazar_main"));
        config.setUsername(System.getProperty("spring.datasource.username", "bazar_user"));
        config.setPassword(System.getProperty("spring.datasource.password", "bazar123"));
        config.setDriverClassName("org.postgresql.Driver");
        
        // Pool settings for high performance
        config.setMaximumPoolSize(30);
        config.setMinimumIdle(5);
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(600000);
        config.setMaxLifetime(1800000);
        config.setLeakDetectionThreshold(60000);
        
        // Performance optimizations
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
        config.addDataSourceProperty("useServerPrepStmts", "true");
        config.addDataSourceProperty("useLocalSessionState", "true");
        config.addDataSourceProperty("rewriteBatchedStatements", "true");
        config.addDataSourceProperty("cacheResultSetMetadata", "true");
        config.addDataSourceProperty("cacheServerConfiguration", "true");
        config.addDataSourceProperty("elideSetAutoCommits", "true");
        config.addDataSourceProperty("maintainTimeStats", "false");
        
        // Connection validation
        config.setConnectionTestQuery("SELECT 1");
        config.setValidationTimeout(5000);
        
        return new HikariDataSource(config);
    }

    /**
     * User Service Database Configuration
     * Dedicated database for user management and authentication
     */
    @Bean(name = "userDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.user")
    public DataSource userDataSource() {
        HikariConfig config = new HikariConfig();
        
        config.setJdbcUrl(System.getProperty("user.datasource.url", 
            "jdbc:postgresql://localhost:5433/bazar_users"));
        config.setUsername(System.getProperty("user.datasource.username", "bazar_user"));
        config.setPassword(System.getProperty("user.datasource.password", "bazar123"));
        config.setDriverClassName("org.postgresql.Driver");
        
        // Optimized for user service workload
        config.setMaximumPoolSize(20);
        config.setMinimumIdle(3);
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(600000);
        config.setMaxLifetime(1800000);
        
        return new HikariDataSource(config);
    }

    /**
     * Order Service Database Configuration
     * Dedicated database for orders, payments, and transactions
     */
    @Bean(name = "orderDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.order")
    public DataSource orderDataSource() {
        HikariConfig config = new HikariConfig();
        
        config.setJdbcUrl(System.getProperty("order.datasource.url", 
            "jdbc:postgresql://localhost:5434/bazar_orders"));
        config.setUsername(System.getProperty("order.datasource.username", "bazar_user"));
        config.setPassword(System.getProperty("order.datasource.password", "bazar123"));
        config.setDriverClassName("org.postgresql.Driver");
        
        // Optimized for transactional workload
        config.setMaximumPoolSize(25);
        config.setMinimumIdle(5);
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(300000); // Shorter idle for transactions
        config.setMaxLifetime(1800000);
        
        // Transaction-specific optimizations
        config.addDataSourceProperty("defaultTransactionIsolation", "READ_COMMITTED");
        config.addDataSourceProperty("autoCommit", "false");
        
        return new HikariDataSource(config);
    }

    /**
     * Analytics Database Configuration
     * Time-series database for analytics and reporting
     */
    @Bean(name = "analyticsDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.analytics")
    public DataSource analyticsDataSource() {
        HikariConfig config = new HikariConfig();
        
        config.setJdbcUrl(System.getProperty("analytics.datasource.url", 
            "jdbc:postgresql://localhost:5435/bazar_analytics"));
        config.setUsername(System.getProperty("analytics.datasource.username", "bazar_user"));
        config.setPassword(System.getProperty("analytics.datasource.password", "bazar123"));
        config.setDriverClassName("org.postgresql.Driver");
        
        // Optimized for read-heavy analytics workload
        config.setMaximumPoolSize(15);
        config.setMinimumIdle(2);
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(900000); // Longer idle for analytics
        config.setMaxLifetime(3600000);
        
        // Read-optimized settings
        config.addDataSourceProperty("readOnly", "true");
        config.addDataSourceProperty("defaultTransactionIsolation", "READ_UNCOMMITTED");
        
        return new HikariDataSource(config);
    }

    // Entity Manager Factories

    @Primary
    @Bean(name = "primaryEntityManagerFactory")
    public LocalContainerEntityManagerFactoryBean primaryEntityManagerFactory(
            @Qualifier("primaryDataSource") DataSource dataSource) {
        
        LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
        em.setDataSource(dataSource);
        em.setPackagesToScan("com.bazar.marketplace.entity");
        
        HibernateJpaVendorAdapter vendorAdapter = new HibernateJpaVendorAdapter();
        em.setJpaVendorAdapter(vendorAdapter);
        
        Properties properties = new Properties();
        properties.setProperty("hibernate.hbm2ddl.auto", "validate");
        properties.setProperty("hibernate.dialect", "org.hibernate.dialect.PostgreSQLDialect");
        properties.setProperty("hibernate.show_sql", "false");
        properties.setProperty("hibernate.format_sql", "false");
        properties.setProperty("hibernate.jdbc.batch_size", "25");
        properties.setProperty("hibernate.order_inserts", "true");
        properties.setProperty("hibernate.order_updates", "true");
        properties.setProperty("hibernate.jdbc.batch_versioned_data", "true");
        properties.setProperty("hibernate.connection.provider_disables_autocommit", "true");
        properties.setProperty("hibernate.query.plan_cache_max_size", "2048");
        properties.setProperty("hibernate.query.plan_parameter_metadata_max_size", "128");
        
        em.setJpaProperties(properties);
        
        return em;
    }

    // Transaction Managers

    @Primary
    @Bean(name = "primaryTransactionManager")
    public PlatformTransactionManager primaryTransactionManager(
            @Qualifier("primaryEntityManagerFactory") LocalContainerEntityManagerFactoryBean primaryEntityManagerFactory) {
        
        JpaTransactionManager transactionManager = new JpaTransactionManager();
        transactionManager.setEntityManagerFactory(primaryEntityManagerFactory.getObject());
        
        return transactionManager;
    }

    /**
     * Database Health Check Configuration
     */
    @Bean
    public DatabaseHealthChecker databaseHealthChecker(
            @Qualifier("primaryDataSource") DataSource primaryDataSource,
            @Qualifier("userDataSource") DataSource userDataSource,
            @Qualifier("orderDataSource") DataSource orderDataSource,
            @Qualifier("analyticsDataSource") DataSource analyticsDataSource) {
        
        return new DatabaseHealthChecker(primaryDataSource, userDataSource, 
                                       orderDataSource, analyticsDataSource);
    }
}

/**
 * Database Health Checker for monitoring multiple databases
 */
class DatabaseHealthChecker {
    private final DataSource primaryDataSource;
    private final DataSource userDataSource;
    private final DataSource orderDataSource;
    private final DataSource analyticsDataSource;
    
    public DatabaseHealthChecker(DataSource primaryDataSource, DataSource userDataSource,
                               DataSource orderDataSource, DataSource analyticsDataSource) {
        this.primaryDataSource = primaryDataSource;
        this.userDataSource = userDataSource;
        this.orderDataSource = orderDataSource;
        this.analyticsDataSource = analyticsDataSource;
    }
    
    public boolean checkAllDatabases() {
        try {
            primaryDataSource.getConnection().close();
            userDataSource.getConnection().close();
            orderDataSource.getConnection().close();
            analyticsDataSource.getConnection().close();
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
