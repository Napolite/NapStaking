//SPDX-License-Identifier: MIT
pragma solidity >=0.8.1 ;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

interface IStake{
    function depositStake( uint amount) external;
    function withdrawStake(uint amount) external;

    function setDuration(uint duration) external;

    function getTimeLeft() external view returns(uint256);

    function calculateReward(uint amount) external;
    function withdrawReward(uint amount) external;

}

contract Staking{
    IERC20 public stakingToken;
    IERC20 public rewardsToken;

    uint public totalStakeSupply;
    uint public totalRewardsGenerated;
    
    uint public duration; // stake duration
    uint public rate; //stake rate

    mapping (address => uint) public stakeBalance;

    //modifiers

    //contract methods
    constructor(address _stakeToken, address _rewardsToken){
        stakingToken = IERC20(_stakeToken);
        rewardsToken = IERC20(_rewardsToken);
    }
}
