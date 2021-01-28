include "InterfaceModules.iol"

include "console.iol"

service BuyerService {

  execution{ single }

  outputPort BuyerPR {
       location: "socket://localhost:8037"
       protocol: http { format = "json" }
       interfaces: BuyerPRInterface
  }
    outputPort BuyerSeller {
        // Dynamic location.
        protocol: http { format = "json" }
        interfaces: BuyerSellerInterface
  }
  inputPort SellerBuyer {
        location: "socket://localhost:8005"
        protocol: http { format = "json" }
        interfaces: SellerBuyerInterface
  }
  inputPort ShipperBuyer {
        location: "socket://localhost:8001"
        protocol: http { format = "json" }
        interfaces: ShipperBuyerInterface
  }
  main {
    getSellers@BuyerPR()(sellers)

    for ( seller in sellers.str){
      println@Console("A seller:'" + seller+"'")()
    }

    for( seller in sellers.str ) { // ask all sellers.
        //println@Console("Asking: " + seller)()
        BuyerSeller.location = seller
        //println@Console("Location is: '"+BuyerSeller.location+"'")()
        ask@BuyerSeller("chips")
        //println@Console("Asked: " + seller)()
    }

    quote(quote)
    best << quote // first quote is just saved
    println@Console("INFO:"+quote+" and "+quote.price + " and "+ quote.location +".")()
    println@Console("INFO:"+best+" and "+best.price + " and "+ best.location +".")()
    for (i = 1, i < #sellers.str, i++ ){
      quote(quote) // get another quote
      if(quote.price < best.price){
        // reject old best, save new.
        BuyerSeller.location = best.location
        reject@BuyerSeller("Not ok to buy chips for " + best.price);
        println@Console("Rejected "+best.price+" from "+best.location+", now considering "+quote.price+" from "+quote.location+".")()
        best << quote
      }else{
        // else reject new quote
        BuyerSeller.location = quote.location
        reject@BuyerSeller("Not ok to buy chips for " + quote.price);
        println@Console("Rejected "+quote.price+" from " + quote.location+".")()
      }
    }
    println@Console( "This:" + best + " "  +best.price+ " "+best.location+".")()
    if(best.location != void){  //is defined.
      println@Console( "I attempt to accept best." )()
      BuyerSeller.location = best.location
      maxprice = 20;
      if(best.price < maxprice){
        accept@BuyerSeller("Ok to buy chips for " + best.price);
        println@Console("Accepted "+best.price+" from "+best.location+".")()

        // Wait for details from shipper.

        details(invoice)
        println@Console("Received the invoice from Shipper: "+invoice)()

      }else{
        reject@BuyerSeller("Not ok to buy chips for " + best.price);
        println@Console("Rejected all.")()
      }
    }
  }
}
