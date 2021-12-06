<template>
  <div class="tabs">
    <b-tabs v-model="activeTab" expanded :animated="false">
      <!-- Mint Tab -->
      <b-tab-item label="Mint">
        <h2 class="title is-size-4">Join the Evmos Ticket Sale</h2>
        <img src="/TICKET_EXAMPLE.png" width="350" />
        <h3>You own {{ balance }}/{{ totalSupply }} tickets!</h3>
        <br />
        <div v-if="totalSupply <= 10000">
          <b-button v-if="!pending" v-on:click="buy" type="is-primary"
            >Buy NFT for 0.0001 PHO</b-button
          >
          <div v-if="pending">
            Pending transaction hash is<br />{{ pending }}..
          </div>
        </div>
      </b-tab-item>
    </b-tabs>
  </div>
</template>

<script>
import Web3 from "web3";
const ABI = require("../abi.json");
const configs = require("../configs.json");
import { toSvg } from "jdenticon";

export default {
  props: ["account"],
  data() {
    return {
      activeTab: 0,
      web3: new Web3(window.ethereum),
      ABI: ABI,
      toSvg: toSvg,
      totalSupply: 0,
      pending: "",
      balance: 0,
    };
  },
  methods: {
    async buy() {
      const app = this;
      const contract = new app.web3.eth.Contract(
        app.ABI,
        configs.contract_address
      );
      try {
        await contract.methods
          .buyNFT(1)
          .send({
            from: app.account,
            value: app.web3.utils.toWei("0.0001", "ether"),
            gasLimit: 100000,
          })
          .on("transactionHash", (pending) => {
            app.pending = pending;
          });
        app.totalSupply = await contract.methods.totalSupply(1).call();
        app.balance = await contract.methods.balanceOf(app.account, 1).call();
        alert("You successfull bought an NFT!");
        app.pending = "";
      } catch (e) {
        alert(e.message);
      }
    },
  },
  async mounted() {
    const app = this;
    const contract = new app.web3.eth.Contract(
      app.ABI,
      configs.contract_address
    );
    app.totalSupply = await contract.methods.totalSupply(1).call();
    app.balance = await contract.methods.balanceOf(app.account, 1).call();
  },
};
</script>
<style>
svg {
  max-width: 100%;
}
</style>