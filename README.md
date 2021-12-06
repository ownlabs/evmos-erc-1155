# Evmos - ERC721 PFP

This is a basic example of a PFP contract with an UI to interact with.

Folders are divided in:
- `contract`: which contains all contract files
- `ui`: which contains user interface

Contract is live here: https://pfp.ownlabs.dev and the contract can be accessed at `0xc2B38b330Aa27d7ff8dc7681946F7E9B972b1536`.

## Build the project

To build the project you first need to install `node` and `yarn`, then you can compile the contract and the ui.

### Compile the contract

To compile the contract you first need to setup a configuration file like the `contract/configs/example.json`, where you need to add some basic configurations.
Then you can run these commands:

```
cd contract
yarn
npm run build evmos
```

At the end of the process you will be able to run tests:

```
npm run test:mint evmos
```

### Build the UI

If you want to build the UI you need to run following commands:

```
cd ui
yarn
npm run build
```