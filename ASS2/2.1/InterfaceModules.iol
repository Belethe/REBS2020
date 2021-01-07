
interface BuyerSellerInterface {
    OneWay:
	      ask( string ),
        accept( string ),
        reject( string )
}

interface SellerShipperInterface {
    OneWay:
        order( string )
}

interface ShipperBuyerInterface {
    OneWay:
        details( string)
}

interface SellerBuyerInterface {
    OneWay:
        quote( int)
}
