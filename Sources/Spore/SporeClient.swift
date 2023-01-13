import Foundation

public typealias SporeResponseHandler = (SporeResponse) -> Void

public final class SporeClient {
    public var responseHandler: SporeResponseHandler?
    
    public init() {}
    
    private lazy var relayPool = {
        let pool = RelayPool()
        pool.delegate = self
        return pool
    }()
    
    public func addRelay(url: URL) throws {
        let relayConnection = RelayConnection(url: url)
        try relayPool.addRelay(relayConnection)
    }
    
    public func removeRelay(url: URL) throws {
        try relayPool.removeRelay(url: url)
    }    
    
    public func connect() {
        relayPool.connect()
    }
    
    public func disconnect() {
        relayPool.disconnect()
    }
    
    public func send(_ event: Event.SignedModel) {
        guard let isValid = try? event.isValid(), isValid else {
            print("Event is not valid. Check signature")
            return
        }
        
        let eventMessage = Message.Client.EventMessage(event: event)
        relayPool.send(clientMessage: eventMessage)
    }
    
    public func subscribe(_ subscription: Subscription) {
        let subscribeMessage = Message.Client.SubscribeMessage(subscription: subscription)
        relayPool.send(clientMessage: subscribeMessage)
    }
    
    public func unsubscribe(_ subscriptionId: SubscriptionId) {
        let unsubscribeMessage = Message.Client.UnsubscribeMessage(subscriptionId: subscriptionId)
        relayPool.send(clientMessage: unsubscribeMessage)
    }
 }

extension SporeClient: RelayPoolMessagingDelegate {
    
    public func relayPool(_ relayPool: RelayPool, didReceiveResponse response: SporeResponse) {
        responseHandler?(response)
    }
}
