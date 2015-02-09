//Streamgraph from FTSE, Hang Seng, Standard and Poors 500
//borrows heavily from block #4060954
//(http://bl.ocks.org/mbostock/4060954)

/*
Helpful links:
  file:///home/ptang11/Documents/Coding/webdesign/personal/paulswtang.github.io/index.html
  http://bost.ocks.org/mike/path/
  https://github.com/mbostock/d3/wiki/Tutorials
  https://github.com/mbostock/d3/wiki/API-Reference
  http://bost.ocks.org/mike/join/
To Do:
  -Make real time data flow from left to right (right to left?)
  -Tie to financial feeds
  -Keep data in window bounds
  -Make responsive: scale to window size appropriately, even on mobile
*/

//////////////////
function bumpLayer(n) {
  // Inspired by Lee Byron's test data generator.
  function bump(a) {
    var x = 1 / (.1 + Math.random()),
        y = 2 * Math.random() - .5,
        z = 10 / (.1 + Math.random());
    for (var i = 0; i < n; i++) {
      var w = (i / n - y) * z;
      a[i] += x * Math.exp(-w * w);
    }
  }

  var a = [], i;
  for (i = 0; i < n; ++i) a[i] = 0;
  for (i = 0; i < 5; ++i) bump(a);
  return a.map(function(d, i) { return {x: i, y: Math.max(0, d)}; });
}
//////////////////

var layers = 8, // number of layers
    samples = 200, // number of samples per layer
    random = d3.random.normal(0, .2), //N(mu=0,sigma=0.2)-distributed RV
    //data containers
    data0 = d3.layout.stack()
              .offset("wiggle")(
                d3.range(layers).map(function() { return bumpLayer(samples); }) //range of 8 random bumps
              ),
    data1 = d3.layout.stack()
              .offset("wiggle")(
                d3.range(layers).map(function() { return bumpLayer(samples); }) //
              );

//width of stream graphs (n.b. -- need to make responsive!)
var width = 1350,
    height = 600;

//x coords are a linear function from number of layers to width
var x = d3.scale.linear()
    .domain([0, samples - 1])
    .range([0, width]);

//y coords are linear scale
var y = d3.scale.linear()
    .domain([0, d3.max(
                  data0.concat(data1),
                  function(layer) { return d3.max(layer, function(d) { return d.y0 + d.y; }); }
                )
    ])
    .range([height, 0]);

//defines color of stream graphs -- here, from bright grey to dark grey.
var color = d3.scale.linear()
    .range(["#eee", "#666"]);

//area generator: see https://github.com/mbostock/d3/wiki/SVG-Shapes#area
var area = d3.svg.area()
    .x(function(d) { return x(d.x); })
    .y0(function(d) { return y(d.y0); })
    .y1(function(d) { return y(d.y0 + d.y); });

//create an SVG of dimensions <<width x height>>
var svg = d3.select("body").append("svg")
    .attr("width", width)
    .attr("height", height);

//choose path
svg.selectAll("path")
    .data(data0)  //get data from data0 stack
  .enter().append("path")
    .attr("d", area)
    .style("fill", function() { return color(Math.random()); });



//transition function:
function transition() {
  d3.selectAll("path")
      .data(function() {
        var d = data1;
        data1 = data0;
        return data0 = d3.layout.stack()
              .offset("wiggle")(d3.range(layers).map(function() { return bumpLayer(samples); }));
      })
    .transition()
      .duration(3500)
      .attr("d", area);
}
//repeat transition every 2.5 seconds
setInterval(transition,3500);