<script>
	$(document).ready(function(){
		$('#refreshButton').css("display", "none");

		$('#titlePag').html("{{.Title}}");
		$('#backButton').css("display", "inline-block");
		$('#backButton').html("Projects");
		$('#backButton').prop('onclick',null).off('click');
		$('#backButton').click(function(){
			reload('/projects',{});
		});
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').html("Set Type");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#loadTypesModal");
	});
</script>

<p class="pull-right" style="padding-right: 0%;"> <label type="text" id="dates"/></p>
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
			<td>{{$projectType.TypeId}}</td>
			<td>
				<button data-toggle="modal" data-target="#confirmUnassignModal" class="buttonTable button2" onclick="unassignProjectType({{$projectType.ProjectId}},{{$projectType.TypeId}})" data-dismiss="modal">Unassign</button>
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
				{{range $key, $type := .Types}}
					<option value="{{$type.ID}}-{{$type.Name}}">{{$type.Name}}</option>
				{{end}}
			</select>
             </div>    
         </div>
      </div>
      <div class="modal-footer">
        <button type="button" id="typeCreate" class="btn btn-default" onclick="addTypeToProject({{.ProjectID}}, $('#typeID').val())" data-dismiss="modal">Add</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
      </div>
    </div>
    
  </div>
</div>