// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/proxy/Clones.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract Marketplace {
    // State variables
    address public owner; // Address of the contract owner
    address public devTeam;
    address implementCollection;

        // Modifier to restrict access to only the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    constructor(
        address _implementCollection
    ) payable {
        owner = msg.sender;
        implementCollection = _implementCollection;
    }

    /// @notice Function to mint a new NFT
    /// @param _nftURI The URI of the NFT
    /// @param _name The name of the new collection
    /// @param _symbol The symbol of the new collection
    /// @param _description The description of the new collection
    /// @return The address of the new collection
    function mintNFTS(
        string[] memory _nftURI,
        string memory _name,
        string memory _symbol,
        string memory _description
    ) external  returns (address) {
        address newDeployedAddress = Clones.clone(implementCollection);
        INFT(newDeployedAddress).initialize(
            _name,
            _symbol,
            _description,
            _nftURI,
            msg.sender
        );
        return newDeployedAddress;
    }
}
