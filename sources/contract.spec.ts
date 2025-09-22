import { toNano } from "@ton/core";
import { Blockchain, SandboxContract, TreasuryContract } from "@ton/sandbox";
import "@ton/test-utils";
import { TactWallet, SendParameters } from "./output/sample_TactWallet";
import { inspect } from "util";
import { mnemonicNew, sign, mnemonicToWalletKey } from 'ton-crypto';

describe("contract", () => {
    it("should deploy correctly", async () => {
        let blockchain = await Blockchain.create();
        let creator = blockchain.treasury("creator");
        let mnemonics = await mnemonicNew();
        let pair = await mnemonicToWalletKey(mnemonics);
        let wallet = blockchain.openContract(
            await TactWallet.fromInit(BigInt('0x' + pair.publicKey.toString("hex")))
        );
        await wallet.send((await creator).getSender(), {value: toNano(0.1)}, "Hello");
        await blockchain.run(); // This line is causing the error. The 'run' method does not exist on the 'Blockchain' type.
        expect(await wallet.getGetPublicKey()).toEqual(
            BigInt('0x' + pair.publicKey.toString("hex"))
        );
        expect(await wallet.getSeqno()).toEqual(0n);
    });
});