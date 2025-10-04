import "@stdlib/ownable";
import "@stdlib/deploy";
import "./messages";
import "./util.fc";

const sale_init_value: Int = ton("0.1");
const sale_processing_value: Int = ton("0.25");
const jetton_transfer: Int = ton("0.05");
const nft_transfer_value: Int = ton("0.04");

const service_numerator: Int = 11;
const service_denominator: Int = 1000;
const hundred_percent: Int = 100000000000;

@name(service_address)
native serviceAddress(): Address;

contract SaleNft with Ownable {
  owner: Address;
  nft: Address;
  nft_received: Bool = false;
  jetton_master: Address;
  jetton_wallet: Address? = null;
  numerator: Int as uint16;
  denominator: Int as uint16;
  royalty_destination: Address?;
  sale_ended: Bool = false;
  price: Int;

  init(
    owner: Address, 
    nft: Address, 
    price: Int,
    jetton_master: Address,
    numerator: Int,
    denominator: Int,
    royalty_destination: Address?
    ) {
      self.owner = owner;
      self.nft = nft;
      self.jetton_master = jetton_master;
      self.royalty_destination = royalty_destination;
      self.numerator = numerator;
      self.denominator = denominator;
      if (self.royalty_destination == null || denominator == 0) {
        self.numerator = 0;
        self.denominator = 1;
      }
      send(SendParameters {
        to: self.jetton_master,
        value: 0,
        mode: SendRemainingValue,
        body: ProvideWalletAddress {
          query_id: now(),
          owner_address: myAddress(),
          include_address: true
        }.toCell()
      });
  }

  receive(msg: TakeWalletAddress) {
    let ctx: Content = content();
    require(ctx.sender == self.jetton_master, "Invalid sender");
    self.jetton_wallet = msg.wallet_address;
  }

  receive(msg: NftOwnershipAssigned) {
    let ctx: Context = context();
    if (ctx.sender != self.nft) {
      send(SendParameters {
        to: ctx.sender,
        value: 0,
        mode: SendRemainingValue,
        body: NftTransfer {
          query_id: msg.query_id,
          new_owner: msg.prev_owner,
          response_destination: msg.prev_owner,
          custom_payload: "Invalid Nft".asComment(),
          forward_amount: 0,
          forward_payload: emptySlice()
        }.toCell()
      });
    } else {
      self.nft_received = true;
    }
  }

  receive(msg: TransferNotification) {
    let ctx: Content = context();
    if (ctx.sender != self.jetton_wallet || self.nft_received == false || self.sale_ended) {
      send(SendParameters {
        to: ctx.sender,
        value
      })
    }
  }

  receive(msg: Deploy) {

  }
}