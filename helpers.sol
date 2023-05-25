// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract SolidityHelper {
    function countWords(string calldata sentence) external pure returns (uint) {
        bytes memory sentencebyts = bytes(sentence) ;
        uint count = 0;
        for (uint i = 0; i < sentencebyts.length; i++) {
            if(i != (sentencebyts.length -1)){
                if (sentencebyts[i] == 0x20 || sentencebyts[i] == 0x0A || sentencebyts[i] == 0x0D || sentencebyts[i] == 0x09) {
                        if (sentencebyts[i-1] != 0x20 && sentencebyts[i-1] != 0x0A && sentencebyts[i-1] != 0x0D && sentencebyts[i-1] != 0x09) {
                            count++;
                        }  
                }
            }else{
                if (sentencebyts[i] != 0x20 && sentencebyts[i] != 0x0A && sentencebyts[i] != 0x0D && sentencebyts[i] != 0x09) {
                    count++;
                }
            }
        }   
        return count;
    }

    function isAddressPresent(address[] memory addressArray,address addressToCheck)external pure returns(bool){
        for(uint i=0; i < addressArray.length; i++){
            if(addressToCheck == addressArray[i]){
                return true;
            }
        }
        return false;
    }

    function addressIndex(address[] memory addressArray,address addressToCheck)external pure returns(uint){
        for(uint i=0; i < addressArray.length; i++){
            if(addressToCheck == addressArray[i]){
                return i;
            }
        }
        revert("Address not found") ;
    }
}
