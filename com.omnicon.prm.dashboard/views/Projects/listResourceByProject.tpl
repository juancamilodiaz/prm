<script>
	$(document).ready(function(){
		$('#viewResourceInProject').DataTable({

		});
		$('#titlePag').html("{{.Title}}")
	});
</script>
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
			<td>{{$resourceToProject.ResourceId}}</td>
			<td>{{dateformat $resourceToProject.StartDate "2006-01-02"}}</td>
			<td>{{dateformat $resourceToProject.EndDate "2006-01-02"}}</td>
			<td>{{$resourceToProject.Lead}}</td>
			<td>
				<button class="BlueButton" data-toggle="modal" data-target="#projectModal" onclick="$('#projectID').val({{$resourceToProject.ProjectId}});" data-dismiss="modal" disabled>Unassign of project</button>
				<button data-toggle="modal" data-target="#confirmModal" class="BlueButton" onclick="$('#nameDelete').html('{{$resourceToProject.ResourceId}}');$('#projectID').val({{$resourceToProject.ProjectId}});" data-dismiss="modal" disabled>Update assign</button>
				<button class="BlueButton" onclick="getResourcesByProject({{$resourceToProject.ResourceId}});" data-dismiss="modal" disabled>Resource Info.</button>
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>