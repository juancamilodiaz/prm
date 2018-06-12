<script>
	$(document).ready(function(){
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-menu'));
		getmdlSelect.init(".getmdl-select");
		
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
		$('#buttonOption').attr("onclick","configureCreateModal()");
		
		var dialogSkills = document.querySelector('#skillModal');
		dialogSkills.querySelector('#cancelSkillDialogButton')
		    .addEventListener('click', function() {
		      dialogSkills.close();	
    	});
		
		var dialogSkillDelete = document.querySelector('#confirmModal');
		dialogSkillDelete.querySelector('#cancelSkillDeleteDialogButton')
		    .addEventListener('click', function() {
		      dialogSkillDelete.close();	
    	});
	});
	
	configureCreateModal = function(){
		
		$("#skillID").val(null);
		$("#skillName").val(null);
		
		$("#modalTitle").html("Create Skill");
		$("#skillUpdate").css("display", "none");
		$("#skillCreate").css("display", "inline-block");
		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		getmdlSelect.init(".getmdl-select");
		$('.mdl-textfield>input').each(function(param){
			$(this).parent().addClass('is-invalid');
			$(this).parent().removeClass('is-dirty');
		});
		
		var dialog = document.querySelector('#skillModal');
		dialog.showModal();
	}
	
	configureUpdateModal = function(pID, pName){
		
		$("#skillID").val(pID);
		$("#skillName").val(pName);
		
		$("#modalTitle").html("Update Skill");
		$("#skillCreate").css("display", "none");
		$("#skillUpdate").css("display", "inline-block");
		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		getmdlSelect.init(".getmdl-select");
		
		$('.mdl-textfield>input').each(function(param){
			if($(this).val() != ""){
				$(this).parent().addClass('is-dirty');
				$(this).parent().removeClass('is-invalid');
			}
			if($(this).val() == "" && $(this).prop("required")){
				$(this).parent().removeClass('is-dirty');
				$(this).parent().addClass('is-invalid');
			}
		});
		
		var dialog = document.querySelector('#skillModal');
		dialog.showModal();
	}
	
	configureDeleteModal = function(){
		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		getmdlSelect.init(".getmdl-select");
		
		var dialog = document.querySelector('#confirmModal');
		dialog.showModal();
	}

	createSkill = function(){
		if (document.getElementById("formCreateUpdate").checkValidity()) {
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
				<button id="editButton{{$skilll.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="configureUpdateModal({{$skilll.ID}},'{{$skilll.Name}}')" data-dismiss="modal">
					<i class="material-icons" style="vertical-align: inherit;">mode_edit</i>
				</button>
				<div class="mdl-tooltip" for="editButton{{$skilll.ID}}">
					Edit skill	
				</div>	
				<button id="deleteButton{{$skilll.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="$('#nameDelete').html('{{$skilll.Name}}');$('#skillID').val({{$skilll.ID}});configureDeleteModal()" data-dismiss="modal">
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
<dialog class="mdl-dialog" id="skillModal">
	<h4 id="modalTitle" class="mdl-dialog__title"></h4>
	<div class="mdl-dialog__content">
		<form id="formCreateUpdate" action="#">
			<input type="hidden" id="skillID">
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
			  <input class="mdl-textfield__input" type="text" id="skillName" required>
			  <label class="mdl-textfield__label" for="skillName">Name...</label>
			</div>	
		</from>
	</div>
	<div class="mdl-dialog__actions">
		<button type="button" id="skillCreate" class="mdl-button" onclick="createSkill()" data-dismiss="modal">Create</button>
		<button type="button" id="skillUpdate" class="mdl-button" onclick="updateSkill()" data-dismiss="modal">Update</button>
      	<button id="cancelSkillDialogButton" type="button" class="mdl-button close" data-dismiss="modal">Cancel</button>
    </div>
</dialog>

<dialog class="mdl-dialog" id="confirmModal">
	<h4 id="modalTitle" class="mdl-dialog__title">Delete Confirmation</h4>
	<div class="mdl-dialog__content">
		Are you sure you want to remove <b id="nameDelete"></b> from skills?
		<br>
		<li>The resources will lose this skill assignment.</li>
		<li>The types will lose this skill assignment.</li>
		<li>The training and the training's assignations will lose this skill assignment and they will be eliminated.</li>
	</div>
	<div class="mdl-dialog__actions">
		<button type="button" id="skillDelete" class="mdl-button" onclick="deleteSkill()" data-dismiss="modal">Yes</button>
		<button id="cancelSkillDeleteDialogButton" type="button" class="mdl-button close" data-dismiss="modal">No</button>
    </div>
</dialog>