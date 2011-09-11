Math.hypot = function(x, y) {
  return Math.sqrt(x * x + y * y) || 0;
}

Math.cartesian_product = function(X, Y) {
  var res = [];

  X.each(function(x) {
    Y.each(function(y) {
      res.push([x, y]);
    })
  })

  return res;
}

var MinecraftSkin = Class.create({
    initialize: function() {
    },

    __translate_coords: function(source, theta, zoom) {
      var x = source[0] - 5,
        y = source[1] - 5,
        z = source[2],
        carousel = Math.hypot(x, z),
        offset = Math.atan2(z, x);
      x = Math.cos(theta + offset) * carousel;

      return [parseInt((x + 5) * zoom), parseInt((y + 5) * zoom)];
    },

    render: function(skin, theta, zoom) {
      var size = [10 * zoom, 10 * zoom]
    }
});
