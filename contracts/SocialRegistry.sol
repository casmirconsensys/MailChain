pragma solidity ^0.8.0;

contract SocialRegistry {
    struct social {
        string twitter;
        string instagram;
        string facebook;
        string tiktok;
        string youtube;
        string twitch;
        string snapchat;
        string linkedin;
        string reddit;
        string github;
        string discord;
        string telegram;
        string whatsapp;
    }
    
    mapping (uint => social) public socialRegistry;
    
    function registerSocial(
        string memory _twitter,
        string memory _instagram,
        string memory _facebook,
        string memory _tiktok,
        string memory _youtube,
        string memory _twitch,
        string memory _snapchat,
        string memory _linkedin,
        string memory _reddit,
        string memory _github,
        string memory _discord,
        string memory _telegram,
        string memory _whatsapp,
     
    ) public {
        uint id = socialRegistry.length + 1;
        socialRegistry[id] = social(_twitter, _instagram, _facebook, _tiktok, _youtube, _twitch, _snapchat, _linkedin, _reddit, _github, _discord, _telegram, _whatsapp,);
    }


}