<script>
	$(document).ready(function(){
		$('#viewResources').DataTable({

		});
	});

	createResource = function(){
		var settings = {
			method: 'POST',
			url: '/resources/create',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"Name": $('#resourceName').val(),
				"LastName": $('#resourceLastName').val(),
				"Email": $('#resourceEmail').val(),
				"Photo": 'test',
				"EngineerRange": $('#resourceRank').val(),
				"Enabled": $('#resourceActive').is(":checked")
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
			url: '/resources/read',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#resourceName').val(),
			}
		}
		$.ajax(settings).done(function (response) {
		  console.log(response);
		});
	}
	
	deleteResource = function(){
		var settings = {
			method: 'POST',
			url: '/resources/delete',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#resourceID').val()
			}
		}
		console.log(settings);
		$.ajax(settings).done(function (response) {
		  console.log(response);
		});
	}
	
	var app = angular.module('resources', ['ngSanitize']);
	
	app.controller('resourcesCtrl', function($scope, $http, $compile){
		$scope.create = function(){
			alert(1);
			var req = {
				method: 'POST',
				url: '/resources/create',
				headers: {
					'Content-Type': undefined
				},
				data: { 
					Name: $('#resourceName').val(),
					LastName: $('#resourceLastName').val(),
					Email: $('#resourceEmail').val(),
					Photo: 'test',
					EngineerRange: $('#resourceEmail').val(),
					Enabled: $('#resourceActive').is(":checked")
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
<table id="viewResources" class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>Name</th>
			<th>Last Name</th>
			<th>Email</th>
			<th>Engineer Rank</th>
			<th>Enabled</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $resource := .Resources}}
		<tr>
			<td>{{$resource.Name}}</td>
			<td>{{$resource.LastName}}</td>
			<td>{{$resource.Email}}</td>
			<td>{{$resource.EngineerRange}}</td>
			<td>{{$resource.Enabled}}</td>
			<td>
				<button class="BlueButton" data-toggle="modal" data-target="#resourceModal" onclick="$('#resourceID').val({{$resource.ID}};" >Update</button>
				<button data-toggle="modal" data-target="#confirmModal" class="BlueButton" onclick="$('#nameDelete').html('{{$resource.Name}} {{$resource.LastName}}');$('#resourceID').val({{$resource.ID}});">Delete</button>
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>
<div style="text-align:center;">
	<button class="BlueButton" data-toggle="modal" data-target="#resourceModal">Create</button>
</div>
</div>

<!-- Modal -->
<div class="modal fade" id="resourceModal" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Create Resource</h4>
      </div>
      <div class="modal-body">
        <input type="hidden" id="resourceID">
        <div class="row-box col-sm-12">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Name"> Name </label>
              <div class="col-sm-8">
              	<input type="text" id="resourceName">
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Last Name"> Last Name </label> 
              <div class="col-sm-8">
              	<input type="text" id="resourceLastName">
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Email"> Email </label> 
              <div class="col-sm-8">
              	<input type="text" id="resourceEmail">
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Enginer Rank"> Enginer Rank </label> 
              <div class="col-sm-8">
              	<select id="resourceRank"><option value="E1">E1</option><option value="E1">E2</option><option value="E1">E3</option><option value="E1">E4</option></select>
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Active"> Active </label> 
              <div class="col-sm-8">
              	<input type="checkbox" id="resourceActive"><br/>
              </div>    
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" id="resourceCreate" class="btn btn-default" onclick="createResource()">Create</button>
        <button type="button" id="resourceUpdate" class="btn btn-default" onclick="update()">Update</button>
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
        Are you sure  yow want to remove <b id="nameDelete"></b> from resources?
      </div>
      <div class="modal-footer" style="text-align:center;">
        <button type="button" id="resourceUpdate" class="btn btn-default" onclick="deleteResource()" data-dismiss="modal">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>