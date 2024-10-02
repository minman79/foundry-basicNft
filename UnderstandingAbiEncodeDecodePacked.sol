// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

// For the cheatsheet, check out the docs: https://docs.soliditylang.org/en/v0.8.13/cheatsheet.html?highlight=encodewithsignature

contract Encoding {
    function concaternateStrings() public pure returns (string memory) {
        return string(abi.encodePacked("Hi Mom! ", "Miss you!"));
    }

    // When we send a transaction, it is "compiled" down to bytecode and sent in a "data" object of the transaction.
    // That data object now governs how future transactions will interact with it.
    // For example: https://etherscan.io/tx/0x112133a0a74af775234c077c397c8b75850ceb61840b33b23ae06b753da40490

    // Now, in order to read and understand these bytes, you need a special reader.
    // This is supposed to be a new contract? How can you tell?
    // Let's compile this contract in hardhat or remix, and you'll see the the "bytecode" output - that's that will be sent when
    // creating a contract.

    // This bytecode represents exactly the low level computer instructions to make our contract happen.
    // These low level instructions are spread out into soemthing call opcodes.

    // An opcode is going to be 2 characters that represents some special instruction, and also optionally has an input

    // You can see a list of there here:
    // https://www.evm.codes/
    // Or here:
    // https://github.com/crytic/evm-opcodes

    // This opcode reader is sometimes abstractly called the EVM - or the ethereum virtual machine.
    // The EVM basically represents all the instructions a computer needs to be able to read.
    // Any language that can compile down to bytecode with these opcodes is considered EVM compatible
    // Which is why so many blockchains are able to do this - you just get them to be able to understand the EVM and presto! Solidity smart contracts work on those blockchains.

    // Now, just the binary can be hard to read, so why not press the `assembly` button? You'll get the binary translated into
    // the opcodes and inputs for us!
    // We aren't going to go much deeper into opcodes, but they are important to know to understand how to build more complex apps.

    // How does this relate back to what we are talking about?
    // Well let's look at this encoding stuff

    // In this function, we encode the number one to what it'll look like in binary
    // Or put another way, we ABI encode it.
    function encodeNumber() public pure returns (bytes memory) {
        bytes memory number = abi.encode(1);
        return number;
    }

    // You'd use this to make calls to contracts
    function encodeStringUnpacked() public pure returns (bytes memory) {
        bytes memory someStringUnpacked = abi.encode("Some String");
        return someStringUnpacked;
    }

    // https://forum.openzeppelin.com/t/difference-between-abi-encodepacked-string-and-bytes-string/11837
    // encodePacked
    // This is great if you want to save space, not good for calling functions.
    // You can sort of think of it as a compressor for the massive bytes object above.
    function encodeStringPacked() public pure returns (bytes memory) {
        bytes memory someStringPacked = abi.encodePacked("Some String");
        return someStringPacked;
    }

    // This is just type casting to string
    // It's slightly different from below, and they have different gas costs
    // This one is cheaper when encoding a single string only
    function encodeStringBytes() public pure returns (bytes memory) {
        bytes memory someStringBytes = bytes("Some String");
        return someStringBytes;
    }

    // decodes the unpacked string version only back into string
    function decodeString() public pure returns (string memory) {
        string memory decodedString = abi.decode(encodeStringUnpacked(), (string));
        return decodedString;
    }

    // Encoding multiple strings at once into bytes
    function multiEncodeStrings() public pure returns (bytes memory) {
        bytes memory multiEncodeTwoStrings = abi.encode("Some String", "More String");
        return multiEncodeTwoStrings;
    }

    // This is able to decode the multiEncodeStrings() into the original two strings
    function multiDecodeStrings() public pure returns (string memory, string memory) {
        (string memory stringOne, string memory stringTwo) = abi.decode(multiEncodeStrings(), (string, string));
        return (stringOne, stringTwo);
    }

    // This would return the packed version of the two strings without the padding
    function multiEncodePacked() public pure returns (bytes memory) {
        bytes memory encodedTwoString = abi.encodePacked("Some String", "Further More String");
        return encodedTwoString;
    }

    // We are not able to decode if we have multi packed two strings as the padding is gone
    function multiDecodePacked() public pure returns (string memory, string memory) {
        (string memory stringOne, string memory stringTwo) = abi.decode(multiEncodePacked(), (string, string));
        return (stringOne, stringTwo);
    }

    // BUT this would work as we are type casting it into string to return the string
    function multiStringCastPacked() public pure returns (string memory) {
        string memory someString = string(multiEncodePacked());
        return someString;
    }
}
