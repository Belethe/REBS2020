include "mosquitto/interfaces/MosquittoInterface.iol"
include "console.iol"

execution {concurrent}

inputPort Server {
    Location: "local"
    Protocol: sodep
    Interfaces: MosquittoReceiverInteface
}

outputPort Mosquitto {
    Interfaces: MosquittoInterface
}

embedded {
    Java: 
        "org.jolielang.connector.mosquitto.MosquittoConnectorJavaService" in Mosquitto
}

init {
    request << {
        brokerURL = "tcp://broker.hivemq.com",
        subscribe << {
            topic = "pmcep/Disco Example Log/+/Inbound Email"
        }
        // I can set all the options available from the Paho library
    }
    setMosquitto@Mosquitto (request)()
}

main {
    receive (request)
    println@Console("topic :     "+request.topic)()
    println@Console("message :   "+request.message)()
}
