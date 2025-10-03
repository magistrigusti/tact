import { Address, beginCell, toNano } from "@ton/core";
import { storeRequestNftDeploy } from "./output/collection_NftCollection";
import { createOffchainContent } from "./helpers";

(async () => {
  let mnemonics = readFileSync("./secret.txt").toString().split(",");
  let pair = await mnemonicToWalletKey(mnemonics);
  let client4 = new TonClient4({endpoint: "https://sandbox-v4.tonhubapi.com"});
  let wallet = client4.open(WalletContractV4.create({workchain: 0, publicKey: pair.publicKey}));
  let collection = client4.open(NftCollection.fromAddress());
  await collection.send(wallet.sender(pair.secret))
})();

export function createNftDeployLink(
  collection: Address, owner: Address, amount: bigint, content: string, index: bigint
) {
  let message = createNftDeployMessage(owner, content, index);
  let link = `ton://transfer/${collection.toString()}?amount=${amount}&bin=${message.toBoc().toString('base64url')}`;
}


export function createNftDeployMessage(
  owner: Address, content: string, index: bigint, amount: bigint = toNano("0.03")
) {
  let message = beginCell()
    .store(storeRequestNftDeploy(
      {$$type: "RequestNftDeploy", index, amount, 
        content: createOffchainContent(content),
        owner
      }
    ))
};