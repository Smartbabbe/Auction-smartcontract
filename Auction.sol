// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Auction {

    event AuctionBidded (address _bidder, uint _bidAmount);
    
    address public owner;
    address public highestBidAddress;
    uint public highestBidAmount;

    constructor() {
        owner = msg.sender;
        highestBidAmount = 0;
    }

    function placeBid() external payable {
        require(msg.sender != owner, "Bids cannot be placed by owner");
        require(msg.value > highestBidAmount, "Bid must be higher than the current highest bid Amount");


        if (highestBidAddress != address(0)) {
            payable(highestBidAddress).transfer(highestBidAmount);
        }

        highestBidAddress = msg.sender;
        highestBidAmount = msg.value;

        emit AuctionBidded(highestBidAddress, highestBidAmount);
    }

    function endAuction() external {
        require(msg.sender == owner, "Only owner can end the auction");
        require(highestBidAddress != address(0), "Auction has not received any bids, wait a little");

        // Transfer funds to the owner
        payable(owner).transfer(highestBidAmount);

        // Reset auction state
        highestBidAddress = address(0);
        highestBidAmount = 0;
    }
}
