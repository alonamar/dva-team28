window.onload = function() {
	// setup the button click
	$("#target").submit(function(e) {
	    data = $(this).serializeArray();
	    $.post("receiver", JSON.stringify(data), function(data, status){
            $("#answer").append("Chance of: " + (data['0']*100).toFixed(2) + "%, to get " + res[data['1']] + " days")
                .append("<br>").append("estimated : " + data['2'].toFixed(2) + " days");
	    });
		e.preventDefault();
	});

};