import { toNano } from "@ton/core";
import { Blockchain } from "@ton/sandbox";
import "@ton/test-utils";
import { AddressBook } from "./output/sample_AddressBook";
import { inspect } from "util";

describe("contract", () => {
    it("should deploy correctly", async () => {
        // Create Sandbox and deploy contract
        const system = await Blockchain.create();
        const owner = await system.treasury("owner");
        let someone = system.treasury("someone");
        let contract = system.open(await AddressBook.fromInit(owner.address));

        await contract.send(
            owner, 
            {value: toNano("0.1")},
            {$$type: 'AddUserMessage', name: "owner", address: owner.address}
        );      
        await contract.send(
            owner,
            {value: toNano("0.1")},
            {$$type: 'AddUserMesage', name: "someone", address: someone.address}
        );  
        await system.run();

        await contract.send(
            owner,
            {value: toNano("0.1")},
            {$$type: "ProxyMessage", message: "hello", to: "someone"}
        );
        await contract.send(
            someone,
            {value: toNano("0.1")},
            {$$type: "ProxyMessage", message: 'hello', to: "owner"}
        );
        await system.run();

        await contract.send(
            someone,
            {value: toNano('0.1')},
            "someone"
        );
        await system.run();

        expect(contract_tracker.collect()).toMatchSnapshot();
    });
});
