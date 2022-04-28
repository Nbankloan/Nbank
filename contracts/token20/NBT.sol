// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NBT is ERC20 {
    constructor () ERC20("NBT","NBT") {
        _mint(msg.sender, 100_000_000*10**18);
    }
}
