#!/bin/bash

# Token Contract Testnet Interaction Script
# This script helps you interact with your deployed token contract

set -e

echo "🔗 Token Contract Testnet Interaction"
echo "====================================="

# Check if contract address is provided
if [ -z "$1" ]; then
    echo "❌ Please provide your contract address"
    echo "Usage: ./interact-testnet.sh <contract-address>"
    echo "Example: ./interact-testnet.sh ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.token"
    exit 1
fi

CONTRACT_ADDRESS=$1

echo "📋 Contract Address: $CONTRACT_ADDRESS"
echo ""

# Display available functions
echo "🛠️  Available Functions:"
echo "========================"
echo "1. Get token symbol"
echo "2. Get token name"
echo "3. Get token decimals"
echo "4. Get balance"
echo "5. Get allowance"
echo "6. Mint tokens (owner only)"
echo "7. Transfer tokens"
echo "8. Approve spender"
echo "9. Transfer from (using allowance)"
echo "10. Burn tokens"
echo "11. Get total supply"
echo ""

# Function to call contract
call_contract() {
    local function_name=$1
    local args=$2
    echo "🔍 Calling $function_name..."
    clarinet console --manifest ./Clarinet.toml --settings settings/Testnet.toml << EOF
(contract-call? $CONTRACT_ADDRESS $function_name $args)
EOF
}

# Interactive menu
while true; do
    echo ""
    echo "Select a function to call (1-11, or 'q' to quit):"
    read -r choice

    case $choice in
        1)
            call_contract "get-symbol" ""
            ;;
        2)
            call_contract "get-name" ""
            ;;
        3)
            call_contract "get-decimals" ""
            ;;
        4)
            echo "Enter principal address:"
            read -r address
            call_contract "get-balance" "$address"
            ;;
        5)
            echo "Enter owner address:"
            read -r owner
            echo "Enter spender address:"
            read -r spender
            call_contract "get-allowance" "$owner $spender"
            ;;
        6)
            echo "Enter amount to mint:"
            read -r amount
            echo "Enter recipient address:"
            read -r recipient
            call_contract "mint" "u$amount $recipient"
            ;;
        7)
            echo "Enter amount to transfer:"
            read -r amount
            echo "Enter sender address:"
            read -r sender
            echo "Enter recipient address:"
            read -r recipient
            call_contract "transfer" "u$amount $sender $recipient none"
            ;;
        8)
            echo "Enter spender address:"
            read -r spender
            echo "Enter amount to approve:"
            read -r amount
            call_contract "approve" "$spender u$amount"
            ;;
        9)
            echo "Enter amount to transfer:"
            read -r amount
            echo "Enter owner address:"
            read -r owner
            echo "Enter recipient address:"
            read -r recipient
            call_contract "transfer-from" "u$amount $owner $recipient none"
            ;;
        10)
            echo "Enter amount to burn:"
            read -r amount
            call_contract "burn" "u$amount"
            ;;
        11)
            call_contract "get-total-supply" ""
            ;;
        q|Q)
            echo "👋 Goodbye!"
            exit 0
            ;;
        *)
            echo "❌ Invalid choice. Please select 1-11 or 'q' to quit."
            ;;
    esac
done

