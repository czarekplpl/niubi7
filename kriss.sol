// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title SimplePrivateToken
 * @dev Bardzo prosty token ERC-20 bez dodatkowych funkcji i opłat.
 * Podaż całkowita wynosi 1,000,000 tokenów.
 */
contract SimplePrivateToken is ERC20 {
    // Ustawienie początkowej podaży na 1 milion tokenów. Pamiętaj, że ERC-20 używa najmniejszych jednostek,
    // więc jeśli chcesz, aby Twój token miał dziesięciny, musisz dodać dodatkowe zera.
    // Na przykład, dla tokena z 18 miejscami po przecinku, 1 milion tokenów to 1e6 * 1e18.
    uint256 public constant INITIAL_SUPPLY = 1e6 * 1e18;

    /**
     * @dev Konstruktor, który dystrybuuje całą początkową podaż tokenów do twórcy kontraktu.
     */
    constructor() ERC20("SimplePrivateToken", "SPT") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }
}