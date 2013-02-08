Raphael.fn.standaloneBar = function (start_x, start_y, width, height, values, labels, colors, options) {
  var paper = this,
      chart = this.set();

  var last_x = start_x,
      last_y = start_y,
      values_sum = sum(values);

  var drawBox = function(j) {
    var value = values[j];
    if (value == 0) { return; }
    var fraction = value/values_sum;
    var boxWidth = fraction*width;
    var box = paper.rect(last_x, last_y, boxWidth, height)
                   .attr({fill: colors[j], 
                          stroke: options['stroke']['color'], 
                          "stroke-width": options['stroke']['width']});

    var cx = last_x + boxWidth/2;
    var cy = last_y + height/2;
    var ms = 500;
    var label = labels[j];
    if (options['labels']['show-percent']) {
      label = (fraction*100).toFixed(1) + "% " + label;
    }
    var txt = paper.text(cx, last_y + height + options['font']['size'], label)
                   .attr({fill: options['font']['color'], 
                          stroke: "none", 
                          opacity: 0, 
                          "font-size": options['font']['size']});

    box.mouseover(function () {
      box.toFront().stop().animate({transform: "s1.03 1.2 " + cx + " " + cy}, ms, "elastic");
      txt.stop().animate({opacity: 1}, ms/3, "elastic");
    }).mouseout(function () {
      box.stop().animate({transform: ""}, ms, "elastic");
      txt.stop().animate({opacity: 0}, ms/3);
    });

    last_x += boxWidth;
    return box;
  };

  for (i = 0; i < values.length; i++) {
    drawBox(i);
  }
  
  return this;
};