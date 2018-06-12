<script>
	getProjectsDropDown = function(){
		var settings = {
			method: 'POST',
			url: '/projects',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"Template": "select",				
			}
		}
		$.ajax(settings).done(function (response) {
		  $('#projectNames').html(response);
		});
	}
	$(document).ready(function(){
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		getmdlSelect.init(".getmdl-select");
		$('#viewResourceInProjects').DataTable({
			"columns":[
				null,
				null,
				null,
				null,
				null,
				{"searchable":false}
			],
			"dom": '<"col-sm-2"<"toolbar">><"col-sm-4"f><"col-sm-6"l><rtip>',
			initComplete: function(){
		      $("div.toolbar").html('<button id="multiDelete" disabled class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="' + "$('#resourceID').val({{.ResourceId}}); $('#nameDelete').html('the marked elements');configureDeleteAssignResourceModal()" + '"> <i class="material-icons" style="vertical-align: inherit;">delete_sweep</i> </button><div class="mdl-tooltip" for="multiDelete">Remove selected assigns</div>');     
		   	}
		});
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
			reload('/projects/resources/assignation',{
				"ResourceId": {{.ResourceId}}
			});
		});
		
		$('#resourceDateStartProject, #resourceDateEndProject, #resourceUpdateDateStartProject, #resourceUpdateDateEndProject, #createHoursPerDay').change(function(){
	    	var startDateCreate = new Date($("#resourceDateStartProject").val());
			var endDateCreate = new Date($("#resourceDateEndProject").val());
			
			$("#resourceHoursProject").parent().addClass('is-dirty');
			$("#resourceDateEndProject").attr("min", $("#resourceDateStartProject").val());
			$("#resourceHoursProject").val(workingHoursBetweenDates(startDateCreate, endDateCreate, $("#createHoursPerDay").val(), $("#checkHoursPerDay").is(":checked")));
			
			var startDateUpdate = new Date($("#resourceUpdateDateStartProject").val());
			var endDateUpdate = new Date($("#resourceUpdateDateEndProject").val());
	
			$("#resourceUpdateDateHoursProject").val(workingHoursBetweenDates(startDateUpdate, endDateUpdate, $("#createHoursPerDay").val(), $("#checkHoursPerDay").is(":checked")));
			$('#resourceUpdateDateEndProject').attr("min", $("#resourceUpdateDateStartProject").val());
		});
		
		$('#checkHoursPerDay').change(function() {
			if ($('#checkHoursPerDay').is(":checked")) {
				$('#resourceHoursProject').attr("disabled", "disabled");
				$('#createHoursPerDay').removeAttr("disabled");
			} else {
				$('#createHoursPerDay').attr("disabled", "disabled");
				$('#createHoursPerDay').parent().addClass('is-dirty');
				$('#createHoursPerDay').val("8");
				$('#resourceHoursProject').removeAttr("disabled");
			}
		});

		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOptionIcon').html("add");
		$('#buttonOptionTooltip').html("Add new assign to project");;
		$('#buttonOption').attr("onclick","$('#resourceProjectId').val({{.ResourceId}});configureShowCreateModal()");
		
		var dialogConfirmDelete = document.querySelector('#confirmUnassignModal');
		dialogConfirmDelete.querySelector('#cancelConfirmUnassignButton')
		    .addEventListener('click', function() {
		      dialogConfirmDelete.close();	
    	});
		
		var dialogConfirmCreate = document.querySelector('#resourceProjectModal');
		dialogConfirmCreate.querySelector('#cancelCreateDialogButton')
		    .addEventListener('click', function() {
		      dialogConfirmCreate.close();	
    	});
		
		var dialogConfirmUpdate = document.querySelector('#resourceProjectUpdateModal');
		dialogConfirmUpdate.querySelector('#cancelUpdateDialogButton')
		    .addEventListener('click', function() {
		      dialogConfirmUpdate.close();	
    	});
	
		getProjectsDropDown();
	});
	
	var listToDelete = [];
	$(document).unbind('change');
	$(document).on('change', '.checkToDelete', function() {
		if(this.checked) {
			listToDelete.push(this.value);
		} else {
			var index = listToDelete.indexOf(this.value);
			if (index > -1){
				listToDelete.splice(index,1);
			}
		}
		if (listToDelete.length > 0){
			$('#multiDelete').removeAttr("disabled");
		} else {
			$('#multiDelete').attr("disabled", "disabled");			
		}
	});
	
	unassignResource = function(){
		var settings = {
			method: 'POST',
			url: '/projects/resources/unassign',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#resourceProjectIDDelete').val(),
				"IDs": listToDelete.toString()
			}
		}
		$.ajax(settings).done(function (response) {
		  reload('/projects/resources/assignation', {"ResourceId": $('#resourceID').val(), "ResourceName": "{{.Title}}"});
		});
	}
	
	configureShowCreateModal = function(){
		$("#resourceDateStartProject").val(getDateToday());
		$("#resourceDateEndProject").val(getDateToday());
		$("#resourceDateEndProject").attr("min", $("#resourceDateStartProject").val());
		$("#resourceHoursProject").val("8");
		$("#createHoursPerDay").attr("disabled", "disabled");
		$("#createHoursPerDay").val("8");
		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-selectfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		getmdlSelect.init(".getmdl-select");
		$('.mdl-textfield>input').each(function(param){if($(this).val() != ""){$(this).parent().addClass('is-dirty');$(this).parent().removeClass('is-invalid')}})
		
		var dialog = document.querySelector('#resourceProjectModal');
		dialog.showModal();
	}
	
	configureShowUpdateModal = function(pStartDate, pEndDate, pHours){
		
		$("#resourceUpdateDateStartProject").val(pStartDate);
		$("#resourceUpdateDateEndProject").val(pEndDate);
		$("#resourceUpdateDateEndProject").attr("min", $("#resourceUpdateDateStartProject").val());
		
		$("#resourceUpdateDateHoursProject").val(pHours);
		$("#modalTitle").html("Update Assign Resource");
		$("#resourceCreate").css("display", "none");
		$("#resourceUpdate").css("display", "inline-block");
		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-selectfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		$('.mdl-textfield>input').each(function(param){if($(this).val() != ""){$(this).parent().addClass('is-dirty');$(this).parent().removeClass('is-invalid')}})
		
		var dialog = document.querySelector('#resourceProjectUpdateModal');
		dialog.showModal();
	}
	
	configureDeleteAssignResourceModal = function(){	
		var dialog = document.querySelector('#confirmUnassignModal');
		dialog.showModal();
	}
	
	setResourceToProject = function(ID, resourceId, projectId, startDate, endDate, hours, isToCreate, hoursPerDay, isHoursPerDay){
		
		if (isToCreate) {
			$('#projectNames').children().each(
				function(param){
					if(this.classList.length >1 && this.classList[1] == "selected"){
						projectId = this.getAttribute("data-val");
					}
				}
			);
		}
		
		var settings = {
			method: 'POST',
			url: '/projects/setresource',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": ID,
				"ProjectId": projectId,
				"ResourceId": resourceId,
				"StartDate": startDate,
				"EndDate": endDate,
				"Hours": hours,
				"HoursPerDay": hoursPerDay,
				"IsHoursPerDay": isHoursPerDay,
				"IsToCreate": isToCreate
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/projects/resources/assignation', {"ResourceId": resourceId});
		});
	}
	
	
</script>

<table id="viewResourceInProjects" class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp">
	<thead>
		<tr>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">To Delete</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Project Name</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Start Date</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">End Date</th>
			<th class="mdl-data-table__cell--numeric" style="text-align:center;">Hours</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $resourceToProject := .ResourcesToProjects}}
		<tr>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric"><input type="checkbox" value="{{$resourceToProject.ID}}" class="mdl-checkbox mdl-checkbox__input checkToDelete"></td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$resourceToProject.ProjectName}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{dateformat $resourceToProject.StartDate "2006-01-02"}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{dateformat $resourceToProject.EndDate "2006-01-02"}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--numeric">{{$resourceToProject.Hours}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">
				<button id="updateAssignButton{{$resourceToProject.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick='$("#resourceProjectUpdateName").val("{{$resourceToProject.ResourceName}}");$("#resourceProjectUpdateId").val({{$resourceToProject.ResourceId}});$("#projectUpdateId").val({{$resourceToProject.ProjectId}});configureShowUpdateModal({{dateformat $resourceToProject.StartDate "2006-01-02"}}, {{dateformat $resourceToProject.EndDate "2006-01-02"}}, {{$resourceToProject.Hours}});$("#resourceProjectIDUpdate").val({{$resourceToProject.ID}});'>
					<i class="material-icons" style="vertical-align: inherit;">mode_edit</i>
				</button>
				<div class="mdl-tooltip" for="updateAssignButton{{$resourceToProject.ID}}">
					Update assign to project	
				</div>
				<button id="deleteButton{{$resourceToProject.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="$('#nameDelete').html('{{$resourceToProject.ProjectName}}');$('#resourceProjectIDDelete').val({{$resourceToProject.ID}});$('#projectID').val({{$resourceToProject.ProjectId}});$('#resourceID').val({{$resourceToProject.ResourceId}});configureDeleteAssignResourceModal()">
					<i class="material-icons" style="vertical-align: inherit;">delete</i>
				</button>
				<div class="mdl-tooltip" for="deleteButton{{$resourceToProject.ID}}">
					Remove assign from project	
				</div>		
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>

<!-- Modal -->
	<dialog class="mdl-dialog" id="resourceProjectModal">
		<h4 id="modalUpdateResourceProjectTitle" class="mdl-dialog__title">Set New Assignment</h4>
		<div class="mdl-dialog__content">
			<form id="formCreate" action="#">
				<input type="hidden" id="resourceProjectId">
				
				<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label getmdl-select">
			        <input type="text" value="" class="mdl-textfield__input" id="projectName" readonly>
			        <input type="hidden" value="" name="projectName" id="realprojectName">
			        <i class="mdl-icon-toggle__label material-icons">keyboard_arrow_down</i>
			        <label for="projectName" class="mdl-textfield__label">Project Name...</label>
			        <ul id="projectNames" for="projectName" class="mdl-menu mdl-menu--bottom-left mdl-js-menu">
			        	
			        </ul>
			    </div>
				<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
				  <input class="mdl-textfield__input" type="date" id="resourceDateStartProject" required>
				  <label class="mdl-textfield__label" for="resourceDateStartProject">Start Date...</label>
				</div>		
				<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
				  <input class="mdl-textfield__input" type="date" id="resourceDateEndProject" required>
				  <label class="mdl-textfield__label" for="resourceDateEndProject">End Date...</label>
				</div>			
				<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
					<input class="mdl-textfield__input" type="text" pattern="-?[0-9]*(\.[0-9]+)?" id="resourceHoursProject">
					<label class="mdl-textfield__label" for="resourceHoursProject">Total Hours...</label>
					<span class="mdl-textfield__error">Input is not a number!</span>
				</div>
				<div>
					<label id="checkHoursPerDayLabel" class="mdl-switch mdl-js-switch mdl-js-ripple-effect" for="checkHoursPerDay">
					    <input type="checkbox" id="checkHoursPerDay" class="mdl-switch__input">
					    <span class="mdl-switch__label">Activate Hours Per Day</span>
					</label>
				</div>
				<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
					<input class="mdl-textfield__input" type="text" pattern="-?[0-9]*(\.[0-9]+)?" id="createHoursPerDay">
					<label class="mdl-textfield__label" for="createHoursPerDay">Hours Per Day...</label>
					<span class="mdl-textfield__error">Input is not a number!</span>
				</div>
			</form>   
  		</div>
		<div class="mdl-dialog__actions">
			<button type="button" id="resourceProjectCreate" class="mdl-button" onclick="setResourceToProject(0, $('#resourceProjectId').val(), $('#projectNames').val(), $('#resourceDateStartProject').val(), $('#resourceDateEndProject').val(), $('#resourceHoursProject').val(), true, $('#createHoursPerDay').val(), $('#checkHoursPerDay').is(':checked'))" data-dismiss="modal">Set</button>
	      	<button id="cancelCreateDialogButton" type="button" class="mdl-button close" data-dismiss="modal">Cancel</button>
	    </div>
	</dialog>
		
	<dialog class="mdl-dialog" id="resourceProjectUpdateModal">
		<h4 id="modalUpdateResourceProjectTitle" class="mdl-dialog__title">Update Assign Resource</h4>
		<div class="mdl-dialog__content">			
			<form id="formUpdate" action="#">			
			   	<input type="hidden" id="resourceProjectUpdateId">
       			<input type="hidden" id="projectUpdateId">
				<input type="hidden" id="resourceProjectIDUpdate">
				
				<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
				  <input class="mdl-textfield__input" type="text" id="resourceProjectUpdateName" required disabled>
				  <label class="mdl-textfield__label" for="resourceProjectUpdateName">Resource Name...</label>
				</div>	
				<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
				  <input class="mdl-textfield__input" type="date" id="resourceUpdateDateStartProject" required>
				  <label class="mdl-textfield__label" for="resourceUpdateDateStartProject">Start Date...</label>
				</div>		
				<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
				  <input class="mdl-textfield__input" type="date" id="resourceUpdateDateEndProject" required>
				  <label class="mdl-textfield__label" for="resourceUpdateDateEndProject">End Date...</label>
				</div>			
				<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
					<input class="mdl-textfield__input" type="text" pattern="-?[0-9]*(\.[0-9]+)?" id="resourceUpdateDateHoursProject">
					<label class="mdl-textfield__label" for="resourceUpdateDateHoursProject">Hours...</label>
					<span class="mdl-textfield__error">Input is not a number!</span>
				</div>	
			</form>		
		</div>
		<div class="mdl-dialog__actions">
			<button type="button" id="resourceProjectCreate" class="mdl-button" onclick="setResourceToProject($('#resourceProjectIDUpdate').val(), $('#resourceProjectUpdateId').val(), $('#projectUpdateId').val(), $('#resourceUpdateDateStartProject').val(), $('#resourceUpdateDateEndProject').val(), $('#resourceUpdateDateHoursProject').val(), false, 0, false)" data-dismiss="modal">Set</button>
	      	<button id="cancelUpdateDialogButton" type="button" class="mdl-button close" data-dismiss="modal">Cancel</button>
	    </div>  
	</dialog>

	<dialog class="mdl-dialog" id="confirmUnassignModal">
		<h4 id="modalUnassignResourceProjectTitle" class="mdl-dialog__title">Unassign Confirmation</h4>
		<!-- Modal content-->
		<div class="mdl-dialog__content">
			<input type="hidden" id="resourceProjectIDDelete">
       		<input type="hidden" id="projectID">
			<input type="hidden" id="resourceID">
			Are you sure that you want to unassign <b>{{.Title}}</b> from <b id="nameDelete"></b> project?
		</div>
		<div class="mdl-dialog__actions">
			<button type="button" id="resourceUnassign" class="mdl-button" onclick="unassignResource()" data-dismiss="modal">Yes</button>
		    <button id="cancelConfirmUnassignButton" type="button" class="mdl-button close" data-dismiss="modal">No</button>
	    </div> 
	</dialog>