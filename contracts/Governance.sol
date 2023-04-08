mapping(string => OrgData) public orgs;
mapping(string => bool) public orgTaken;
mapping(address => string) public artists;
mapping(address => bool) public governance;
mapping(address => bool) public initialGovernanceList;
 
 
 /** Governance functions **/

  /**
    @notice setMarketplacecontract allows the Governance to give a contract mint permissions
    @dev this is a protected function that only the Governance can call
    */
    function setMARKETPLACEcontract(address _contract) public override onlyGovernance() {
        marketplaceContract[MARKETPLACEcontract(_contract)] = true;
      }
    
      /**
        @notice createOrganization allows the Governance to create organizations
        @param _orgName is the name of the org being created
        @param _orgData is the orgs informational URI
        @param _address is the first Governance address of an org
        */
      function createOrganization(
        string memory _orgName,
        string memory _orgData,
        address _address
      ) external override onlyGovernance() notPaused() {
        require(!orgTaken[_orgName]);
        OrgData storage _org = orgs[_orgName];
        _org.orgDataURI = _orgData;
        _org.isMember[_address] = true;
        _org.orgGovernance[_address] = true;
        orgTaken[_orgName] = true;
        emit OrganizationCreated(_orgName, _orgData, _address);
      }
      
        /**
        @notice addIGovernance allows a initialGovernance address to add other addresses to the initialGovernance list
        @param _address is the address of the new initialGovernance
        */
      function addIGovernance(address _address)
        external
        override
        onlyIGovernance(_msgSender())
        notPaused()
      {
        initialGovernanceList[_address] = true;
      }
    
      /**
        @notice removeIGovernance allows a initialGovernance address to remove other addresses from the initialGovernance list
        @param _address is the address from the initialGovernance list being removed
        */
      function removeIGovernance(address _address)
        external
        override
        onlyIGovernance(_msgSender())
        notPaused()
      {
        initialGovernanceList[_address] = false;
      }
    
      /**
        @notice add Governance allows a governance address to add other addresses to the Governance list
        @param _address is the address of the new Governance
        */
      function addGovernance(address _address)
        external
        override
        onlyGovernance()
        notPaused()
      {
        governance[_address] = true;
        emit GovernanceAdded(_address);
      }
    
      /**
        @notice removeGovernance allows a governance address to remove other addresses from the Governance list
        @param _address is the address from the Governance list being removed
        */
      function removeGovernance(address _address)
        external
        override
        onlyGovernance()
        notPaused()
      {
        require(!initialGovernanceList[_address]);
        governance[_address] = false;
        emit GovernanceRemoved(_address);
      }
    
      /**Org Governance functions **/
    
      /**
        @notice addOrgGovernance allows an Org Governance to add another Governance address to an org
        @param _orgName is the name of the org
        @param _address is the address of the Governance
        */
      function addOrgGovernance(string memory _orgName, address _address)
        external
        override
        onlyOrgGovernance(_orgName)
        notPaused()
      {
        OrgData storage _org = orgs[_orgName];
        _org.orgGovernance[_address] = true;
        emit OrgGovernanceAdded(_orgName, _address);
      }
    
      /**
        @notice addArtistToOrg allows an Org Governance to add an artist to an organization
        @param _orgName is the name of the org
        @param _artistData is the URI for an artists data
        @param _address is the address of the artist being added
        */
      function addArtistToOrg(
        string memory _orgName,
        string memory _artistData,
        address _address
      ) external override onlyOrgGovernance(_orgName) notPaused() {
        OrgData storage _org = orgs[_orgName];
        _org.isMember[_address] = true;
        _org.memberData[_address] = _artistData;
        emit ArtistAdded(_address, _orgName, _artistData);
      }
    
      /**
        @notice removeOrgGovernance allows an Org Governance to remove an Org Governance address
        @param _orgName is the name of the org
        @param _address is the address of the Org Governance being removed
        */
      function removeOrgGovernance(string memory _orgName, address _address)
        external
        override
        onlyOrgGovernance(_orgName)
        notPaused()
      {
        OrgData storage _org = orgs[_orgName];
        _org.orgGovernance[_address] = false;
        emit OrgGovernanceRemoved(_orgName, _address);
      }
    
      /**
        @notice removeArtist allows an Org Governance to remove an artist
        @param _orgName is the name of the org
        @param _address is the address of the artist being removed
        */
      function removeArtist(string memory _orgName, address _address)
        external
        override
        onlyOrgGovernance(_orgName)
        notPaused()
      {
        OrgData storage _org = orgs[_orgName];
        _org.isMember[_address] = false;
        _org.memberData[_address] = " ";
        emit ArtistRemoved(_orgName, _address);
      }
    
      /**Artist functions **/
    
      /**
        @notice mint allows an artist to mint a new NFT
        @param _orgName is the name of the org
        @param _metadataUri is the new NFTs metadata URI
        @param _to is the address the NFT is being minted to
        @param _royaltyReceiver is the address of the royalty receiver
        @param _author is the author of the NFT
        @param _issues is the number of issues of an NFT to mint
        @param _royalty is the royalty percentage of a sale that is sent to the artist
        */