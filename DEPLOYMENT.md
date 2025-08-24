# Token Contract Deployment Guide

This guide will walk you through deploying your token contract to Stacks testnet.

## Prerequisites

1. **Clarinet CLI**: Make sure you have Clarinet installed
   ```bash
   # Install Clarinet (if not already installed)
   curl -L https://github.com/hirosystems/clarinet/releases/latest/download/clarinet-installer.sh | bash
   ```

2. **Testnet STX**: You'll need some testnet STX for deployment fees
   - Get testnet STX from the [Hiro Faucet](https://faucet.hiro.so/)

3. **Wallet**: You'll need a wallet with a mnemonic phrase
   - You can use an existing wallet or generate a new one

## Step 1: Generate a Testnet Account (Optional)

If you don't have a wallet, you can generate one:

```bash
clarinet accounts generate
```

This will output a mnemonic phrase. **Save this securely!**

## Step 2: Configure Testnet Settings

1. Edit `settings/Testnet.toml`
2. Replace the placeholder mnemonic with your actual mnemonic:

```toml
[accounts.deployer]
mnemonic = "your twelve word mnemonic phrase goes here"
```

## Step 3: Get Testnet STX

1. Go to [Hiro Faucet](https://faucet.hiro.so/)
2. Enter your Stacks address (you can get this from your wallet)
3. Request testnet STX

## Step 4: Deploy to Testnet

### Option A: Using the Deployment Script (Recommended)

```bash
./deploy-testnet.sh
```

### Option B: Manual Deployment

1. **Check contract syntax**:
   ```bash
   clarinet check
   ```

2. **Check deployment requirements**:
   ```bash
   clarinet deployment check --manifest ./Clarinet.toml --settings settings/Testnet.toml
   ```

3. **Deploy to testnet**:
   ```bash
   clarinet deployment apply --manifest ./Clarinet.toml --settings settings/Testnet.toml
   ```

## Step 5: Verify Deployment

1. Wait for the transaction to be confirmed (usually 1-2 blocks)
2. Check the [Testnet Explorer](https://explorer.hiro.so/?chain=testnet)
3. Search for your contract address

## Step 6: Test Your Contract

### Using the Explorer

1. Go to [Testnet Explorer](https://explorer.hiro.so/?chain=testnet)
2. Find your contract
3. Use the "Call Contract" feature to test functions

### Using a Wallet

1. Connect your wallet to the testnet
2. Use the contract interface to call functions

## Contract Address

After deployment, your contract will be available at:
```
ST[your-deployer-address].token
```

## Testing Your Token

### 1. Mint Tokens
```clarity
(contract-call? .token mint u1000 'ST1J4G6WW6439GXCK3KMCJGF8V66BSPF1K9X95K4E)
```

### 2. Check Balance
```clarity
(contract-call? .token get-balance 'ST1J4G6WW6439GXCK3KMCJGF8V66BSPF1K9X95K4E)
```

### 3. Transfer Tokens
```clarity
(contract-call? .token transfer u500 tx-sender 'ST2J4G6WW6439GXCK3KMCJGF8V66BSPF1K9X95K5F none)
```

## Troubleshooting

### Common Issues

1. **Insufficient Balance**: Make sure your deployer account has enough STX
2. **Invalid Mnemonic**: Double-check your mnemonic phrase
3. **Network Issues**: Ensure you're connected to testnet, not mainnet

### Error Messages

- `ERR-INSUFFICIENT-BALANCE (u1001)`: Not enough tokens
- `ERR-NOT-AUTHORIZED (u1003)`: Only contract owner can mint
- `ERR-ZERO-AMOUNT (u1004)`: Cannot transfer/mint zero tokens

## Security Considerations

1. **Never share your mnemonic phrase**
2. **Test thoroughly on testnet before mainnet**
3. **Review contract code before deployment**
4. **Keep your private keys secure**

## Next Steps

After successful testnet deployment:

1. **Test all functions thoroughly**
2. **Get community feedback**
3. **Audit your contract** (recommended for mainnet)
4. **Deploy to mainnet** when ready

## Useful Links

- [Stacks Documentation](https://docs.stacks.co/)
- [Clarinet Documentation](https://docs.hiro.so/clarinet/)
- [Testnet Explorer](https://explorer.hiro.so/?chain=testnet)
- [Testnet Faucet](https://faucet.hiro.so/)
- [Hiro Wallet](https://wallet.hiro.so/)

## Support

If you encounter issues:

1. Check the [Stacks Discord](https://discord.gg/stacks)
2. Review the [Clarinet GitHub Issues](https://github.com/hirosystems/clarinet/issues)
3. Consult the [Stacks Forum](https://forum.stacks.org/)

---

**Happy deploying! 🚀**

