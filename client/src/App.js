// import React, { Component } from "react";
// import GreeterContract from "./contracts/Greeter.json";
// import getWeb3 from "./utils/getWeb3";

// import "./App.css";
//  // eslint-disable-next-line
// class App extends Component {
//   state = { greeting: '', web3: null, accounts: null, contract: null };

//   componentDidMount = async () => {
//     try {
//       // Get network provider and web3 instance.
//       const web3 = await getWeb3();

//       // Use web3 to get the user's accounts.
//       const accounts = await web3.eth.getAccounts();

//       // Get the contract instance.
//       const networkId = await web3.eth.net.getId();
//       const deployedNetwork = GreeterContract.networks[networkId];
//       const instance = new web3.eth.Contract(
//         GreeterContract.abi,
//         deployedNetwork && deployedNetwork.address,
//       );

//       // Set web3, accounts, and contract to the state, and then proceed with an
//       // example of interacting with the contract's methods.
//       this.setState({ web3, accounts, contract: instance }, this.runExample);
//     } catch (error) {
//       // Catch any errors for any of the above operations.
//       alert(
//         `Failed to load web3, accounts, or contract. Check console for details.`,
//       );
//       console.error(error);
//     }
//   };

//   runExample = async () => {
//      // eslint-disable-next-line
//     const { accounts, contract } = this.state;
//     const response = await contract.methods.greet().call()

//     this.setState({ greeting: response });
//   };

//   handleGreetingChange = (e) => {
//     const inputVal = e.target.value
//     this.setState({ greeting: inputVal })
//   }

//   formSubmitHandler = async () => {
//     const { accounts, contract, greeting } = this.state;
//      // eslint-disable-next-line
//     const updatedGreeting = await contract.methods.setGreeting(greeting).send({from: accounts[0]});
//   }

//   render() {
//     if (!this.state.web3) {
//       return <div>Loading Web3, accounts, and contract...</div>;
//     }
//     return (
//       <div className="App">
//         <h1>Greeter</h1>

//         {this.state.greeting}

//         <form>
//           <label>
//             New Greeting:
//             <input type="text" value={this.state.greeting} onChange={e => this.handleGreetingChange(e)} />
//           </label>
//         </form>

//         <button onClick={this.formSubmitHandler}> Submit </button>

//       </div>
//     );
//   }
// }

// export default App;

import React, { useEffect, useState } from "react";
import Web3 from "web3";
import MetaCoinContract from "./contracts/MetaCoin.json"; // Assuming you have the JSON ABI of the MetaCoin contract

const App = () => {
  const [web3, setWeb3] = useState(null);
  const [accounts, setAccounts] = useState([]);
  const [metaCoinContract, setMetaCoinContract] = useState(null);
  const [receiverAddress, setReceiverAddress] = useState("");
  const [amountToSend, setAmountToSend] = useState(0);
  const [balance, setBalance] = useState(0);
  const accountIndex = 0;

  useEffect(() => {
    const initWeb3 = async () => {
      if (window.ethereum) {
        try {
          await window.ethereum.request({ method: "eth_requestAccounts" });
          const web3Instance = new Web3(window.ethereum);
          setWeb3(web3Instance);

          const networkId = await web3Instance.eth.net.getId();
          const deployedNetwork = MetaCoinContract.networks[networkId];
          const contractInstance = new web3Instance.eth.Contract(
            MetaCoinContract.abi,
            deployedNetwork && deployedNetwork.address
          );
          setMetaCoinContract(contractInstance);

          const accounts = await web3Instance.eth.getAccounts();
          setAccounts(accounts);
          const ethBalance = await web3Instance.eth.getBalance(accounts[accountIndex]);

          // const balance = await metaCoinContract.methods
          //   .getBalance(accounts[accountIndex])
          //   .call();
          setBalance(ethBalance);
        } catch (error) {
          console.error("Error while connecting to MetaMask:", error);
        }
      } else {
        console.error("Please install MetaMask to interact with this app.");
      }
    };
    initWeb3();
  }, []);

  const sendCoin = async () => {
    if (!web3 || !metaCoinContract) {
      console.error("Web3 or MetaCoin contract not initialized.");
      return;
    }

    try {
      await metaCoinContract.methods
        .sendCoin(receiverAddress, amountToSend)
        .send({ from: accounts[0] });
      console.log("Transaction successful!");
    } catch (error) {
      console.error("Error while sending coins:", error);
    }
  };

  return (
    <div>
      <h1>MetaCoin App</h1>
      {accounts.length > 0 && (
        <div>
          <p>Connected Account: {accounts[accountIndex]}</p>
          <p>current balance:{balance}</p>

          <input
            type="text"
            placeholder="Receiver Address"
            value={receiverAddress}
            onChange={(e) => setReceiverAddress(e.target.value)}
          />
          <input
            type="number"
            placeholder="Amount to Send"
            value={amountToSend}
            onChange={(e) => setAmountToSend(parseInt(e.target.value))}
          />
          <button onClick={sendCoin}>Send Coins</button>
        </div>
      )}
    </div>
  );
};

export default App;
