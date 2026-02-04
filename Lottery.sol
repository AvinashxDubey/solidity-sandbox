// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Lottery {
    address public owner;
    address[] public listOfPlayers;
    mapping(address => bool) public addressExists;
    address public prevWinner;

    constructor() {
        owner = msg.sender;
    }

    function enter() public payable {
        require(msg.value>= 0.001 ether, "Minimum 0.001 Ether required");
        if(!addressExists[msg.sender]){
            listOfPlayers.push(msg.sender);
            addressExists[msg.sender] = true;
        }
    }

    function pickWinner() public {
        require(msg.sender == owner, "Only owner can pick winner!!");
        require(listOfPlayers.length>0, "We ain't got enough players!!");

        uint256 randomIdx = random() % listOfPlayers.length;
        address winner = listOfPlayers[randomIdx];

        (bool success, ) = payable(winner).call{value: address(this).balance}("");
        require(success, "ETH transfer failed");

        delete listOfPlayers;
        prevWinner = winner;
    }

    function random() internal view returns (uint256){
        return uint256(
            keccak256(
                abi.encode(
                    block.timestamp,
                    blockhash(block.number-1),
                    listOfPlayers.length
                )
            )
        );
    }

    function getPlayers() public view returns (address[] memory) {
        return listOfPlayers;
    }
}