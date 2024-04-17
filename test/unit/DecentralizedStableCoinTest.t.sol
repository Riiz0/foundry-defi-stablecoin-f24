// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {DeployDecentralizedStableCoin} from "../../script/DeployDecentralizedStableCoin.s.sol";

contract DecentralizedStableCoinTest is Test {
    DecentralizedStableCoin decentralizedStableCoin;
    DeployDecentralizedStableCoin deployer;

    uint256 STARTING_BALANCE = 100 ether;
    address USER = makeAddr("user");
    address public deployerAddress;

    function setUp() public {
        deployer = new DeployDecentralizedStableCoin();
        decentralizedStableCoin = deployer.run();
    }

    function testContractNameAndSymbol() public view {
        assertEq(
            decentralizedStableCoin.name(),
            "DecentralizedStableCoin",
            "Name should be 'DecentralizedStableCoin'"
        );
        assertEq(
            decentralizedStableCoin.symbol(),
            "DSC",
            "Symbol should be 'DSC'"
        );
    }

    function testOnlyOwnerCanMint() public {
        decentralizedStableCoin.mint(msg.sender, 1000);
        assertEq(
            decentralizedStableCoin.balanceOf(msg.sender),
            1000,
            "Minted amount should be 1000"
        );
    }

    // function testFailedMintByUser() public {
    //     vm.prank(USER);
    //     decentralizedStableCoin.mint(USER, 1000);
    //     expectRevert(USER);
    // }

    // function testOnlyOwnerCanBurn() public {
    //     decentralizedStableCoin.burn(2000)
    // }

    // function testFailedBurnByUser() public {
    //     vm.prank(USER);
    // }
}
