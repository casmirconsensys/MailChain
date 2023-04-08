// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract sneakerRegistry {

    struct sneaker {
        string brand;
        string style;
        string colorway;
        string size;
        string condition;
        string provenance;
        string price;
        string shippingAddress;
        string merchantAccount;
        string cart;
        string placeOrder;
        string style;
        string price;
        string brandMetadata;
        string shippingAddress;
        string merchantAccount;
        string placeOrder;
        string acceptOrder;
        string georegistry;
        string protocol;
        string tokenizedIncentives;
        string boilerplate;
        string eventReceiver;
        string accounts;
        string provenance;
        string Curated_Access;
    }
    
    mapping (uint => sneaker) public sneakerRegistry;
    
    function registerSneaker(
        string memory _brand,
        string memory _style,
        string memory _colorway,
        string memory _size,
        string memory _condition,
        string memory _provenance,
        string memory _price,
        string memory _shippingAddress,
        string memory _merchantAccount,
        string memory _cart,
        string memory _placeOrder,
        string memory _style,
        string memory _price,
        string memory _brandMetadata,
        string memory _shippingAddress,
        string memory _merchantAccount,
        string memory _placeOrder,
        string memory _acceptOrder,
        string memory _georegistry,
        string memory _protocol,
        string memory _tokenizedIncentives,
        string memory _boilerplate,
        string memory _eventReceiver,
        string memory _accounts,
        string memory _provenance,
        string memory _Curated_Access
    ) public {
        uint id = uint(keccak256(abi.encodePacked(_brand, _style, _colorway, _size, _condition, _provenance, _price, _shippingAddress, _merchantAccount, _cart, _placeOrder, _style, _price, _brandMetadata, _shippingAddress, _merchantAccount, _placeOrder, _acceptOrder, _georegistry, _protocol, _tokenizedIncentives, _boilerplate, _eventReceiver, _accounts, _provenance, _Curated_Access)));
        sneakerRegistry[id] = sneaker(_brand, _style, _colorway, _size, _condition, _provenance, _price, _shippingAddress, _merchant
}
