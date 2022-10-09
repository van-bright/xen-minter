// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IBurnableToken {
    function burn(address user, uint256 amount) external;
}