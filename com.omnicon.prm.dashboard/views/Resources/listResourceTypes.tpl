<script>
	$(document).ready(function(){
		$('.modal-trigger').leanModal();
		$('.tooltipped').tooltip();
		$('select').material_select();
		$('#viewSkillsResourceByType').DataTable({
			"iDisplayLength": 20,
			"bLengthChange": false,
			"columns":[
				null,
				{"searchable":false}
			]
		});
		$('#refreshButton').css("display", "none");

		$('#titlePag').html("{{.Title}}");
		$('#backButton').css("display", "inline-block");
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
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("href", "#loadTypesResourceModal");
	});
</script>

<div class="container" style="padding:15px;">
	<div class="row">
		<div class="col s12   marginCard">
			<div id="pry_add">
				<h4 id="titlePag"></h4>
				<a id="backButton" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Back"  ><i class="mdi-navigation-arrow-back large"></i></a>
				<a id="refreshButton" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Refresh"  ><i class="mdi-navigation-refresh large"></i></a>
				<a id="buttonOption" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Set Type"><i class="mdi-action-note-add large"></i></a>
			</div>
		</div>
		<table id="viewSkillsResourceByType" class="display TableConfig responsive-table marginCard " cellspacing="0" width="100%">
			<thead>
				<tr>
					<th>Type</th>
					<th>Options</th>
				</tr>
			</thead>
			<tbody>
				{{range $key, $resourceType := .ResourceTypes}}
				<tr>
					<td>{{$resourceType.Name}}</td>
					<td>
						<a class='modal-trigger tooltipped' href="#confirmUnassignModal" data-position="top" data-tooltip="Unassign"  onclick="$('#resourceIDToDelete').val({{$resourceType.ResourceId}});$('#typeIDToDelete').val({{$resourceType.TypeId}});$('#nameDelete').html({{$resourceType.Name}});" data-dismiss="modal"><i class="mdi-action-delete"></i></a>	
					<!--	<button data-toggle="modal" data-target="#confirmUnassignModal" class="buttonTable button2" onclick="$('#resourceIDToDelete').val({{$resourceType.ResourceId}});$('#typeIDToDelete').val({{$resourceType.TypeId}});$('#nameDelete').html({{$resourceType.Name}});" data-dismiss="modal">Unassign</button>-->
					</td>
				</tr>
				{{end}}
			</tbody>
		</table>
	</div>
</div>


<!--
<div class="modal fade" id="loadTypesResourceModal" role="dialog">
  <div class="modal-dialog">
   
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
</div> -->

<!-- Materialize Modal Update -->
	<div id="loadTypesResourceModal" class="modal " style = "overflow:visible" >
			<div class="modal-content">
				<h5 id="modalUpdateResourceProjectTitle" class="modal-title">Create/Update Type</h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="typeeID">	
				<div id="divSkillType" class="input-field row">	
					<!-- Select -->
					<div class="input-field col s12 ">
						<label for="projectNames"  class= "active">Project Name</label>
						<select  id="typeID">
							<option value="">Please select an option</option>
							{{range $key, $type := .Types}}
								<option value="{{$type.ID}}">{{$type.Name}}</option>
							{{end}}
						</select>
					</div>
					<!-- Close Select -->	
				</div>
			</div>
			<div class="modal-footer">
				<a id="typeCreate" onclick="addTypeToResource({{.ResourceID}}, $('#typeID').val(), {{.Title}})"  class="waves-effect waves-green btn-flat modal-action modal-close" >Set</a>
       	<a class="waves-effect waves-red btn-flat modal-action modal-close">Cancel</a>
			</div>
	</div>
    
<!-- Modal Update-->





<!-- Materialize Modal Unassign -->
<div id="confirmUnassignModal" class="modal" >
			<div class="modal-content">
				<h5  class="modal-title">Unassign Confirmation</h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="resourceIDToDelete">
				<input type="hidden" id="typeIDToDelete"> 
					Are you sure that you want to unassign <b id="nameDelete"></b> from <b>{{.Title}}</b> resource?
			</div>
			<div class="modal-footer">
				<a id="resourceUnassign"  onclick="unassignResourceType($('#resourceIDToDelete').val(),$('#typeIDToDelete').val(),{{.Title}})" class="waves-effect waves-green btn-flat modal-action modal-close" >Yes</a>
        		<a class="waves-effect waves-red btn-flat modal-action modal-close">No</a>
			</div>
</div>

<!-- Modal Unassign close -->
<!-- Modal content
<div class="modal fade" id="confirmUnassignModal" role="dialog">
	<div class="modal-dialog">
    
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
</div>-->