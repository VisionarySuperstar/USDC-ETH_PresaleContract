// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface INFT {
    function ownerOf(uint256 tokenId) external view returns (address);
    function factory() external view returns (address);
    function description() external view returns (string memory);
    function tokenNumber() external view returns (uint256);
    function initialize(
        string memory _name,
        string memory _symbol,
        string memory _description,
        string[] memory _nftURI,
        address _target
    ) external;
    function mint(string[] memory _nftURI) external payable returns (uint256);
    function burn(uint256 tokenId) external payable returns (uint256);
    function tokenURI(uint256 _tokenId) external view returns (string memory);
}