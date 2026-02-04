// SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

// importing contracts
import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        listOfSimpleStorageContracts.push(newSimpleStorageContract);
    }

    // ABI (Application Binary Interface) serves as a bridge, translating high-level, human-readable function calls
    //  (e.g., transfer(address,uint256)) into the specific, low-level hexadecimal bytecode
    //   that the Ethereum Virtual Machine (EVM) understands.

    function sfStore(uint256 idx, uint256 _myFavNumber) public {
        SimpleStorage simpleStorage = listOfSimpleStorageContracts[idx];
        simpleStorage.store(_myFavNumber);
    }

    function sfGet(uint256 idx) public view returns (uint256) {
        SimpleStorage simpleStorage = listOfSimpleStorageContracts[idx];
        return simpleStorage.retrieve();
    }
}
