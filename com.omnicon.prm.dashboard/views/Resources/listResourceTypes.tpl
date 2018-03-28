<script>
	$(document).ready(function(){
		$('#viewSkillsResourceByType').DataTable({
			"columns":[
				null,
				{"searchable":false}
			]
		});
		$('#refreshButton').css("display", "none");

		$('#titlePag').html("{{.Title}}");
		$('#backButton').css("display", "inline-block");
		$('#backButtonIcon').html("arrow_back");
		$('#backButtonTooltip').html("Back to resources");
		$('#backButton').prop('onclick',null).off('click');
		$('#backButton').click(function(){
			reload('/resources',{});
		});
		
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			getTypesByResource({{.ResourceID}}, '{{.Title}}');
		}); 
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOptionIcon').html("add");
		$('#buttonOptionTooltip').html("Add new type to resource");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#loadTypesResourceModal");
	});
</script>

<table id="viewSkillsResourceByType" class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp">
	<thead>
		<tr>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Type</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $resourceType := .ResourceTypes}}
		<tr>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$resourceType.Name}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">
				<button id="deleteButton" data-toggle="modal" data-target="#confirmUnassignModal" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="$('#resourceIDToDelete').val({{$resourceType.ResourceId}});$('#typeIDToDelete').val({{$resourceType.TypeId}});$('#nameDelete').html({{$resourceType.Name}});" data-dismiss="modal">
					<i class="material-icons" style="vertical-align: inherit;">delete</i>
				</button>
				<div class="mdl-tooltip" for="deleteButton">
					Delete project	
				</div>	
			</td>
		</tr>
		{{end}}
	</tbody>
</table>


<div class="modal fade" id="loadTypesResourceModal" role="dialog">
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
        <button type="button" id="typeCreate" class="btn btn-default" onclick="addTypeToResource({{.ResourceID}}, $('#typeID').val(), {{.Title}})" data-dismiss="modal">Add</button>
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
				<input type="hidden" id="resourceIDToDelete">
				<input type="hidden" id="typeIDToDelete">        		
					Are you sure that you want to unassign <b id="nameDelete"></b> from <b>{{.Title}}</b> resource?
      		</div>
			<div class="modal-footer" style="text-align:center;">
				<button type="button" id="resourceUnassign" class="btn btn-default" onclick="unassignResourceType($('#resourceIDToDelete').val(),$('#typeIDToDelete').val(),{{.Title}})" data-dismiss="modal">Yes</button>
				<button type="button" class="btn btn-default" data-dismiss="modal">No</button>
			</div>
		</div>
	</div>
</div>