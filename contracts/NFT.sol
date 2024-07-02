// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract Collection is ERC721Upgradeable {
    address public factory;
    string public description;
    uint256 public tokenNumber;
    mapping(uint256 => string) private nftURIPath; // Mapping to store NFT URI paths
    function initialize(
        string memory _name,
        string memory _symbol,
        string memory _description,
        string[] memory _nftURI,
        address _target
    ) external initializer{
        ERC721Upgradeable.__ERC721_init(_name, _symbol);
        factory = msg.sender;
        require(_target != address(0), "target address cannot be 0");
        tokenNumber = 1;
        for(uint256 i = 0 ; i < _nftURI.length ; i ++){
            _mint(_target, tokenNumber);
            _setTokenURI(_nftURI[i]);
        }
      description = _description;
    }

    function mint(string[] memory _nftURI) external {
        // Mint the NFT token
        uint256 len = _nftURI.length;
        for(uint256 i = 0 ; i < len ; i ++){
            _mint(msg.sender, tokenNumber);
            _setTokenURI(_nftURI[i]);
        }
    }

    function burn(uint256  _tokenId) external  {
        require(msg.sender == ownerOf(_tokenId), "only owner can burn");
        // Burn the NFT token
        _burn(_tokenId);
    }

    /// @notice Function to get the token URI for a given token ID
    /// @param _tokenId Token ID of the NFT token
    /// @return Token URI
    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        return nftURIPath[_tokenId];
    }

    function _setTokenURI(string memory _nftURI) private {
        nftURIPath[tokenNumber] = _nftURI;
        tokenNumber++;
    }
}