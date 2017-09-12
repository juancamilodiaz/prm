<script>
	$(document).ready(function(){
			
		{{range $key, $resource := .Resources}}
			$("#resources").append('<p id="drag' + {{$key}} + '" draggable="true" ondragstart="drag(event,'+{{$resource.ID}}+')">'+ {{$resource.Name}} + ' '+ {{$resource.LastName}}+'</p>')
		{{end}}	
		
		{{$projectsLoop := .Projects}}
		{{$resourcesProject := .ResourcesToProjects}}
		{{range $key, $project := $projectsLoop}}
		 	$("#projects").append('<div class="panel panel-default">'+
			'<div id="project'+ {{$key}} + '" class="panel-heading">' + {{$project.Name}}+ '</div>'+
			'<div class="panel-body" ondrop="drop(event,'+ {{$project.ID}} +')" ondragover="allowDrop(event)">'
		{{range $keyR, $resProj := $resourcesProject}}
			{{if eq  $resProj.ProjectId $project.ID}}
				+'<p id="res'  + {{$keyR}} + '">'+ {{$resProj.ResourceName}} 
				+'<a class="btn" onclick="unassignResource('+{{$resProj.ProjectId}}+','+ {{$resProj.ResourceId}}+', this)">x</a>'
				+'</p>'
			{{end}}
		{{end}}
			+'</div>'+'</div>');
		{{end}}	
	});
	
	unassignResource = function(projectID, resourceID, obj){
		var settings = {
			method: 'POST',
			url: '/projects/resources/unassign',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"resourceID": resourceID,
				"projectID": projectID
			}
		}
		$.ajax(settings).done(function (response) {
			$(obj).parent().remove();
		});
	}
	

		

</script>

<script>
$( "btn" ).click(function() {
		  $( "p" ).remove(":contains('Juan Torres')");
		});
</script>

<script>

setResourceToProject = function(resourceId, projectId){
	var settings = {
		method: 'POST',
		url: '/projects/setresource',
		headers: {
			'Content-Type': undefined
		},
		data: { 
			"ProjectId": parseInt(projectId),
			"ResourceId": parseInt(resourceId),
			"StartDate": "2017-09-12",
			"EndDate": "2017-09-12"
		}
	}
	console.log(settings);
	$.ajax(settings).done(function (response) {
	  
	});
}

function allowDrop(ev) {
    ev.preventDefault();
}

function drag(ev, resourceID) {
    ev.dataTransfer.setData("text", ev.target.id);
	ev.dataTransfer.setData("resourceID", resourceID);
}

function drop(ev, projectID) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("text");
	console.log(ev.dataTransfer.getData("resourceID"));
	console.log(projectID);
    ev.target.appendChild(document.getElementById(data));
	
	setResourceToProject(ev.dataTransfer.getData("resourceID"), projectID);
}

function remove(projectID, resourceID){
	console.log(projectID);
	console.log(resourceID);
}

</script>


	<div class="row">
		<div class="col-sm-2">
			<div class="panel-group" >
				<div class="panel panel-default">
					<div class="panel-heading">Resources</div>
					<div id="resources" class="panel-body"></div>
				</div>
			</div>
		</div>
		<div class="col-sm-3">
			<div class="panel-group">
	    		<div id="projects" class="panel"></div>
			</div>
		</div>
	</div>
