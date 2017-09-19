<script>
	$(document).ready(function(){
		$('#viewResources').DataTable({
			"columns":[
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
		sendTitle("Resources");
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/resources',{});
		});
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOption').html("New Resource");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#resourceModal");
		$('#buttonOption').attr("onclick","configureCreateModal()");
	});

	
	configureCreateModal = function(){
		
		$("#resourceID").val(null);
		$("#resourceName").val(null);
		$("#resourceLastName").val(null);
		$("#resourceEmail").val(null);
		$("#resourceRank").val(null);
		$("#resourceActive").prop('checked', false);
		
		$("#modalResourceTitle").html("Create Resource");
		$("#resourceUpdate").css("display", "none");
		$("#resourceCreate").css("display", "inline-block");
	}
	
	configureUpdateModal = function(pID, pName, pLastName, pEmail, pRank, pActive){
		
		$("#resourceID").val(pID);
		$("#resourceName").val(pName);
		$("#resourceLastName").val(pLastName);
		$("#resourceEmail").val(pEmail);
		$("#resourceRank").val(pRank);
		$("#resourceActive").prop('checked', pActive);
		
		$("#modalResourceTitle").html("Update Resource");
		$("#resourceCreate").css("display", "none");
		$("#resourceUpdate").css("display", "inline-block");
	}

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
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/resources', {});
		});
	}
	
	updateResource = function(){
		var settings = {
			method: 'POST',
			url: '/resources/update',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#resourceID').val(),
				"Name": $('#resourceName').val(),
				"LastName": $('#resourceLastName').val(),
				"Email": $('#resourceEmail').val(),
				"Photo": 'test',
				"EngineerRange": $('#resourceRank').val(),
				"Enabled": $('#resourceActive').is(":checked")
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/resources', {});
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
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/resources', {});
		});
	}
	
	getSkillsByResource = function(resourceID, resourceName){
		var settings = {
			method: 'POST',
			url: '/resources/skills',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": resourceID,
				"ResourceName": resourceName
			}
		}
		$.ajax(settings).done(function (response) {
		  $("#content").html(response);
		});
	}
		
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
			<td><input type="checkbox" {{if $resource.Enabled}}checked{{end}} disabled></td>
			<td>
				<button class="buttonTable button2" data-toggle="modal" data-target="#resourceModal" onclick="configureUpdateModal({{$resource.ID}},'{{$resource.Name}}','{{$resource.LastName}}','{{$resource.Email}}','{{$resource.EngineerRange}}',{{$resource.Enabled}})" data-dismiss="modal">Update</button>
				<button data-toggle="modal" data-target="#confirmModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$resource.Name}} {{$resource.LastName}}');$('#resourceID').val({{$resource.ID}});">Delete</button>
				<button class="buttonTable button2" ng-click="link('/resources/skills')" onclick="getSkillsByResource({{$resource.ID}}, '{{$resource.Name}}');" data-dismiss="modal">Skills</button>
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>

</div>

	<!-- Modal -->
	<div class="modal fade" id="resourceModal" role="dialog">
	  <div class="modal-dialog">
	    <!-- Modal content-->
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal">&times;</button>
	        <h4 id="modalResourceTitle" class="modal-title"></h4>
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
	              	<select id="resourceRank"><option value="E1">E1</option><option value="E2">E2</option><option value="E3">E3</option><option value="E4">E4</option></select>
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
	        <button type="button" id="resourceCreate" class="btn btn-default" onclick="createResource()" data-dismiss="modal">Create</button>
	        <button type="button" id="resourceUpdate" class="btn btn-default" onclick="updateResource()" data-dismiss="modal">Update</button>
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
	      		Are you sure you want to remove <b id="nameDelete"></b> from resources?
				<br>
				<li>The projects will lose this resource assignment.</li>
				<li>The skills will lose this resource assignment.</li>
	      	</div>
	      	<div class="modal-footer" style="text-align:center;">
		        <button type="button" id="resourceDelete" class="btn btn-default" onclick="deleteResource()" data-dismiss="modal">Yes</button>
		        <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
	      	</div>
	    </div>
	</div>
</div>