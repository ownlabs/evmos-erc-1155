// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EvmosCollectible is ERC1155, Ownable {
    
    address proxyRegistryAddress;
    string metadata_uri;
    mapping(uint256 => uint256) private MINT_PRICES;
    mapping(uint256 => uint256) private HARD_CAPS;
    mapping(uint256 => uint256) private MINTED;

    constructor(address _proxyRegistryAddress) ERC1155("https://raw.githubusercontent.com/ownlabs/evmos-erc-721-pfp/master/metadata/{id}.json") {
        proxyRegistryAddress = _proxyRegistryAddress;
        metadata_uri = "https://raw.githubusercontent.com/ownlabs/evmos-erc-721-pfp/master/metadata/{id}.json";
        MINT_PRICES[1] = 0.0001 ether;
        HARD_CAPS[1] = 10001;
    }

    function setURI(string memory newuri) public onlyOwner {
        metadata_uri = newuri;
        _setURI(newuri);
    }

    function contractURI() public view returns (string memory){
        return metadata_uri;
    }

    function totalSupply(uint256 id) public view returns (uint256){
        return MINTED[id];
    }

    function buyNFT(uint256 id)
        public payable
    {
        require(MINT_PRICES[id] > 0, "EvmosCollectible: NFT price doesn't exists");
        require(HARD_CAPS[id] > 0, "EvmosCollectible: NFT hard cap doesn't exists");
        require(msg.value % MINT_PRICES[id] == 0, 'EvmosCollectible: Amount must be a multiple of price');
        uint256 bought = msg.value / MINT_PRICES[id];
        require(bought >= 1, 'EvmosCollectible: Amount should be at least 1');
        uint256 reached = MINTED[id] + 1;
        require(reached <= HARD_CAPS[id], "EvmosCollectible: Hard cap reached");
        MINTED[id] = MINTED[id] + 1;
        _mint(msg.sender, id, bought, "0x0");
    }

    /**
   * Override isApprovedForAll to auto-approve marketplace proxy contract
   */
    function isApprovedForAll(
        address _owner,
        address _operator
    ) public override view returns (bool isOperator) {
       if (_operator == address(proxyRegistryAddress)) {
            return true;
        }
        return ERC1155.isApprovedForAll(_owner, _operator);
    }
}