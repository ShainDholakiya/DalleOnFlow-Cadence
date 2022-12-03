import DalleOnFlow from "../contracts/DalleOnFlow.cdc"

transaction(isEnabled: Bool) {
    
    prepare(signer: AuthAccount) {
        let admin = signer.borrow<&DalleOnFlow.Admin>(from: DalleOnFlow.AdminStoragePath)!
        admin.changeMintingEnabled(isEnabled: isEnabled)
    }
}