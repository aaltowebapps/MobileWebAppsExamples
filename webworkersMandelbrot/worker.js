self.onmessage = function (event) {
  var data = event.data;
  var max_iter = data.max_iter;
  var escape = data.escape * data.escape;
  data.values = [];
  for (var j = data.j_start; j < data.j_end; j++) {
    var c_j = data.r_min + (data.r_max - data.r_min) * (j-data.j_start) / data.height;
    for (var i = data.i_start; i < data.i_end; i++) {
      var c_i = data.c_min + (data.c_max - data.c_min) * (i-data.i_start) / data.width;
      var z_j = 0, z_i = 0;
      for (iter = 0; z_j*z_j + z_i*z_i < escape && iter < max_iter; iter++) {
	// z -> z^2 + c
	var tmp = z_j*z_j - z_i*z_i + c_i;
	z_i = 2 * z_j * z_i + c_j;
	z_j = tmp;
      }
      if (iter == max_iter) {
	iter = -1;
      }
      data.values.push(iter);
    }
  }
  self.postMessage(data);
}
