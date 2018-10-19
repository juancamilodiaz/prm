<script>
	$(document).ready(function(){
		$('.tooltipped').tooltip();
		$('.modal-trigger').leanModal();
		$('select').material_select();
		$('#viewProjects').DataTable({			
		"iDisplayLength": 20,
		"bLengthChange": false,
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

		$('.datepicker').pickadate({
			selectMonths: true,
			selectYears: 15,
			format: 'yyyy-mm-dd',
			formatSubmit: 'yyyy-mm-dd',
			container: 'body'
		});
		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		$('#backButton').prop('onclick',null).off('click');
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/projects',{});
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
		$("#projectActive").prop('checked', false);
		$("#leaderID").val(0);
		$("#projectCost").val(null);
		
		$("#modalProjectTitle").html("Create Project");
		$("#projectUpdate").css("display", "none");
		$("#projectCreate").css("display", "inline-block");
	}
	
	configureUpdateModal = function(pID, pOperationCenter, pWorkOrder, pName, pStartDate, pEndDate, pActive, pLeaderID, pCost){
		
		$("#projectID").val(pID);
		$("#projectOperationCenter").val(pOperationCenter);
		$("#projectWorkOrder").val(pWorkOrder);
		$("#projectName").val(pName);
		
		$("#projectStartDate").val(pStartDate);
		$("#projectEndDate").val(pEndDate);
		$("#projectEndDate").attr("min", pStartDate);
		$("#projectActive").prop('checked', pActive);
		
		$("#leaderID").val(0);
		if (pLeaderID != null) {
			$("#leaderID").val(pLeaderID);
		}
		$("#projectCost").val(pCost);
		
		$("#modalProjectTitle").html("Update Project");
		$("#projectCreate").css("display", "none");
		$("#projectUpdate").css("display", "inline-block");
		$("#divProjectType").css("display", "none");
	}
	
	createProject = function(){
		var values = "";
		if ($('#projectType').val() != null) {
			for (i =0; i<$('#projectType').val().length; i++){
				if (values != ""){
					values = values + ",";
				}	
				values = values + $('#projectType').val()[i];
			}
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
				"Enabled": $('#projectActive').is(":checked"),
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
				"Enabled": $('#projectActive').is(":checked"),
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
		 //$('.modal-backdrop').remove();
		});
	}
	
</script>
<div class="container" style="padding:20px;">
<div id="pry_add">
	<h4>Projects </h5>
	<a id="refreshButton" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Refresh"  ><i class="mdi-navigation-refresh large"></i></a>	
	<a class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-position="top" data-tooltip="Create" href="#projectModal" onclick="configureCreateModal()"><i class="mdi-action-note-add large"></i></a>
</div>
<table id="viewProjects" class="display responsive-table" cellspacing="0" width="100%" >
	<thead>
		<tr>
			<th>Operation Center</th>
			<th>Work Order</th>
			<th>Name</th>
			<th>Start Date</th>
			<th>End Date</th>
			<th>Leader</th>
			<th>Cost</th>
			<th>Enabled</th>			
			<th>Options</th>			
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $project := .Projects}}
		<tr>
			<td>{{$project.OperationCenter}}</td>
			<td>{{$project.WorkOrder}}</td>
			<td style="width:100px;">{{$project.Name}}</td>
			<td>{{dateformat $project.StartDate "2006-01-02"}}</td>
			<td>{{dateformat $project.EndDate "2006-01-02"}}</td>
			<td>{{$project.Lead}}</td>
			<td>{{if $project.Cost}} {{$project.Cost}} {{end}}</td>
			<td><input type="checkbox" {{if $project.Enabled}}checked{{end}} disabled></td>			
			<td style="width:120px;">
			  <a class='modal-trigger tooltipped' data-position="top" data-tooltip="Edit"  href='#projectModal' onclick='configureUpdateModal({{$project.ID}}, "{{$project.OperationCenter}}", {{$project.WorkOrder}}, "{{$project.Name}}", {{dateformat $project.StartDate "2006-01-02"}}, {{dateformat $project.EndDate "2006-01-02"}}, {{$project.Enabled}}, {{$project.LeaderID}}, {{$project.Cost}})'><i class="mdi-editor-mode-edit"></i></a>
			  <a class='modal-trigger tooltipped' data-position="top" data-tooltip="Delete"  href='#confirmModal' onclick="$('#nameDelete').html('{{$project.Name}}');$('#projectID').val({{$project.ID}});" ><i class="mdi-action-delete"></i></a>
			  <a class='tooltipped' data-position="top" data-tooltip="Get Resources" href="#" ng-click="link('/projects/resources')" onclick="getResourcesByProject({{$project.ID}}, '{{$project.Name}}');" ><i class="mdi-action-assignment-ind"></i></a>
			  <a class='tooltipped' data-position="top" data-tooltip="Get Types"  href="#" onclick="getTypesByProject({{$project.ID}}, '{{$project.Name}}');" data-dismiss="modal"><i class="mdi-image-style"></i></a>		
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>

</div>

<!-- Modal -->
<div class="modal" id="projectModal" style="overflow: visible;"> 
    <div class="modal-content">
		<h5 id="modalProjectTitle" class="modal-title"></h5>
		<div class="divider"></div><br>
		<input type="hidden" id="projectID">		
		<div class="input-field col s12 m5 l5">
			<label class="active"> Operation Center </label>
			<input type="text" id="projectOperationCenter">
		</div>   	
		<div class="input-field col s12 m5 l5">
			<label class="active"> Work Order </label>
			<input type="number" id="projectWorkOrder">
		</div>

		<div class="input-field col s12 m5 l5">
			<label class="active"> Name </label>
			<input type="text" id="projectName">
		</div>

		<div class="input-field col s12 m5 l5">
			<label class="active"> Start Date </label> 
			<input type="date" class="datepicker" id="projectStartDate">
		</div>
		
		<div class="input-field col s12 m5 l5">
			<label class="active"> End Date </label>               
			<input type="date" class="datepicker" id="projectEndDate">
		</div>

		<div class="input-field col s12 m5 l5">
			<label class="active"> Types </label> 
			<div class=" col s12 m5 l5">
					<select  id="projectType" multiple>
					<option value="" disabled selected>Select a type</option>
					{{range $key, $types := .Types}}
						<option value="{{$types.ID}}">{{$types.Name}}</option>
					{{end}}
					</select>
			</div>    
		</div>
	
		<div class="input-field col s12 m5 l5" style="bottom: 15px;">
				<p>
					<input id="projectActive" type="checkbox" /> 
					<label for="projectActive" ><span>Active</span></label>
				</p> 
		</div>
		<div class="input-field col s12 m5 l5">
			<label class="active">  Leader </label> 
			<div class="col-sm-8">
				<select  id="leaderID">
				<option value="0">Without leader</option>
				{{range $key, $resource := .Resources}}
				<option value="{{$resource.ID}}">{{$resource.Name}} {{$resource.LastName}}</option>
				{{end}}
				</select>
			</div>    
		</div>
		<div class="input-field col s12 m5 l5">
			<label class="active"> Cost </label>
				<input type="number" id="projectCost" min="0" step="1000" class="currency">
		
		</div>
      </div>
      <div class="modal-footer">		
			<a id="projectCreate" onclick="createProject()" class="btn green waves-effect white-text waves-light btn-flat modal-action modal-close" onclick="createTask()" >Create</a>
			<a id="projectUpdate" onclick="updateProject()" class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close" onclick="updateTask()" >Update</a>
			<a class="btn red white-text waves-effect waves-light btn-flat modal-action modal-close">Cancel</a>
      </div>
    </div> 
</div>


<div class="modal" id="confirmModal">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Delete Confirmation</h5>
      </div>			
			<div class="divider"></div>
		</div>
    <div class="modal-content">
        Are you sure you want to remove <b id="nameDelete"></b> from projects?
		<br>
		<li>The resources will lose this project assignment.</li>
		<li>The types will lose this project assignment.</li>
      </div>
      <div class="modal-footer" style="text-align:center;">
			<a id="projectCreate" onclick="deleteProject()" class="btn green white-text waves-effect waves-green btn-flat modal-action modal-close" onclick="deleteProject()" >Yes</a>
				<a class="btn red white-text waves-effect waves-red btn-flat modal-action modal-close">Cancel</a>
      </div>
    </div>
  </div>
</div>