// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // Solidity 0.8.0 use safe math by default
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Insurance.sol";

contract Land is ERC20, Ownable {
    uint256 public sold;
    uint256 public currentPrice;
    uint256 limit;
    Insurance public insurance;

    constructor(
        uint256 initialSupply,
        uint256 initialPrice,
        uint256 limit_,
        address insurance_
    ) payable ERC20("Land", "LAND") {
        _mint(msg.sender, initialSupply);
        currentPrice = initialPrice;
        limit = limit_;
        insurance = Insurance(insurance_);
        insurance.initLand{value: msg.value}(limit);
    }

    function buy() external payable {
        require(msg.value > 0);
        sold += msg.value;
        (bool success, ) = msg.sender.call{value: msg.value / currentPrice}("");
        require(success, "Transfer failed.");
    }

    function setPrice(uint256 price) external onlyOwner {
        currentPrice = price;
    }

    function withdraw() external onlyOwner {
        (bool success, ) = owner().call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    function harvest() external onlyOwner {
        insurance.finish();
    }
}
