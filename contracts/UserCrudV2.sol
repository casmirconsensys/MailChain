pragma solidity ^0.8.0;

/// advanced user crud
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract UserCrudV2 {

    struct UserStruct is AccessControl{
        uint userIndex;
        string userName;
        string userEmail;
        string userPassword;
        string userAddress;
        string userPhone;
        string userSocial;
        string userTechs;
        string userSneakers;
    }
    mapping(address => UserStruct) private userStructs;
    address[] private userIndex;

    event LogNewUser   (address indexed userAddress, uint index, string userName, string userEmail, string userPassword, string userAddress, string userPhone, string userSocial, string userTechs, string userSneakers);
    event LogUpdateUser(address indexed userAddress, uint index, string userName, string userEmail, string userPassword, string userAddress, string userPhone, string userSocial, string userTechs, string userSneakers);
    event LogDeleteUser(address indexed userAddress, uint index);

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
        string memory userName,
        string memory userEmail,
        string memory userPassword,
        string memory userPhone,
        string memory userSocial,
        string memory userTechs,
        string memory userSneakers)
        public
        returns(uint index)
    {
        if(isUser(userAddress)) revert();
        userStructs[userAddress].userIndex = userIndex.push(userAddress)-1;
        userStructs[userAddress].userName = userName;
        userStructs[userAddress].userEmail = userEmail;
        userStructs[userAddress].userPassword = userPassword;
        userStructs[userAddress].userPhone = userPhone;
        userStructs[userAddress].userSocial = userSocial;
        userStructs[userAddress].userTechs = userTechs;
        userStructs[userAddress].userSneakers = userSneakers;
        emit LogNewUser(
            userAddress,
            userStructs[userAddress].userIndex,
            userName,
            userEmail,
            userPassword,
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
            string memory userEmail,
            string memory userPassword,
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
            userStructs[userAddress].userPassword,
            userStructs[userAddress].userAddress,
            userStructs[userAddress].userPhone,
            userStructs[userAddress].userSocial,
            userStructs[userAddress].userTechs,
            userStructs[userAddress].userSneakers);
    }
    function deleteUser(address userAddress)
        public
        returns(uint index)
    {
        if(!isUser(userAddress)) revert();
        uint rowToDelete = userStructs[userAddress].userIndex;
        address keyToMove   = userIndex[userIndex.length-1];
        userIndex[rowToDelete] = keyToMove;
        userStructs[keyToMove].userIndex = rowToDelete;
        userIndex.pop();
        emit LogDeleteUser(
            userAddress,
            rowToDelete);
        emit LogUpdateUser(
            keyToMove,
            rowToDelete,
            userStructs[keyToMove].userName,
            userStructs[keyToMove].userEmail,
            userStructs[keyToMove].userPassword,
            userStructs[keyToMove].userAddress,
            userStructs[keyToMove].userPhone,
            userStructs[keyToMove].userSocial,
            userStructs[keyToMove].userTechs,
            userStructs[keyToMove].userSneakers);
        return rowToDelete;
    }
    function updateUserEmail(address userAddress, string memory userEmail)
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
            userStructs[userAddress].userPassword,
            userStructs[userAddress].userAddress,
            userStructs[userAddress].userPhone,
            userStructs[userAddress].userSocial,
            userStructs[userAddress].userTechs,
            userStructs[userAddress].userSneakers);
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
}