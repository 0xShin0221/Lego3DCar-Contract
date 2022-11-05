// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./interfaces/IWhitelist.sol";
import "./interfaces/ILego3DNFTRender.sol";

contract Lego3DCar is ERC721Enumerable, ReentrancyGuard, Ownable {
    /**
    * @dev _baseTokenURI for computing {tokenURI}. If set, the resulting URI for each
    * token will be the concatenation of the `baseURI` and the `tokenId`.
    */
    string _baseTokenURI;

    // 3dNFT contract 
    ILego3DNFTRenderer public renderer;

    //  _price is the price of one  NFT
    uint256 public _price = 0.01 ether;

    // _paused is used to pause the contract in case of an emergency
    bool public _paused;

    // max number of Lego3DCar
    uint256 public maxTokenIds = 10000;

    // total number of tokenIds minted
    uint256 public tokenIds;

    // Whitelist contract instance
    IWhitelist whitelist;

    // boolean to keep track of whether presale started or not
    bool public presaleStarted;

    // timestamp for when presale would end
    uint256 public presaleEnded;

    modifier onlyWhenNotPaused {
        require(!_paused, "Contract currently paused");
        _;
    }

    /**
    * @dev ERC721 constructor takes in a `name` and a `symbol` to the token collection.
    * name in our case is `Lego3DCar` and symbol is `CD`.
    * Constructor for Lego3DCar takes in the baseURI to set _baseTokenURI for the collection.
    * It also initializes an instance of whitelist interface.
    */
    constructor (string memory baseURI, address whitelistContract) ERC721("Lego3DCar", "L3DCar") {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    /**
    * @dev startPresale starts a presale for the whitelisted addresses
    */
    function startPresale() public onlyOwner {
        presaleStarted = true;
        // Set presaleEnded time as current timestamp + 10 minutes
        // Solidity has cool syntax for timestamps (seconds, minutes, hours, days, years)
        presaleEnded = block.timestamp + 10 minutes;
    }

    /**
    * @dev presaleMint allows a user to mint one NFT per transaction during the presale.
    */
    function presaleMint() public payable onlyWhenNotPaused nonReentrant {
        require(presaleStarted && block.timestamp < presaleEnded, "Presale is not running");
        require(whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted");
        require(tokenIds < maxTokenIds, "Exceeded maximum Lego3DCar supply");
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds += 1;
        //_safeMint is a safer version of the _mint function as it ensures that
        // if the address being minted to is a contract, then it knows how to deal with ERC721 tokens
        // If the address being minted to is not a contract, it works the same way as _mint
        _safeMint(msg.sender, tokenIds);
    }

    function presaleStatus() public view returns (bool, uint256) {
        return (presaleStarted, presaleEnded);
    }
    /**
    * @dev mint allows a user to mint 1 NFT per transaction after the presale has ended.
    */
    function mint() public payable onlyWhenNotPaused nonReentrant {
        require(presaleStarted && block.timestamp >=  presaleEnded, "Presale has not ended yet");
        require(tokenIds < maxTokenIds, "Exceed maximum Lego3DCar supply");
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds += 1;
        _mint(msg.sender, tokenIds);
    }

    /**
    * @dev _baseURI overides the Openzeppelin's ERC721 implementation which by default
    * returned an empty string for the baseURI
    */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    /**
    * @dev setPaused makes the contract paused or unpaused
    */
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    /**
    * @dev withdraw sends all the ether in the contract
    * to the owner of the contract
    */
    function withdraw() public onlyOwner  {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) =  _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    /**
     * @dev setRender sets the render of the NFT
     */
    function setRenderer(address addr) public onlyOwner {
        renderer = ILego3DNFTRenderer(addr);
    }

    function resetRenderer(address addr) public onlyOwner {
        renderer = ILego3DNFTRenderer(address(0));
        renderer = ILego3DNFTRenderer(addr);
    }

    /**
     * @dev tokenURI renders the tokenURI for a given tokenId
    
     */
    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        return renderer.tokenURI(tokenId);
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
