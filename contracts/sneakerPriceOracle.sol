//SPDX-Liscence-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract sneakerPriceOracle {
    AggregatorV3Interface internal priceFeed;
    address internal oracleAd;
    uint256 internal price;

    constructor() {
        priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
        oracleAd = 0x9326BFA02ADD2366b30bacB125260Af641031331;
    }   
    function getLatestPrice() public view returns (uint256) {
        (,int price,,,) = priceFeed.latestRoundData();
        return uint256(price * 10000000000);
    }
//Move to Interface Directory 
    interface AggregatorV3Interface {
        function latestRoundData() external view returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
    }
    