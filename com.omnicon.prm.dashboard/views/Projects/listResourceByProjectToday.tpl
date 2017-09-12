<script>
	$(document).ready(function(){
			
		{{range $key, $resource := .Resources}}
			$("#resources").append('<p id="drag' + {{$key}} + '" draggable="true" ondragstart="drag(event)">'+ {{$resource.Name}} + '</p>')
		{{end}}	
		
		{{range $key, $project := .Projects}}
		 	$("#projects").append('<div class="panel panel-default">'+
			'<div id="project'+ {{$key}} + '" class="panel-heading">' + {{$project.Name}}+ '</div>'+
			'<div class="panel-body" ondrop="drop(event)" ondragover="allowDrop(event)"></div>'+
			'</div>')
		{{end}}	
	});
	
	unassignResource = function(){
		var settings = {
			method: 'POST',
			url: '/projects/resources/unassign',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"resourceID": $('#resourceID').val(),
				"projectID": $('#projectID').val()
			}
		}
		console.log(settings);
		$.ajax(settings).done(function (response) {
		  reload('/projects/resources', {"ID": $('#projectID').val(),"ProjectName": "{{.Title}}"})
		});
	}
</script>


<script>
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
</script>


	<div class="row">
		<div class="col-sm-4">
			<div id="resources">
			</div>
		</div>
		<div class="col-sm-4">
	<div class="panel-group">
	    <div id="projects" class="panel">
	
	    </div>
	</div>
