const HDWalletProvider = require("@truffle/hdwallet-provider");
require('dotenv').config()

module.exports = {
    contracts_directory: "./contracts/",
    plugins: [
        'truffle-plugin-verify'
    ],
    api_keys: {
        etherscan: process.env.ETHERSCAN_KEY
    },
    networks: {
        ganache: {
            host: "localhost",
            port: 7545,
            gas: 5000000,
            gasPrice: 15000000000,
            network_id: "*", // Match any network id
        },
        evmos: {
            provider: () => new HDWalletProvider(process.env.MNEMONIC, process.env.PROVIDER),
            network_id: 9000,
            confirmations: 2,
            gasPrice: "30",
            timeoutBlocks: 200,
            skipDryRun: true
        },
    },
    mocha: {
        reporter: "eth-gas-reporter",
        reporterOptions: {
            currency: "USD",
            gasPrice: 2,
        },
    },
    compilers: {
        solc: {
            version: "0.8.6"
        },
    },
};