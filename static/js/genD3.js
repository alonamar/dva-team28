//First chart

// Set the dimensions of the canvas / graph
var margin = {top: 50, right: 120, bottom: 30, left: 120},
    width = 830 - margin.left - margin.right,
    height = 320 - margin.top - margin.bottom;

// Parse the date / time
var parseDate = d3.timeParse("%Y"); 

// Set the ranges
var x = d3.scaleTime().rangeRound([0, width]);
//var x = d3.scaleLinear().range([0, width]);
//var x = d3.scaleOrdinal().range([0, width]);
var y = d3.scaleLinear().range([height, 0]);

// Define the axes
var xAxis = d3.axisBottom(x)//.tickFormat(d3.format("d")).ticks(5);
//var xAxis = d3.axisBottom(x).ticks(5);
//var xAxis = d3.svg.axis().scale(x)
 //   .orient("bottom").ticks(5);

var yAxis = d3.axisLeft(y).tickFormat(d3.format("d")).ticks(10);
//var yAxis = d3.svg.axis().scale(y)
 //   .orient("left").ticks(10);

// Define the line
/*var priceline = d3.svg.line()
    .x(function(d) { return x(d.year); })
    .y(function(d) { return y(d.count); });
    */
// Adds the svg canvas
var svg = d3.select("#d3Container")
    .append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
    .append("g")
        .attr("transform", 
              "translate(" + margin.left + "," + margin.top + ")");
			  
			  


//d_8=d3.map
// Get the data
d3.csv("../static/data/Call_Counts_monthly_1.csv").then(function(data) {

    data.forEach(function(d) {
		//d.year = parseDate(d.year).getFullYear();
		//d.year_month=+d.year_month
		d.year_month=d3.timeParse("%Y%m")(d.year_month)
		d["call_year"] = +d["call_year"]
		d["call_month"]=+d["call_month"]
		d["no_of_calls"] = +d["no_of_calls"]
		//console.log(d)
		
    });
//console.log(data);

// Define the line
var trend_line = d3.line()
    .x(function(d) { return x(d.year_month); })
    .y(function(d) { return y(d.no_of_calls ); });

//nsole.log(priceline_8);	
//x.domain([201701,201909])
	x.domain([
                d3.min(data, function(d) { return d.year_month; }),
                d3.max(data, function(d) { return d.year_month; })
           ]);
        //y.domain([0, d3.max(data, function(d) { return d.count; })]).nice();
	y.domain([0,50000]); 
//console.log(x.domain)
    
		
		svg.append("path")
            .attr("class", "line")
			.style("stroke", "#021d96")
            .attr("d", trend_line(data));
			//.attr("d", priceline(data_s.values.forEach(function (element){  return element; })));\\\
			
			
			
var mouseover_daily = function(r_data) {
	  d3.select(this).attr("r", 6)
	  d3.select("#svg2").remove();
	  d3.select("#svg3").remove();
	  var clicked_year=r_data.call_year
	  var clicked_month=r_data.call_month
	  //console.log(clicked_year)
	  //console.log(clicked_month)
	  margin.left=120
	
	 let height1 = 320 - margin.top - margin.bottom;
	 var svg_2 = d3.select("#d3Container")
    .append("svg")
	.attr("id", "svg2")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height1 + margin.top + margin.bottom)
    .append("g")
        .attr("transform", 
              "translate(" + margin.left+ "," + margin.top + ")");
			  
d3.csv("../static/data/Call_all_years_daily.csv").then(function(data) {
    data.forEach(function(d) {
		d["SR CREATE DATE"]=d3.timeParse("%Y-%m-%d")(d["SR CREATE DATE"])
		d["call_year"] = +d["call_year"]
		d["call_month"]=+d["call_month"]
		d["call_day"]=+d["call_day"]
		d["call_count"] = +d["call_count"]
		d["weatherflag"] = +d["weatherflag"]
		
    });

 let data_y=data.filter(function(d) { return d.call_year == clicked_year; })
 let data_m=data_y.filter(function(d) { return d.call_month == clicked_month; })
//console.log(data_m);
//console.log(data_m);
//console.log(data_m["weatherflag"])

// Set the ranges
var x1 = d3.scaleTime().rangeRound([0, width]);
//var x = d3.scaleLinear().range([0, width]);
var y1 = d3.scaleLinear().range([height, 0]);

// Define the axes
var xAxis1 = d3.axisBottom(x1)//.tickFormat(d3.format("d")).ticks(5);
var yAxis1 = d3.axisLeft(y1).tickFormat(d3.format("d")).ticks(10);

var month_line = d3.line()
    .x(function(d) { return x1(d["SR CREATE DATE"]); })
    .y(function(d) { return y1(d["call_count"]); });

	x1.domain([
                d3.min(data_m, function(d) { return d["SR CREATE DATE"]; }),
                d3.max(data_m, function(d) { return d["SR CREATE DATE"]; })
           ]);

y1.domain([0, d3.max(data_m, function(d) { return d.call_count; })]).nice();
    
		
		svg_2.append("path")
            .attr("class", "line")
			.style("stroke", "#021d96")
            .attr("d", month_line(data_m));

 // Add the X Axis
    svg_2.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis1);
		
		 // text label for the x axis
	  svg_2.append("text")             
      .attr("transform",
            "translate(" + (width/2) + " ," + 
                           (height +  30) + ")")
      .style("text-anchor", "middle")
	  .style("font-size", "13px") 
      .text("Month");

    // Add the Y Axis
    svg_2.append("g")
        .attr("class", "y axis")
        .call(yAxis1);
		
		 // text label for the Y axis
   // text label for the y axis
  svg_2.append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 60 - margin.left)
      .attr("x",0 - (height / 2))
      .attr("dy", "1em")
      .style("text-anchor", "middle")
	  .style("font-size", "13px") 
      .text("311 Calls"); 
	
	
		svg_2.append("text")
        .attr("x", (width / 2))             
        .attr("y", 0 - (margin.top / 8))
        .attr("text-anchor", "middle")  
        .style("font-size", "16px") 
        
        .text("Daily 311 Call volume");
		
		svg_2.append("circle").attr("cx",(width+30 )).attr("cy",27).attr("r", 3).style("fill", "#fa0202");
		svg_2.append("text").attr("x",(width+80 )).attr("y",30).attr("text-anchor", "middle").text("Weather day");

		
		
		var mouseover_top3 = function(r_data) {
	  d3.select(this).attr("r", 6)
	  d3.select("#svg3").remove();
	  //var sr_date=	d3.timeParse("%d")(r_data["SR CREATE DATE"])
	  
	  //console.log(sr_date)
	  
	  margin.left=170
	
	 let height3 = 230 - margin.top - margin.bottom;
	 var svg_3 = d3.select("#d3Container")
    .append("svg")
	.attr("id", "svg3")
        .attr("width", width + margin.left + margin.right - 50)
        .attr("height", height3 + margin.top + margin.bottom)
    .append("g")
        .attr("transform", 
              "translate(" + margin.left+ "," + margin.top + ")");
			  
d3.csv("../static/data/Call_daily_top_3.csv").then(function(data) {
    data.forEach(function(d) {
		d["SR CREATE DATE"]=d3.timeParse("%Y-%m-%d")(d["SR CREATE DATE"])
		d["count_sr_type"] = +d["count_sr_type"]
		d["call_year"] = +d["call_year"]
		d["call_month"]=+d["call_month"]
		d["call_day"]=+d["call_day"]
		
    });
//console.log(data);
	  var clicked_year=r_data.call_year
	  var clicked_month=r_data.call_month
	  var clicked_day=r_data.call_day
	  console.log(clicked_month)
	  console.log(clicked_year)
	  console.log(clicked_day)
 data_y=data.filter(function(d) { return d.call_year == clicked_year; })
 data_m=data_y.filter(function(d) { return d.call_month == clicked_month; })
 let data_d=data_m.filter(function(d) { return d.call_day == clicked_day; })
 
 
console.log(data_d);

 var y3 = d3.scaleBand().range([height3, 0])
          .padding(0.1);
	 var x3 = d3.scaleLinear().range([0, width]);
	 
		 let sr_type=data_d.map(function (element){  return(element["SR TYPE"]); })
		 //console.log(sr_type);
		y3.domain(sr_type);
	let counts=data_d.map(function (element){  return(element.count_sr_type); })
	x3.domain([0, d3.max(data_d, function(d){ return d.count_sr_type; })])
	 var xAxis3 = d3.axisBottom(x3).tickFormat(d3.format("d"));//.ticks(10);

	 var yAxis3 = d3.axisLeft(y3);//.ticks(10);

	svg_3.selectAll(".bar")
         .data(data_d)
         .enter().append("rect")
         .attr("class", "bar")
		.attr("width", function(d) { return x3(d.count_sr_type); })
		//.attr("width", 10)
		 .attr("y", function(d) { return y3(d["SR TYPE"]); })
		 .attr("x", 0)
         //.attr("height", y3.bandwidth());
		 .attr("height", 40);

		 // Add the X Axis
    svg_3.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height3 + ")")
        .call(xAxis3);
		
		 // text label for the x axis
	  svg_3.append("text")             
      .attr("transform",
            "translate(" + (width/2) + " ," + 
                           (height3 +  30) + ")")
      .style("text-anchor", "middle")
	  .style("font-size", "13px") 
      .text("Counts");

    // Add the Y Axis
    svg_3.append("g")
        .attr("class", "y axis")
        .call(yAxis3)
		.style("font-size", "13px") ;
		
		 // text label for the Y axis
   // text label for the y axis
  svg_3.append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 0 - margin.left)
      .attr("x",0 - (height / 2))
      .attr("dy", "1em")
      .style("text-anchor", "middle")
      //.text("311 Calls"); 
	
	
		svg_3.append("text")
        .attr("x", (width / 2))             
        .attr("y", 0 - (margin.top / 8))
        .attr("text-anchor", "middle")  
        .style("font-size", "16px") 
        
        .text("Top 3 call types");

  });
}	
		
		
	svg_2.selectAll("s.dot")
    .data(data_m)
	.enter().append("circle") // Uses the enter().append() method
    .attr("class", "dot") // Assign a class for styling
    .attr("cx", function(d, i) { return x1(d["SR CREATE DATE"]) })
    .attr("cy", function(d) { return y1(d["call_count"]) })
	.attr("fill",function(d) { if (d["weatherflag"] > 0) {return "#fa0202"} else{ return "#021d96"};})
	//.attr("fill","#fa0202")
    .attr("r", 3)
	//.on("mouseover", function(d) {d3.select(this).attr("r", 6)})
	.on("mouseover", mouseover_top3)
	.on("mouseout", function(d){         d3.select(this).attr("r", 3)})		;
		
  var ls_w = 20, ls_h = 20;
  


  /*var dataNest = d3.nest()

		.key(function(d) { return d["SR CREATE DATE"];})
		//.key(function(d) { return d.year;})
		.rollup(function(d) { 
		//return d3.count(d, function(g) {return +g.call_month; });
		return d.length;})
		.entries(data_m)
		  
	console.log(dataNest);*/
	
	
  });
}  
		

    // Add the X Axis
    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);
		
		 // text label for the x axis
	  svg.append("text")             
      .attr("transform",
            "translate(" + (width/2) + " ," + 
                           (height +  30) + ")")
      .style("text-anchor", "middle")
	  .style("font-size", "13px") 
      .text("Year");

    // Add the Y Axis
    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)
		;
		
		 // text label for the Y axis
   // text label for the y axis
  svg.append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 60 - margin.left)
      .attr("x",0 - (height / 2))
      .attr("dy", "1em")
      .style("text-anchor", "middle")
	  .style("font-size", "13px") 
      .text("311 Calls"); 
	
		
			svg.selectAll("s.dot")
    .data(data)
	.enter().append("circle") // Uses the enter().append() method
    .attr("class", "dot") // Assign a class for styling
    .attr("cx", function(d, i) { return x(d.year_month) })
    .attr("cy", function(d) { return y(d.no_of_calls) })
	.attr("fill","#021d96")
    .attr("r", 3)
	//.on("mouseover", function(d) {d3.select(this).attr("r", 6)})
	.on("mouseover", mouseover_daily)
	.on("mouseout", function(d){         d3.select(this).attr("r", 3)})		;
	
		svg.append("text")
        .attr("x", (width / 2))             
        .attr("y", 0 - (margin.top / 8))
        .attr("text-anchor", "middle")  
        .style("font-size", "16px") 
        
        .text("Monthly 311 Call volume");
		
  var ls_w = 20, ls_h = 20;
  
  

});