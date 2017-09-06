<script>
	$(document).ready(function(){
		$('#viewProjects').DataTable({

		});
	});

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
		  console.log(response);
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
		  console.log(response);
		});
	}
	
	var app = angular.module('projects', ['ngSanitize']);
	
	app.controller('projectsCtrl', function($scope, $http, $compile){
		$scope.create = function(){
			alert(1);
			var req = {
				method: 'POST',
				url: '/projects/create',
				headers: {
					'Content-Type': undefined
				},
				data: { 
					Name: $('#projectName').val(),
					StartDate: $('#projectStartDate').val(),
					EndDate: $('#projectEndDate').val(),
					Enabled: $('#projectActive').is(":checked")
				}
			}
			console.log(req);
			/*$http(req)
		    .then(function(response) {
		        $("#content").html(response.data);
		    });*/
		}
		
		$scope.read = function(id){
			$http.post(url)
		    .then(function(response) {
		        $("#content").html(response.data);
		    });
		}
		
		$scope.update = function(id){
			$http.post(url)
		    .then(function(response) {
		        $("#content").html(response.data);
		    });
		}
		
		$scope.delete = function(id){
			$http.post(url)
		    .then(function(response) {
		        $("#content").html(response.data);
		    });
		}
	    
	});
	
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
			<td>{{$project.StartDate}}</td>
			<td>{{$project.EndDate}}</td>
			<td>{{$project.Enabled}}</td>
			<td>
				<button class="BlueButton" data-toggle="modal" data-target="#projectModal" onclick="$('#projectID').val({{$project.ID}};" >Update</button>
				<button data-toggle="modal" data-target="#confirmModal" class="BlueButton" onclick="$('#nameDelete').html('{{$project.Name}}');$('#projectID').val({{$project.ID}});">Delete</button>
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>
<div style="text-align:center;">
	<button class="BlueButton" data-toggle="modal" data-target="#projectModal">Create</button>
</div>
</div>

<!-- Modal -->
<div class="modal fade" id="projectModal" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Create Project</h4>
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
        <button type="button" id="projectCreate" class="btn btn-default" onclick="createProject()">Create</button>
        <button type="button" id="projectUpdate" class="btn btn-default" onclick="update()">Update</button>
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
        <button type="button" id="projectUpdate" class="btn btn-default" onclick="deleteProject()" data-dismiss="modal">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>