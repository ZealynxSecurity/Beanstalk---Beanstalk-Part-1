// SPDX-License-Identifier: MIT
pragma solidity >=0.7.6 <0.9.0;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../../contracts/beanstalk/sun/GaugePointFacet.sol";

contract GaugePointFacetTest is Test {
    GaugePointFacet gaugePointFacet;

    uint256 private constant ONE_POINT = 1e18;
    uint256 private constant MAX_GAUGE_POINTS = 1000e18;

    uint256 private constant UPPER_THRESHOLD = 10001;
    uint256 private constant LOWER_THRESHOLD = 9999;
    uint256 private constant THRESHOLD_PRECISION = 10000;
    function setUp() public {
        gaugePointFacet = new GaugePointFacet();
    }

    function testGaugePointAdjustment() public {
        uint256 currentGaugePoints = 500e18; 
        uint256 optimalPercentDepositedBdv = 50; 
        uint256 percentOfDepositedBdv = 49; 

        uint256 newGaugePoints = gaugePointFacet.defaultGaugePointFunction(
            currentGaugePoints,
            optimalPercentDepositedBdv,
            percentOfDepositedBdv
        );

        assertEq(newGaugePoints, currentGaugePoints + 1e18, "Gauge points should increment by 1 point");

        assertLt(newGaugePoints, MAX_GAUGE_POINTS, "Gauge points should not exceed maximum");

        assertTrue(newGaugePoints >= 0, "Gauge points should not be negative");
    }

    function testGaugePointAdjustmentFuzzing(
        uint256 currentGaugePoints,
        uint256 optimalPercentDepositedBdv,
        uint256 percentOfDepositedBdv
    ) public {
        currentGaugePoints = bound(currentGaugePoints, 0, MAX_GAUGE_POINTS);
        optimalPercentDepositedBdv = bound(optimalPercentDepositedBdv, 0, 100);
        percentOfDepositedBdv = bound(percentOfDepositedBdv, 0, 100);

        uint256 newGaugePoints = gaugePointFacet.defaultGaugePointFunction(
            currentGaugePoints,
            optimalPercentDepositedBdv,
            percentOfDepositedBdv
        );

        assertTrue(newGaugePoints <= MAX_GAUGE_POINTS, "New gauge points exceed the maximum allowed");
        assertTrue(newGaugePoints >= 0, "Gauge points should not be negative");

    }

//VULN
    function testGaugePointAdjustmentUnifiedFuzzing(
        uint256 currentGaugePoints,
        uint256 optimalPercentDepositedBdv,
        uint256 percentOfDepositedBdv
    ) public {
        currentGaugePoints = bound(currentGaugePoints, 1, MAX_GAUGE_POINTS - 1);
        optimalPercentDepositedBdv = bound(optimalPercentDepositedBdv, 1, 100);
        percentOfDepositedBdv = bound(percentOfDepositedBdv, 1, 100);

        uint256 expectedGaugePoints = currentGaugePoints;
        bool isWithinThreshold = (percentOfDepositedBdv * THRESHOLD_PRECISION >= optimalPercentDepositedBdv * LOWER_THRESHOLD) &&
                                (percentOfDepositedBdv * THRESHOLD_PRECISION <= optimalPercentDepositedBdv * UPPER_THRESHOLD);

        if (!isWithinThreshold) {
            if (percentOfDepositedBdv * THRESHOLD_PRECISION > optimalPercentDepositedBdv * UPPER_THRESHOLD) {
                expectedGaugePoints = currentGaugePoints > ONE_POINT ? currentGaugePoints - ONE_POINT : 0;
            } else if (percentOfDepositedBdv * THRESHOLD_PRECISION < optimalPercentDepositedBdv * LOWER_THRESHOLD) {
                expectedGaugePoints = currentGaugePoints + ONE_POINT <= MAX_GAUGE_POINTS ? currentGaugePoints + ONE_POINT : MAX_GAUGE_POINTS;
            }
        }

        uint256 newGaugePoints = gaugePointFacet.defaultGaugePointFunction(
            currentGaugePoints,
            optimalPercentDepositedBdv,
            percentOfDepositedBdv
        );

        assertTrue(newGaugePoints <= MAX_GAUGE_POINTS, "New gauge points exceed the maximum allowed");

        assertEq(newGaugePoints, expectedGaugePoints, "Gauge points adjustment does not match expected outcome");
    }


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



    function testGaugePointsDecrementFuzzing(
        uint256 currentGaugePoints,
        uint256 optimalPercentDepositedBdv
    ) public {
        uint256 percentOfDepositedBdv = ((optimalPercentDepositedBdv*(UPPER_THRESHOLD))/(THRESHOLD_PRECISION));

        currentGaugePoints = bound(currentGaugePoints, ONE_POINT, MAX_GAUGE_POINTS);
        optimalPercentDepositedBdv = bound(optimalPercentDepositedBdv, 0, 100);

        uint256 newGaugePoints = gaugePointFacet.defaultGaugePointFunction(
            currentGaugePoints,
            optimalPercentDepositedBdv,
            percentOfDepositedBdv
        );

        uint256 expectedGaugePoints = currentGaugePoints > ONE_POINT ? currentGaugePoints - ONE_POINT : 0;
        assertEq(newGaugePoints, expectedGaugePoints, "Gauge points should decrement correctly");
    }

    function testGaugePointsIncrementFuzzing(
        uint256 currentGaugePoints,
        uint256 optimalPercentDepositedBdv
    ) public {
        uint256 percentOfDepositedBdv =((optimalPercentDepositedBdv*(UPPER_THRESHOLD))/(THRESHOLD_PRECISION));

        currentGaugePoints = bound(currentGaugePoints, 0, MAX_GAUGE_POINTS - ONE_POINT);
        optimalPercentDepositedBdv = bound(optimalPercentDepositedBdv, 0, 100);

        uint256 newGaugePoints = gaugePointFacet.defaultGaugePointFunction(
            currentGaugePoints,
            optimalPercentDepositedBdv,
            percentOfDepositedBdv
        );

        uint256 expectedGaugePoints = currentGaugePoints + ONE_POINT;
        console.log("expectedGaugePoints",expectedGaugePoints);
        if (expectedGaugePoints > MAX_GAUGE_POINTS) expectedGaugePoints = MAX_GAUGE_POINTS;
        console.log("expectedGaugePoints2",expectedGaugePoints);
        assertEq(newGaugePoints, expectedGaugePoints, "Gauge points should increment correctly");
    }
}
