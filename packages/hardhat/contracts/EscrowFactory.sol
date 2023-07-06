// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./Escrow.sol";
import "./IEscrow.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract EscrowFactory {
    event EscrowCreated(address indexed escrow, address indexed arbiter, address indexed beneficiary);

    mapping(address => address[]) public userEscrows;
    address[] public allEscrows;

    function createEscrow(address arbiter, address beneficiary, bytes32 salt) external payable returns (address) {
        require(msg.value > 0, "EscrowFactory: Must provide value to create Escrow");

        // Define the implementation contract for the escrow
        Escrow escrowImplementation = new Escrow(arbiter, beneficiary, msg.sender);

        // Compute the address for the new escrow contract with the given salt
        address escrowAddress = Clones.predictDeterministicAddress(address(escrowImplementation), salt);

        // Create the new escrow contract using CREATE2
        Clones.cloneDeterministic(address(escrowImplementation), salt);

        userEscrows[msg.sender].push(escrowAddress);
        allEscrows.push(escrowAddress);

        emit EscrowCreated(escrowAddress, arbiter, beneficiary);
        return escrowAddress;
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
