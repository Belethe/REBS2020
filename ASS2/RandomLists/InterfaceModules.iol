type InvoiceInfo: void {
    .product: string
    .price: int
    .location: string
}

type Sellers: void {
    sellers[1,*]: string // list of port strings. I think.
}

type StringList: void {
  str[0,*]:string
}

interface SellerPRInterface {
    RequestResponse:
        register(String)(string),
}

interface BuyerPRInterface {
    RequestResponse:
        getSellers(void)(StringList)
}

interface BuyerSellerInterface {
    OneWay:
        ask( string ),
        accept( string ),
        reject( string )
}

interface SellerShipperInterface {
    OneWay:
        order( InvoiceInfo )
}

interface ShipperBuyerInterface {
    OneWay:
        details( string )
}

interface SellerBuyerInterface {
    OneWay:
        quote( InvoiceInfo )
}
