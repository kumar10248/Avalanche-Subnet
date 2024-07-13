// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    function mint(uint amount) external;
    function burn(uint amount) external;
    function pendingReward(address account) external view returns (uint);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Vault {
    IERC20 public immutable token;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    address[] public depositors; // Array to track depositors
    mapping(address => bool) public isDepositor; // To avoid duplicate entries in depositors array

    constructor(address _token) {
        token = IERC20(_token);
    }

    function _mint(address _to, uint _shares) private {
        if (!isDepositor[_to]) {
            isDepositor[_to] = true;
            depositors.push(_to);
        }
        totalSupply += _shares;
        balanceOf[_to] += _shares;
    }

    function _burn(address _from, uint _shares) private {
        totalSupply -= _shares;
        balanceOf[_from] -= _shares;
        if (balanceOf[_from] == 0) {
            isDepositor[_from] = false;
        }
    }

    function deposit(uint _amount) external {
        uint shares;
        if (totalSupply == 0) {
            shares = _amount;
        } else {
            shares = (_amount * totalSupply) / token.balanceOf(address(this));
        }

        _mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint _shares) external {
        uint amount = (_shares * token.balanceOf(address(this))) / totalSupply;
        _burn(msg.sender, _shares);
        token.transfer(msg.sender, amount);
    }

    function distributeRewards() external {
        uint reward = token.pendingReward(address(this));
        if (reward > 0) {
            token.mint(reward);
            uint totalBalance = token.balanceOf(address(this));
            for (uint i = 0; i < depositors.length; i++) {
                address account = depositors[i];
                if (balanceOf[account] > 0) {
                    uint share = (balanceOf[account] * reward) / totalBalance;
                    token.transfer(account, share);
                }
            }
        }
    }
}
