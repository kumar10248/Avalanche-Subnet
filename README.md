# Creating EVM subnet with Ava Labs

- Created my own (custom) Subnet using the Avalanche-Cli.

## Steps to Follow

- avalanche subnet create prinsusubnetubnet (chain ID : 10248) (Token Symbol : DEV)
- avalanche subnet deploy prinsusubnetubnet
- Importing the account & Copying the private key in the metamask.
- Adding the network through RPC URL and chain ID
- Interacting with the game using the REMIX IDE
- For Better Interaction i downloaded contracts folder from openzepellin

![Screenshot_20240829_163126](https://github.com/user-attachments/assets/c9a839a7-7749-4ac9-bc5a-17b66e0fd435)
![image](https://github.com/user-attachments/assets/c669358c-1185-4c2f-8639-b4108bcff1fa)
![image](https://github.com/user-attachments/assets/92bed31c-d023-4bbb-a6d8-3e2ed6b51be0)

I successfully created my own Avalanche subnet, named prinsusubnet, using Ubuntu. After setting it up, I deployed the subnet and obtained the account address along with some tokens. Next, I added the subnet to Metamask by entering the RPC URL, chain ID, and token name. I imported my funded account into Metamask and ensured it was selected as the active network. Then, I connected Remix to my Metamask wallet using the Injected Provider. This allowed me to deploy smart contracts directly onto my subnet. I successfully deployed one contract and began testing my application. Using Remix, I interacted with my deployed smart contracts and explored deploying tokens, pools, and other functionalities.

## Video Explanation of Project
https://www.loom.com/share/af2ba63c275e4ea297f0f67501d24ab9?sid=0381396a-434a-49c6-94aa-8811ec6b6b44


### ERC20.sol
This contract implements the ERC20 token standard. Key functions include:
- `decimals()`: Returns the number of decimals the token uses.
- `mintTokens(address owner, uint _amount)`: Mints `_amount` tokens to the `owner`.
- `totalSupply()`: Returns the total supply of the token.
- `balanceOf(address account)`: Returns the balance of the `account`.
- `transfer(address to, uint256 value)`: Transfers `value` tokens to the `to` address.
- `allowance(address owner, address spender)`: Returns the remaining number of tokens that `spender` is allowed to spend on behalf of `owner`.
- `approve(address spender, uint256 value)`: Approves `spender` to spend `value` tokens on behalf of the caller.

### Vault.sol
This contract interacts with the ERC20 token. Key functions include:
- `totalSupply`: Retrieves the total supply of the token.

### DefiUniversalGame.sol
This contract implements a lottery game. Key functions include:
- `pickWinner()`: Picks a winner from the list of players.
- `getPlayers()`: Returns the list of players.
- `timeLeft()`: Returns the time left for the lottery to end.

## Authors

Kumar Devashish

email - kumardevashish000@gmail.com

## License

This project is licensed under the MIT License.
```






```
