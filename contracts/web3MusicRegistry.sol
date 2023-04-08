pragma solidity ^0.8.0;

contract MusicRegistry {
    struct music {
        string artist;
        string album;
        string song;
        string genre;
        string price;
        string provenance;
        string brandMetadata;
        string merchantAccount;
        string georegistry;
        string tokenizedIncentives;
        string eventReceiver;
        string accounts;
        string provenance;
        string Curated_Access;
    }
    
    mapping (uint => music) public musicRegistry;
    
    function registerMusic(
        string memory _artist,
        string memory _album,
        string memory _song,
        string memory _genre,
        string memory _price,
        string memory _provenance,
      
        string memory _merchantAccount,
        string memory _style,
        string memory _price,
        string memory _brandMetadata,
        string memory _georegistry,
        string memory _protocol,
        string memory _tokenizedIncentives,
        string memory _eventReceiver,
        string memory _accounts,
        string memory _provenance,
        string memory _Curated_Access,
    ) public {
        uint id = musicRegistry.length + 1;
        musicRegistry[id] = music(_artist, _album, _song, _genre, _price, _provenance, _merchantAccount, _style, _price, _brandMetadata, _merchantAccount, _georegistry,  _tokenizedIncentives, _eventReceiver, _accounts, _provenance, _Curated_Access,);
    }
}