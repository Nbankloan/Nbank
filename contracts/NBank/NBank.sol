// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interface/token721/INDeposit721.sol";
import "../library/TransferHelper.sol";



contract NBank{
    INDeposit721 deposit;
    //Recording the last bank balance There is a lack of a way to get bank balances here
    uint private reserve;
    address public token20;
    address manager;
    uint amount;

    mapping(address => bool) public allowToken;
    
    event DepositToken(address to , uint indexed month ,uint indexed value);
    event Withdrawa(address indexed to,uint indexed tokenId);

    constructor(address _manager) {
        manager = _manager;

    }

    modifier onlyAdmin(){
        require(msg.sender == manager, "u are not manager");
        _;
    }
    
    function initialize(address token , address _deposits)  public {
        token20 = token;
        deposit = INDeposit721(_deposits);
    }
    
    function depositToken(
        address to,
        uint month,
        uint value,
        string memory url
        )external {
        require(month==0||month==3||month==6||month==12||month==24||month==36,"Deposit month error");
        IERC20(token20).transferFrom(to,address(this), value);
        deposit.mint(to, value, month ,url);
        uint balance = IERC20(token20).balanceOf(address(this));
        amount = balance-reserve;
        reserve = balance;
        emit DepositToken(to, month, value);
    }
    
    function withdrawa(address to,uint tokenId) external {
        uint32 blockTime = uint32(block.timestamp % 2 ** 32);
        uint value=amount;
        require(blockTime>=deposit.expire(tokenId),'unable to extract');
        TransferHelper.safeTransfer(token20, to, value);
        deposit.burn(tokenId);
        uint balance=IERC20(token20).balanceOf(address(this));
        reserve =balance ;       
        emit Withdrawa(to,tokenId);
    }
}