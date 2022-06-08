// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.14;

import {ERC721, ERC721TokenReceiver} from "solmate/tokens/ERC721.sol";
import {Strings} from "openzeppelin-contracts/utils/Strings.sol";
import {PullPayment} from "openzeppelin-contracts/security/PullPayment.sol";
import {Ownable} from "openzeppelin-contracts/access/Ownable.sol";

import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {Address} from "openzeppelin-contracts/utils/Address.sol";
import {Utilities} from "./Utilities.sol";

contract SolmateNFT is ERC721, PullPayment, Ownable {
    using Strings for uint256;
    string public baseURI;
    uint256 public currentTokenId;
    uint256 public constant TOTAL_SUPPLY = 10_000;
    uint256 public constant MINT_PRICE = 0.08 ether;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI
    ) ERC721(_name, _symbol) {
        baseURI = _baseURI;
    }

    function mintTo(address recipient) public payable returns (uint256) {
        require(
            msg.value == MINT_PRICE,
            "Transaction value did not equal the mint price"
        );
        uint256 newTokenId = ++currentTokenId;
        require(newTokenId <= TOTAL_SUPPLY, "Max supply reached");
        _safeMint(recipient, newTokenId);
        return newTokenId;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        // mapping(uint256 => address) internal _ownerOf;
        // mapping(address => uint256) internal _balanceOf;
        // function ownerOf(uint256 id) public view virtual returns (address owner) {
        //     require((owner = _ownerOf[id]) != address(0), "NOT_MINTED");
        // }

        require(
            (ownerOf(tokenId) != address(0)),
            "ERC721Metadata: URI query for nonexistent token"
        );

        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
                : "";
    }

    /// @dev Overridden in order to make it an onlyOwner function
    function withdrawPayments(address payable payee) public override onlyOwner {
        super.withdrawPayments(payee);
    }
}
