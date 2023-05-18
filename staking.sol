//SPDX-License-Identifier: MIT
pragma solidity >=0.8.1 ;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

interface IStake{
        function depositStake( uint amount) external;
}

contract Staking{
    IERC20 public stakingToken;
    IERC20 public rewardsToken;


    constructor(address _stakeToken, address _rewardsToken){
        stakingToken = IERC20(_stakeToken);
        rewardsToken = IERC20(_rewardsToken);
    }
}
