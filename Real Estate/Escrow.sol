// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;

interface IERC721 {
    function transferFrom(address from, address to, uint256 tokenId) external;
}

contract Escrow {
    address public seller;
    address public nftAddress;
    address public inspector;
    address public lender;

    constructor(
        address payable _seller,
        address _nftAddress,
        address _inspector,
        address _lender
    ) {
        seller = _seller;
        nftAddress = _nftAddress;
        inspector = _inspector;
        lender = _lender;
    }

    mapping(uint256 => bool) public isListed;
    mapping(uint256 => uint256) public purchasePrice;
    mapping(uint256 => address) public buyer;
    mapping(uint256 => uint256) public escrowAmount;
    mapping(uint256 => bool) public inspectorPassed;
    mapping(uint256 => mapping(address => bool)) public approvals;

    modifier onlySeller() {
        require(seller == msg.sender, "Only Seller Can Call this method");
        _;
    }

    modifier onlyBuyer(uint256 _nftID) {
        require(buyer[_nftID] == msg.sender, "Only Buyer Can Call this method");
        _;
    }

    modifier onlyInspector() {
        require(inspector == msg.sender, "Only Inspector Can Call this method");
        _;
    }

    function list(
        uint256 _nftID,
        address _buyer,
        uint256 _purchasePrice,
        uint256 _escrowAmount
    ) public payable onlySeller {
        IERC721(nftAddress).transferFrom(msg.sender, address(this), _nftID);

        isListed[_nftID] = true;
        purchasePrice[_nftID] = _purchasePrice;
        buyer[_nftID] = _buyer;
        escrowAmount[_nftID] = _escrowAmount;
    }

    function depositEarnest(uint256 _nftID) public payable onlyBuyer(_nftID) {
        require(msg.value <= escrowAmount[_nftID]);
    }

    function updateInspectionStatus(
        uint256 _nftID,
        bool _passed
    ) public onlyInspector {
        inspectorPassed[_nftID] = _passed;
    }

    function approveSale(uint256 _nftID) public {
        approvals[_nftID][msg.sender] = true;
    }

    function finalizeSale(uint256 _nftID) public {
        require(inspectorPassed[_nftID]);
        require(approvals[_nftID][buyer[_nftID]]);
        require(approvals[_nftID][seller]);
        require(approvals[_nftID][lender]);
        require(address(this).balance >= purchasePrice[_nftID]);

        isListed[_nftID] = false;

        (bool success, ) = payable(seller).call{value: address(this).balance}(
            ""
        );
        require(success);

        IERC721(nftAddress).transferFrom(address(this), buyer[_nftID], _nftID);
    }

    function cancelSale(uint256 _nftID) public {
        if (inspectorPassed[_nftID] == false) {
            payable(buyer[_nftID]).transfer(address(this).balance);
        } else {
            payable(seller).transfer(address(this).balance);
        }
    }

    receive() external payable {}

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
