Raphael.fn.pieChart = function (cx, cy, r, values, labels, colors, options) {
  var paper = this,
      rad = Math.PI / 180,
      chart = this.set();

  function sector(cx, cy, r, startAngle, endAngle, params) {
    var x1 = cx + r * Math.cos(-startAngle * rad),
        x2 = cx + r * Math.cos(-endAngle * rad),
        y1 = cy + r * Math.sin(-startAngle * rad),
        y2 = cy + r * Math.sin(-endAngle * rad);
    return paper.path(["M", cx, cy, "L", x1, y1, "A", r, r, 0, +(endAngle - startAngle > 180), 0, x2, y2, "z"]).attr(params);
  }

  var angle = 0,
      total = 0,
      start = 0,
      process = function (j) {
        var value = values[j];
        if (value == 0) { return; }
        var angleplus = 360 * value / total,
            popangle = angle + (angleplus / 2),
            color = colors[j],
            ms = 500,
            delta = 30,
            bcolor = color, 
            p = sector(cx, cy, r, angle, angle + angleplus, {fill: "90-" + bcolor + "-" + color, stroke: options['stroke']['color'], "stroke-width": options['stroke']['width']}),
            txt = paper.text(cx + (r + delta) * Math.cos(-popangle * rad), cy + (r + delta + 25) * Math.sin(-popangle * rad), labels[j]).attr({fill: bcolor, stroke: "none", opacity: 0, "font-size": 20});

        p.mouseover(function () {
          p.stop().animate({transform: "s1.1 1.1 " + cx + " " + cy}, ms, "elastic");
          txt.stop().animate({opacity: 1}, ms, "elastic");
        }).mouseout(function () {
          p.stop().animate({transform: ""}, ms, "elastic");
          txt.stop().animate({opacity: 0}, ms);
        });

        angle += angleplus;
        chart.push(p);
        chart.push(txt);
        start += .1;
      };

  for (var i = 0, ii = values.length; i < ii; i++) {
    total += values[i];
  }
  for (i = 0; i < ii; i++) {
    process(i);
  }

  return this;
};