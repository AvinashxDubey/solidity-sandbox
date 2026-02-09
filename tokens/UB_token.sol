// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address _account) external view returns (uint256);

    function transfer(address _to, uint256 _amount) external returns (bool);

    function allowance(address _owner, address _spender) external view returns (uint256);
    function approve(address _spender, uint256 _amount) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}


// self implemented fungible token
contract UB_token is IERC20{
    // metadata
    string public name = "UB_token";
    string public symbol = "UBT";
    uint8 public decimals = 18;

    uint256 public override totalSupply;
    address public owner;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender==owner, "Unauthorised Transaction!!");
        _;
    }

    // mandatory functions
    function balanceOf(address _account) public view override returns (uint256) {
        return balances[_account];
    }

    function allowance(address _owner, address _spender) public view override returns(uint256) {
        return allowances[_owner][_spender];
    }

    function transfer(address _to, uint256 _amount) public override returns (bool) {
        require(_to!=address(0), "Attempted transfer to Zero address");
        require(balances[msg.sender] >= _amount, "Insufficient Balance!!");

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function approve(address _spender, uint256 _amount) public override returns(bool) {
        require(_spender != address(0), "Zero address can't be the spender!!");
        allowances[msg.sender][_spender] = _amount;

        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _amount) public override returns (bool) {
        // here, msg.sender is the spender
        require(_from != address(0), "Transfer from zero address");
        require(_to != address(0), "Transfer to zero address");
        require(balances[_from]>=_amount, "Insufficient Balance!!");
        require(allowances[_from][msg.sender]>=_amount, "Insufficient  Allowance!!");

        allowances[_from][msg.sender]-=_amount;
        balances[_from]-=_amount;
        balances[_to]+=_amount;

        emit Transfer(_from, _to, _amount);
        return true;
    }

    // OWNER only functions
    function mint(address _to, uint256 _amount) public onlyOwner {
        require(_to!=address(0), "Attempt at minting to zero address!!");
        totalSupply+=_amount;
        balances[_to]+=_amount;

        emit Transfer(address(0), _to, _amount);
    }

    function burn(uint256 _amount) public {
        require(balances[msg.sender]>=_amount, "Insufficient Balance!!");
        
        totalSupply-=_amount;
        balances[msg.sender]-=_amount;
        
        emit Transfer(msg.sender, address(0), _amount);
    }
}