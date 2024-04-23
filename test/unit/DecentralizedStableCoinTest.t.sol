// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {DeployDecentralizedStableCoin} from "../../script/DeployDecentralizedStableCoin.s.sol";

contract DecentralizedStableCoinTest is Test {
    DecentralizedStableCoin dsc;
    DeployDecentralizedStableCoin deployer;

    uint256 STARTING_BALANCE = 100 ether;
    address USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployDecentralizedStableCoin();
        dsc = deployer.run();
    }

    function testContractNameAndSymbol() public view {
        assertEq(dsc.name(), "DecentralizedStableCoin", "Name should be 'DecentralizedStableCoin'");
        assertEq(dsc.symbol(), "DSC", "Symbol should be 'DSC'");
    }

    function testOnlyOwnerCanMint() public {
        uint256 initalMint = 2000;
        vm.prank(dsc.owner());
        dsc.mint(msg.sender, initalMint);
        assertEq(dsc.balanceOf(msg.sender), initalMint, "Minted amount should be 2000");
    }

    function testUserShouldFailTryingToMint() public {
        uint256 initalMint = 2000;
        vm.prank(USER);
        vm.expectRevert("Ownable: caller is not the owner");
        dsc.mint(msg.sender, initalMint);
    }

    function testOnlyOwnerCanBurn() public {
        uint256 initalMint = 2000;
        uint256 initalBurn = 2000;
        uint256 AfterBurn = 0;

        vm.prank(dsc.owner());
        dsc.mint(msg.sender, initalMint);

        vm.prank(dsc.owner());
        dsc.burn(initalBurn);
        assertEq(dsc.balanceOf(msg.sender), AfterBurn);
    }

    function testFailedBurnByUser() public {
        uint256 initalMint = 2000;
        uint256 initalBurn = 2000;

        vm.prank(dsc.owner());
        dsc.mint(msg.sender, initalMint);

        vm.prank(USER);
        dsc.burn(initalBurn);
        vm.expectRevert("Ownable: caller is not the owner");
    }

    function testCantMintToZeroAddress() public {
        uint256 initialMint = 1000; // Assuming a non-zero mint amount for this test
        address zeroAddress = address(0);
        vm.prank(dsc.owner());
        vm.expectRevert(DecentralizedStableCoin.DecentralizedStableCoin__CantMintToZeroAddress.selector);
        dsc.mint(zeroAddress, initialMint);
    }

    function testMintAmountMustBeMoreThanZero() public {
        uint256 initialMint = 0;
        vm.prank(dsc.owner());
        vm.expectRevert(DecentralizedStableCoin.DecentralizedStableCoin__MustBeMoreThanZero.selector);
        dsc.mint(msg.sender, initialMint);
    }

    function testBurnMustBeMoreThanZero() public {
        uint256 initialMint = 1000;
        vm.prank(dsc.owner());
        dsc.mint(msg.sender, initialMint);
        assertEq(dsc.balanceOf(msg.sender), initialMint);

        vm.prank(dsc.owner());
        vm.expectRevert(DecentralizedStableCoin.DecentralizedStableCoin__MustBeMoreThanZero.selector);
        dsc.burn(0);
    }

    function testBurnAmountExceedsBalance() public {
        uint256 initialMint = 1000;
        vm.prank(dsc.owner());
        dsc.mint(msg.sender, initialMint);
        assertEq(dsc.balanceOf(msg.sender), initialMint);

        vm.prank(dsc.owner());
        vm.expectRevert(DecentralizedStableCoin.DecentralizedStableCoin__BurnAmountExceedsBalance.selector);
        dsc.burn(2000);
    }
}
