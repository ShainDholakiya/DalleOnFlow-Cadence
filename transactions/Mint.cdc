import DalleOnFlow from "../contracts/DalleOnFlow.cdc"
import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import FlowToken from "../contracts/FlowToken.cdc"

transaction(description: String, thumbnailCID: String, metadata: {String: String}, price: UFix64) {
    let FlowTokenVault: &FlowToken.Vault
    let CollectionPublic: Capability<&DalleOnFlow.Collection{DalleOnFlow.CollectionPublic}>
    let Admin: &DalleOnFlow.Admin
    
    prepare(signer: AuthAccount, dofSigner: AuthAccount) {
        self.FlowTokenVault = signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)!

        self.Admin = dofSigner.borrow<&DalleOnFlow.Admin>(from: DalleOnFlow.AdminStoragePath)!
            
        var collectionPubCap = signer.getCapability<&DalleOnFlow.Collection{DalleOnFlow.CollectionPublic}>(DalleOnFlow.CollectionPublicPath)
                
        if !collectionPubCap.check() {
            signer.save(<- DalleOnFlow.createEmptyCollection(), to: DalleOnFlow.CollectionStoragePath)
            signer.link<&DalleOnFlow.Collection{DalleOnFlow.CollectionPublic}>(DalleOnFlow.CollectionPublicPath, target: DalleOnFlow.CollectionStoragePath)
        }
            
        self.CollectionPublic = collectionPubCap
    }
            
    execute { 
        let payment <- self.FlowTokenVault.withdraw(amount: price) as! @FlowToken.Vault
        self.Admin.mintNFT(description: description, thumbnailCID: thumbnailCID, metadata: metadata, recepient: self.CollectionPublic, payment: <- payment)
    }
}