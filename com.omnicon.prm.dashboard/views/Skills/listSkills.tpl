<script>
	$(document).ready(function(){
		$('#viewSkills').DataTable({
			"columns":[
				null,
				{"searchable":false}
			]
		});
		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		sendTitle("Skills");
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/skills',{});
		});
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOptionIcon').html("add");
		$('#buttonOptionTooltip').html("Add new skill");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#skillModal");
		$('#buttonOption').attr("onclick","configureCreateModal()");
	});
	
	configureCreateModal = function(){
		
		$("#skillID").val(null);
		$("#skillName").val(null);
		
		$("#modalTitle").html("Create Skill");
		$("#skillUpdate").css("display", "none");
		$("#skillCreate").css("display", "inline-block");
	}
	
	configureUpdateModal = function(pID, pName){
		
		$("#skillID").val(pID);
		$("#skillName").val(pName);
		
		$("#modalTitle").html("Update Skill");
		$("#skillCreate").css("display", "none");
		$("#skillUpdate").css("display", "inline-block");
	}

	createSkill = function(){
		var settings = {
			method: 'POST',
			url: '/skills/create',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"Name": $('#skillName').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/skills', {});
		});
	}
	
	updateSkill = function(){
		var settings = {
			method: 'POST',
			url: '/skills/update',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#skillID').val(),
				"Name": $('#skillName').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/skills', {});
		});
	}
	
	read = function(){
		var settings = {
			method: 'POST',
			url: '/skills/read',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#skillName').val(),
			}
		}
		$.ajax(settings).done(function (response) {
		});
	}
	
	deleteSkill = function(){
		var settings = {
			method: 'POST',
			url: '/skills/delete',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#skillID').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/skills', {});
		});
	}
	
</script>
<div>
<table id="viewSkills" class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp">
	<thead>
		<tr>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Name</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $skilll := .Skills}}
		<tr>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$skilll.Name}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">
				<button id="editButton{{$skilll.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" data-toggle="modal" data-target="#skillModal" onclick="configureUpdateModal({{$skilll.ID}},'{{$skilll.Name}}')" data-dismiss="modal">
					<i class="material-icons" style="vertical-align: inherit;">mode_edit</i>
				</button>
				<div class="mdl-tooltip" for="editButton{{$skilll.ID}}">
					Edit skill	
				</div>	
				<button id="deleteButton{{$skilll.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" data-toggle="modal" data-target="#confirmModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$skilll.Name}}');$('#skillID').val({{$skilll.ID}});" data-dismiss="modal">
					<i class="material-icons" style="vertical-align: inherit;">delete</i>
				</button>
				<div class="mdl-tooltip" for="deleteButton{{$skilll.ID}}">
					Delete skill	
				</div>	
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>

</div>

<!-- Modal -->
<div class="modal fade" id="skillModal" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 id="modalTitle" class="modal-title">Create/Update Skill</h4>
      </div>
      <div class="modal-body">
        <input type="hidden" id="skillID">
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Name"> Name </label>
              <div class="col-sm-8">
              	<input type="text" id="skillName" style="border-radius: 8px;">
        		</div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" id="skillCreate" class="btn btn-default" onclick="createSkill()" data-dismiss="modal">Create</button>
        <button type="button" id="skillUpdate" class="btn btn-default" onclick="updateSkill()" data-dismiss="modal">Update</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
      </div>
    </div>
    
  </div>
</div>
<div class="modal fade" id="confirmModal" role="dialog">
<div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Delete Confirmation</h4>
      </div>
      <div class="modal-body">
        Are you sure you want to remove <b id="nameDelete"></b> from skills?
		<br>
		<li>The resources will lose this skill assignment.</li>
		<li>The types will lose this skill assignment.</li>
		<li>The training and the training's assignations will lose this skill assignment and they will be eliminated.</li>
      </div>
      <div class="modal-footer" style="text-align:center;">
        <button type="button" id="skillDelete" class="btn btn-default" onclick="deleteSkill()" data-dismiss="modal">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>