type GetInvoiceInfo: void {
    .product: string
    .price: int
    .seller: string
}

interface BuyerSellerInterface {
    OneWay:
        ask( string ),
        accept( string ),
        reject( string )
}

interface SellerShipperInterface {
    OneWay:
        order( GetInvoiceInfo )
}

interface ShipperBuyerInterface {
    OneWay:
        details( string)
}

interface SellerBuyerInterface {
    OneWay:
        quote( int)
}
