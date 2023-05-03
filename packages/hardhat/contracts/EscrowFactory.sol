// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./Escrow.sol";
import "./IEscrow.sol";

contract EscrowFactory {
    event EscrowCreated(address indexed escrow, address indexed arbiter, address indexed beneficiary);

    mapping(address => address[]) public userEscrows;
    address[] public allEscrows;

    function createEscrow(address arbiter, address beneficiary) external payable returns (address) {
        require(msg.value > 0, "EscrowFactory: Must provide value to create Escrow");

        // Pass the msg.sender as the funder when creating a new instance of Escrow
        Escrow escrow = new Escrow{value: msg.value}(arbiter, beneficiary, msg.sender);
        
        userEscrows[msg.sender].push(address(escrow));
        allEscrows.push(address(escrow));

        emit EscrowCreated(address(escrow), arbiter, beneficiary);
        return address(escrow);
    }
    function getEscrowStatus(address escrowAddress) external view returns (string memory) {
        IEscrow escrow = IEscrow(escrowAddress);
        return escrow.getStatus();
    }
    function getEscrowCount() public view returns (uint256) {
        return allEscrows.length;
}

    function getEscrowAtIndex(uint256 index) public view returns (address) {
        require(index < allEscrows.length, "EscrowFactory: Index out of bounds");
        return allEscrows[index];
}

    function getUserEscrowCount(address user) public view returns (uint256) {
        return userEscrows[user].length;
}

    function getUserEscrowAtIndex(address user, uint256 index) public view returns (address) {
        require(index < userEscrows[user].length, "EscrowFactory: Index out of bounds");
        return userEscrows[user][index];
}
}
