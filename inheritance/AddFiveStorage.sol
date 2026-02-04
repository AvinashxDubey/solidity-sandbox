// SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {SimpleStorage} from "../SimpleStorage.sol";

contract AddFiveStorage is SimpleStorage {
    // need to use override keyword to allow overriding
    // and fxn that can be potentially overridden should have virtual keyword
    function store(uint256 _myFavNumber) public override {
        myFavNumber = _myFavNumber+5;
    }
}