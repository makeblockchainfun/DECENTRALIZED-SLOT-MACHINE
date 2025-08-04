// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// A simple decentralized slot machine.
// Note: On-chain randomness is not truly secure and is for demonstration purposes only.
contract SlotMachine {
    address public owner;
    uint256 public nonce;

    // Symbol representation: 0=🍒, 1=🍋, 2=💎, 3=🔔, 4=7️⃣
    // The cost to play is fixed at 0.001 ETH.

    // Payouts for matching symbols.
    uint256 public constant PAYOUT_3X_DIAMOND = 0.01 ether;
    uint256 public constant PAYOUT_3X_LEMON = 0.005 ether;
    uint256 public constant PAYOUT_2X_ANY = 0.002 ether;

    uint256 public constant PAYOUT_3X_SEVEN = 1 ether;
    uint256 public constant PAYOUT_3X_BELL = 0.02 ether;
    uint256 public constant PAYOUT_3X_CHERRY = 0.01 ether;

    // Events to help the frontend listen for changes.
    event Fund(address indexed funder, uint256 amount);
    event SpinResult(address indexed player, uint8 reel1, uint8 reel2, uint8 reel3, uint256 payoutAmount);
    event Withdrawal(address indexed to, uint256 amount);

    constructor() {
        owner = msg.sender;
        nonce = 0;
    }

    // Allows anyone to send ETH to the contract to fund the prize pool.
    function fundContract() public payable {
        require(msg.value > 0, "Amount must be greater than zero.");
        emit Fund(msg.sender, msg.value);
    }

    // The main function to play the slot machine.
    // It costs exactly 0.001 ETH to play.
    function play() public payable {
        // Ensure the player sent the correct amount.
        require(msg.value == 0.001 ether, "Cost to play is exactly 0.001 ETH.");

        // Increment the nonce to change the random seed for each spin.
        nonce++;

        // Generate a pseudo-random number using keccak256.
        // This is not cryptographically secure and is for demonstration purposes.
        bytes32 randomSeed = keccak256(abi.encodePacked(block.timestamp, uint256(block.prevrandao), nonce, msg.sender));

        // Use the random number to get three reel numbers (0-4).
        // Cast literal numbers to uint8 to fix compiler error.
        uint8 reel1 = uint8(uint256(randomSeed) % 5);
        uint8 reel2 = uint8(uint256(keccak256(abi.encodePacked(randomSeed, uint8(1)))) % 5);
        uint8 reel3 = uint8(uint256(keccak256(abi.encodePacked(randomSeed, uint8(2)))) % 5);

        uint256 payoutAmount = 0;
        
        // --- WINNING LOGIC ---
        // Jackpot: all three symbols match.
        if (reel1 == reel2 && reel2 == reel3) {
            if (reel1 == 4) { // 7️⃣
                payoutAmount = PAYOUT_3X_SEVEN;
            } else if (reel1 == 2) { // 💎
                payoutAmount = PAYOUT_3X_DIAMOND;
            } else if (reel1 == 1) { // 🍋
                payoutAmount = PAYOUT_3X_LEMON;
            } else if (reel1 == 3) { // 🔔
                payoutAmount = PAYOUT_3X_BELL;
            } else if (reel1 == 0) { // 🍒
                payoutAmount = PAYOUT_3X_CHERRY;
            }
        } 
        // Small win: two symbols match.
        else if (reel1 == reel2 || reel1 == reel3 || reel2 == reel3) {
            payoutAmount = PAYOUT_2X_ANY;
        }

        if (payoutAmount > 0) {
            // Ensure the contract has enough balance to pay out.
            require(address(this).balance >= payoutAmount, "Insufficient contract balance for payout.");
            
            // Transfer the winning amount to the player.
            (bool success, ) = msg.sender.call{value: payoutAmount}("");
            require(success, "Failed to send payout.");
        }

        // Emit an event with the spin result.
        emit SpinResult(msg.sender, reel1, reel2, reel3, payoutAmount);
    }

    // Allows the contract owner to withdraw the entire balance.
    function withdrawAll() public {
        require(msg.sender == owner, "Only the owner can withdraw funds.");
        
        uint256 balance = address(this).balance;
        // Transfer the entire balance to the owner.
        (bool success, ) = owner.call{value: balance}("");
        require(success, "Failed to withdraw funds.");
        emit Withdrawal(owner, balance);
    }

    // Fallback function to allow funding without calling `fundContract`.
    receive() external payable {
        fundContract();
    }
}

