import { beginCell, toNano } from "@ton/core";
import { Blockchain } from "@ton/sandbox";
import "@ton/test-utils";
import { TokenWallet } from "./output/sample_TokenWallet";

import { inspect } from "util";

describe('contract', () => {
  it("should deploy correctly", async () => {
    const system = await Blockchain.create();
    const master = system.treasury('master');
    const owner1 = system.treasury('owner1');
    const owner2 = system.treasury('owner2');
    const owner1_wallet = system.openContract(
      await TokenWallet.fromInit(owner1.address, master.address)
    );
    const owner2_wallet = system.openContract(
      await TokenWallet.fromInit(owner2.address, master.address)
    );
    const tracker_1 = system.track(owner1_wallet);
    const tracker_2 = system.track(owner2_wallet);

    await owner1_wallet.send(master, 
      {value: toNano("0.05")},
      {$$type: 'InternalTransfer', 
        amount: toNano(100), query_id: 13n, 
        from: master.address,
        forward_ton_amount: 0n,
        forward_payload: beginCell().endCell(),
      }
    );
    await system.run();

    let event_1 = tracker_1.collect();
    console.log(inspect(event_1, true, null, true));
    let result_1 = await owner1_wallet.getGetWalletData();
    expect(result_1.balance).toEqual(toNano(100));
    expect(result_1.owner.equals(owner1.address)).toBeTruthy();
    expect(result_1.master.equals(master.address)).toBeTruthy();

    await owner1_wallet.send(owner1, 
      {value: toNano("1.0")},
      {$$type: 'Transfer', 
        query_id: 5n, 
        amount: toNano(20), 
        destination: owner2.address,
        responae_destination: owner1.address,
        owner1.address,
        custom_payload: beginCell().endCell(),
        forward_ton_amount: toNano(1),
        forward_payload: beginCell()
          .storeUint(0, 32)
          .storeStringTail("hello owner2")
          .endCell()
      }
    );
    await system.run();
    event_1 = tracker_1.collect();
    let event_2 = tracker_2.collect();

    result_1 = await owner1_wallet.getGetWalletData();
    expect(result_1.balance).toEqual(toNano(80));
    expect(result_1.owner.equals(owner1.address)).toBeTruthy();
    expect(result_1.master.equals(master.address)).toBeTruthy();

    result_2 = await owner2_wallet.getGetWalletData();
    expect(result_2.balance).toEqual(toNano(20));
    expect(result_2.owner.equals(owner2.address)).toBeTruthy();
    expect(result_2.master.equals(master.address)).toBeTruthy();
  });
});

// describe("contract", () => {
//   it("should deploy correctly", async () => {
//     const system = await Blockchain.create();
//     const owner = await system.treasury("owner");
//     const user1 = await system.treasury("user1");
//     const user2 = await system.treasury("user2");
//     const broadcast = system.openContract(await BroadcastContract.fromInit(owner.address, 0n));
//     await broadcast.send(owner, {value: toNano(1)}, {$$type: 'AddMessage', address: user1.address});
//     await broadcast.send(owner, {value: toNano(1)}, {$$type: "AddMessage", address: user2.address});
//     let tracker = system.track(broadcast.address);
//     await broadcast.send(owner, {value: toNano(5)}, {$$type: "BroadcastMesage", message: 'hi'});
//   })
// })


// import { toNano } from "@ton/core";
// import { Blockchain } from "@ton/sandbox";
// import "@ton/test-utils";
// import { SampleTactContract } from "./output/sample_SampleTactContract";

// describe("contract", () => {
//     it("should deploy correctly", async () => {
//         // Create Sandbox and deploy contract
//         const system = await Blockchain.create();
//         const owner = await system.treasury("owner");
//         const nonOwner = await system.treasury("non-owner");
//const contract = system.openContract(await SampleTactContract.fromInit(owner.address, 0n));
//         const deployResult = await contract.send(owner.getSender(), { value: toNano(1) }, null);
//         expect(deployResult.transactions).toHaveTransaction({
//             from: owner.address,
//             to: contract.address,
//             deploy: true,
//             success: true,
//         });
//         // Check counter
//         expect(await contract.getCounter()).toEqual(0n);

//         // Increment counter
//         await contract.send(owner.getSender(), { value: toNano(1) }, { $$type: "Increment" });

//         // Check counter
//         expect(await contract.getCounter()).toEqual(1n);

//         // Non-owner
//         const nonOwnerResult = await contract.send(nonOwner.getSender(), { value: toNano(1) }, { $$type: "Increment" });
//         const accessDeniedExitCode = 132;
//         expect(nonOwnerResult.transactions).toHaveTransaction({
//             from: nonOwner.address,
//             to: contract.address,
//             success: false,
//             exitCode: accessDeniedExitCode,
//         });
//     });
// });