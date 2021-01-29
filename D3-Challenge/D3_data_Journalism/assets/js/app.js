// Set up height and width of the chart area
var svgWidth = 960;
var svgHeight = 870;

//Set margins
var margin = {
    top :50,
    right: 50,
    bottom: 50,
    left: 50
};

var chartWidth = svgWidth - margin.left - margin.right;
var chartHeight = svgHeight = margin.top - margin.bottom;

//Append the svg group that will hold the chart

var svg = d3.select("#scatter")
  .append("svg")
  .attr("width", svgWidth)
  .attr("height", svgHeight);

var chartGroup = svg.append("g")
  .attr("transform", `translate(${margin.left}, ${margin.top})`);

//Import data from the csv file
d3.csv("/assets/data/data.csv").then(function(stateData) {
// Format the data
    stateData.forEach(function(data) {
    data.poverty = +data.poverty;
    data.healthcare = +data.healthcare;
    //console.log(data.poverty)
});
      
//Create our scaling functions
    var xScale = d3.scaleLinear()
        .domain([d3.min(stateData, d => d.poverty),d3.max(stateData, d => d.poverty)])
        .range([0, chartWidth]);
    
    var yScale = d3.scaleLinear()
    .domain([0, d3.max(stateData, d => d.healthcare)])
    .range([chartHeight, 0]);

//Create axis functions
    var xAxis = d3.axisBottom(xScale);
    var yAxis = d3.axisLeft(yScale);

//Add axis
    chartGroup.append("g")
        .attr("transform", `translate(0, ${chartHeight})`)
        .call(xAxis);

    chartGroup.append("g")
        .call(yAxis);
    
    var circlesGroup = chartGroup.selectAll("circle")
        .data(stateData)
        .enter()
        .append("circle")
        .attr("cx", d => xScale(d.poverty))
        .attr("cy", d => yScale(d.healthcare))
        .attr("r", 10)
        .attr("fill", "lightblue")
        .attr("opacity", ".4")
        .attr("stroke-width", "1")
        .attr("stroke", "white");    

        chartGroup.append("text")
        .style("text-anchor", "middle")
        .style("font-family", "Times New Roman")
        .style("font-size", "7px")
        .selectAll("tspan")
        .data(stateData)
        .enter()
        .append("tspan")
        .attr("x", function(data) {
            return xScale(data.poverty);
        })
        .attr("y", function(data) {
            return yScale(data.healthcare -.02);
        })
        .text(function(data) {
            return data.abbr
        });
    
// Initalize Tooltip
    var toolTip = d3.tip()
    .attr("class", "tooltip")
    .offset([80, -70])
    .style("position", "absolute")
    .style("background", "lightsteelblue")
    .style("pointer-events", "none")
    .html(function(d) {
        return (`${d.state}<br>Population In Poverty (%): ${d.poverty}<br>Lacks Healthcare (%): ${d.healthcare}`)
    });      

// tooltip in the chart
chartGroup.call(toolTip);   

// Add an on mouseover event to display a tooltip   
circlesGroup.on("mouseover", function(data) {
    toolTip.show(data, this);
})

// Add an on mouseout    
.on("mouseout", function(data, index) {
    toolTip.hide(data);
});

// Create axes labels  
chartGroup.append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 0 - margin.left - 5)
    .attr("x", 0 - (chartHeight / 1.30))
    .attr("dy", "1em")
    .attr("class", "axisText")
    .text("Lacks Healthcare (%)");

chartGroup.append("text")
    .attr("transform", `translate(${chartWidth / 2.5}, ${chartHeight + margin.top + 30})`)
    .attr("class", "axisText")
    .text("In Poverty (%)");

}).catch(function(error) {
    console.log(error);
  });

