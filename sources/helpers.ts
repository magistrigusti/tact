import { Address, beginCell, Cell, toNano } from "@ton/core";
import { Blockchain, SandboxContract, TreasuryContract } from "@ton/sandbox";
import "@ton/test-utils";
import { TactWallet, SendParameters, storeSendParameters, ExtMessage } from "./output/sample_TactWallet";
import { inspect } from "util";
import { mnemonicNew, sign, mnemonicToWalletKey } from 'ton-crypto';

export function fill_send_parameters(
  to: Address, value: bigint, body: Cell, 
  mode: bigint = 1n,
  bounce: boolean = true,
  code: Cell | null = null,
  data: Cell | null = null,
) {
  return {$$type: "SendParameters", to, value, body, mode, bounce, code, data}
}

export async function send_ext_message(
  wallet: any, secretKey: Buffer, valid_until: bigint, params: SendParameters
) {
  let parameters_b = beginCell();
  storeSendParameters(params)(parameters_b);

  let seqno = await wallet.getSeqno();
  let hash = beginCell()
    .storeUint(seqno, 32)
    .storeUint(valid_until, 32)
    .storeRef(parameters_b.endCell())
    .endCell().hash();

  wallet.sendExternal({
    $$type: 'ExtMessage', signature: sign(hash, secretKey), 
    seqno, valid_until, 
    params: params
  });
}