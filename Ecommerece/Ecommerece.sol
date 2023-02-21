//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Ecommerce {
    struct Product {
        string title;
        string description;
        address payable seller;
        uint productID;
        uint price;
        address buyer;
        bool delivered;
    }
    Product[] public products;
    uint productID = 1;

    function registerProduct(
        string memory _title,
        string memory _desc,
        uint _price
    ) public {
        require(_price > 0, "Price must be greater than Zero");
        Product memory tempProduct;
        tempProduct.title = _title;
        tempProduct.description = _desc;
        tempProduct.seller = payable(msg.sender);
        tempProduct.productID = productID;
        tempProduct.price = _price * 1e18;
        productID++;
        products.push(tempProduct);
    }

    function buyProduct(uint _productID) public payable {
        require(
            products[_productID - 1].price == msg.value,
            "You have not enough balance"
        );
        require(
            products[_productID - 1].seller != msg.sender,
            "Seller cannot be buyer"
        );
        products[_productID - 1].buyer = msg.sender;
    }

    function delivery(uint _productID) public {
        require(
            products[_productID - 1].delivered == false,
            "Already Delivered"
        );
        require(
            products[_productID - 1].buyer == msg.sender,
            "Only Buyer Can Confirm it"
        );
        products[_productID - 1].delivered = true;
        products[_productID - 1].seller.transfer(products[productID - 1].price);
    }
}
