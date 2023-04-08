//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.6;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "./interfaces/IMARKETPLACE.sol";
import "./interfaces/MARKETPLACEcontract.sol";

contract MARKETPLACE is IMARKETPLACE, ERC1155SupplyUpgradeable {
  bool public override isPaused;

  mapping(uint256 => TokenMetadata) public metadata;
  mapping(MARKETPLACEcontract => bool) public marketplaceContract;
  mapping(uint256 => bool) public flaggedNFTS;

  uint256 private tokenCount;

  struct TokenMetadata {
    string metadataUri;
    string orgName;
    address author;
    address royaltyReceiver;
    uint24 royalty;
    bool splitPayable;
  }

  struct OrgData {
    string orgDataURI;
    mapping(address => bool) orgGovernance;
    mapping(address => bool) isMember;
    mapping(address => string) memberData;
  }

  string public name; 


  function initialize(address[] memory _addresses) public initializer {
    ERC1155Upgradeable.__ERC1155_init(
      "https://game.example/api/item/{id}.json"
    );
    ERC1155SupplyUpgradeable.__ERC1155Supply_init();
    for (uint256 i = 0; i < _addresses.length; i++) {
      initialGovernanceList[_addresses[i]] = true;
      governance[_addresses[i]] = true;
      emit GovernanceAdded(_addresses[i]);
    }
  }

  /**Modifier functions **/

  modifier onlyGovernance() {
    require(governance[_msgSender()]);
    _;
  }

  modifier onlyIGovernance(address _address) {
    require(initialGovernanceList[_address]);
    _;
  }

  modifier onlyOrgGovernance(string memory _orgName) {
    OrgData storage _org = orgs[_orgName];
    require(_org.orgGovernance[_msgSender()] || governance[_msgSender()]);
    _;
  }

  modifier onlyArtist(string memory _orgName) {
    require(hasAuthorization(_msgSender(), _orgName));
    _;
  }

  modifier notPaused() {
    require(!isPaused);
    _;
  }

 
  function mint(
    string memory _orgName,
    string memory _metadataUri,
    address _to,
    address _royaltyReceiver,
    address _author,
    uint256 _issues,
    uint24 _royalty,
    bool _splitPayable
  )
    external
    override
    onlyArtist(_orgName)
    notPaused()
    returns (uint256 tokenId_)
  {
    require(_royalty <= 200000);

    tokenId_ = ++tokenCount;

    _mint(_to, tokenId_, _issues, "");

    TokenMetadata storage _metadata = metadata[tokenId_];

    _metadata.metadataUri = _metadataUri;
    _metadata.orgName = _orgName;
    _metadata.author = _author;
    _metadata.royalty = _royalty;
    _metadata.royaltyReceiver = _royaltyReceiver;
    _metadata.splitPayable = _splitPayable;

    flaggedNFTS[tokenId_] = false;

    emit Mint(
      tokenId_,
      _metadata.author,
      _to,
      _metadata.royaltyReceiver,
      _metadata.royalty,
      _issues,
      _metadata.metadataUri,
     _metadata.splitPayable
    );

    emit MintOrg(tokenId_, _orgName);
  }

  /**
    @notice updateMetadata allows an artist to edit an NFT's metadata URI
    @param _tokenId is the NFT's token ID
    @param _metadataUri is the new metadata URI
    @param _royaltyReceiver is the address of the royalty receiver
    @param _royalty is the royalty percentage of a sale that is sent to the artist
    */
  function updateMetadata(
    uint256 _tokenId,
    string memory _metadataUri,
    address _royaltyReceiver,
    uint24 _royalty
  ) external override notPaused() {
    TokenMetadata storage _metadata = metadata[_tokenId];
    require(hasAuthorization(_msgSender(), _metadata.orgName));
    require(_royalty <= 200000);
    _metadata.metadataUri = _metadataUri;
    _metadata.royaltyReceiver = _royaltyReceiver;
    _metadata.royalty = _royalty;

    emit MetadataUpdate(
      _tokenId,
      _msgSender(),
      _metadataUri,
      _royaltyReceiver,
      _royalty
    );
  }

  /** view functions **/

  /**
    @notice Called with the sale price to determine how much royalty
              is owed and to whom.
    @param _tokenId - the NFT asset queried for royalty information
    @param _value - the sale price of the NFT asset specified by _tokenId
    @return _receiver - address of who should be sent the royalty payment
    @return _royaltyAmount - the royalty payment amount for _value sale price
    @dev percentages should be set as parts per million 1000000 == 100% and 100000 == 10%
    */
  function royaltyInfo(
    uint256 _tokenId,
    uint256 _value
  )
    external
    view
    override
    returns (
      address _receiver,
      uint256 _royaltyAmount
    )
  {
    TokenMetadata storage _metadata = metadata[_tokenId];
    uint256 royaltyP = _metadata.royalty;
    _royaltyAmount = ((_value * royaltyP) / 1000000);
    _receiver = _metadata.royaltyReceiver;
  }

  /**
    @notice isIGov returns a bool representing whether or not an address in included in initialGovernance list
    @param _address is the address in question
    */
  function isIGovernance(address _address)
    public
    view
    override
    returns (bool)
  {
    return initialGovernanceList[_address];
  }

  /**
    @notice hasAuthorization returns a bool representing whether or not an address has mint permissions
    @param _address is the address in question
    @param _orgName is the name of the org in question
    */
  function hasAuthorization(address _address, string memory _orgName)
    public
    view
    override
    returns (bool)
  {
    OrgData storage _org = orgs[_orgName];
    if (_org.isMember[_address]) {
      return true;
    } else if (marketplaceContract[MARKETPLACEcontract(_address)]) {
      return true;
    } else if (_org.orgGovernance[_address]) {
      return true;
    } else if (governance[_address]) {
      return true;
    } else {
      return false;
    }
  }

  /**
        @notice triggerPause allows one of the initial Governance to pause or unpause the functions
                of the Marketplace contract
    */
  function triggerPause() external override onlyIGovernance(_msgSender()) {
    if (isPaused) {
      isPaused = false;
    } else {
      isPaused = true;
    }
  }

  /**
    @notice unlockPlatform is a proxy function that allows an initial Governance
            to unlock and Marketplace cointract to NFT's from outside the Marketplace platform
    @param _marketplaceContract is the address of the contract being unlocked
    */
  function unlockPlatform(address _marketplaceContract) external onlyIGovernance(_msgSender()) {
    require(marketplaceContract[MARKETPLACEcontract(_marketplaceContract)]);
    MARKETPLACEcontract marketplaceCon = MARKETPLACEcontract(_marketplaceContract);
    marketplaceCon.unlockPlatform();
  }

  /**
   * @dev Gets the base token URI
   * @return string representing the base token URI
   */
  function baseTokenURI() public pure returns (string memory) {
    return "https://marketplace-production.mypinata.cloud/ipfs/";
  }

  function uri(uint256 _tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    TokenMetadata storage _metadata = metadata[_tokenId];

    string memory result =
      string(abi.encodePacked(baseTokenURI(), _metadata.metadataUri));
    return result;
  }

  function setName(string memory _name) external {
    name = _name;
  }
  
}