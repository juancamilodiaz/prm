

function allowDrop(ev) {
  ev.preventDefault();
}

function drag(ev) {
  ev.dataTransfer.setData("text", ev.target.id);
}

function drop(ev) {
  ev.preventDefault();
  var data = ev.dataTransfer.getData("text");
  ev.target.appendChild(document.getElementById(data));
}

function link(id){
	$.ajax({
	  	async: true,
	  	url: "resources",
	  	method: "GET",
	  	processData: true,
		data: {},
		dataType: "html"
	}).done(function( msg ) {
	  	$( "#content" ).html( msg );
	});
}

$(document).ready(
	function(){
		$('#sidebar').collapse();
		$("#NavMenuButton").click(function(e) {
		  	e.preventDefault();
		  	$('#sidebar').toggleClass('collapsed');
		});
	}
);
