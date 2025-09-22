import { toNano } from "@ton/core";
import { Blockchain, SandboxContract, TreasuryContract } from "@ton/sandbox";
import "@ton/test-utils";
import { TactWallet, SendParameters } from "./output/sample_TactWallet";
import { inspect } from "util";
import { mnemonicNew, sign, mnemonicToWalletKey } from 'ton-crypto';

export async function send_ext_message(
  wallet: TactWallet, valid_until: bigint, params: SendParameters
) {

}