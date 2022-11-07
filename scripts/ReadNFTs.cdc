import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import DalleOnFlow from "../contracts/DalleOnFlow.cdc"
    
pub fun main(account: Address): [&DalleOnFlow.NFT?] {
    let collection = getAccount(account).getCapability(DalleOnFlow.CollectionPublicPath)
                        .borrow<&DalleOnFlow.Collection{DalleOnFlow.CollectionPublic}>()
                        ?? panic("Can't get the User's collection.")
    let answer: [&DalleOnFlow.NFT?] = []

    let ids = collection.getIDs()
    for id in ids {
        let resolver = collection.borrowDalleOnFlowNFT(id: id)
        answer.append(resolver)
    }

    return answer
}