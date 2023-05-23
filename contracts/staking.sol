//SPDX-License-Identifier: MIT
pragma solidity >=0.8.1 ;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

interface IStake{
    function depositStake( uint amount) external;
    function withdrawStake(uint amount) external;

    function setDuration(uint duration) external;

    function getTimeLeft() external view returns(uint256);

    function calculateReward(uint amount) external;
    function withdrawReward(uint amount) external;

}

contract Staking{
    using SafeMath for uint256;
    using SafeMath for uint;
    IERC20 public stakingToken;
    IERC20 public rewardsToken;

    uint public totalStake;
    uint public totalStakeRewards;
    
    uint public duration; // stake duration
    uint public finishAt;
    uint public updatedAt;

    uint public rate; //stake rate

    mapping (address => mapping(string => uint256)) public _balance;
    mapping (address => uint) private _rewardsWithdrawals;
    mapping (address => uint) private accBeforeUpdate;

    //modifiers


    // contract methods
    constructor(address _stakeToken, address _rewardsToken){
        stakingToken = IERC20(_stakeToken);
        rewardsToken = IERC20(_rewardsToken);
    }

    function depositStake (uint amount) external {
        require(stakingToken.balanceOf(msg.sender) >= amount, "Not enough tokens for stake");
        require(stakingToken.transferFrom(msg.sender, address(this), amount),"Failed to stake token");
        
        _balance[msg.sender]["amount"] = _balance[msg.sender]["amount"].add(amount);
        if (_balance[msg.sender]["updatedAt"] == 0) {
        _balance[msg.sender]["updatedAt"]= block.timestamp;
        }else{
            accBeforeUpdate[msg.sender] += earned();
            _balance[msg.sender]["updatedAt"]= block.timestamp;
        }
        totalStake = totalStake.add(amount);
    }
    function balance() external view returns (uint256){
        return _balance[msg.sender]["amount"];
    }

    function setDuration(uint256 _duration) external{
        require(finishAt < block.timestamp, "can't set date to a previous timestamp");

        duration = _duration;
        finishAt = _duration.add(block.timestamp);
        updatedAt = block.timestamp;
    }

    function getDuration() view external returns(uint256){
        return duration;
    }

    function setRewardRate(uint256 _rate) external{
        require(finishAt < block.timestamp, "Staking still in progress");

        rate = _rate;
    }

    function earned() view public returns(uint256){
        require(_balance[msg.sender]["amount"] > 0, "You have not staked any tokens");

        return (_balance[msg.sender]["amount"] * (rate/100) * (block.timestamp - _balance[msg.sender]["updatedAt"])) + accBeforeUpdate[msg.sender];
    }

    function withdrawReward(uint256 _amount) external{
        require(earned() > 0 && _amount > 0, "You have not earned any rewards");
        require(earned() - _rewardsWithdrawals[msg.sender] < _amount, "You don't have enough to withdraw");
        require(rewardsToken.transfer(msg.sender, _amount), "Failed to transfer tokens");
        _rewardsWithdrawals[msg.sender] += _amount;
    }
 
    
}
