#!/bin/bash

# Test Deployment Configuration Script
# This script tests your deployment setup without actually deploying

set -e

echo "🧪 Testing Deployment Configuration"
echo "==================================="

# Check if Clarinet is installed
if ! command -v clarinet &> /dev/null; then
    echo "❌ Clarinet is not installed"
    exit 1
fi

# Check contract syntax
echo "📝 Checking contract syntax..."
if clarinet check; then
    echo "✅ Contract syntax is valid"
else
    echo "❌ Contract syntax errors found"
    exit 1
fi

# Check testnet configuration
echo "🔧 Checking testnet configuration..."
if [ ! -f "settings/Testnet.toml" ]; then
    echo "❌ Testnet configuration file not found"
    exit 1
fi

if grep -q "<YOUR PRIVATE TESTNET MNEMONIC HERE>" settings/Testnet.toml; then
    echo "❌ Please update settings/Testnet.toml with your mnemonic"
    echo "   Replace the placeholder with your actual mnemonic phrase"
    exit 1
fi

echo "✅ Testnet configuration looks good"

# Check deployment requirements
echo "💰 Checking deployment requirements..."
if clarinet deployment check --manifest ./Clarinet.toml --settings settings/Testnet.toml; then
    echo "✅ Deployment requirements met"
else
    echo "❌ Deployment requirements not met"
    echo "   Make sure you have enough testnet STX"
    echo "   Get testnet STX from: https://faucet.hiro.so/"
    exit 1
fi

echo ""
echo "🎉 All checks passed! Your deployment configuration is ready."
echo ""
echo "📋 Next steps:"
echo "1. Run: ./deploy-testnet.sh"
echo "2. Wait for confirmation"
echo "3. Test your contract on testnet"
echo ""
echo "🔗 Useful links:"
echo "- Testnet Explorer: https://explorer.hiro.so/?chain=testnet"
echo "- Testnet Faucet: https://faucet.hiro.so/"

