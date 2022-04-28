// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "../interface/token721/INDeposit721.sol";
import "../library/TransferHelper.sol";

contract LoanMarket {

    struct LoanRecording{
        uint tokenId;
        uint id;
        uint amount;
        uint money;
        uint day;
        uint dayRate;
        uint interest;
        uint contango;
        uint status;
        uint expireTime;
        address owner;
        address lender;
    }
    
    LoanRecording[] public list;
    INDeposit721  deposit;

    address to;
    address public admin;
    address token;
    address agent;
    

    event MortgageMarket(uint  tokenId,uint amount ,uint day ,uint dayRate);
    event Repayment(uint indexed id,uint indexed value);
    event RepealMortgage(uint indexed id);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin(){
        require(admin == msg.sender ,"not admin");
        _;

    }
    //initialize
    function initialize(address _agent,address _deposits,address _token) public onlyAdmin {
        agent=_agent;
        deposit=INDeposit721(_deposits);
        token=_token;
    }


    //Mortgage voucher market
    function mortgageMarket(uint tokenId,uint amount ,uint day ,uint dayRate)public{
        require(deposit.ownerOf(tokenId) == msg.sender);
        uint _expireTime = block.timestamp+(day*86400);
        uint interest = amount*(dayRate*day);
        uint mortgageAmount = deposit.amount(tokenId);
        uint contango = dayRate*2;
        uint id=list.length+1;
        LoanRecording memory record = LoanRecording({
             tokenId:tokenId,
             id:id,
             amount:mortgageAmount,
             money:amount,
             day:day,
             dayRate:dayRate,
             interest:interest,
             contango:contango,
             status:0,
             expireTime:_expireTime,
             owner:deposit.ownerOf(tokenId),
             lender:address(0)
         });
         list.push(record);
        //The lender hands over the deposit token to a third-party intermediary
        deposit.safeTransferFrom(msg.sender,agent, tokenId);
        emit MortgageMarket(tokenId,amount,day,dayRate);
    }

    //Revoke the mortgage certificate on the market
    function repealMortgage(uint id)public{
        require(msg.sender==list[id-1].owner&&list[id-1].status==0,"The current user has no permissions");
        //Third-party intermediary return will return the token to the lender
        deposit.safeTransferFrom(agent,msg.sender, list[id-1].tokenId);
        //Delete the record in list
        delete list[id-1];
        emit RepealMortgage(id);
    }


    function lend(uint id,uint value)public{
        require(list[id-1].money==value,'Incorrect bid');
        TransferHelper.safeTransferFrom(token,msg.sender,list[id-1].owner,value);
        list[id-1].status=1;
        list[id-1].lender=msg.sender;
    }
    
      function lengthToken() public view  returns (uint tokenLength){
        tokenLength = list.length;
    }


    function repayment(uint id,uint value) public {
        require(value != 0 , "value error");
        require(msg.sender != address(0),"not 0 address");
        if( block.timestamp <= list[id-1].expireTime){
            uint usedDay = (list[id-1].day - (list[id-1].expireTime - block.timestamp)/86400);
            require(value >= list[id-1].money + list[id-1].money*(list[id-1].dayRate/100)*usedDay ,"value is error");
            TransferHelper.safeTransferFrom(token,msg.sender,list[id-1].lender ,list[id-1].money+list[id-1].money*(list[id-1].dayRate/100)*usedDay);
            deposit.safeTransferFrom(agent, msg.sender, list[id-1].tokenId);
        }else if ((block.timestamp - list[id-1].expireTime)/86400 <= 3){
            uint amount = list[id-1].money+list[id-1].interest+(block.timestamp - list[id-1].expireTime)/86400*list[id-1].contango/100;
            require(value == amount);
            TransferHelper.safeTransferFrom(token,msg.sender, list[id-1].lender, amount);
            deposit.safeTransferFrom(agent, msg.sender, list[id-1].tokenId);
        }else if ((block.timestamp - list[id-1].expireTime)/86400 > 3){
            deposit.safeTransferFrom(agent, list[id-1].lender, list[id-1].tokenId);
        }
        emit  Repayment(id,value);
    }
}