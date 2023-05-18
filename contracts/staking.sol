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
    uint public totalRewardsPaid;
    
    uint public duration; // stake duration
    uint public rate; //stake rate

    mapping (address => uint) public _balance;

    //modifiers

    //contract methods
    constructor(address _stakeToken, address _rewardsToken){
        stakingToken = IERC20(_stakeToken);
        rewardsToken = IERC20(_rewardsToken);
    }

    function depositStake (uint amount) external {
        require(stakingToken.balanceOf(msg.sender) >= amount, "Not enough tokens for stake");
        require(stakingToken.transferFrom(msg.sender, address(this), amount),"Failed to stake token");

        _balance[msg.sender] = _balance[msg.sender].add(amount);
        totalStake = totalStake.add(amount);
    }
    function balance() external view returns (uint256){
        return _balance[msg.sender];
    }

    // function setDuration(uint duration) public
 
    
}
