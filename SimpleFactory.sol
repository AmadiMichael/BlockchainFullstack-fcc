// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public simpleStorage;


    function createSimpleStorageContract() public {
        simpleStorage.push(new SimpleStorage());
    }

    function sfStore(uint256 _index, uint256 _favoriteNumber) public {
        simpleStorage[_index].store(_favoriteNumber);
    }

    function sfRetrieve(uint256 _index) public view returns(uint256) {
        return simpleStorage[_index].retrieve();
    }

}
