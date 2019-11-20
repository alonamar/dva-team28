let res = ["smaller than -150", "between -150 and 0", "between -150 and 0", "bigger than 150"];
let entry = {
'TRASH.QUAD': 'NE',
'RECYCLE.QUAD': 'NW',
'TRASH.DAY': 'FRIDAY',
'HEAVY.TRASH.DAY': '1st Friday',
'RECYCLE.DAY': 'FRIDAY-B',
'DEPARTMENT': '311 HelpLine',
'DIVISION': '311 Call Handling',
'SR.TYPE': 'Unclassified 311 Web Request',
'QUEUE': '311_Seniors',
'SLA': '18',
'LATITUDE': '29.80654129',
'LONGITUDE': '-95.35715636',
'Channel.Type': 'WAP',
'weatherflag': '0',
'eventType': 'unknown',
'Nearest_facility': '1.975372688'
};

window.onload = function() {
	// setup the button click
	// $("#target").submit(function(e) {
	//     data = $(this).serializeArray();
	//     $.post("receiver", JSON.stringify(data), function(data, status){
    //         $("#answer").append("Chance of: " + (data['0']*100).toFixed(2) + "%, to get " + res[data['1']] + " days")
    //             .append("<br>").append("estimated : " + data['2'].toFixed(2) + " days");
	//     });
	// 	e.preventDefault();
	// });

};

function doWork() {
	// ajax the JSON to the server
    $.post("receiver", JSON.stringify(entry), function(data, status){
        alert("Data: " + data['0'] + "\nStatus: " + status);
	});
	// stop link reloading the page
 event.preventDefault();
}

