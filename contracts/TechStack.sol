pragma Solidity ^0.8.0;\

contract Techs{
    string [] myTechs;

    function addTech(string memory _tech) public {
        myTechs.push(_tech);
    }
    function updateTechs(uint techIndex, string memory _tech) public returns (bool) {
       if(myTechs.length > techIndex){
           myTechs[techIndex] = _tech;
            return true;
       }
         return false;
    }
    function deleteTech(uint techIndex) public returns (bool) {
        if(myTechs.length > techIndex){
           for(myTechs.length > techIndex; myTechs.length - 1; techIndex++){
               myTechs[techIndex] = myTechs[techIndex + 1];
           }
           myTechs.pop();
           return true;
        }
      return false;
    }
    function getTechs() public view returns (string [] memory) {
        return myTechs;
    }
}