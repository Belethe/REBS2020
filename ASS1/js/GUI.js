var taskTable;
var graphs = graphs || []; //If not already defined, set to empty
var logs = logs || [];

function fillDcrTable(status) {
    for (var row of status)
    {
        row.executed = (row.executed ? "V:" + row.lastExecuted : "");            
        row.pending = (row.pending ? "!" + (row.deadline === undefined ? "" : ":" + row.deadline) : "");            
        row.included = (row.included ? "" : "%");       
        row.name = "<button " + (row.enabled ? "" : "disabled") + " onclick=\"graph1.execute('" + row.name + "');fillDcrTable(graph1.status());\">" + row.label + "</button>";
    }
    taskTable.load(status);
    updateAccepting(graph1.isAccepting());
}

function updateAccepting(status) {
    document.getElementById("accepting").innerHTML = (status ? "Accepting" : "Not accepting");
}

$(document).ready(function(e) {    
    taskTable = dynamicTable.config('task-table', 
    ['executed', 'included', 'pending', 'enabled', 'name'], 
    ['Executed', 'Included', 'Pending', 'Enabled', 'Name'], 
    'There are no items to list...'); 

    $('#btn-time').click(function(e) {
        graph1.timeStep(1);
        fillDcrTable(graph1.status());
    });           

    $('#ta-dcr').keyup(function(e) {
        var x = document.getElementById("ta-dcr");
        try{
            var strings = x.value.split("\n\n")
            graphs  = []
            for (i = 0 ; i < strings.length ; i++){
                graphs[i] = parser.parse(strings[i]);
            }

            graph1 = parser.parse(x.value);
            fillDcrTable(graph1.status());
            document.getElementById("parse-error").innerHTML = "";
        }
        catch(err)
        {
            document.getElementById("parse-error").innerHTML = err.message + "</br>" + JSON.stringify(err.location);
        }
    });         
    
    $('#ta-log').keyup(function(e) {
        var x = document.getElementById("ta-log");
        try{
            var y = document.getElementById("ta-log");
            var rawlog = y.value;
            var log = $.csv.toArrays(rawlog, {
                delimiter: "'", // Sets a custom value delimiter character
                separator: '\t', // Sets a custom field separator character
            });
            
            //Code marking the log a 3d array of [trace[activity[id,name,date]]]
            logs = [[]]
            logs[0][0] = log[0]
            var prev = log[0][0] // id of first element
            var tracenr = 0

            for (i = 1 ; i < log.length ; i++){
                if (log[i][0] != prev) {
                    tracenr++
                    logs[tracenr] = []
                    prev = log[i][0]
                }
                logs[tracenr][logs[tracenr].length] = (log[i])
            }
        }
        catch(err)
        {
            document.getElementById("parse-error").innerHTML = err.message + "</br>" + JSON.stringify(err.location);
        }
    });

    try{
        var x = document.getElementById("ta-dcr");
        graph1 = parser.parse(x.value);                
        fillDcrTable(graph1.status());
        document.getElementById("parse-error").innerHTML = "";
    }
    catch(err)
    {
        document.getElementById("parse-error").innerHTML = err.message + "</br>" + JSON.stringify(err.location);
    }

});