<script>
	$(document).ready(function(){
		$('#viewSkillsInResource').DataTable({

		});
		$('#titlePag').html("{{.Title}}")
		$('#backButton').css("display", "inline-block");
		$('#backButton').html("Resources");
		$('#backButton').click(function(){
			reload('/resources',{});
		}); 
	});
</script>
<table id="viewSkillsInResource" class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>Name</th>
			<th>Value</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $skill := .Skills}}
		<tr>
			<td>{{$skill.Name}}</td>
			<td>{{$skill.Value}}</td>
			<td>
				<button class="buttonTable button2" data-toggle="modal" data-target="#skillModal" onclick="configureUpdateModal({{$skill.ID}},'{{$skill.Name}}')" data-dismiss="modal" disabled>Update</button>
				<button data-toggle="modal" data-target="#confirmModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$skill.Name}}');$('#skillID').val({{$skill.ID}});" data-dismiss="modal" disabled>Delete</button>
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>