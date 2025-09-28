import "@stdlib/ownable";
import "@stdlib/deploy";
import "./messages";

const min_balance: Int = ton("0.05");
const gas_consumption: Int = ton("0.02");

trait NftStandart {
  collection: Address;
  owner: Address;
  index: Int;
  content: Cell;

  receive(msg: NftTransfer) { 
    let ctx: Context = context();
    require(ctx.sender == self.owner, "Invalid Owner");
    let min: Int = min_balance - min(min_balance, myBalance());
    let required: Int = gas_consumption + msg.forward_amount + min;
    if (msg.forward_amount != 0) {
      required = required + ctx.readForwardFee();
    }
    require(ctx.value >= required, "Invalid Amount");
    let cashback: Int = ctx.value - gas_consumption - msg.forward_amount - min;
    if (msg.forward_amount != 0) {
      cashback = cashback - ctx.readForwardFee();
      send(SendParameters {
        to: msg.new_owner,
        value: msg.forward_amount,
        mode: SendPayGasSeparately,
        body: NftOwnershipAssigned {
          query_id: msg.query_id,
          prev_owner: self.owner,
          forward_payload: msg.forward_payload
        }.toCell()
      });
    }
    self.owner = msg.new_owner;
    if (cashback > 0) {
      send(SendParameters {
        to: msg.response_destination,
        value: cashback,
        body: NftExcesses {
          query_id: msg.query_id
        }.toCell()
      });
    }
  }
}

contract NftItem {
  collection: Address;
  owner: Address;
  index: Int as uint256;
  content: Cell;

  init(collection: Address, owner: Address, index: Int, content: Cell) {
    require(collection == sender(), "Invalid Sender");
    self.collection = collection;
    self.owner = owner;
    self.index = index;
    self.content = content;
  }
}