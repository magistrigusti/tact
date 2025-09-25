import "@stdlib/ownable";
import "@stdlib/deploy";
import "./messages";

const gasConsumption: Int = ton("0.01");
const minTons: Int = ton("0.01");

struct WalletData {
    balance: Int;
    owner: Address;
    master: Address;
    code: Cell;
}

contract TokenWallet {
    balance: Int as coins = 0;
    owner: Address;
    master: Address;

    init(owner: Address, master: Address) {
        self.owner = owner;
        self.master = master;
    }

    receive(msg: Transfer) {
        let ctx: Context = context();
        require(self.owner == ctx.sender, "Invalid sender");
        self.balance = self.balance - msg.amount;
        require(self.balance >= 0, "Invalid token amount");
        require(
            ctx.readForwardFee() * 2 + 2 * gasConsumption 
            + minTons + msg.forward_ton_amount < ctx.value,
            "Invalid ton amount"
        );
        let to: Address = contractAddress(initOf TokenWallet(self.owner, self.master));
        send(SendParameters {
            to: to,
            value: 0,
            mode: SendRemainingValue,
            bounce: false,
            body: InternalTransfer{
                query_id: msg.query_id,
                amount: msg.amount,
                from: self.owner,
                response_destination: msg.response_destination,
                forward_ton_amount: msg.forward_ton_amount,
                forward_payload: msg.forward_payload
            }.toCell()
        });
    }

    get fun get_wallet_data(): WalletData {
        return WalletData{
            balance: self.balance, 
            owner: self.owner, 
            master: self.master, 
            code: (initOf TokenWallet(self.owner, self.master)).code
        };
    }
}