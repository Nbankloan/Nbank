// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.0;

import "../NBank/NBank.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract nbankFactory is Ownable{
  
    address public newBank;

    mapping(address => string) public bankName;
    mapping(address => uint) public userBank;
    mapping(address => uint) public createBankTime;

    constructor()  {

    }

    
    function creatBank(address manager,string memory _bankName) public returns(address){
        require(userBank[manager] != 1, "you has created!");
        address bank = address(new NBank(manager));
        newBank = bank;
        bankName[bank] = _bankName;
        userBank[manager] = 1;
        createBankTime[manager] = block.timestamp;
        return bank;
    }

    function addBlackList(address User) public onlyOwner(){
       userBank[User] = 1;
   }
    function removeBlackList(address User) public onlyOwner(){
        userBank[User] = 0;
    }
}