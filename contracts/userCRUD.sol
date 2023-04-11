pragma solidity ^0.8.0;
//Basic implementation of a CRUD for a user
contract UserCrud {

    struct UserStruct {
        uint userIndex;
        string userName;
        bytes32 userEmail;
        string userAddress;
        string userPhone;
        string userSocial;
        string userTechs;
        string userSneakers;
    }
    mapping(address => UserStruct) private userStructs;
    address[] private userIndex;

    event LogNewUser   (address indexed userAddress, uint index, string userName, bytes32 userEmail, string userAddress, string userPhone, string userSocial, string userTechs, string userSneakers);
    event LogUpdateUser(address indexed userAddress, uint index, string userName, bytes32 userEmail, string userAddress, string userPhone, string userSocial, string userTechs, string userSneakers);

    function isUser(address userAddress)
        public
        view
        returns(bool isIndeed)
    {
        if(userIndex.length == 0) return false;
        return (userIndex[userStructs[userAddress].userIndex] == userAddress);
    }
    function insertUser(
        address userAddress,
        bytes32 userEmail,
        string memory userName,
        string memory userPhone,
        string memory userSocial,
        string memory userTechs,
        string memory userSneakers)
        public
        returns(uint index)
    {
        if(isUser(userAddress)) revert();
        userStructs[userAddress].userIndex = userIndex.push(userAddress)-1;
        userStructs[userAddress].userEmail = userEmail;
        userStructs[userAddress].userName = userName;
        userStructs[userAddress].userPhone = userPhone;
        userStructs[userAddress].userSocial = userSocial;
        userStructs[userAddress].userTechs = userTechs;
        userStructs[userAddress].userSneakers = userSneakers;
        emit LogNewUser(
            userAddress,
            userStructs[userAddress].userIndex,
            userName,
            userEmail,
            userAddress,
            userPhone,
            userSocial,
            userTechs,
            userSneakers);
        return userIndex.length-1;
    }
    function getUser(address userAddress)
        public
        view
        returns(
            uint index,
            string memory userName,
            bytes32 userEmail,
            string memory userAddress,
            string memory userPhone,
            string memory userSocial,
            string memory userTechs,
            string memory userSneakers)
    {
        if(!isUser(userAddress)) revert();
        return(
            userStructs[userAddress].userIndex,
            userStructs[userAddress].userName,
            userStructs[userAddress].userEmail,
            userStructs[userAddress].userAddress,
            userStructs[userAddress].userPhone,
            userStructs[userAddress].userSocial,
            userStructs[userAddress].userTechs,
            userStructs[userAddress].userSneakers);
    }
    /// Use MailChain to update user email via ENS
    function updateUserEmail(
        address userAddress,
        bytes32 userEmail)
        public
        returns(bool success)
    {
        if(!isUser(userAddress)) revert();
        userStructs[userAddress].userEmail = userEmail;
        emit LogUpdateUser(
            userAddress,
            userStructs[userAddress].userIndex,
            userStructs[userAddress].userName,
            userEmail,
            userStructs[userAddress].userAddress,
            userStructs[userAddress].userPhone,
            userStructs[userAddress].userSocial,
            userStructs[userAddress].userTechs,
            userStructs[userAddress].userSneakers);
        return true;
    }
    function updateUserPhone(
        address userAddress,
        string memory userPhone)
        public
        returns(bool success)
    {
        if(!isUser(userAddress)) revert();
        userStructs[userAddress].userPhone = userPhone;
        emit LogUpdateUser(
            userAddress,
            userStructs[userAddress].userIndex,
            userStructs[userAddress].userName,
            userStructs[userAddress].userEmail,
            userStructs[userAddress].userAddress,
            userPhone,
            userStructs[userAddress].userSocial,
            userStructs[userAddress].userTechs,
            userStructs[userAddress].userSneakers);
        return true;
    }   
    function updateUserSocial(
        address userAddress,
        string memory userSocial)
        public
        returns(bool success)
    {
        if(!isUser(userAddress)) revert();
        userStructs[userAddress].userSocial = userSocial;
        emit LogUpdateUser(
            userAddress,
            userStructs[userAddress].userIndex,
            userStructs[userAddress].userName,
            userStructs[userAddress].userEmail,
            userStructs[userAddress].userAddress,
            userStructs[userAddress].userPhone,
            userSocial,
            userStructs[userAddress].userTechs,
            userStructs[userAddress].userSneakers);
        return true;
    }
    function updateUserTechs(
        address userAddress,
        string memory userTechs)
        public
        returns(bool success)
    {
        if(!isUser(userAddress)) revert();
        userStructs[userAddress].userTechs = userTechs;
        emit LogUpdateUser(
            userAddress,
            userStructs[userAddress].userIndex,
            userStructs[userAddress].userName,
            userStructs[userAddress].userEmail,
            userStructs[userAddress].userAddress,
            userStructs[userAddress].userPhone,
            userStructs[userAddress].userSocial,
            userTechs,
            userStructs[userAddress].userSneakers);
        return true;
    }
    function updateUserSneakers(
        address userAddress,
        string memory userSneakers)
        public
        returns(bool success)
    {
        if(!isUser(userAddress)) revert();
        userStructs[userAddress].userSneakers = userSneakers;
        emit LogUpdateUser(
            userAddress,
            userStructs[userAddress].userIndex,
            userStructs[userAddress].userName,
            userStructs[userAddress].userEmail,
            userStructs[userAddress].userAddress,
            userStructs[userAddress].userPhone,
            userStructs[userAddress].userSocial,
            userStructs[userAddress].userTechs,
            userSneakers);
        return true;
    }
    function getUserCount()
        public
        view
        returns(uint count)
    {
        return userIndex.length;
    }
    function getUserAtIndex(uint index)
        public
        view
        returns(address userAddress)
    {
        return userIndex[index];
    
}