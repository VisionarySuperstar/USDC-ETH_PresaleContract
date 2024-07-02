// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
// mainnet usdc address 0xdAC17F958D2ee523a2206206994597C13D831ec7

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

uint256 constant INITIAL_TOKEN_PRICE = 14; //0.0014
// address constant MAINNET_USDC = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d; // USDC address in BSC
// address constant MAINNET_USDC = 0x16227D60f7a0e586C66B005219dfc887D13C9531; // USDC address in BSC Testnet
address constant MAINNET_USDC = 0x94a9D9AC8a22534E3FaCa9F4e7F2E2cf85d5E4C8; // USDC address in Sepolia Testnet

// address constant MAINNET_TOKEN = 0x5DFADeacc8239edBDa5598AEEd615d18F6825dE9; // Token Address in BSC
// address constant MAINNET_TOKEN = 0x69C9A6ccb9d07276e960eC7eD05e46ea815eD579; // Token Address in BSC Testnet
address constant MAINNET_TOKEN = 0x69C9A6ccb9d07276e960eC7eD05e46ea815eD579; // Token Address in Sepolia Testnet

// mainnet router
// address constant PANCAKESWAPV2_ROUTER_ADDRESS = address(
//     0x10ED43C718714eb63d5aA57B78B54704E256024E 
// );

// BSC testnet router
// address constant PANCAKESWAPV2_ROUTER_ADDRESS = address(
//     0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3 
// );

// Sepolia testnet router
address constant PANCAKESWAPV2_ROUTER_ADDRESS = address(
    0xB26B2De65D07eBB5E54C7F6282424D3be670E1f0
);

contract Presale is Ownable {
    bool public presaleStarted;
    uint public startTimeStamp;
    uint public endTimeStamp;
    uint256 public totalCap;
    mapping (address => uint256) balanceOf;

    IUniswapV2Router02 public router =
        IUniswapV2Router02(address(PANCAKESWAPV2_ROUTER_ADDRESS));

    IERC20 usdc = IERC20(MAINNET_USDC); // USDC contract address
    IERC20 token = IERC20(MAINNET_TOKEN);

    receive() external payable {}

    constructor(uint _endTimeStamp) Ownable(msg.sender) {
        require(
            block.timestamp < _endTimeStamp,
            "Presale end time should be in the future"
        );
        endTimeStamp = _endTimeStamp;
        startTimeStamp = _endTimeStamp;
        totalCap = 0;
        presaleStarted = false;
    }
    function updateEndTimeStamp(uint256 _endTimeStamp) public onlyOwner {
        require(
            block.timestamp < _endTimeStamp,
            "Update endtime in the future"
        );
        endTimeStamp = _endTimeStamp;
    }

    function getCurrentTokenPrice() public view returns (uint256) {
        uint256 currentStep = totalCap / (500 * 10 ** (3 + 18));
        uint256 tokenPrice = INITIAL_TOKEN_PRICE + currentStep * 20;
        return tokenPrice;
    }
    
    function startPresale (uint256 _endTimeStamp) public onlyOwner {
        require(
            block.timestamp < _endTimeStamp,
            "Update endtime in the future"
        );

        startTimeStamp = block.timestamp;
        endTimeStamp = _endTimeStamp;
        presaleStarted = true;
    }
    function calculateRemainingTime() public view returns(uint256) {
        require(block.timestamp < endTimeStamp, "Presale is ended");

        return (endTimeStamp - block.timestamp);
    }

    function buyTokenWithUSDC(uint256 _usdcAmount) public {
        if(block.timestamp >= endTimeStamp) presaleStarted = false;

        require(block.timestamp > startTimeStamp, "Presale is not started");
        require(presaleStarted == true, "Presale is ended");
        require(0 < _usdcAmount, "Unavailable amount of token to buy");

        uint256 currentTokenPrice = getCurrentTokenPrice();
        uint256 tokenAmount = (_usdcAmount * 10 ** 4) / currentTokenPrice;

        totalCap = totalCap + _usdcAmount;
        usdc.transferFrom(msg.sender, address(this), _usdcAmount);
        balanceOf[msg.sender] += tokenAmount;
    }
    function buyTokenWithBNB() public payable {
        if(block.timestamp >= endTimeStamp) presaleStarted = false;
        
        require(block.timestamp > startTimeStamp, "Presale is not started");
        require(presaleStarted == true, "Presale is ended");
        require(0 < msg.value, "Unavailable amount of token to buy");

        address WETH = router.WETH();
        address[] memory path = new address[](2);
        path[0] = WETH;
        path[1] = MAINNET_USDC;
        uint256[] memory amounts = router.swapExactETHForTokens{
            value: msg.value
        }(0, path, address(this), block.timestamp + 15 minutes);
        uint256 usdAmount = amounts[1];
        
        uint256 currentTokenPrice = getCurrentTokenPrice();
        uint256 tokenAmount = (usdAmount * 10 ** 4) / currentTokenPrice;
        totalCap += usdAmount;
        balanceOf[msg.sender] += tokenAmount;
    }

    function withdraw(address _to) public payable onlyOwner {
        usdc.transfer(_to, usdc.balanceOf(address(this)));
    }

    function claim() external {
        require(block.timestamp > endTimeStamp, "presale did not finished");
        require(balanceOf[msg.sender] > 0, "No balane to claim");
        uint256 amount = balanceOf[msg.sender];
        balanceOf[msg.sender] = 0;
        token.transfer(msg.sender, amount);
    }
}