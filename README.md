# 🎰 Ethereum Slot Machine (Smart Contract)

A simple decentralized **Slot Machine** built with Solidity for the Ethereum blockchain. This smart contract allows users to play a slot game for a fixed ETH cost and win based on symbol combinations. The randomness is pseudo-random and **not secure**, meant only for educational or demo purposes.

---

## 🚀 Features

- 🎮 **Play for 0.001 ETH** per spin.
- 💰 Win ETH based on symbol combinations.
- 🔒 Owner-controlled withdrawals.
- 🌐 Open funding – anyone can fund the prize pool.
- 📦 Emits useful events for frontend integration (`SpinResult`, `Fund`, `Withdrawal`).

---

## ⚙️ Symbols

| Symbol | Index | Emoji |
|--------|-------|-------|
| 0      | 🍒     | Cherry |
| 1      | 🍋     | Lemon  |
| 2      | 💎     | Diamond |
| 3      | 🔔     | Bell   |
| 4      | 7️⃣     | Lucky Seven |

---

## 🎁 Payouts

| Match Type             | Condition               | Payout        |
|------------------------|-------------------------|---------------|
| 🎉 Jackpot (3x 7️⃣)     | `reel1 == reel2 == reel3 == 4` | `1 ETH`       |
| 💎 3x Diamonds         | `reel1 == reel2 == reel3 == 2` | `0.01 ETH`    |
| 🍋 3x Lemons           | `reel1 == reel2 == reel3 == 1` | `0.005 ETH`   |
| 🔔 3x Bells            | `reel1 == reel2 == reel3 == 3` | `0.02 ETH`    |
| 🍒 3x Cherries         | `reel1 == reel2 == reel3 == 0` | `0.01 ETH`    |
| 😊 2x Any Symbols       | Any 2 of 3 symbols match | `0.002 ETH`   |
| 😢 No Match            | All symbols different     | No payout     |

---

## 📜 How to Use

1. **Deploy the contract** using Remix, Hardhat, or any other tool.
2. **Fund the contract** by calling `fundContract()` or sending ETH directly.
3. **Play the game** by calling `play()` with exactly `0.001 ETH`.
4. If you're lucky, you'll receive a payout immediately!

---

## 🛡️ Security Notice

This contract uses `block.timestamp`, `block.prevrandao`, and `nonce` for randomness. This is **not secure** for production or real-money applications. For secure randomness, consider Chainlink VRF or other verifiable solutions.

---

## 🧑‍💻 Functions Overview

- `fundContract()`: Fund the game pool.
- `play()`: Play the game. Sends payout if eligible.
- `withdrawAll()`: Owner-only. Withdraws all funds.
- `receive()`: Accept ETH directly to fund the contract.

---

## 🧪 Example (Frontend)

To connect this contract with a frontend, listen for:
- `SpinResult` – reels and payout
- `Fund` – ETH added to prize pool
- `Withdrawal` – owner withdrew funds

---

## 🔓 License

MIT

---

## 🤖 Author

Smart contract by makeblockchainfun. Built for fun, learning, and demos.

---

