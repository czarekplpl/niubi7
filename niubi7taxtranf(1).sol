// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

    contract Niubi7 is IERC20 {
    string public constant name = "Niubi7";
    string public constant symbol = "NIUBI7";
    uint8 public constant decimals = 18;
    uint256 private _totalSupply = 690000000 * (10 ** uint256(decimals));

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address public owner;
    address public daoAddress;

    constructor(address _daoAddress) {
        require(_daoAddress != address(0), "Niubi7: DAO address cannot be the zero address");
        owner = msg.sender;
        daoAddress = _daoAddress;

        _balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        require(amount <= _totalSupply * 5 / 100, "Niubi7: Transfer amount exceeds the 5% total supply limit");
        _transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view override returns (uint256) {
    return _allowances[tokenOwner][spender];
    }  


    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        require(amount <= _totalSupply * 5 / 100, "Niubi7: Transfer amount exceeds the 5% total supply limit");
        _spendAllowance(from, msg.sender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "Niubi7: decreased allowance below zero");
        _approve(msg.sender, spender, currentAllowance - subtractedValue);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "Niubi7: transfer from the zero address");
        require(to != address(0), "Niubi7: transfer to the zero address");
        require(_balances[from] >= amount, "Niubi7: transfer amount exceeds balance");

        uint256 taxAmount = amount * 5 / 1000; // 0.5% of the amount
        uint256 amountAfterTax = amount - taxAmount;

        // Splitting the tax between the owner and the DAO
        uint256 splitTax = taxAmount / 2;
        _balances[owner] += splitTax;
        _balances[daoAddress] += splitTax;

        _balances[from] -= amount;
        _balances[to] += amountAfterTax;

        emit Transfer(from, owner, splitTax);
        emit Transfer(from, daoAddress, splitTax);
        emit Transfer(from, to, amountAfterTax);
    }

    function _approve(address tokenOwner, address spender, uint256 amount) internal {
    require(tokenOwner != address(0), "Niubi7: approve from the zero address");
    require(spender != address(0), "Niubi7: approve to the zero address");
    _allowances[tokenOwner][spender] = amount;
    emit Approval(tokenOwner, spender, amount);
    }


    function _spendAllowance(address tokenOwner, address spender, uint256 amount) internal {
    uint256 currentAllowance = _allowances[tokenOwner][spender];
    require(currentAllowance >= amount, "Niubi7: insufficient allowance");
    _approve(tokenOwner, spender, currentAllowance - amount);
    }

}
