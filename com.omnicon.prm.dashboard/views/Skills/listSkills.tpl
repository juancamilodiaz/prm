<script>
	$(document).ready(function(){
		$('#viewSkills').DataTable({

		});
	});

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
		console.log(settings);
		$.ajax(settings).done(function (response) {
		  console.log(response);
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
		  console.log(response);
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
		console.log(settings);
		$.ajax(settings).done(function (response) {
		  console.log(response);
		});
	}
	
	var app = angular.module('skills', ['ngSanitize']);
	
	app.controller('skillsCtrl', function($scope, $http, $compile){
		$scope.create = function(){
			alert(1);
			var req = {
				method: 'POST',
				url: '/skills/create',
				headers: {
					'Content-Type': undefined
				},
				data: { 
					Name: $('#skillName').val()
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
<table id="viewSkills" class="table table-striped table-bordered">
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
				<button class="BlueButton" data-toggle="modal" data-target="#skillModal" onclick="$('#skillID').val({{$skilll.ID}};" >Update</button>
				<button data-toggle="modal" data-target="#confirmModal" class="BlueButton" onclick="$('#nameDelete').html('{{$skilll.Name}}');$('#skillID').val({{$skilll.ID}});">Delete</button>
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>
<div style="text-align:center;">
	<button class="BlueButton" data-toggle="modal" data-target="#skillModal">Create</button>
</div>
</div>

<!-- Modal -->
<div class="modal fade" id="skillModal" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Create Skill</h4>
      </div>
      <div class="modal-body">
        <input type="hidden" id="skillID">
        <div class="row-box col-sm-12">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Name"> Name </label>
              <div class="col-sm-8">
              	<input type="text" id="skillName">
        		</div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" id="skillCreate" class="btn btn-default" onclick="createSkill()">Create</button>
        <button type="button" id="skillUpdate" class="btn btn-default" onclick="update()">Update</button>
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
        Are you sure  yow want to remove <b id="nameDelete"></b> from skills?
      </div>
      <div class="modal-footer" style="text-align:center;">
        <button type="button" id="skillUpdate" class="btn btn-default" onclick="deleteSkill()" data-dismiss="modal">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>