// Oversæt csv til arrays (Kun ID, Title, Date, ét array pr ID)

// For hver array:
//     Sorter efter dato
//     Fjern "-"
//     for hver element i array:
//         Event.eneable()
//             if false:
//                 false+1
//                 break to next array
//         Event.execute()
//     sucesses+1

var graphs = graphs || [] ; //If not already defined, set to empty
var logs = logs || [] ;

$(document).ready(function(e) {
    $('#btn-check').click(function(e) {
        var empty = false;
        document.getElementById("check-error").innerHTML = "";
        console.log(JSON.stringify("checker"));
        if (graphs.length == 0) {
            document.getElementById("check-error").innerHTML += "Please define a graph<br />";
            empty = true;
        }
        else {
            document.getElementById("check-error").innerHTML += "There are "+graphs.length+" graphs<br />";
            console.log(graphs)
        }
        if (logs.length == 0) {
            document.getElementById("check-error").innerHTML += "Please write the log";
            empty = true
        }
        else {
            document.getElementById("check-error").innerHTML += "There are "+logs.length+" traces";
            console.log(logs)
        }
        results = []
        if(!empty){
            graphs.forEach((graph) => {
                // logs.forEach((log) => {
                //     for(j = 0 ; j < log.length ; j++){
                //         if(!graph.execute(logs[j][1])){
                //             graph.marking.fails += 1; //XXX: checker.js:44 Uncaught TypeError: Cannot read property 'fails' of undefined
                //             break;
                //         }
                //     }
                //     graph.marking.successes += 1;
                // });
                // results.push([graph.marking.successes,graph.marking.fails])
                console.log(JSON.stringify("Test"))
                console.log(JSON.stringify(graph)) //graph IS an object...
            });
        }
        console.log(JSON.stringify(results))

    });
});