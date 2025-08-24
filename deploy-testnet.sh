#!/bin/bash

# Token Contract Testnet Deployment Script
# This script helps deploy the token contract to Stacks testnet

set -e

echo "🚀 Starting Token Contract Testnet Deployment"
echo "=============================================="

# Check if Clarinet is installed
if ! command -v clarinet &> /dev/null; then
    echo "❌ Clarinet is not installed. Please install it first:"
    echo "   https://docs.hiro.so/clarinet/getting-started"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "Clarinet.toml" ]; then
    echo "❌ Please run this script from the project root directory"
    exit 1
fi

# Check contract syntax
echo "📝 Checking contract syntax..."
clarinet check
echo "✅ Contract syntax is valid"

# Check if testnet configuration is set up
if ! grep -q "mnemonic" settings/Testnet.toml; then
    echo "❌ Testnet configuration not set up properly"
    echo "   Please edit settings/Testnet.toml and add your mnemonic"
    exit 1
fi

if grep -q "<YOUR PRIVATE TESTNET MNEMONIC HERE>" settings/Testnet.toml; then
    echo "❌ Please replace the placeholder mnemonic in settings/Testnet.toml"
    echo "   with your actual testnet wallet mnemonic"
    exit 1
fi

# Check deployer account balance
echo "💰 Checking deployer account balance..."
clarinet deployment check --manifest ./Clarinet.toml --settings settings/Testnet.toml

# Deploy to testnet
echo "🚀 Deploying to testnet..."
clarinet deployment apply --manifest ./Clarinet.toml --settings settings/Testnet.toml

echo ""
echo "✅ Deployment completed!"
echo ""
echo "📋 Next steps:"
echo "1. Wait for the transaction to be confirmed (usually 1-2 blocks)"
echo "2. Verify your contract on the testnet explorer:"
echo "   https://explorer.hiro.so/?chain=testnet"
echo "3. Test your contract functions using the explorer or a wallet"
echo ""
echo "🔗 Useful links:"
echo "- Testnet Explorer: https://explorer.hiro.so/?chain=testnet"
echo "- Testnet Faucet: https://faucet.hiro.so/"
echo "- Documentation: https://docs.hiro.so/"
echo ""
echo "🎉 Your token contract is now live on testnet!"

