var Mandelbrot = function (options) {
  var self = this; // for use in closures where 'this' is rebound
  this.canvas = options.canvas;
  var canvas = this.canvas;
  this.ctx = this.canvas.getContext("2d");
  this.row_data = this.ctx.createImageData(this.canvas.width, 1);
  this.canvas.addEventListener("click", function(event) {
      self.click(event.clientX + document.body.scrollLeft +
		 document.documentElement.scrollLeft - canvas.offsetLeft,
		 event.clientY + document.body.scrollTop +
		 document.documentElement.scrollTop - canvas.offsetTop);
    }, false);

  window.addEventListener("resize", function(event) {
      self.resize_to_parent();
    }, false);

  this.completed=options.completed;
  this.changeBoundaries=options.changeBoundaries;
  this.start=options.start;

  this.max_iter = 4096;
  this.escape = 100;

  this.make_palette();
 
}

  Mandelbrot.prototype = {

  init : function(options){
      var me=this;
      this.workers = [];

      this.nb_workers=options.nbworkers;

      for (var i = 0; i < this.nb_workers; i++) {
	var worker = new Worker("worker.js");
	worker.label=""+i;
	worker.onmessage = function(event) {
	  me.received_block(event.target, event.data)
	}
	worker.idle = true;
	this.workers.push(worker);
      }
      this.grid_size=options.gridsize;
      this.i_completedWorker=0;

      this.j_max = options.y_max;
      this.j_min = options.y_min;
      this.i_min = options.x_min;
      this.i_max = options.x_max;

      this.generation = 0;
      this.nextblock = 0;
    },

  make_palette: function() {
      this.palette = []
      // wrap values to a saw tooth pattern.
      function wrap(x) {
	x = ((x + 256) & 0x1ff) - 256;
	if (x < 0) x = -x;
	return x;
      }
      for (i = 0; i <= this.max_iter; i++) {
	this.palette.push([wrap(7*i), wrap(5*i), wrap(11*i)]);
      }
    },

  draw_block: function(data) {
      var values = data.values;
      var pdata = this.row_data.data;
      var k=0;
      for (var j = data.j_start; j < data.j_end; j++) {
	for (var i = data.i_start; i < data.i_end; i++) {
	  var pixel;
	  pdata[4*k+3] = 255;
	  if (values[k] < 0) {
	    pdata[4*k] = pdata[4*k+1] = pdata[4*k+2] = 0;
	  } else {
	    var colour = this.palette[values[k]];
	    pdata[4*k] = colour[0];
	    pdata[4*k+1] = colour[1];
	    pdata[4*k+2] = colour[2];
	  }
	  k++;
	}
      }
      this.ctx.putImageData(this.row_data, data.i_start, data.j_start);
    },

  draw_init_block: function(data) {
      this.ctx.fillStyle   = '#777'; // blue
      this.ctx.lineWidth   = 0;
      this.ctx.fillRect  (data.i_start, data.j_start, data.i_end-data.i_start, data.j_end-data.j_start);

      this.ctx.fillStyle    = '#fff';
      this.ctx.font         = 'bold '+ this.labelFontWidth + 'px sans-serif';
      this.ctx.textBaseline = 'middle';
      this.ctx.textAlign    = 'center';
      this.ctx.fillText  (data.workerLabel, (data.i_end+data.i_start)/2, (data.j_end+data.j_start)/2);
    },

  received_block: function (worker, data) {
      if (data.generation == this.generation) {
	// Interesting data: display it.
	this.draw_block(data);
      }
      this.process_block(worker);
    },

  block_boundaries: function(ib){
      var icol=ib%this.grid_size;
      var irow=Math.floor(ib/this.grid_size);
      
      var b= {
      i_start:icol*this.block_width,
      i_end:(icol+1)*this.block_width,
      j_start:irow*this.block_height,
      j_end:(irow+1)*this.block_height,
      }

      return b;
    },

  process_block: function(worker) {
      var ib = this.nextblock++;
      if (ib >= this.grid_size*this.grid_size) {
	worker.idle = true;
	if(++this.i_completedWorker==this.nb_workers){
	  this.completed();
	}
      } else {
	worker.idle = false;
        var block=this.block_boundaries(ib);
	var data = {
	width: this.block_width,
	height: this.block_height,
	i_start:block.i_start,
	i_end:block.i_end,
	j_start:block.j_start,
	j_end:block.j_end,

	//	      width: this.row_data.width-100,
	generation: this.generation,
	c_min: this.i_max + (this.i_min - this.i_max) * block.i_start / this.canvas.width,
	c_max: this.i_max + (this.i_min - this.i_max) * block.i_end / this.canvas.width,
	r_min: this.j_max + (this.j_min - this.j_max) * block.j_start / this.canvas.height,
	r_max: this.j_max + (this.j_min - this.j_max) * block.j_end / this.canvas.height,
	max_iter: this.max_iter,
	escape: this.escape,
        workerLabel: worker.label,
	};
	this.draw_init_block(data);

	worker.postMessage(data);
      }
    },

  redraw: function() {
      this.changeBoundaries(this.i_min, this.i_max, this.j_min, this.j_max);
      //clearing the canvas
      this.canvas.width=this.canvas.width;
      this.generation++;
      this.i_completedWorker=0;
      this.nextblock = 0;
      this.start();
      for (var i = 0; i < this.workers.length; i++) {
	var worker = this.workers[i];
	if (worker.idle)
	  this.process_block(worker);
      }
    },

  click: function(x, y) {
      var width = this.i_max - this.i_min;
      var height = this.j_max - this.j_min;
      var click_i = this.i_max - width * x / this.canvas.width;
      var click_j = this.j_max - height * y / this.canvas.height;

      this.i_min = click_i - width/8;
      this.i_max = click_i + width/8;
      this.j_max = click_j + height/8;
      this.j_min = click_j - height/8;
      this.redraw()
    },

  resize_to_parent: function() {
      var cont = $('#canvas-container');
      this.canvas.width = cont.width();
      this.canvas.height = window.innerHeight;

      // Adjust the horizontal scale to maintain aspect ratio
      var width = ((this.j_max - this.j_min) *
		   this.canvas.width / this.canvas.height);
      var i_mid = (this.i_max + this.i_min) / 2;
      var j_mid = (this.j_max + this.j_min) / 2;

      this.block_width=Math.floor(this.canvas.width/this.grid_size+0.999999);
      this.block_height=Math.floor(this.canvas.height/this.grid_size+0.999999);

      this.labelFontWidth=Math.min(this.block_width, this.block_height)/2;

      this.i_min = i_mid - width/2;
      this.i_max = i_mid + width/2;

      // Reallocate the image data object used to draw rows.
      this.row_data = this.ctx.createImageData(this.block_width, this.block_height);

      this.redraw();
    },
  }
