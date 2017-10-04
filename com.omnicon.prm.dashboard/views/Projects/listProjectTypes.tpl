<script>
	$(document).ready(function(){
		$('#viewSkillsByType').DataTable({
			"columns":[
				null,
				{"searchable":false}
			]
		});
		$('#refreshButton').css("display", "none");

		$('#titlePag').html("{{.Title}}");
		$('#backButton').css("display", "inline-block");
		$('#backButton').html("Projects");
		$('#backButton').prop('onclick',null).off('click');
		$('#backButton').click(function(){
			reload('/projects',{});
		});
		
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			getTypesByProject({{.ProjectID}}, '{{.Title}}');
		}); 
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').html("Set Type");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#loadTypesModal");
	});
</script>

<table id="viewSkillsByType" class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>Type</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $projectType := .ProjectTypes}}
		<tr>
			<td>{{$projectType.Name}}</td>
			<td>
				<button data-toggle="modal" data-target="#confirmUnassignModal" class="buttonTable button2" onclick="$('#projectIDToDelete').val({{$projectType.ProjectId}});$('#typeIDToDelete').val({{$projectType.TypeId}});$('#nameDelete').html({{$projectType.Name}});" data-dismiss="modal">Unassign</button>
			</td>
		</tr>
		{{end}}
	</tbody>
</table>


<div class="modal fade" id="loadTypesModal" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 id="modalTitle" class="modal-title">Create/Update Type</h4>
      </div>
      <div class="modal-body">
        <input type="hidden" id="typeeID">
		<div id="divSkillType" class="form-group form-group-sm">
      		<label class="control-label col-sm-4 translatable" data-i18n="Types"> Types </label> 
           	<div class="col-sm-8">
            	<select  id="typeID">
					<option value="">Please select an option</option>
					{{range $key, $type := .Types}}
						<option value="{{$type.ID}}">{{$type.Name}}</option>
					{{end}}
			</select>
             </div>    
         </div>
      </div>
      <div class="modal-footer">
        <button type="button" id="typeCreate" class="btn btn-default" onclick="addTypeToProject({{.ProjectID}}, $('#typeID').val(), {{.Title}})" data-dismiss="modal">Add</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
      </div>
    </div>
    
  </div>
</div>

<div class="modal fade" id="confirmUnassignModal" role="dialog">
	<div class="modal-dialog">
    <!-- Modal content-->
    	<div class="modal-content">
      		<div class="modal-header">
        		<button type="button" class="close" data-dismiss="modal">&times;</button>
        		<h4 class="modal-title">Unassign Confirmation</h4>
      		</div>
      		<div class="modal-body">
				<input type="hidden" id="projectIDToDelete">
				<input type="hidden" id="typeIDToDelete">        		
					Are you sure that you want to unassign <b id="nameDelete"></b> from <b>{{.Title}}</b> project?
      		</div>
			<div class="modal-footer" style="text-align:center;">
				<button type="button" id="resourceUnassign" class="btn btn-default" onclick="unassignProjectType($('#projectIDToDelete').val(),$('#typeIDToDelete').val(),{{.Title}})" data-dismiss="modal">Yes</button>
				<button type="button" class="btn btn-default" data-dismiss="modal">No</button>
			</div>
		</div>
	</div>
</div>