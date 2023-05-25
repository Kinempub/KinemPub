// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20.sol";
import "./token.sol";
import "./helpers.sol";
contract Blog  {
    uint public supply;
    address owner;
    address elegible_contract;
    address[] admins;
    basepub token;
    SolidityHelper helpfunctions;
    // WordCounter countwords;
    uint public amount_per_word = 5;

    enum post_status{
        pending,
        approved,
        declined,
        removed
    }

    struct post{
        string postid;
        string category;
        address owner;
        uint id;
        post_status status;
    }
    mapping(uint => post) public posts;
    string[] public categories;
    uint public post_count = 0;
    constructor( address _reward_token_contract, address _helpfunctions) {
        owner = msg.sender;
        token = basepub(_reward_token_contract);
        admins.push(msg.sender);
        helpfunctions = SolidityHelper(_helpfunctions);
    }

    modifier isOwner{
        require(msg.sender == owner,"You are not authorized to perform this function");
        _;
    }
    modifier isAdmin{
        require(msg.sender == owner,"You are not authorized to perform this function");
        _;
    }

//Owner functions 
    function setAmountPerWord (uint _amount)public isOwner{
        amount_per_word = _amount;
    }

    function set_reward_tokens(address _reward_token_contract)public isOwner{
        token = basepub(_reward_token_contract);
    }
    function set_help_functions(address _helpfunctions)public isOwner{
        helpfunctions = SolidityHelper(_helpfunctions);
    }

    function removeAdmin(address _admin_address)public isOwner{
      require(helpfunctions.isAddressPresent(admins,_admin_address),"Address not present");
      uint addressIndex = helpfunctions.addressIndex(admins,_admin_address);
      delete admins[addressIndex];
    }
    function add_admin(address _admin_address) public isOwner{
        admins.push(_admin_address);
    }


//Admin functions
    function updatePost(uint _post_id,uint __count_words, post_status _status )public isAdmin{
        if(_status == post_status.approved && posts[_post_id].status != post_status.approved){
        token._mint_Token((__count_words *amount_per_word ),posts[_post_id].owner);
        }
        posts[_post_id].status = _status;
    }
    
    function add_category(string calldata _category_name)public isAdmin{
        categories.push(_category_name);
    }

    function deleteCategory(uint index)public isAdmin{
        delete categories[index];
    }

    function editCategory(uint index, string calldata _new_category)public isAdmin{
        categories[index] = _new_category;
    }

//users functions
    function write_post(string memory _postid,
            uint category
            )public{
            posts[post_count] = post({
                postid:_postid,
                category:categories[category],
                id:post_count,
                status:post_status.pending,
                owner:msg.sender
            });
            post_count++;
    }

    // function edit_post(string memory _title,
    //          string memory _description,
    //         string memory _img,uint id,uint _category)public{
    //             require(posts[id].id == id,"Post id is wrong");
    //             require(posts[id].owner == msg.sender,"You are not the owner of this post");
    //             require(posts[id].status == post_status.pending,"You cannot edit this post");
    //             posts[id].description = _description;
    //             posts[id].title = _title;
    //             posts[id].category = categories[_category];
    //             posts[id].img = _img;
    //         }

    function delete_post(uint id)public{
        require(posts[id].id == id,"Post id is wrong");
        require(posts[id].owner == msg.sender,"You are not the owner of this post");
        require(posts[id].status == post_status.pending,"You cannot delete this post");
        posts[id].status = post_status.removed;
    }


//View functions
    function get_all_admins()public view returns(address[] memory){
        return admins;
    }
    function get_all_categories()public view returns(string[] memory){
        return categories;
    }

    function get_all_posts()public view returns(post[] memory){
        post[] memory blog_posts = new post[](post_count);
        for(uint i = 0; i <post_count; i++){
            post memory item = posts[i];
            blog_posts[i] = item;
        }
        return blog_posts;
    }
    

}