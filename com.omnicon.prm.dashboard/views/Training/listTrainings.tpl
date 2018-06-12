<script>
	$(document).ready(function(){
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-menu'));
		getmdlSelect.init(".getmdl-select");
		
		$('#viewTrainings').DataTable({
			"columns":[
				null,
				null,
				null,
				{"searchable":false}
			]
		});
		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		sendTitle("Trainings");
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/trainings',{});
		});
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOptionIcon').html("add");
		$('#buttonOptionTooltip').html("Add new training");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#trainingModal");
		$('#buttonOption').attr("onclick","configureCreateModal()");
		
		var dialogTraining = document.querySelector('#trainingModal');
		dialogTraining.querySelector('#cancelTrainingDialogButton')
		    .addEventListener('click', function() {
		      dialogTraining.close();	
    	});
		
		var dialogTrainingDelete = document.querySelector('#confirmModal');
		dialogTrainingDelete.querySelector('#cancelTrainingConfirmButton')
		    .addEventListener('click', function() {
		      dialogTrainingDelete.close();	
    	});
	});
	
	configureCreateModal = function(){
		
		$("#trainingID").val(null);
		$("#trainingName").val(null);
		
		$("#typeInput").show();
		$("#skillInput").show();
		
		$("#modalTitle").html("Create Training");
		$("#trainingCreate").css("display", "inline-block");
		$("#trainingUpdate").css("display", "none");
		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-selectfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		getmdlSelect.init(".getmdl-select");
		$('.mdl-textfield>input').each(function(param){if($(this).val() != ""){$(this).parent().addClass('is-dirty');$(this).parent().removeClass('is-invalid')}})
		
		var dialog = document.querySelector('#trainingModal');
		dialog.showModal();		
	}
	
	configureUpdateModal = function(pID, pName, pTypeName, pSkillName){
		
		$("#trainingID").val(pID);
		$("#trainingName").val(pName);
		
		$("#typeInput").hide();
		$("#skillInput").hide();
		
		$("#modalTitle").html("Update Training");
		$("#trainingCreate").css("display", "none");
		$("#trainingUpdate").css("display", "inline-block");
		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-selectfield'));
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
		
		var dialog = document.querySelector('#trainingModal');
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

	createTraining = function(){
		if (document.getElementById("formCreate").checkValidity() && document.getElementById("formCreateUpdate").checkValidity()) {
			var typeValue;
			var skillValue;
			$('#typeValueList').children().each(
				function(param){
					if(this.classList.length >1 && this.classList[1] == "selected"){
						typeValue = this.getAttribute("data-val");
					}
				});
			
			$('#skillValueList').children().each(
				function(param){
					if(this.classList.length >1 && this.classList[1] == "selected"){
						skillValue = this.getAttribute("data-val");
					}
				});
			var settings = {
				method: 'POST',
				url: '/trainings/create',
				headers: {
					'Content-Type': undefined
				},
				data: {
					"TypeId": typeValue,
					"SkillId": skillValue,
					"Name": $('#trainingName').val()
				}
			}
			$.ajax(settings).done(function (response) {
				validationError(response);
				reload('/trainings', {});
			});
		}
	}
	
	updateTraining = function(){
		if (document.getElementById("formCreateUpdate").checkValidity()) {
			var settings = {
				method: 'POST',
				url: '/trainings/update',
				headers: {
					'Content-Type': undefined
				},
				data: { 
					"ID": $('#trainingID').val(),
					"Name": $('#trainingName').val()
				}
			}
			$.ajax(settings).done(function (response) {
				validationError(response);
				reload('/trainings', {});
			});
		}
	}
	
	deleteTraining = function(){
		var settings = {
			method: 'POST',
			url: '/trainings/delete',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#trainingID').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/trainings', {});
		});
	}
		
	$('#typeValue').change(function() {		
		var typeValue;
		$('#typeValueList').children().each(
			function(param){
				if(this.classList.length >1 && this.classList[1] == "selected"){
					typeValue = this.getAttribute("data-val");
				}
			});
			
		$('#skillValueList').html('');
		
        {{range $index, $typeSkill := .TypesSkills}}
			if ({{$typeSkill.TypeId}} == typeValue) {
				$('#skillValueList').append('<li id="{{$typeSkill.SkillId}}" class="mdl-menu__item" data-val="{{$typeSkill.SkillId}}">{{$typeSkill.Name}}</li>');
			}
        {{end}}
		
		var type = document.getElementById(typeValue);
		var att = document.createAttribute("data-selected");
		att.value = "true";
		type.setAttributeNode(att);
		
		getmdlSelect.init("#skillInput");
	});
	
</script>
<div>
<table id="viewTrainings" class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp">
	<thead>
		<tr>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Type Name</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Skill Name</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Training Name</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $training := .Trainings}}
		<tr>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$training.TypeName}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$training.SkillName}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$training.Name}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">
				<button id="editButton{{$training.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="configureUpdateModal({{$training.ID}},'{{$training.Name}}', '{{$training.TypeName}}', '{{$training.SkillName}}')" data-dismiss="modal">
					<i class="material-icons" style="vertical-align: inherit;">mode_edit</i>
				</button>
				<div class="mdl-tooltip" for="editButton{{$training.ID}}">
					Edit training	
				</div>	
				<button id="deleteButton{{$training.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="$('#nameDelete').html('{{$training.Name}}');$('#trainingID').val({{$training.ID}});configureDeleteModal()" data-dismiss="modal">
					<i class="material-icons" style="vertical-align: inherit;">delete</i>
				</button>
				<div class="mdl-tooltip" for="deleteButton{{$training.ID}}">
					Delete training	
				</div>
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>

</div>

<!-- Modal -->
<dialog class="mdl-dialog" id="trainingModal">
	<h4 id="modalTitle" class="mdl-dialog__title"></h4>
	<div class="mdl-dialog__content">
		<input type="hidden" id="trainingID">		
		<form id="formCreate" action="#">
			<div id="typeInput" class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label getmdl-select">
		        <input type="text" value="" class="mdl-textfield__input" id="typeValue" readonly required>
		        <input type="hidden" value="" name="typeValue" id="realTypeValue">
		        <i class="mdl-icon-toggle__label material-icons">keyboard_arrow_down</i>
		        <label for="typeValue" class="mdl-textfield__label">Type...</label>
		        <ul id="typeValueList" for="typeValue" class="mdl-menu mdl-menu--bottom-left mdl-js-menu">
		        	{{range $index, $type := .Types}}
					<li id="{{$type.ID}}" class="mdl-menu__item" data-val="{{$type.ID}}">{{$type.Name}}</li>
		        	{{end}}
				</ul>
		    </div>
			<div id="skillInput" class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label getmdl-select">
		        <input type="text" value="" class="mdl-textfield__input" id="skillValue" readonly required>
		        <input type="hidden" value="" name="skillValue" id="realSkillValue">
		        <i class="mdl-icon-toggle__label material-icons">keyboard_arrow_down</i>
		        <label for="skillValue" class="mdl-textfield__label">Skill...</label>
		        <ul id="skillValueList" for="skillValue" class="mdl-menu mdl-menu--bottom-left mdl-js-menu">
		        	
				</ul>
		    </div>
		</form>
		<form id="formCreateUpdate" action="#">			
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
			  <input class="mdl-textfield__input" type="text" id="trainingName" required>
			  <label class="mdl-textfield__label" for="trainingName">Name...</label>
			</div>	
		</form>
	</div>
	<div class="mdl-dialog__actions">
		<button type="button" id="trainingCreate" class="mdl-button" onclick="createTraining()" data-dismiss="modal">Create</button>
		<button type="button" id="trainingUpdate" class="mdl-button" onclick="updateTraining()" data-dismiss="modal">Update</button>
      	<button id="cancelTrainingDialogButton" type="button" class="mdl-button close" data-dismiss="modal">Cancel</button>
    </div>
</dialog>
<dialog class="mdl-dialog" id="confirmModal">
	<h4 id="modalTitle" class="mdl-dialog__title">Delete Confirmation</h4>
	<div class="mdl-dialog__content">
		Are you sure you want to remove <b id="nameDelete"></b> from trainings?
		<br>
		<li>The resources will lose this training assignment.</li>
	</div>
	<div class="mdl-dialog__actions">
		<button type="button" id="trainingDelete" class="mdl-button" onclick="deleteTraining()" data-dismiss="modal">Yes</button>
	    <button id="cancelTrainingConfirmButton" type="button" class="mdl-button close" data-dismiss="modal">No</button>
    </div> 
</dialog>