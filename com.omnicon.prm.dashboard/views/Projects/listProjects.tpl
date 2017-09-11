<script>
	$(document).ready(function(){
		$('#viewProjects').DataTable({
		});
		$('#backButton').css("display", "none");
		sendTitle("Projects");
	});
	
	configureCreateModal = function(){
		
		$("#projectID").val(null);
		$("#projectName").val(null);
		$("#projectStartDate").val(null);
		$("#projectEndDate").val(null);
		$("#projectActive").prop('checked', false);
		
		$("#modalTitle").html("Create Project");
		$("#projectUpdate").css("display", "none");
		$("#projectCreate").css("display", "inline-block");
	}
	
	configureUpdateModal = function(pID, pName, pStartDate, pEndDate, pActive){
		
		$("#projectID").val(pID);
		$("#projectName").val(pName);
		$("#projectStartDate").val(pStartDate);
		$("#projectEndDate").val(pEndDate);
		$("#projectActive").prop('checked', pActive);
		
		$("#modalTitle").html("Update Project");
		$("#projectCreate").css("display", "none");
		$("#projectUpdate").css("display", "inline-block");
	}
	
	createProject = function(){
		var settings = {
			method: 'POST',
			url: '/projects/create',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"Name": $('#projectName').val(),
				"StartDate": $('#projectStartDate').val(),
				"EndDate": $('#projectEndDate').val(),
				"Enabled": $('#projectActive').is(":checked")
			}
		}
		console.log(settings);
		$.ajax(settings).done(function (response) {
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
				"StartDate": $('#projectStartDate').val(),
				"EndDate": $('#projectEndDate').val(),
				"Enabled": $('#projectActive').is(":checked")
			}
		}
		console.log(settings);
		$.ajax(settings).done(function (response) {
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
		  console.log(response);
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
		console.log(settings);
		$.ajax(settings).done(function (response) {
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
				"ID": projectID,
				"ProjectName": projectName
			}
		}
		$.ajax(settings).done(function (response) {
			console.log(response);
		  $("#content").html(response);
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
			<td>{{$project.Enabled}}</td>
			<td>
				<button class="buttonTable button2" data-toggle="modal" data-target="#projectModal" onclick='configureUpdateModal({{$project.ID}}, "{{$project.Name}}", {{dateformat $project.StartDate "2006-01-02"}}, {{dateformat $project.EndDate "2006-01-02"}}, {{$project.Enabled}})' data-dismiss="modal">Update</button>
				<button data-toggle="modal" data-target="#confirmModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$project.Name}}');$('#projectID').val({{$project.ID}});" data-dismiss="modal">Delete</button>
				<button class="buttonTable button2" ng-click="link('/projects/resources')" onclick="getResourcesByProject({{$project.ID}}, '{{$project.Name}}');" data-dismiss="modal">More Info.</button>
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>
<div style="text-align:center;">
	<button class="button button2" data-toggle="modal" data-target="#projectModal" onclick='configureCreateModal()'>New Project</button>
</div>
</div>

<!-- Modal -->
<div class="modal fade" id="projectModal" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 id="modalTitle" class="modal-title"></h4>
      </div>
      <div class="modal-body">
        <input type="hidden" id="projectID">
        <div class="row-box col-sm-12">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Name"> Name </label>
              <div class="col-sm-8">
              	<input type="text" id="projectName">
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Start Date"> Start Date </label> 
              <div class="col-sm-8">
              	<input type="date" id="projectStartDate">
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="End Date"> End Date </label> 
              <div class="col-sm-8">
              	<input type="date" id="projectEndDate">
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12">
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

<div class="modal fase" id="confirmModal" role="dialog">
<div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Delete Confirmation</h4>
      </div>
      <div class="modal-body">
        Are you sure  yow want to remove <b id="nameDelete"></b> from projects?
      </div>
      <div class="modal-footer" style="text-align:center;">
        <button type="button" id="projectDelete" class="btn btn-default" onclick="deleteProject()" data-dismiss="modal">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>