<template>
  <div id="app">
    <b-navbar>
      <template #brand>
        <b-navbar-item tag="router-link" :to="{ path: '/' }">
          <b>Evmos - PFP</b>
        </b-navbar-item>
      </template>

      <template #end>
        <b-navbar-item tag="div">
          <div
            v-if="account"
            style="font-size: 12px; text-align: right; padding-right: 15px"
          >
            {{ account.substr(0, 6) }}...{{ account.substr(-6) }}<br />
            {{ balance }} PHO
          </div>
          <div class="buttons">
            <a v-if="!account" v-on:click="connect" class="button is-primary">
              <strong>Connect</strong>
            </a>
            <a v-if="account" v-on:click="disconnect" class="button is-primary">
              <strong>Disconnect</strong>
            </a>
          </div>
        </b-navbar-item>
      </template>
    </b-navbar>
    <div v-if="!account" class="dapp">
      <h2 class="title is-size-4">You must add Evmos Testnet first</h2>
      <p>
        In order to interact with EVM you must add the network to your Metamask
        wallet.<br />If you already added it, just switch network and click
        connect button.
      </p>
      <br /><br />
      <b-button type="is-primary" v-on:click="switchNetwork()"
        >Switch to testnet</b-button
      >
    </div>
    <router-view v-if="account" :account="account" />
  </div>
</template>

<style>
#app,
html,
body {
  text-align: center;
  font-family: "IBM Plex Mono", monospace;
  background: #000 !important;
  color: #fff;
}
.title {
  color: #fff !important;
}
.button {
  font-family: "IBM Plex Mono", monospace;
}
.dapp {
  padding: 10vh 0;
}
.tab-item {
  padding: 5vh 0;
}
.field.has-addons {
  display: inline-block;
}
</style>


<script>
import Web3 from "web3";
export default {
  data() {
    return {
      selected_network: "",
      account: "",
      web3: "",
      balance: 0,
      signed: "",
    };
  },
  methods: {
    async connect() {
      const app = this;
      if (window.ethereum) {
        // Check if network is desired one
        app.selected_network = await app.web3.eth.net.getId();
        if (app.selected_network !== 9000) {
          alert("Wrong network!");
        } else {
          // Request accounts
          await window.ethereum.send("eth_requestAccounts");
          // Read accounts
          const accounts = await app.web3.eth.getAccounts();
          if (accounts[0] !== undefined) {
            app.account = accounts[0];
            // Take balance
            const balance = await app.web3.eth.getBalance(accounts[0]);
            app.balance = parseFloat(
              app.web3.utils.fromWei(balance, "ether")
            ).toFixed(10);
            localStorage.setItem("connected", app.account);
          }
        }
      } else {
        alert("Please install Metamask");
      }
    },
    async disconnect() {
      const app = this;
      localStorage.removeItem("connected");
      app.account = "";
      app.balance = 0;
      location.reload();
    },
    async switchNetwork() {
      await window.ethereum.request({
        method: "wallet_addEthereumChain",
        params: [
          {
            chainId: "0x2328",
            chainName: "Evmos Testnet",
            rpcUrls: ["https://evmos-node.ownlabs.dev"],
            nativeCurrency: {
              name: "Photon",
              symbol: "PHO",
              decimals: 18,
            },
            blockExplorerUrls: ["https://evm.evmos.org/"],
          },
        ],
      });
      location.reload();
    },
    async sign() {
      const app = this;
      const signed = await app.web3.eth.personal.sign("BUY-POS", app.account);
      console.log("Signed message: " + signed);
    },
  },
  async mounted() {
    const app = this;
    if (window.ethereum) {
      app.web3 = await new Web3(window.ethereum);
      const accounts = await app.web3.eth.getAccounts();
      if (accounts.length > 0) {
        if (accounts[0] === localStorage.getItem("connected")) {
          const balance = await app.web3.eth.getBalance(accounts[0]);
          app.account = accounts[0];
          app.balance = parseFloat(
            app.web3.utils.fromWei(balance, "ether")
          ).toFixed(10);
        }
      }
    }
  },
};
</script>