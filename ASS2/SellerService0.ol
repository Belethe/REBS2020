include "InterfaceModules.iol"

include "console.iol"

service SellerService {

    execution{ single }

    outputPort SellerBuyer {
         location: "socket://localhost:8005"
         protocol: http { format = "json" }
         interfaces: SellerBuyerInterface
    }

    outputPort SellerShipper {
         location: "socket://localhost:8003"
         protocol: http { format = "json" }
         interfaces: SellerShipperInterface
    }

    inputPort BuyerSeller {
         location: "socket://localhost:8004"
         protocol: http { format = "json" }
         interfaces: BuyerSellerInterface
    }

     main {
          [ask(product)]{
               price = 19;
               name = "Seller0"
               invoice.product = product;
               invoice.price = price;
               invoice.seller = name;
               quote@SellerBuyer(invoice);
               println@Console("Quoted buyer " + invoice.price + "DKK for " + invoice.product + ".")();

               [accept(sth)]{
                    order@SellerShipper(invoice);
                    println@Console("The price was accepted with message: " + sth)()
               }

               [reject(sth)]{
                    println@Console("The price was rejected with messsage: " + sth)()
               }
          }
     }
}
