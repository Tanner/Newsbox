<script type="text/javascript">

function resize() {
	var imgs = document.getElementsByTagName("img");
	for (var i = 0; i < imgs.length; i++) {
		var w = imgs[i].width;
		var h = imgs[i].height;
		if (w * h < 4000) 
			imgs[i].className += "smallImage";
	}
}

</script>