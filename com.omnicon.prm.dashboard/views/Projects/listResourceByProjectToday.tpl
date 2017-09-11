<script>
	$(document).ready(function(){
		$('#viewResourceInProject').DataTable({

		});
		$('#titlePag').html("{{.Title}}");
		$('#backButton').css("display", "inline-block");
		$('#backButton').html("Projects");
		$('#backButton').click(function(){
			reload('/projects',{});
		}); 
		
		{{range $key, $resourceToProject := .ResourcesToProjects}}
			$("#resources").append('<p id="drag' + {{$key}} + '" draggable="true" ondragstart="drag(event)">'+ {{$resourceToProject.ResourceName}} + '</p>')
			$("#projects").append('<p id="drag' + {{$key}} + '" draggable="true" ondragstart="drag(event)">'+ {{$resourceToProject.ResourceName}} + '</p>')
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

<style>
#div1, #div2 {
    width: 350px;
    height: 70px;
    padding: 10px;
    border: 1px solid #aaaaaa;
}
</style>

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

<div id="resources">

</div>

<div id="projects">

</div>

<div id="div1" ondrop="drop(event)" ondragover="allowDrop(event)"></div>
<div id="div2" ondrop="drop(event)" ondragover="allowDrop(event)"></div>
<br>
<p id="drag1" draggable="true" ondragstart="drag(event)">Anderson</p>

<table id="viewResourceInProject" class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>Resource Name</th>
			<th>Start Date</th>
			<th>End Date</th>
			<th>Lead</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $resourceToProject := .ResourcesToProjects}}
		<tr>
			<td>{{$resourceToProject.ResourceName}}</td>
			<td>{{dateformat $resourceToProject.StartDate "2006-01-02"}}</td>
			<td>{{dateformat $resourceToProject.EndDate "2006-01-02"}}</td>
			<td>{{$resourceToProject.Lead}}</td>
			<td>
				<button data-toggle="modal" data-target="#confirmUnassignModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$resourceToProject.ResourceName}}');$('#resourceID').val({{$resourceToProject.ResourceId}});$('#projectID').val({{$resourceToProject.ProjectId}});" data-dismiss="modal">Unassign of project</button>
				<button data-toggle="modal" data-target="#confirmModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$resourceToProject.ResourceId}}');$('#projectID').val({{$resourceToProject.ProjectId}});" data-dismiss="modal" disabled>Update assign</button>
				<button class="buttonTable button2" onclick="getResourcesByProject({{$resourceToProject.ResourceId}});" data-dismiss="modal" disabled>Resource Info.</button>
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>

	<div class="modal fase" id="confirmUnassignModal" role="dialog">
		<div class="modal-dialog">
	    <!-- Modal content-->
	    	<div class="modal-content">
	      		<div class="modal-header">
	        		<button type="button" class="close" data-dismiss="modal">&times;</button>
	        		<h4 class="modal-title">Unassign Confirmation</h4>
	      		</div>
	      		<div class="modal-body">
					<input type="hidden" id="resourceID">
	        		<input type="hidden" id="projectID">
						Are you sure that you want to unassign <b id="nameDelete"></b> from <b>{{.Title}}</b> project?
	      		</div>
	      	<div class="modal-footer" style="text-align:center;">
	    	<button type="button" id="resourceUnassign" class="btn btn-default" onclick="unassignResource()" data-dismiss="modal">Yes</button>
	    	<button type="button" class="btn btn-default" data-dismiss="modal">No</button>
	    </div>
	</div>
</div>
</div>