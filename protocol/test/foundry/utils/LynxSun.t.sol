// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;
pragma abicoder v2;

import "forge-std/Test.sol";
import {Utils} from "test/foundry/utils/Utils.sol";
// import {MockWell, MockBeanEthWell} from "path/to/MockWell.sol";


import { SeasonFacet } from "contracts/beanstalk/sun/SeasonFacet/SeasonFacet.sol";
import {OracleLibrary} from "@uniswap/v3-periphery/contracts/libraries/OracleLibrary.sol";
import "contracts/libraries/LibSafeMath32.sol";
import "contracts/libraries/LibPRBMath.sol";
import "contracts/libraries/Decimal.sol";
import {MockToken} from "contracts/mocks/MockToken.sol";

contract LynxSunTest is Test {
    SeasonFacet seasonFacet;
    MockToken bean;
    MockToken unripeBean;
    MockToken unripeLP;
    // MockWell well;
    address owner;
    address user;
    address user2;

    function setUp() public {
        owner = address(this); // En Foundry, address(this) es típicamente el dueño o el llamador
        user = makeAddr("user");
        user2 = makeAddr("user2");

        bean = new MockToken("Bean", "BEAN");
        unripeBean = new MockToken("Unripe Bean", "uBEAN");
        unripeLP = new MockToken("Unripe LP", "uLP");
        // well = new MockBeanEthWell();

        seasonFacet = new SeasonFacet();
        deal(address(bean), address(seasonFacet), 1 ether);
        vm.deal(owner, 1 ether); // Proporcionando ETH a la dirección simulada
        vm.deal(user, 1 ether);
        // Configuración adicional según sea necesario
    }

    // function testSeasonIncentive() public {

    //     vm.startPrank(user);
    //     bean.mint(user, 1 ether);
    //     bean.approve(address(seasonFacet), 1 ether);
    //     vm.stopPrank();

    //     vm.warp(block.timestamp + 3600); // Avanzar 1 hora
    //     // Llamada a la función sunrise
    //     vm.prank(owner);
    //     seasonFacet.sunrise{value: 1 ether}();

    //     // assertEq(bean.balanceOf(owner), expectedAmount, "Balance incorrecto despues de sunrise");
    // }

    // function testSunriseFuzzing(uint256 timeAdvance) public {
    //     vm.warp(block.timestamp + timeAdvance % 365 days); // Limita el avance de tiempo para evitar overflow

    //     // Prueba la llamada a sunrise y captura cualquier revertido
    //     (bool success,) = address(seasonFacet).call(abi.encodeWithSignature("sunrise()"));

    //     // Realiza aserciones basadas en el éxito o fracaso esperado
    //     assertTrue(success, "La llamada a sunrise deberia ser exitosa bajo estas condiciones.");
    // }

//     function testreSunriseFuzzing(uint256 warpSeconds) public {
//     // Configura el entorno inicial según sea necesario
//     // Por ejemplo, si necesitas mintear tokens antes de llamar a sunrise:
//     // C.bean().mint(address(this), 1 ether); // Asegúrate de que esta función sea ejecutable en el estado actual del contrato

//     // Simula el paso del tiempo si es necesario
//     vm.warp(block.timestamp + warpSeconds);

//     // Asume que se han cumplido todas las condiciones previas necesarias
//     // Intenta llamar a sunrise y captura la reversión si ocurre
//     bool success = address(seasonFacet).call{value: 1 ether}(abi.encodeWithSelector(seasonFacet.sunrise.selector));

//     // Verifica que la llamada haya sido exitosa
//     if (!success) {
//         emit log("La llamada a sunrise fue revertida. Verifica las condiciones previas y el estado del contrato.");
//     }
//     assertTrue(success, "La llamada a sunrise deberia ser exitosa bajo estas condiciones.");
// }
    
}
