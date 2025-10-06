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

@name(muidiv)
native mulDiv(a: Int, b: Int, c: Int): Int;

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
      self.price = price;
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
    let sale_fee: Int = mulDiv(
      self.price,
      mulDiv(service_numerator, hundred_percent, service_denominator),
      hundred_percent
      );
    let royalty_fee: Int = mulDiv(
      self.price,
      mulDiv(self.numerator, hundred_percent, self.denominator),
      hundred_percent
    );
    let full_price = self.price + sale_fee + royalty_fee;
    if (ctx.sender != self.jetton_wallet 
      || self.nft_received == false 
      || self.sale_ended
      || ctx.value < sale_processing_value
      || msg.amount >= full_price
    ) {
      send(SendParameters {
        to: ctx.sender,
        value: 0,
        mode: SendRemainingValue,
        body: Transfer {
          query_id: msg.query_id,
          amount: msg.amount,
          destination: msg.sender,
          response_destination: msg.sender,
          custom_payload: "Error occured".asComment(),
          forward_ton_amount: 0,
          forward_payload: emptySlice()
        }.toCell();
      });
      self.send_jetton(
        ctx.sender, 0, 
        SendRemainingValue, 
        msg.query_id,
        msg.amount,
        msg.sender,
        "Error occured".asComment()
      );
      return;
    }

    if (msg.amount > full_price) {
      self.send_jetton(
        ctx.sender, 
        jetton_transfer_value, 0,
        SendRemainingValue,
        msg.query_id,
        msg.amount - full_price,
        msg.sender,
        "Error occured".asComment()
      );

      ctx.value = ctx.value - jetton_transfer_value;
    }

    self.send_jetton(
      ctx.sender,
      jetton_transfer_value, 0,
      SendRemainingValue,
      msg.query_id,
      sale_fee,
      serviceAddress(),
      msg.sender,
      emptyCell()
    );

    if (self.royalty_destination != null) {
      self.send_jetton(
      ctx.sender,
      jetton_transfer_value, 0
      msg.query_id,
      royalty_fee,
      self.destination!!,
      msg.sender,
      "Error occured".asComment(),
      );

      ctx.value = ctx.value - jetton_transfer_value;
    }

    self.send_jetton(
      ctx.sender,
      jetton_transfer_value, 0,
      msg.query_id,
      self.price, 
      self.owner,
      msg.sender,
      emptyCell()
    );
    send(SendParameters {
      to: self.nft,
      value: nft_transfer_value,
      body: NftTransfer {
        query_id: msg.query_id,
        new_owner: msg.sender,
        response_destination: msg.sender,
        custom_payload: "Nft received".asComment(),
        forward_amount: 0,
        forward_payload: emptySlice()
      }.toCell()
    })
  }

  receive(msg: Deploy) {

  }

  fun send_jetton(
    to: Address, value: Int, mode: Int, query_id: Int, amount: Int,
    destination: Address, response_destination: Address,
    custom_payload: Cell,
    ) {
      if (value > 0) {
        send(SendParameters {
          to: to,
          value: value,
          mode: mode,
          body: Transfer {
            query_id: query_id, 
            amount: amount,
            destination: destination,
            response_destination: response_destination,
            custom_payload: custom_payload,
            forward_ton_amount: 0,
            forward_payload: emptySlice()
          }.toCell()
        })
      }
  }
}