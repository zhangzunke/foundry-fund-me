// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { FundMe } from "../../src/FundMe.sol";
import { DeployFundMe } from "../../script/DeployFundMe.s.sol";
import { FundFundMe, WithdrawFundMe } from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    address private USER = makeAddr("User");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant INITAL_BALANCE = 200 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, INITAL_BALANCE);
    }

    function testUserCanFundInteractions() public {
        // FundFundMe fundfundMe = new FundFundMe();
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));
        assertEq(address(fundMe).balance, 0);
    }
}