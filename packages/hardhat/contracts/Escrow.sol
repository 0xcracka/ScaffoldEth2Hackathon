// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

contract Escrow {
    address public arbiter;
    address public beneficiary;
    address public depositor;

    bool public isApproved;


    constructor(address _arbiter, address _beneficiary, address _depositor)payable {
        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = _depositor;
    }

    event Approved(bool isApproved);
	event EtherReleased(uint256 amount, uint256 timestamp);
    event ERC20Released(address tokenAddress, uint256 amount, uint256 timestamp);
    event ERC721Released(address tokenAddress, uint256 tokenId, uint256 timestamp);
    event ERC1155Released(address tokenAddress, uint256 tokenId, uint256 amount, uint256 timestamp);
	event EtherDeposited(uint256 amount, uint256 timestamp);
	event ERC20Deposited(address tokenAddress, uint256 amount, uint256 timestamp);
	event ERC721Deposited(address tokenAddress, uint256 tokenId, uint256 timestamp);
	event ERC1155Deposited(address tokenAddress, uint256 tokenId, uint256 amount, uint256 timestamp);

    function depositEther() external payable {
        require(msg.sender == depositor, "Only the depositor can deposit Ether");
		emit EtherDeposited(msg.value, block.timestamp);

    }

    function depositERC20(address tokenAddress, uint256 amount) external {
        require(msg.sender == depositor, "Only the depositor can deposit ERC20 tokens");
        IERC20 token = IERC20(tokenAddress);
        require(token.transferFrom(msg.sender, address(this), amount), "ERC20 token transfer failed");
		emit ERC20Deposited(tokenAddress, amount, block.timestamp);

    }

    function depositERC721(address tokenAddress, uint256 tokenId) external {
        require(msg.sender == depositor, "Only the depositor can deposit ERC721 tokens");
        IERC721 token = IERC721(tokenAddress);
        token.safeTransferFrom(msg.sender, address(this), tokenId);
		emit ERC721Deposited(tokenAddress, tokenId, block.timestamp);

    }

    function depositERC1155(address tokenAddress, uint256 tokenId, uint256 amount, bytes memory data) external {
        require(msg.sender == depositor, "Only the depositor can deposit ERC1155 tokens");
        IERC1155 token = IERC1155(tokenAddress);
        token.safeTransferFrom(msg.sender, address(this), tokenId, amount, data);
		emit ERC1155Deposited(tokenAddress, tokenId, amount, block.timestamp);

    }

	function approve() external {
		require(msg.sender == arbiter, "Only the arbiter can approve the transfer");
		isApproved = true;
		emit Approved(isApproved); // Emit the Approved event with the current approval status
		}

    function releaseEther() external {
        require(isApproved, "The transfer must be approved by the arbiter");
        require(msg.sender == beneficiary, "Only the beneficiary can release the Ether");
        uint256 amount = address(this).balance;
        payable(beneficiary).transfer(amount);
        emit EtherReleased(amount, block.timestamp);
}

    function releaseERC20(address tokenAddress, uint256 amount) external {
        require(isApproved, "The transfer must be approved by the arbiter");
        require(msg.sender == beneficiary, "Only the beneficiary can release the ERC20 tokens");
        IERC20 token = IERC20(tokenAddress);
        require(token.transfer(beneficiary, amount), "ERC20 token transfer failed");
		emit ERC20Released(tokenAddress, amount, block.timestamp);

    }

    function releaseERC721(address tokenAddress, uint256 tokenId) external {
        require(isApproved, "The transfer must be approved by the arbiter");
        require(msg.sender == beneficiary, "Only the beneficiary can release the ERC721 tokens");
        IERC721 token = IERC721(tokenAddress);
        token.safeTransferFrom(address(this), beneficiary, tokenId);
        emit ERC721Released(tokenAddress, tokenId, block.timestamp);


    }

    function releaseERC1155(address tokenAddress, uint256 tokenId, uint256 amount, bytes memory data) external {
        require(isApproved, "The transfer must be approved by the arbiter");
        require(msg.sender == beneficiary, "Only the beneficiary can release the ERC1155 tokens");
        IERC1155 token = IERC1155(tokenAddress);
        token.safeTransferFrom(address(this), beneficiary, tokenId, amount, data);
		emit ERC1155Released(tokenAddress, tokenId, amount, block.timestamp);

    }
}
