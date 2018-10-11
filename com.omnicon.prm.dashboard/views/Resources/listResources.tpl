<script>
	$(document).ready(function(){
		$('.modal-trigger').leanModal();
		$('.tooltipped').tooltip();
		$('select').material_select();
		$('#viewResources').DataTable({			
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
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("href", "#resourceModal");
		



		
		
		$("#resourceEmail").keyup(function(){

	        var email = $("#resourceEmail").val();
	
	        if(email != 0)
	        {
	            if(isValidEmailAddress(email))
	            {
	                $("#resourceEmail").css({
	                    "border-color": "lightgreen"
	                });
	            } else {
	                $("#resourceEmail").css({
	                    "border-color": "crimson"
	                });
	            }
	        } else {
	            $("#resourceEmail").css({
	                "border-color": "crimson"
	            });         
	        }
	
	    });
	});

	
	configureCreateModal = function(){
		
		$("#resourceID").val(null);
		$("#resourceName").val(null);
		$("#resourceLastName").val(null);
		$("#resourceEmail").val(null);
		$("#resourceRank").val(null);
		$("#resourceActive").prop('checked', false);
		$("#resourceVisaUS").val(null);
		$('#trainingCreate').show();
		$('#trainingUpdate').hide();
		$("#modalResourceTitle").html("Create Resource");
		$("#resourceUpdate").css("display", "none");
		$("#resourceCreate").css("display", "inline-block");
	}
	
	configureUpdateModal = function(pID, pName, pLastName, pEmail, pRank, pActive, pVisaUS){
		
		$("#resourceID").val(pID);
		$("#resourceName").val(pName);
		$("#resourceLastName").val(pLastName);
		$("#resourceEmail").val(pEmail);
		$("#resourceRank").val(pRank);
		$("#resourceActive").prop('checked', pActive);
		$("#resourceVisaUS").val(pVisaUS);
		$('#trainingUpdate').show();
		$('#trainingCreate').hide();
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
				"Enabled": $('#resourceActive').is(":checked"),
				"VisaUS": $('#resourceVisaUS').val()
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
				"Enabled": $('#resourceActive').is(":checked"),
				"VisaUS": $('#resourceVisaUS').val()
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
	
	getSkillsByResource = function(resourceID, resourceName, mapTypesResource){
		var settings = {
			method: 'POST',
			url: '/resources/skills',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": resourceID,
				"ResourceName": resourceName,
				"MapTypesResource" : JSON.stringify(mapTypesResource)
			}
		}
		$.ajax(settings).done(function (response) {
		  $("#content").html(response);
		});
	}
	
	getAssignationsByResource = function(resourceID, resourceName){
		var settings = {
			method: 'POST',
			url: '/projects/resources/assignation',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ResourceId": resourceID,
				"ResourceName": resourceName
			}
		}
		$.ajax(settings).done(function (response) {
		  $("#content").html(response);
		});
	}
		
</script>
<div class="container" style="padding:15px;">
<table id="viewResources" class="display" cellspacing="0" width="100%">
<div id="pry_add">
	<h4>Resources</h5>
	<a class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" id="buttonOption" onclick="configureCreateModal()" data-position="top" data-tooltip="Create" href="#" ><i class="mdi-action-note-add large"></i></a>
</div>
	<thead>
		<tr>
			<th>Name</th>
			<th>Last Name</th>
			<th>Profile(s)</th>
			<th>Email</th>
			<th>Engineer Rank</th>
			<th>Visa US</th>
			<th>Enabled</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
		{{$typesResource := .TypesResource}}
	 	{{range $key, $resource := .Resources}}
		<tr>
			<td>{{$resource.Name}}</td>
			<td>{{$resource.LastName}}</td>
			<td>
			{{$mapOfTypes := index $typesResource $resource.ID}}
			<ul>
			{{range $key, $type := $mapOfTypes}}
				<li>{{$type}}</li>
			{{end}}
			</ul>
			</td>
			<td>{{$resource.Email}}</td>
			<td>{{$resource.EngineerRange}}</td>
			<td>{{if $resource.VisaUS}} {{$resource.VisaUS}} {{end}}</td>
			<td><input type="checkbox" {{if $resource.Enabled}}checked{{end}} disabled></td>
			<td>							
				<a class='modal-trigger tooltipped' data-position="top" data-tooltip="Edit"  href="#resourceModal"  onclick="configureUpdateModal({{$resource.ID}},'{{$resource.Name}}','{{$resource.LastName}}','{{$resource.Email}}','{{$resource.EngineerRange}}',{{$resource.Enabled}},{{$resource.VisaUS}})"><i class="mdi-editor-mode-edit"></i></a>
				<a class='modal-trigger tooltipped' data-position="top" data-tooltip="Delete"  href='#confirmModal' onclick='$("#nameDelete").html("{{$resource.Name}} {{$resource.LastName}}");$("#resourceID").val({{$resource.ID}});'><i class="mdi-action-delete"></i></a>
				<a class='tooltipped' data-position="top" data-tooltip="Resource's skills" href="#" ng-click="link('/resources/skills')" onclick="getSkillsByResource({{$resource.ID}}, '{{$resource.Name}}', {{$mapOfTypes}});" ><i class="mdi-action-trending-up"></i></a>
				<a class='tooltipped' data-position="top" data-tooltip="Asign to projects" href="#"  ng-click="link('/projects/resources/assignation')" onclick="getAssignationsByResource({{$resource.ID}},'{{$resource.Name}}'+' '+'{{$resource.LastName}}');" ><i class="mdi-action-assignment-ind"></i></a>
				<a class='tooltipped' data-position="top" data-tooltip="Resource's types" href="#"  ng-click="link('/projects/resources/assignation')" onclick="getTypesByResource({{$resource.ID}}, '{{$resource.Name}}');" ><i class="mdi-image-style"></i></a>
				<!--
				<button class="buttonTable button2" data-toggle="modal" data-target="#resourceModal" onclick="configureUpdateModal({{$resource.ID}},'{{$resource.Name}}','{{$resource.LastName}}','{{$resource.Email}}','{{$resource.EngineerRange}}',{{$resource.Enabled}},{{$resource.VisaUS}})" data-dismiss="modal">Update</button>
				<button data-toggle="modal" data-target="#confirmModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$resource.Name}} {{$resource.LastName}}');$('#resourceID').val({{$resource.ID}});">Delete</button>
				<button class="buttonTable button2" ng-click="link('/resources/skills')" onclick="getSkillsByResource({{$resource.ID}}, '{{$resource.Name}}', {{$mapOfTypes}});" data-dismiss="modal">Skill Matrix</button>
				<button class="buttonTable button2" ng-click="link('/projects/resources/assignation')" onclick="getAssignationsByResource({{$resource.ID}},'{{$resource.Name}}'+' '+'{{$resource.LastName}}');" data-dismiss="modal">Assignations</button>
				<button class="buttonTable button2" onclick="getTypesByResource({{$resource.ID}}, '{{$resource.Name}}');" data-dismiss="modal">Types</button>-->
			</td>
		</tr>
		{{end}}
	</tbody>
</table>


<!-- Materialize Modal Update -->
	<div id="resourceModal" class="modal " style="overflow: visible;" >
			<div class="modal-content">
				<h5 id="modalResourceTitle" class="modal-title"></h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="resourceID">
				<div class="input-field row">	

					<!-- Input -->
					<div class="input-field col s12 m5 l5">
						<input id="resourceName" type="text" class="validate">
						<label  for="resourceName"  class="active">Name</label>
					</div>
					<!-- /Input -->	

					<!-- Input -->
					<div class="input-field col s12 m5 l5">
						<input id="resourceLastName" type="text" class="validate">
						<label  for="resourceLastName"  class="active">Last Name</label>
					</div>
					<!-- /Input -->

					<!-- Input -->
					<div class="input-field col s12 m5 l5">
						<input id="resourceEmail" type="email" class="validate">
						<label  for="resourceEmail"  class="active">Email</label>
					</div>
					<!-- /Input -->

					<!-- Select -->
					<div class="input-field col s12 m5 l5" id="inputCreateTypeValue">
						<label  class= "active">Select Type</label>
						<select id="resourceRank"  style="width: 174px; border-radius: 8px;">
							<option value="E1">E1</option>
							<option value="E2">E2</option>
							<option value="E3">E3</option>
							<option value="E4">E4</option>
							<option value="PM">PM</option>
						</select>	
					</div>
					<!-- Close Select -->

					<!-- Input -->
					<div class="input-field col s12 m5 l5">
						<input id="resourceVisaUS" type="text" class="validate">
						<label  for="resourceVisaUS"  class="active">Visa US</label>
					</div>
					<!-- /Input -->				

					<!-- Input -->
					<div class=" col s12 m5 l5">
						<p>
							<input id="resourceActive" type="checkbox" />
							<label for="resourceActive" ><span>Active</span></label>
						</p>
					</div>
					<!-- /Input -->
									
				</div>
			</div>
			<div class="modal-footer">
				<a id="trainingCreate" onclick="createResource()" class="waves-effect waves-green btn-flat modal-action modal-close" >Create</a>
				<a id="trainingUpdate" onclick="updateResource()" class="waves-effect waves-blue btn-flat modal-action modal-close"  >Update</a>
       		 	<a class="waves-effect waves-red btn-flat modal-action modal-close">Cancel</a>
			</div>
	</div>
    
<!-- Modal Update -->




	<!-- Modal 
	<div class="modal" id="resourceModal">-->
	    <!-- Modal content
	    <div class="modal-content">
	        <h4 id="modalResourceTitle" class="modal-title"></h4>	  	  
		<div class="divider"></div>
			<input type="hidden" id="resourceID">
	        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div class="form-group form-group-sm">
	        		<label class="control-label col-sm-4 translatable" data-i18n="Name"> Name </label>
	              <div class="col-sm-8">
	              	<input type="text" id="resourceName" class="style-input" style="border-radius: 8px;">
	        		</div>
	          </div>
	        </div>
	        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div class="form-group form-group-sm">
	        		<label class="control-label col-sm-4 translatable" data-i18n="Last Name"> Last Name </label> 
	              <div class="col-sm-8">
	              	<input type="text" id="resourceLastName" class="style-input" style="border-radius: 8px;">
	        		</div>
	          </div>
	        </div>
	        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div class="form-group form-group-sm">
	        		<label class="control-label col-sm-4 translatable" data-i18n="Email"> Email </label> 
	              <div class="col-sm-8">
	              	<input type="text" id="resourceEmail" class="style-input" style="border-radius: 8px;">
	        		</div>
	          </div>
	        </div>
	        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div class="form-group form-group-sm">
	        		<label class="control-label col-sm-4 translatable" data-i18n="Enginer Rank"> Enginer Rank </label> 
	              <div class="col-sm-8">
	              	<select id="resourceRank" class="style-input" style="width: 174px; border-radius: 8px;">
					  <option value="E1">E1</option>
					  <option value="E2">E2</option>
					  <option value="E3">E3</option>
					  <option value="E4">E4</option>
					  <option value="PM">PM</option>
					</select>
	        		</div>
	          </div>
	        </div>
			<div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div class="form-group form-group-sm">
	        		<label class="control-label col-sm-4 translatable" data-i18n="Visa US"> Visa US </label>
	              <div class="col-sm-8">
	              	<input type="text" id="resourceVisaUS" class="style-input" style="border-radius: 8px;">
	        		</div>
	          </div>
	        </div>
	        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div class="form-group form-group-sm">
	        		<label class="control-label col-sm-4 translatable" data-i18n="Active"> Active </label> 
	              <div class="col-sm-8">
	              	<input type="checkbox" id="resourceActive" class="style-input"><br/>
	              </div>    
	          </div>
	        </div>
	    </div>
		<div class="modal-footer">		
			<a class="waves-effect waves-green btn-flat modal-action modal-close" onclick="createTask()" >Create</a>
			<a class="waves-effect waves-blue btn-flat modal-action modal-close" onclick="updateTask()" >Update</a>
			<a class="waves-effect waves-red btn-flat modal-action modal-close">Cancel</a>
		</div>
	    </div>
	</div>-->


	<!-- Materialize Modal Delete -->
<div id="confirmModal" class="modal" >
			<div class="modal-content">
				<h5 id="modalTitle" class="modal-title">Delete Confirmation</h5>
				<div class="divider CardTable"></div>
				Are you sure you want to remove <b id="nameDelete"></b> from resources?
				<br>
				<li>The projects will lose this resource assignment.</li>
				<li>The skills will lose this resource assignment.</li>
				<li>The trainings will lose this resource assignment.</li>
				<li>The projects will lose this resource assignment as leader.</li>
			</div>
			<div class="modal-footer">
				<a onclick="deleteResource()" class="waves-effect waves-green btn-flat modal-action modal-close" >Delete</a>
        		<a class="waves-effect waves-red btn-flat modal-action modal-close">Cancel</a>
			</div>
</div>

<!-- Modal delete close -->