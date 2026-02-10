// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

interface IERC721 {
    function balanceOf(address _owner) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);

    function approve(address _to, uint256 _tokenId) external;
    function getApproved(uint256 _tokenId) external view returns (address);

    function setApprovalForAll(address _operator, bool _approved) external;
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);

    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external;


    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
}

contract Token721_impl is IERC721 {

    string public name = "Token721I";
    string public symbol = "T7KI";

    // tokenId => owner
    mapping(uint256 => address) private _owners;

    // owner => number of NFTs owned
    mapping(address => uint256) private _balances;

    // tokenId => approved address
    mapping(uint256 => address) private _tokenApprovals;

    // owner => operator => approved?
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner {
        require(msg.sender==owner, "Unauthorised Access of Function!!");
        _;
    }

    function balanceOf(address _owner) public override  view returns(uint256) {
        require(_owner!=address(0), "Zero Address!!");
        return _balances[_owner];
    }

    function ownerOf(uint256 _tokenId) public override  view returns (address) {
        require(_owners[_tokenId]!=address(0), "Token doesn't exist!!");
        return _owners[_tokenId];
    }

    function approve(address to, uint256 tokenId) external override {
        address tokenOwner = ownerOf(tokenId);

        require(
            msg.sender == tokenOwner || isApprovedForAll(tokenOwner, msg.sender),
            "Not authorized!!"
        );

        _tokenApprovals[tokenId] = to;
        emit Approval(tokenOwner, to, tokenId);
    }

    function getApproved(uint256 tokenId) public view override returns (address) {
        require(_owners[tokenId] != address(0), "Token does not exist");
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) external override {
        require(operator != msg.sender, "Self approval not allowed");

        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address _owner, address _operator) public override view returns(bool) {
        return _operatorApprovals[_owner][_operator];
    }

    // helper fxn
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
        address tokenOwner = ownerOf(tokenId);
        return (
            spender == tokenOwner ||
            spender == getApproved(tokenId) ||
            isApprovedForAll(tokenOwner, spender)
        );
    }

    function transferFrom(address from, address to, uint256 tokenId) public override {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not authorized");
        require(ownerOf(tokenId) == from, "Not allowed!!");
        require(to != address(0), "Zero address");

        delete _tokenApprovals[tokenId];

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory data) private returns (bool) {
        if(to.code.length==0) {
            return true;
        }

        try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 returnVal) {
            return returnVal == IERC721Receiver.onERC721Received.selector;
        } catch {
            return false;
        }
    }


    function safeTransferFrom( address from, address to, uint256 tokenId, bytes memory data) public override {
    
        transferFrom(from, to, tokenId);

        require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override {
         safeTransferFrom(from, to, tokenId, "");
    }

    function mint(address to, uint256 tokenId) external onlyOwner {
        require(to != address(0), "Zero address");
        require(_owners[tokenId] == address(0), "Token already exists");

        _owners[tokenId] = to;
        _balances[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }
}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes memory data
    ) external returns (bytes4);
}