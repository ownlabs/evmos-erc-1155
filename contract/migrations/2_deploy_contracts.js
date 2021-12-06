const EvmosCollectible = artifacts.require("./EvmosCollectible.sol");
const fs = require('fs')

module.exports = async(deployer, network) => {
    // OpenSea proxy registry addresses for rinkeby and mainnet.
    let proxyRegistryAddress = "0x0000000000000000000000000000000000000000";

    await deployer.deploy(EvmosCollectible, proxyRegistryAddress);
    const contract = await EvmosCollectible.deployed();

    let configs = JSON.parse(fs.readFileSync('./configs/' + network + '.json').toString())
    console.log('Saving address in config file..')
    configs.contract_address = contract.address
    fs.writeFileSync('./configs/' + network + '.json', JSON.stringify(configs, null, 4))
    console.log('--')

};