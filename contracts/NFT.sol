// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Collection is ERC721 {
    string public description;
    uint256 public tokenNumber;
    mapping(uint256 => string) private nftURIPath; // Mapping to store NFT URI paths
    address public feeToken;
    uint256 public mintFee;
    mapping(address => uint256) creators;
    address public devTeam;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _description,
        address _feeToken,
        uint256 _mintFee,
        address _devTeam
    ) ERC721(_name, _symbol) {
        description = _description;
        feeToken = _feeToken;
        mintFee = _mintFee;
        devTeam = _devTeam;
    }

    function mint(string memory _nftURI) external {
        if (tokenNumber < 1000) {
            require(creators[msg.sender] == 0, "Invalid minter");
            _mint(msg.sender, tokenNumber);
            _setTokenURI(_nftURI);
            creators[msg.sender] += 1;
        }
        else{
            require(creators[msg.sender] < 5, "Mint number exceed");
            SafeERC20.safeTransferFrom(
                IERC20(feeToken),
                msg.sender,
                address(this),
                mintFee
            );
            _mint(msg.sender, tokenNumber);
            _setTokenURI(_nftURI);
            creators[msg.sender] += 1;
        }
    }

    function burn(uint256 _tokenId) external {
        require(msg.sender == ownerOf(_tokenId), "only owner can burn");
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
    function withdraw() external{
        require(msg.sender == devTeam, "Only dev team can withdraw");
        uint256 amount = IERC20(feeToken).balanceOf(address(this));
        SafeERC20.safeTransfer(IERC20(feeToken), msg.sender, amount);
    }
}
