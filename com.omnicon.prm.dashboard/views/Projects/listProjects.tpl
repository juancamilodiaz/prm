<script>
	$(document).ready(function(){
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-selectfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		$('#viewProjects').DataTable({
			"columns":[
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				{"searchable":false}
			]
		});
		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		$('#backButton').prop('onclick',null).off('click');
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/projects',{});
		});
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOptionIcon').html("add");
		$('#buttonOptionTooltip').html("Add new project");
		$('#buttonOption').attr("onclick","configureCreateModal()");
		
		var dialog = document.querySelector('#projectModal');
		dialog.querySelector('#cancelDialogButton')
		    .addEventListener('click', function() {
		      dialog.close();	
    	});
		
		var dialogConfirm = document.querySelector('#confirmModal');
		dialogConfirm.querySelector('#cancelConfirmButton')
		    .addEventListener('click', function() {
		      dialogConfirm.close();	
    	});
		
		sendTitle("Projects");
		
		$('#projectStartDate').change(function(){
			$('#projectEndDate').attr("min", $("#projectStartDate").val());
		});
	});
	
	configureCreateModal = function(){
		
		$("#projectID").val(null);
		$("#projectOperationCenter").val(null);
		$("#projectWorkOrder").val(null);
		$("#projectName").val(null);
		$("#projectStartDate").val(null);		
		$("#projectEndDate").val(null);
		$("#projectActiveCheckbox").removeClass('is-checked');
		$("#leaderID").val(0);
		$("#projectCost").val(null);
		
		$("#modalProjectTitle").html("Create Project");
		$("#formTypes").css("display", "inline-block");
		$("#projectUpdate").css("display", "none");
		$("#projectCreate").css("display", "inline-block");
		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-selectfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		$('.mdl-textfield>input').each(function(param){if($(this)[0].id == "projectName" || $(this)[0].id == "projectStartDate" || $(this)[0].id == "projectEndDate"){$(this).parent().addClass('is-invalid')}$(this).parent().removeClass('is-dirty');})
		var dialog = document.querySelector('#projectModal');
		dialog.showModal();
	}
	
	configureUpdateModal = function(pID, pOperationCenter, pWorkOrder, pName, pStartDate, pEndDate, pActive, pLeaderID, pCost){
		
		$("#projectID").val(pID);
		$("#projectOperationCenter").val(pOperationCenter);
		$("#projectWorkOrder").val(pWorkOrder);
		$("#projectName").val(pName);
		
		$("#projectStartDate").val(pStartDate);
		$("#projectEndDate").val(pEndDate);
		$("#projectEndDate").attr("min", pStartDate);
		if(pActive){
			$("#projectActive").addClass('is-checked');
			$("#projectActiveCheckbox").prop('checked', pActive);
		}else{
			$("#projectActive").removeClass('is-checked');
			$("#projectActiveCheckbox").prop('checked', pActive);
		}
		
		
		$("#leaderID").val(0);
		if (pLeaderID != null) {
			$("#leaderID").val(pLeaderID);
		}
		$("#projectCost").val(pCost);
		
		$("#modalProjectTitle").html("Update Project");
		$("#projectCreate").css("display", "none");
		$("#projectUpdate").css("display", "inline-block");
		$("#formTypes").css("display", "none");
		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-selectfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		$('.mdl-textfield>input').each(function(param){if($(this).val() != ""){$(this).parent().addClass('is-dirty');$(this).parent().removeClass('is-invalid')}})
		
		var dialog = document.querySelector('#projectModal');
		dialog.showModal();
	}
	
	configureDeleteModal = function(pID, pName){
		$("#projectID").val(pID);
		$("#nameDelete").html(pName);
		
		var dialog = document.querySelector('#confirmModal');
		dialog.showModal();
	}
	
	createProject = function(){
		var values = "";
		var projectType = [];
		{{range $key, $types := .Types}}
			if($('#{{$types.ID}}').is(":checked")){
				projectType.push({{$types.ID}});
			}			
		{{end}}	
		for (i =0; i<projectType.length; i++){
			if (values != ""){
				values = values + ",";
			}	
			values = values + projectType[i];
		}
		var settings = {
			method: 'POST',
			url: '/projects/create',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"OperationCenter": $('#projectOperationCenter').val(),
				"WorkOrder": $('#projectWorkOrder').val(),
				"Name": $('#projectName').val(),
				"ProjectType": values,
				"StartDate": $('#projectStartDate').val(),
				"EndDate": $('#projectEndDate').val(),
				"Enabled": $('#projectActiveCheckbox').is(":checked"),
				"LeaderID": $('#leaderID').val(),
				"Cost": $('#projectCost').val()
			}
		}
		$.ajax(settings).done(function (response) {
		  validationError(response);
		  reload('/projects', {})
		});
	}
	
	updateProject = function(){
		var settings = {
			method: 'POST',
			url: '/projects/update',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#projectID').val(),
				"OperationCenter": $('#projectOperationCenter').val(),
				"WorkOrder": $('#projectWorkOrder').val(),
				"Name": $('#projectName').val(),
				"ProjectType": $('#projectType').val(),
				"StartDate": $('#projectStartDate').val(),
				"EndDate": $('#projectEndDate').val(),
				"Enabled": $('#projectActiveCheckbox').is(":checked"),
				"LeaderID": $('#leaderID').val(),
				"Cost": $('#projectCost').val()
			}
		}
		$.ajax(settings).done(function (response) {
		  validationError(response);
		  reload('/projects', {})
		});
	}
	
	read = function(){
		var settings = {
			method: 'POST',
			url: '/projects/read',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#projectName').val(),
			}
		}
		$.ajax(settings).done(function (response) {
		});
	}
	
	deleteProject = function(){
		var settings = {
			method: 'POST',
			url: '/projects/delete',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#projectID').val()
			}
		}
		$.ajax(settings).done(function (response) {
		  validationError(response);
		  reload('/projects', {})
		});
	}
	
	getResourcesByProject = function(projectID, projectName){
		var settings = {
			method: 'POST',
			url: '/projects/resources',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ProjectId": projectID,
				"ProjectName": projectName
			}
		}
		$.ajax(settings).done(function (response) {
		  $("#content").html(response);
		  $('.modal-backdrop').remove();
		});
	}
	
</script>

<div>

<table id="viewProjects" class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp">
	<thead>
		<tr>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Operation Center</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Work Order</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Name</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Start Date</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">End Date</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Leader</th>
			<th class="mdl-data-table__cell--numeric" style="text-align:center;">Cost</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Enabled</th>			
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Options</th>			
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $project := .Projects}}
		<tr>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$project.OperationCenter}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$project.WorkOrder}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$project.Name}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{dateformat $project.StartDate "2006-01-02"}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{dateformat $project.EndDate "2006-01-02"}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$project.Lead}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--numeric">{{if $project.Cost}} {{$project.Cost}} {{end}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric"><input id="checkbox{{$project.ID}}" type="checkbox" {{if $project.Enabled}}checked{{end}} class="mdl-checkbox mdl-checkbox__input" disabled></td>
			
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">
				<button id="editButton{{$project.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick='configureUpdateModal({{$project.ID}}, "{{$project.OperationCenter}}", {{$project.WorkOrder}}, "{{$project.Name}}", {{dateformat $project.StartDate "2006-01-02"}}, {{dateformat $project.EndDate "2006-01-02"}}, {{$project.Enabled}}, {{$project.LeaderID}}, {{$project.Cost}})'>
					<i class="material-icons" style="vertical-align: inherit;">mode_edit</i>
				</button>
				<div class="mdl-tooltip" for="editButton{{$project.ID}}">
					Edit project	
				</div>	
				<button id="deleteButton{{$project.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick='configureDeleteModal("{{$project.ID}}", "{{$project.Name}}")'>
					<i class="material-icons" style="vertical-align: inherit;">delete</i>
				</button>
				<div class="mdl-tooltip" for="deleteButton{{$project.ID}}">
					Delete project	
				</div>	
				<button id="asignButton{{$project.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" ng-click="link('/projects/resources')" onclick="getResourcesByProject({{$project.ID}}, '{{$project.Name}}');" data-dismiss="modal">
					<i class="material-icons" style="vertical-align: inherit;">assignment_ind</i>
				</button>
				<div class="mdl-tooltip" for="asignButton{{$project.ID}}">
					Asign resources	
				</div>	
				<button id="typeButton{{$project.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="getTypesByProject({{$project.ID}}, '{{$project.Name}}');" data-dismiss="modal">
					<i class="material-icons" style="vertical-align: inherit;">style</i>
				</button>
				<div class="mdl-tooltip" for="typeButton{{$project.ID}}">
					Project's types	
				</div>	
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>

</div>

<!-- Modal -->
<dialog class="mdl-dialog" id="projectModal">
    <!-- Modal content-->        
    <h4 id="modalProjectTitle" class="mdl-dialog__title"></h4>
    <div class="mdl-dialog__content">	
		<form action="#">		
		    <input type="hidden" id="projectID">
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
			  <input class="mdl-textfield__input" type="text" id="projectOperationCenter">
			  <label class="mdl-textfield__label" for="projectOperationCenter">Operation Center...</label>
			</div>
		</form>
		<form action="#">		
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
				<input class="mdl-textfield__input" type="text" pattern="-?[0-9]*(\.[0-9]+)?" id="projectWorkOrder">
				<label class="mdl-textfield__label" for="projectWorkOrder">Work Order...</label>
				<span class="mdl-textfield__error">Input is not a number!</span>
			</div>
		</form>
		<form action="#">		
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
			  <input class="mdl-textfield__input" type="text" id="projectName" required>
			  <label class="mdl-textfield__label" for="projectName">Project Name...</label>
			</div>
		</form>
		<form action="#">		
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
			  <input class="mdl-textfield__input" type="date" id="projectStartDate" required>
			  <label class="mdl-textfield__label" for="projectStartDate">Start Date...</label>
			</div>
		</form>
		<form action="#">		
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
			  <input class="mdl-textfield__input" type="date" id="projectEndDate" required>
			  <label class="mdl-textfield__label" for="projectEndDate">End Date...</label>
			</div>
		</form>
		<form id="formTypes" action="#">
			<div class="mdl-textfield mdl-js-textfield" style="padding: 6%;">
				<label class="mdl-textfield__label">Types...</label>
			</div>
			<div>
				{{range $key, $types := .Types}}
				<label id="type{{$types.ID}}" class="mdl-switch mdl-js-switch mdl-js-ripple-effect" for="{{$types.ID}}">
				    <input type="checkbox" id="{{$types.ID}}" class="mdl-switch__input">
				    <span class="mdl-switch__label">{{$types.Name}}</span>
				</label>
				{{end}}	
			</div>			
		</form>
		<form action="#">		
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
				<input class="mdl-textfield__input currency" id="projectCost" min="0" step="1000" type="text" pattern="-?[0-9]*(\.[0-9]+)?">
				<label class="mdl-textfield__label" for="projectCost">Project Cost...</label>
				<span class="mdl-textfield__error">Input is not a number!</span>
			</div>
		</form>
		<hr>
		<form action="#">						
			<label id="projectActive" class="mdl-switch mdl-js-switch mdl-js-ripple-effect" for="projectActiveCheckbox">
			    <input type="checkbox" id="projectActiveCheckbox" class="mdl-switch__input">
			    <span class="mdl-switch__label">Active</span>
			</label>
		</form>
		<form action="#">		
			<div class="mdl-selectfield mdl-js-selectfield mdl-selectfield--floating-label">
				<select  id="leaderID" class="mdl-selectfield__select">
					<option value="0"></option>
					{{range $key, $resource := .Resources}}
					<option value="{{$resource.ID}}">{{$resource.Name}} {{$resource.LastName}}</option>
					{{end}}
				</select>
			  <label class="mdl-selectfield__label" for="leaderID">Leader...</label>
			</div>
		</form>
		    <!--div class="row-box col-sm-12" style="padding-bottom: 1%;">
		      	<div class="form-group form-group-sm">
		      		<label class="control-label col-sm-4 translatable" data-i18n="Operation Center"> Operation Center </label>
		            <div class="col-sm-8">
		            	<input type="text" id="projectOperationCenter" style="border-radius: 8px;">
		      		</div>
		        </div>
		    </div-->
		    <!--div class="row-box col-sm-12" style="padding-bottom: 1%;">
		      	<div class="form-group form-group-sm">
		      		<label class="control-label col-sm-4 translatable" data-i18n="Work Order"> Work Order </label>
		            <div class="col-sm-8">
		            	<input type="number" id="projectWorkOrder" style="border-radius: 8px;">
		      		</div>
		        </div>
		    </div>
		    <div class="row-box col-sm-12" style="padding-bottom: 1%;">
		      	<div class="form-group form-group-sm">
		      		<label class="control-label col-sm-4 translatable" data-i18n="Name"> Name </label>
		            <div class="col-sm-8">
		            	<input type="text" id="projectName" style="border-radius: 8px;">
		      		</div>
		        </div>
		    </div>
		    <div class="row-box col-sm-12" style="padding-bottom: 1%;">
		      	<div class="form-group form-group-sm">
		      		<label class="control-label col-sm-4 translatable" data-i18n="Start Date"> Start Date </label> 
		            <div class="col-sm-8">
		            	<input type="date" id="projectStartDate" style="inline-size: 174px; border-radius: 8px;">
		      		</div>
		        </div>
		    </div>
		    <div class="row-box col-sm-12" style="padding-bottom: 1%;">
		    	<div class="form-group form-group-sm">
		    		<label class="control-label col-sm-4 translatable" data-i18n="End Date"> End Date </label> 
		          	<div class="col-sm-8">
		          		<input type="date" id="projectEndDate" style="inline-size: 174px; border-radius: 8px;">
		    		</div>
		      	</div>
		    </div>
			<div class="row-box col-sm-12" style="padding-bottom: 1%;">
		    	<div id="divProjectType" class="form-group form-group-sm">
		    		<label class="control-label col-sm-4 translatable" data-i18n="Types"> Types </label> 
		         	<div class="col-sm-8">
		    	      	<select  id="projectType" multiple style="width: 174px; border-radius: 8px;">
						{{range $key, $types := .Types}}
							<option value="{{$types.ID}}">{{$types.Name}}</option>
						{{end}}
						</select>
		          	</div>    
		      	</div>
		    </div>
		    <div class="row-box col-sm-12" style="padding-bottom: 1%;">
		    	<div class="form-group form-group-sm">
		    		<label class="control-label col-sm-4 translatable" data-i18n="Active"> Active </label> 
		         	<div class="col-sm-8">
		          		<input type="checkbox" id="projectActive"><br/>
		          	</div>    
		     	</div>
		    </div>
			<div class="row-box col-sm-12" style="padding-bottom: 1%;">
				<div id="divProjectType" class="form-group form-group-sm">
					<label class="control-label col-sm-4 translatable" data-i18n="Leader"> Leader </label> 
					<div class="col-sm-8">
						<select  id="leaderID" style="width: 174px; border-radius: 8px;">
							<option value="0">Without leader</option>
							{{range $key, $resource := .Resources}}
							<option value="{{$resource.ID}}">{{$resource.Name}} {{$resource.LastName}}</option>
							{{end}}
						</select>
					</div>    
				</div>
			</div>
			<div class="row-box col-sm-12" style="padding-bottom: 1%;">
		    	<div class="form-group form-group-sm">
		      		<label class="control-label col-sm-4 translatable" data-i18n="Cost"> Cost </label>
		        	<div class="col-sm-8">
		           		<input type="number" id="projectCost" min="0" step="1000" class="currency" style="border-radius: 8px;">
		       		</div>
		      	</div>
		    </div-->
		
    </div>
	<div class="mdl-dialog__actions">
		<button type="button" id="projectCreate" class="mdl-button" onclick="createProject()" data-dismiss="modal">Create</button>
		<button type="button" id="projectUpdate" class="mdl-button" onclick="updateProject()" data-dismiss="modal">Update</button>
      	<button id="cancelDialogButton" type="button" class="mdl-button close" data-dismiss="modal">Cancel</button>
    </div>    
</dialog>

<dialog class="mdl-dialog" id="confirmModal">
	<h4 class="mdl-dialog__title">Delete Confirmation</h4>
    <div class="mdl-dialog__content">
		Are you sure you want to remove <b id="nameDelete"></b> from projects?
		<br>
		<li>The resources will lose this project assignment.</li>
		<li>The types will lose this project assignment.</li>
	</div>
	<div class="mdl-dialog__actions">
		<button type="button" id="projectDelete" class="mdl-button" onclick="deleteProject()" data-dismiss="modal">Yes</button>
	    <button id="cancelConfirmButton" type="button" class="mdl-button close" data-dismiss="modal">No</button>
    </div> 
</dialog>