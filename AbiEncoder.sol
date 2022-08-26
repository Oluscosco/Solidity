//SPDX-License-Identifier: Dee
pragma solidity ^0.8.7;
    
contract AbiDecode{
    struct MyAbiStruct{
        string name;
        uint[2] nums;
    }

    function encode(
        uint x,
        address addr,
        uint[] calldata arr,
        MyAbiStruct calldata myAbiStruct
    ) external pure returns (bytes memory) {
        return abi.encode(x, addr, arr, myAbiStruct);
    }

    function decode(bytes calldata data) 
        external pure 
        returns (
            uint x,
            address addr,
            uint[] memory arr,
            MyAbiStruct memory myAbiStruct
        ) 
    {
        (x, addr, arr, myAbiStruct) = abi.decode(data, (uint, address, uint[], MyAbiStruct));
    }
}
