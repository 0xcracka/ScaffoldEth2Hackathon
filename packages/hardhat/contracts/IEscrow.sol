// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEscrow {
    function deposit() external payable;
    function approve() external;
    function reject() external;
    function getStatus() external view returns (string memory);
}
