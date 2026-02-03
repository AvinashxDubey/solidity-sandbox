// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;  // this is the solidity version

contract SimpleStorage  {
    // basic types: boolean, uint, int, address, bytes
    // uint is bydefault uint256
    // The primary reason for this default is the architecture of EVM,
    //  which processes data in 256-bit (32-byte) words natively. 
    // its better to be explicit about size tho
    // default visibility of var is internal
    // with public keyword getter and setter are generated for the var
    uint256 myFavNumber; // default value is 0
    // uint are +ve and 0, while int are -ve, 0 and +ve
    // int256 favInt = -88;
    // string favNumInTxt = "eighty-eight";
    // address myAddress = 0xa9390Bf7c9E880c510d6dB71d5A29B71D9aa66Ba;
    // // bytes32 and byte are diff things, and 32 is the max bytes size
    // bytes32 favBytes32 = "meow";

    function store(uint256 _myFavNumber) public {
        myFavNumber = _myFavNumber;
        // retrieve(); // thisd charge more execution costs
    }

    // view functions are are explicitly designed to be read-only
    //  and cannot modify the global state of the contract
    // They do not consume gas when called externally (e.g., via a frontend or eth_call),
    //  but they do consume gas when called internally by a state-changing transaction. 
    function retrieve() public view returns(uint256) {
        return myFavNumber;
    }

    // pure function is a function that promises neither to read from nor modify the blockchain's state.
    // Its output is solely determined by its input parameters and local variables declared within its scope
    function getNumPassed(uint256 num) public pure returns(uint256) {
        return num;
    }

    // structs and arrays
    struct Person {
        string name;
        uint256 favNumber;
    }

    Person public p1 = Person('avi', 32); 
    // Person public p1 = Person({name: "avi", favNumber: 32}); // same thing

    // dynamic array
    Person[] public listOfPeople;

    // static array of size 3
    // Person[3] public listOfPeople;

    // mapping
    mapping(string => uint256) public nameToFavNum;

    // memory keyword is used to define temporary variables which can be reassigned
    // calldata keyword is used to define temp vars which cant be reassigned
    // storage keyword is used to define permanent variables
    // vars defined at the contract level (state variables) are automatically storage vars

    // struct, arrays and mapping need memory keyword 
    function addPerson(string memory _name, uint256 _favNumber) public {
        // _name = "dasf"; // this is doable with memory not with calldata
        listOfPeople.push(Person(_name, _favNumber));
        nameToFavNum[_name] = _favNumber;
    }
}