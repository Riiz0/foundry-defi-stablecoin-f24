// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DecentralizedStableCoin} from "../src/DecentralizedStableCoin.sol";

contract DeployDecentralizedStableCoin is Script {
    function run() external returns (DecentralizedStableCoin) {
        address initialOwner = msg.sender;

        vm.startBroadcast();
        DecentralizedStableCoin decentralizedStableCoin = new DecentralizedStableCoin(
                initialOwner
            );
        vm.stopBroadcast();
        return decentralizedStableCoin;
    }
}
