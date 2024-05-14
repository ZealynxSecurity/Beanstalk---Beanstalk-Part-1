# Beanstalk Codehawks


## </a>M-02. [M-2] Failure in Maintaining Gauge Points            

### Relevant GitHub Links
	
https://github.com/Cyfrin/2024-02-Beanstalk-1/blob/a3658861af8f5126224718af494d02352fbb3ea5/protocol/contracts/beanstalk/sun/GaugePointFacet.sol#L36-L57

## Summary
The defaultGaugePointFunction in the smart contract does not explicitly handle the scenario where the percentage of the Base Deposited Value (BDV) equals the optimal percentage (optimalPercentDepositedBdv), resulting in an unintended reduction of gauge points to 0 instead of maintaining their current value.

## Impact
This behavior can lead to an undesired decrease in incentives for contract participants, potentially affecting participation and reward accumulation within the contract's ecosystem. Users may lose gauge points and, consequently, rewards due to a technical flaw rather than their actions.

## Proof of Concept (PoC)
[TEST](https://github.com/ZealynxSecurity/Beanstalk---Beanstalk-Part-1/blob/main/protocol/test/foundry/sun/Lynx_GaugePointFacet.t.sol)

The testnew_GaugePointAdjustment() test demonstrated this flaw by providing inputs where currentGaugePoints = 1189, optimalPercentDepositedBdv = 64, and percentOfDepositedBdv = 64, expecting newGaugePoints to equal currentGaugePoints. However, the outcome was newGaugePoints = 0, indicating an unexpected reduction to zero.

```solidity
function testnew_GaugePointAdjustment() public {
    uint256 currentGaugePoints = 1189; 
    uint256 optimalPercentDepositedBdv = 64; 
    uint256 percentOfDepositedBdv = 64; 

    uint256 newGaugePoints = gaugePointFacet.defaultGaugePointFunction(
        currentGaugePoints,
        optimalPercentDepositedBdv,
        percentOfDepositedBdv
    );

    assertTrue(newGaugePoints <= MAX_GAUGE_POINTS, "New gauge points exceed the maximum allowed");
    assertEq(newGaugePoints, currentGaugePoints, "Gauge points adjustment does not match expected outcome");
}
````

## Recommendations
Implement Explicit Returns: Ensure the defaultGaugePointFunction has an explicit return for the case where gauge points should not be adjusted. This can be achieved by adding a final return statement that simply returns currentGaugePoints if neither condition for incrementing nor decrementing is met, as shown below:

```solidity
else {
    return currentGaugePoints; 
}
```


## Setup

Clone repo: 

```bash
git clone https://github.com/Cyfrin/2024-02-Beanstalk-1
```
Install dependencies: 
```bash
cd Beanstalk/protocol
yarn
```
Add RPC:
```bash
export FORKING_RPC=https://eth-mainnet.g.alchemy.com/v2/{RPC_KEY}
```

Build: 
```bash
npx hardhat compile
```
Test: 
```bash
npx hardhat test
```
