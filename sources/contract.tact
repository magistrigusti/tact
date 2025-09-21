import "@stdlib/ownable";
import "@stdlib/deploy";

contract TactWallet {
    seqno: Int as uint32 = 0;
    publicKey: Int as uint256;

    init (publicKey: Int) {
        self.publicKey = publicKey;
    }

    receive() {}
    receive(str: String) {}
    receive(slice: Slice) {}

    external() {
        
    }

    get fun seqno(): Int {
        return self.seqno;
    }

    get fun get_public_key(): Int {
        return self.publicKey;
    }
}