// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Land.sol";

contract Insurance {
    struct staked {
        uint256 insurance;
        bool claimable;
        uint256 limit;
        mapping(address => uint256) insurers;
    }
    mapping(address => staked) landInsurance;
    mapping(address => uint256) rewards;

    function initLand(uint256 limit_) external payable {
        require(msg.value > 0);
        landInsurance[msg.sender].limit = limit_;
        rewards[msg.sender] += msg.value;
    }

    function stake(address landContract) external payable {
        require(msg.value > 0);
        landInsurance[landContract].insurance += msg.value;
        landInsurance[landContract].insurers[msg.sender] += msg.value;
    }

    function finish() external {
        if (Land(msg.sender).sold() < landInsurance[msg.sender].limit) {
            (bool success, ) = msg.sender.call{
                value: landInsurance[msg.sender].insurance
            }("");
            require(success, "Transfer failed.");
        } else {
            landInsurance[msg.sender].claimable = true;
        }
    }

    function withdraw(address landContract) external payable {
        require(landInsurance[landContract].claimable);
        require(landInsurance[landContract].insurers[msg.sender] > 0);
        (bool success, ) = msg.sender.call{
            value: landInsurance[landContract].insurers[msg.sender] +
                (landInsurance[landContract].insurance /
                    landInsurance[landContract].insurers[msg.sender]) *
                rewards[landContract]
        }("");
        require(success, "Transfer failed.");
    }

    function getBalance(address landContract) external view returns (uint256) {
        return landInsurance[landContract].insurers[msg.sender];
    }

    function isClaimable(address landContract) external view returns (bool) {
        return landInsurance[landContract].claimable;
    }

    function getLimit(address landContract) external view returns (uint256) {
        return landInsurance[landContract].limit;
    }
}
