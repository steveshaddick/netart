var Chart = function($element, countLabel) {
	this.$element = $element;
	this.countLabel = countLabel;

	this.$bar = $(".bar", $element);
	this.$barCount = $(".barCount", $element);
	this.totalWidth = 0;
	this.totalCount = 0;
	this.currentWidth = 0;
	this.currentCount = 0;

	this.widthPerFrame = 0;
	this.countPerFrame = 0;
}
Chart.prototype.initValues = function(data) {
	this.totalWidth = data.width;
	this.totalCount = data.count;
	this.widthPerFrame = data.width / data.frames;
	this.countPerFrame = data.count / data.frames;

	this.currentWidth = 0;
	this.currentCount = 0;
}
Chart.prototype.growChart = function() {

	var newCount = parseInt(this.currentCount + this.countPerFrame);
	if (newCount >= this.totalCount) {
		return true;
	} else {
		this.currentCount = newCount;
		this.currentWidth += this.widthPerFrame;
		this.updateView();
		return false;
	}
}
Chart.prototype.setTotal = function() {
	this.currentCount = this.totalCount;
	this.currentWidth = this.totalWidth;
	this.updateView();
}
Chart.prototype.updateView = function() {
	this.$bar.css('width', this.currentWidth + '%');
	this.$barCount.html(this.currentCount + ' ' + this.countLabel);
}



var Main = (function() {

	var $form;
	var $output;
	var $txtLink;
	var $statsWrapper;

	var chart_0;
	var chart_1;


	var comm = false;
	var id = '';
	var maxBarWidth = 0;
	var url;

	function init(data) {

		$form = $("#frmLink");
		$form.submit(formSubmit);

		$txtLink = $("#txtLink");

		$output = $("#outputArea");
		$statsWrapper = $("#statsWrapper");

		chart_0 = new Chart($("#chart_0"), "0s");
		chart_1 = new Chart($("#chart_1"), "1s");

		maxBarWidth = 80;

		id = data.id;

	}

	function formSubmit(e) {
		
		if (comm) return false;
		comm = true;

		url = $.trim($txtLink .val());

		$txtLink[0].disabled = true;
		$("#spinner").removeClass('disabled');
		$statsWrapper.removeClass('open');

		$.ajax({
			url: 'php/BinaryMain.php',
			type: 'POST',
			data: {
				id:id, 
				action:'readLink', 
				url: url
			},
			dataType: 'json',
			success: formReturn

		});

		return false;
	}

	function formReturn(data) {

		$("#spinner").addClass('disabled');
		$txtLink[0].disabled = false;

		if (data.success !== 'true') {
			$("#urlError").removeClass('disabled');
			setTimeout(function() {
				$("#urlError").fadeOut(3000, function() { $("#urlError").css('display', '').addClass('disabled'); } );
			}, 2000);
			comm = $txtLink[0].disabled = false;
			return;
		}

		var zeroes = data.binary[0];
		var ones = data.binary[1];

		$("#urlResponse").html(url);
		
		var canvas = document.getElementById('canvas');
		var ctx = canvas.getContext('2d');
		canvas.width  = 440;
		var len = data.binary.all.length;
		canvas.height  = Math.ceil(len / 440);
		ctx.clearRect(0, 0, canvas.width, canvas.height);
		var x=0,y=0;
		var digit='';
		for (var i=0; i<len; i++) {
			digit = data.binary.all.charAt(i);
			if (digit == '0') {
				ctx.fillStyle = "rgba(0,0,0,1)";
			} else {
				ctx.fillStyle = "rgba(255,255,255,1)";
			}
			ctx.fillRect( x, y, 1, 1 );
			x++;
			if (x == 440) {
				x = 0;
				y++;
			}
		}
		return;

		var frames = 25;
		var largest = Math.max(zeroes, ones);

		if (largest < 1000) {
			frames = 20;
		} else if (largest < 10000) {
			frames = (Math.random() * 30) + 20;
		} else {
			frames = (Math.random() * 40) + 40;
		}

		if (zeroes > ones) {
			chart_0.initValues({
				width: maxBarWidth,
				count: zeroes,
				frames: frames
			});
			chart_1.initValues({
				width: maxBarWidth * (ones / zeroes),
				count: ones,
				frames: frames
			});

		} else {
			chart_0.initValues({
				width: maxBarWidth * (zeroes / ones),
				count: zeroes,
				frames: frames
			});
			chart_1.initValues({
				width: maxBarWidth,
				count: ones,
				frames: frames
			});
		}

		tick();


	}

	function tick() {
		
		if ((chart_0.growChart()) || (chart_1.growChart())) {
			chart_0.setTotal();
			chart_1.setTotal();

			comm = $txtLink[0].disabled = false;



			$statsWrapper.addClass('open');

		} else {
			setTimeout(tick, 40);
		}

		
	}

	return {
		init: init
	}

})();