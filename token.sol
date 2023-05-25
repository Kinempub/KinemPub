// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20.sol";

contract basepub is ERC20 {
    uint public supply;
    address owner;
    address elegible_contract;
    constructor(uint256 initialSupply) ERC20("basepub", "basepub") {
        _mint(msg.sender, initialSupply * 10 ** 18);
        supply = initialSupply;
        owner = msg.sender;
    }

    modifier isOwner{
        require(msg.sender == owner,"You are not authorized to perform this function");
        _;
    }
    function setElegibleContract(address _contract_Address) isOwner public{
        elegible_contract = _contract_Address;
    }

    function _mint_Token(uint _amount, address _receiver) external{
        require(msg.sender == elegible_contract,"This contract is not authorized");
         _mint(_receiver, _amount * 10 ** 18);
         supply += _amount; 
    }
}