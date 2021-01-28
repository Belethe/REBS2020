include "InterfaceModules.iol"

include "console.iol"

service PriceRunner {

    execution{ concurrent }

    inputPort PRBuyer {
         location: "socket://localhost:8037"
         protocol: http { format = "json" }
         interfaces: BuyerPRInterface
    }

    inputPort PRSeller {
         location: "socket://localhost:8038"
         protocol: http { format = "json" }
         interfaces: SellerPRInterface
    }

     main {
          [register(location)(response){
            println@Console("Registering buyer at location: "+test.str+".")();

            global.sellers[#global.sellers] = location.str;
            global.i++;

            println@Console("There are now "+#global.sellers+" sellers. Just registered "+location.str+".")()

            response = "You are now registered."
          }]

          [getSellers(request)(response){
            // How to return all sellers?
            response.str << global.sellers
            println@Console("Got a request: "+request)()
          }]
     }
}
