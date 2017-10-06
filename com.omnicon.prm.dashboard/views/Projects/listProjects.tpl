<script>
	$(document).ready(function(){
		$('#viewProjects').DataTable({
			"columns":[
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
		$('#buttonOption').html("New Project");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#projectModal");
		$('#buttonOption').attr("onclick","configureCreateModal()");
		
		sendTitle("Projects");
		
		$('#projectStartDate').change(function(){
			$('#projectEndDate').attr("min", $("#projectStartDate").val());
		});
	});
	
	configureCreateModal = function(){
		
		$("#projectID").val(null);
		$("#projectName").val(null);
		$("#projectStartDate").val(null);		
		$("#projectEndDate").val(null);
		$("#projectActive").prop('checked', false);
		
		$("#modalProjectTitle").html("Create Project");
		$("#projectUpdate").css("display", "none");
		$("#projectCreate").css("display", "inline-block");
	}
	
	configureUpdateModal = function(pID, pName, pStartDate, pEndDate, pActive){
		
		$("#projectID").val(pID);
		$("#projectName").val(pName);
		
		$("#projectStartDate").val(pStartDate);
		$("#projectEndDate").val(pEndDate);
		$("#projectEndDate").attr("min", pStartDate);
		$("#projectActive").prop('checked', pActive);
		
		$("#modalProjectTitle").html("Update Project");
		$("#projectCreate").css("display", "none");
		$("#projectUpdate").css("display", "inline-block");
		$("#divProjectType").css("display", "none");
	}
	
	createProject = function(){
		var values = "";
		for (i =0; i<$('#projectType').val().length; i++){
			if (values != ""){
				values = values + ",";
			}	
			values = values + $('#projectType').val()[i];
		}
		var settings = {
			method: 'POST',
			url: '/projects/create',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"Name": $('#projectName').val(),
				"ProjectType": values,
				"StartDate": $('#projectStartDate').val(),
				"EndDate": $('#projectEndDate').val(),
				"Enabled": $('#projectActive').is(":checked")
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
				"Name": $('#projectName').val(),
				"ProjectType": $('#projectType').val(),
				"StartDate": $('#projectStartDate').val(),
				"EndDate": $('#projectEndDate').val(),
				"Enabled": $('#projectActive').is(":checked")
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

<table id="viewProjects" class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>Name</th>
			<th>Start Date</th>
			<th>End Date</th>
			<th>Enabled</th>			
			<th>Options</th>			
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $project := .Projects}}
		<tr>
			<td>{{$project.Name}}</td>
			<td>{{dateformat $project.StartDate "2006-01-02"}}</td>
			<td>{{dateformat $project.EndDate "2006-01-02"}}</td>
			<td><input type="checkbox" {{if $project.Enabled}}checked{{end}} disabled></td>
			
			<td>
				<button class="buttonTable button2" data-toggle="modal" data-target="#projectModal" onclick='configureUpdateModal({{$project.ID}}, "{{$project.Name}}", {{dateformat $project.StartDate "2006-01-02"}}, {{dateformat $project.EndDate "2006-01-02"}}, {{$project.Enabled}})' data-dismiss="modal">Update</button>
				<button data-toggle="modal" data-target="#confirmModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$project.Name}}');$('#projectID').val({{$project.ID}});" data-dismiss="modal">Delete</button>
				<button class="buttonTable button2" ng-click="link('/projects/resources')" onclick="getResourcesByProject({{$project.ID}}, '{{$project.Name}}');" data-dismiss="modal">Resources</button>
				<button class="buttonTable button2" onclick="getTypesByProject({{$project.ID}}, '{{$project.Name}}');" data-dismiss="modal">Types</button>
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>

</div>

<!-- Modal -->
<div class="modal fade" id="projectModal" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 id="modalProjectTitle" class="modal-title"></h4>
      </div>
      <div class="modal-body">
        <input type="hidden" id="projectID">
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
      </div>
      <div class="modal-footer">
        <button type="button" id="projectCreate" class="btn btn-default" onclick="createProject()" data-dismiss="modal">Create</button>
		<button type="button" id="projectUpdate" class="btn btn-default" onclick="updateProject()" data-dismiss="modal">Update</button>
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
        Are you sure you want to remove <b id="nameDelete"></b> from projects?
		<br>
		<li>The resources will lose this project assignment.</li>
		<li>The types will lose this project assignment.</li>
      </div>
      <div class="modal-footer" style="text-align:center;">
        <button type="button" id="projectDelete" class="btn btn-default" onclick="deleteProject()" data-dismiss="modal">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>