var w = 300,
	h = 300;
var div_radial = d3.select("#radial");
var svg = div_radial.append("svg")
	.attr("id", "svg-radial")
	.attr("width", w)
	.attr("height", h);
var radial = svg.append("g");
var angle_data = [],
	radius_data = [];
var nA = 20,
	nR = 10;
var r0 = 50,
	R = 150 * Math.sqrt(2);
for (var i = 1; i < nA+1; i++) {
	angle_data.push(i);
}
for (var i = 1; i < nR+1; i++) {
	radius_data.push(i);
}
var pi = Math.PI;
var dA = 2 * pi / nA,
	dR = 100 / nR;
radial.append("g")
	.selectAll("line")
	.data(angle_data)
	.enter()
	.append("line")
	.attr("class", "radial-angles")
	.attr("x1", w / 2)
	.attr("y1", h / 2)
	.attr("x2", function(d) {
		return w / 2 + R * Math.cos(dA * d);
	})
	.attr("y2", function(d) {
		return h / 2 + R * Math.sin(dA * d);
	});
radial.append("g")
	.selectAll("circle")
	.data(radius_data)
	.enter()
	.append("circle")
	.attr("class", "radial-circles")
	.attr("cx", w / 2)
	.attr("cy", h / 2)
	.attr("r", function(d) {
		return r0 + d * dR;
	});
radial.append("circle")
	.attr("class", "central-circle circle")
	.attr("cx", w / 2)
	.attr("cy", h / 2)
	.attr("r", r0);

var div_rect = d3.select("#rect");
var kA = 260 / (2 * pi),
	kR = 260 / 150;
svg = div_rect.append("svg")
	.attr("id", "svg-rect")
	.attr("width", w)
	.attr("height", h);
rect = svg.append("g")
	.attr("transform", "translate(10,10)");
rect.append("rect")
	.attr("class", "central-circle")
	.attr("y", 20)
	.attr("width", 50 * kR)
	.attr("height", 260);
var grid = rect.append("g")
	.attr("transform", "translate(" + kR * 50 + ",20)");
grid.append("rect")
	.attr("id", "outer-rect")
	.attr("width", 260 - 50*kR)
	.attr("height", 260);
grid.append("g")
	.selectAll("line")
	.data(angle_data)
	.enter()
	.append("line")
	.attr("class", "radial-angles")
	.attr("x2", 260 - 50*kR)
	.attr("y1", function(d){
		return kA * (d-1) * dA;
	})
	.attr("y2", function(d){
		return kA * (d-1) * dA;
	});
grid.append("g")
	.selectAll("line")
	.data(radius_data)
	.enter()
	.append("line")
	.attr("class", "radial-circles")
	.attr("x1", function(d){
		return kR * dR * d;
	})
	.attr("x2", function(d){
		return kR * dR * d;
	})
	.attr("y2", 260);
rect.append("line")
	.attr("class", "circle")
	.attr("x1", 50 * kR)
	.attr("x2", 50 * kR)
	.attr("y1", 20)
	.attr("y2", 280);
rect.append("line")
	.attr("class", "circle")
	.attr("x2", 50*kR)
	.attr("y1", 20)
	.attr("y2", 20);
rect.append("line")
	.attr("class", "axis")
	.attr("x1", -5)
	.attr("x2", 280)
	.attr("y1", 280)
	.attr("y2", 280);
rect.append("line")
	.attr("class", "axis")
	.attr("y2", 285);
rect.append("line")
	.attr("class", "tick")
	.attr("x1", -4)
	.attr("x2", 4)
	.attr("y1", 20)
	.attr("y2", 20);
rect.append("line")
	.attr("class", "tick")
	.attr("x1", kR * 50)
	.attr("x2", kR * 50)
	.attr("y1", 276)
	.attr("y2", 284);
rect.append("line")
	.attr("class", "tick")
	.attr("x1", 260)
	.attr("x2", 260)
	.attr("y1", 276)
	.attr("y2", 284);