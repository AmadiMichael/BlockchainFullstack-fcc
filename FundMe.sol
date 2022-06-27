//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";

contract FundMe {

    constructor (){
        i_owner = msg.sender;
    }

    using PriceConverter for uint256;

    address public immutable i_owner;

    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address [] public funders;

    mapping(address => uint256) public addressToAmountFunded;

    function fund () public payable {
        uint256 usdAmount = msg.value.getConversionRate();
        require (usdAmount >= MINIMUM_USD, "Not enough");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    modifier onlyOwner {
        require (msg.sender == i_owner, "not owner");
        _;
    }

    

    function withdraw () public onlyOwner {
        
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address [](0);

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require (callSuccess, "call failed");
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
