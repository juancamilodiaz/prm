<script>
	$(document).ready(function(){
		$('.modal-trigger').leanModal();
		$('.tooltipped').tooltip();
		$('#viewSkills').DataTable({			
			"iDisplayLength": 20,
			"bLengthChange": false,
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
<div class="container">
	<div class="row">
		<div class= "col s12 m12  marginCard">
				<div id="pry_add">
					<h4 >Skills</h4>
					<a class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Create Skill" href="#skillModal" onclick="configureCreateModal()"><i class="mdi-action-note-add large"></i></a>
				</div>
				
				<table id="viewSkills" class="display TableConfig " cellspacing="0" width="100%">
					<thead>
						<tr>
							<th>Name</th>
							<th>Options</th>
						</tr>
					</thead>
					<tbody>
						{{range $key, $skilll := .Skills}}
						<tr>
							<td>{{$skilll.Name}}</td>
							<td>
								<a class='modal-trigger tooltipped' data-position="top" data-tooltip="Edit"  href="#skillModal"  onclick="configureUpdateModal({{$skilll.ID}},'{{$skilll.Name}}')"><i class="mdi-editor-mode-edit"></i></a>
								<a class='modal-trigger tooltipped' data-position="top" data-tooltip="Delete"  href='#confirmModal' onclick="$('#nameDelete').html('{{$skilll.Name}}');$('#skillID').val({{$skilll.ID}});"><i class="mdi-action-delete"></i></a>
								<!--<button class="buttonTable button2" data-toggle="modal" data-target="#skillModal" onclick="configureUpdateModal({{$skilll.ID}},'{{$skilll.Name}}')" data-dismiss="modal">Update</button>
								<button data-toggle="modal" data-target="#confirmModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$skilll.Name}}');$('#skillID').val({{$skilll.ID}});" data-dismiss="modal">Delete</button> -->
							</td>
						</tr>
						{{end}}	
					</tbody>
				</table>
			</div>

		</div>	
</div>
<!-- Modal -->

    <!-- Modal content-->
   <!-- <div class="modal-content">
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

					<div class="input-field">
							<input id="last_name" type="text" class="validate">
							<label id="skillName" for="last_name" data-i18n="Name" class="">Name</label>
					</div>
        </div>
      </div>
      <div class="modal-footer">
				<a onclick="createSkill()" class="waves-effect waves-green btn-flat modal-action modal-close" >Create</a>
				<a onclick="updateSkill()" class="waves-effect waves-blue btn-flat modal-action modal-close"  >Update</a>
        <a class="waves-effect waves-red btn-flat modal-action modal-close">Cancel</a>
      </div>
    </div>-->


		<div id="skillModal" class="modal" >
			<div class="modal-content">
				<h5 id="modalTitle" class="modal-title">Create/Update Skill</h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="skillID">
				<div class="input-field">
							<input id="skillName" type="text" class="validate">
							<label  for="last_name"  class="active">Name</label>
				</div>
			</div>
			<div class="modal-footer">
				<a onclick="createSkill()" class="waves-effect waves-green btn-flat modal-action modal-close" >Create</a>
				<a onclick="updateSkill()" class="waves-effect waves-blue btn-flat modal-action modal-close"  >Update</a>
        <a class="waves-effect waves-red btn-flat modal-action modal-close">Cancel</a>
			</div>
		</div>
    


<div id="confirmModal" class="modal" >
			<div class="modal-content">
				<h5 id="modalTitle" class="modal-title">Delete Confirmation</h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="skillID">
				Are you sure you want to remove <b id="nameDelete"></b> from skills?
				<br>
				<li>The resources will lose this skill assignment.</li>
				<li>The types will lose this skill assignment.</li>
				<li>The training and the training's assignations will lose this skill assignment and they will be eliminated.</li>
			</div>
			<div class="modal-footer">
				<a onclick="deleteSkill()" class="waves-effect waves-green btn-flat modal-action modal-close" >Yes</a>
        <a class="waves-effect waves-red btn-flat modal-action modal-close">No</a>
			</div>
</div>



