#!/bin/bash

# BAZAR Marketplace - SSL Certificate Generation Script
# Generates self-signed certificate for development and staging

echo "🔐 Generating SSL Certificate for BAZAR Marketplace..."

# Configuration
KEYSTORE_PATH="src/main/resources/keystore/bazar-keystore.p12"
KEYSTORE_PASSWORD="bazar-secure-password"
KEY_ALIAS="bazar-marketplace"
VALIDITY_DAYS=365
KEY_SIZE=2048

# Certificate details
COUNTRY="DZ"
STATE="Algiers"
CITY="Algiers"
ORGANIZATION="BAZAR Marketplace"
ORGANIZATIONAL_UNIT="IT Department"
COMMON_NAME="localhost"
EMAIL="admin@bazar.dz"

# Subject Alternative Names for multiple domains
SAN="DNS:localhost,DNS:127.0.0.1,DNS:bazar.dz,DNS:api.bazar.dz,DNS:marketplace.dz,IP:127.0.0.1"

# Create keystore directory if it doesn't exist
mkdir -p src/main/resources/keystore

echo "📋 Certificate Configuration:"
echo "   - Keystore: $KEYSTORE_PATH"
echo "   - Alias: $KEY_ALIAS"
echo "   - Validity: $VALIDITY_DAYS days"
echo "   - Key Size: $KEY_SIZE bits"
echo "   - Common Name: $COMMON_NAME"
echo "   - SAN: $SAN"
echo ""

# Generate the keystore with certificate
keytool -genkeypair \
    -alias "$KEY_ALIAS" \
    -keyalg RSA \
    -keysize $KEY_SIZE \
    -validity $VALIDITY_DAYS \
    -keystore "$KEYSTORE_PATH" \
    -storepass "$KEYSTORE_PASSWORD" \
    -keypass "$KEYSTORE_PASSWORD" \
    -storetype PKCS12 \
    -dname "CN=$COMMON_NAME, OU=$ORGANIZATIONAL_UNIT, O=$ORGANIZATION, L=$CITY, ST=$STATE, C=$COUNTRY, emailAddress=$EMAIL" \
    -ext "SAN=$SAN"

if [ $? -eq 0 ]; then
    echo "✅ SSL Certificate generated successfully!"
    echo ""
    echo "📁 Files created:"
    echo "   - $KEYSTORE_PATH"
    echo ""
    echo "🔧 Configuration for application-prod.yml:"
    echo "server:"
    echo "  ssl:"
    echo "    key-store: classpath:keystore/bazar-keystore.p12"
    echo "    key-store-password: $KEYSTORE_PASSWORD"
    echo "    key-store-type: PKCS12"
    echo "    key-alias: $KEY_ALIAS"
    echo ""
    echo "⚠️  IMPORTANT:"
    echo "   - This is a self-signed certificate for development only"
    echo "   - For production, use a certificate from a trusted CA"
    echo "   - Never commit the keystore password to version control"
    echo "   - Use environment variables for sensitive configuration"
    echo ""
    echo "🚀 You can now start the application with HTTPS enabled!"
    
    # Display certificate information
    echo ""
    echo "📜 Certificate Details:"
    keytool -list -v -keystore "$KEYSTORE_PATH" -storepass "$KEYSTORE_PASSWORD" -alias "$KEY_ALIAS"
    
else
    echo "❌ Failed to generate SSL certificate"
    exit 1
fi
