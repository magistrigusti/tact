import { toNano } from "@ton/core";
import { Blockchain } from "@ton/sandbox";
import "@ton/test-utils";
import { BroadcastContract } from "./output/sample_BroadcastContract";

describe("contract", () => {
  it("should deploy correctly", async () => {
    const system = await Blockchain.create();
    const owner = await system.treasury("owner");
    const user1 = await system.treasury("user1");
    const user2 = await system.treasury("user2");
    const broadcast = system.openContract(await BroadcastContract.fromInit(owner.address, 0n));
    await broadcast.send(owner, {value: toNano(1)}, {$$type: 'AddMessage', address: user1.address});
    await broadcast.send(owner, {value: toNano(1)}, {$$type: "AddMessage", address: user2.address});
    let tracker = system.track(broadcast.address);
    await broadcast.send(owner, {value: toNano(5)}, {$$type: "BroadcastMesage", message: 'hi'});
  })
})


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