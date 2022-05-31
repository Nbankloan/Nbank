![image](https://raw.githubusercontent.com/Nbanksolo/Nbank-front-end/main/Pictures/NBank.jpg)
## Overview

NBank is an ERC20 token bank that produces NFTs in batch while providing composable deposit certificates.

## How to use it?

1.Use the ERC20 token factory to create an token, and set basic information such as the token name, issuance quantity, token logo, and decimal places.  

2.Create a NFT bank: NFT bank name, the address of the staked governance token, the staking duration, and the generated NFT name;  

3.The NFT token mainly contains the following information: NFT number, NFT initial minter, NFT current holder, NFT lock-up time, NFT governance token name, NFT governance token quantity, lock-up start time, lock-up time End time, remaining days of lock-up, withdrawal button;  

4.Stake governance tokens to create NFT tokens: select the deposit amount and time to generate NFT tokens;  

5.In order to obtain liquidity during the staking period, NFT tokens can be mortgaged in the loan market, and then a certain amount of funds can be borrowed;  

6.The loan order contains the following information: loan tokens, loan amount, loan period, loan start time, estimated repayment time, remaining repayment days, loan interest rate, loan actual interest, repayment operation;  

7.In order to obtain liquidity during the mortgage period, NFT tokens can be transferred in the transfer market, and existing tokens can be directly sold;  

8.The transfer market order mainly includes the following information: order number, NFT number, NFT initial creator, NFT current holder, NFT creation time, NFT expiration time, unlocking reputation time, NFT transfer price, including the number of tokens, transfer procedures fee.  

9.Anyone can purchase the NFT in circulation through the transfer market, and obtain the token contained in the NFT. After the bank lock-up expires, the token can be withdrawn from the bank through the NFT lock-up token.

## BNB test smart chain contract address
- erc20Factory 0x508a8068Afb86AD772927917a62bc13787cbaF8C
- loanMarket 0x299cc9cB5151c3B2bD5826CeF8F98b4151267465
- NBank 0xee3b12acA7eCc34f900024e86B2b9a42d63AB329
- nbankFactory 0x1Aa203ee0C15b836E88BFe7c79BC209dA65E3202
- NBT 0x5D0577Fc873f6c82f57c4e177fe57B26cde6FC6e
- NDeposit721 0x5cA32386F3EB0aC1806De335d53f365ec252770F    
