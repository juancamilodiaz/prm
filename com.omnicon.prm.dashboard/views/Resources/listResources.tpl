<script>
	$(document).ready(function(){
		$('#viewResources').DataTable({
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
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOptionIcon').html("add");
		$('#buttonOptionTooltip').html("Add new resource");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#resourceModal");
		$('#buttonOption').attr("onclick","configureCreateModal()");
		
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
<div>
	<table id="viewResources" class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp">
		<thead>
			<tr>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Name</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Last Name</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Profile(s)</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Email</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Engineer Rank</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Visa US</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Enabled</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Options</th>
			</tr>
		</thead>
		<tbody>
			{{$typesResource := .TypesResource}}
		 	{{range $key, $resource := .Resources}}
			<tr>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$resource.Name}}</td>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$resource.LastName}}</td>
				<td style="vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">
				{{$mapOfTypes := index $typesResource $resource.ID}}
				<ul style="margin-bottom: auto;">
				{{range $key, $type := $mapOfTypes}}
					<li>{{$type}}</li>
				{{end}}
				</ul>
				</td>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$resource.Email}}</td>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$resource.EngineerRange}}</td>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{if $resource.VisaUS}} {{$resource.VisaUS}} {{end}}</td>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric"><input type="checkbox" {{if $resource.Enabled}}checked{{end}} disabled></td>
				<td style="vertical-align: inherit;text-align: center;" class="mdl-data-table__cell--non-numeric">
					<button id="editButton{{$resource.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" data-toggle="modal" data-target="#resourceModal" onclick="configureUpdateModal({{$resource.ID}},'{{$resource.Name}}','{{$resource.LastName}}','{{$resource.Email}}','{{$resource.EngineerRange}}',{{$resource.Enabled}},{{$resource.VisaUS}})" data-dismiss="modal">
						<i class="material-icons" style="vertical-align: inherit;">mode_edit</i>
					</button>
					<div class="mdl-tooltip" for="editButton{{$resource.ID}}">
						Edit resource	
					</div>	
					<button id="deleteButton{{$resource.ID}}" data-toggle="modal" data-target="#confirmModal" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="$('#nameDelete').html('{{$resource.Name}} {{$resource.LastName}}');$('#resourceID').val({{$resource.ID}});">
						<i class="material-icons" style="vertical-align: inherit;">delete</i>
					</button>
					<div class="mdl-tooltip" for="deleteButton{{$resource.ID}}">
						Delete resource	
					</div>	
					<button id="skillButton{{$resource.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" ng-click="link('/resources/skills')" onclick="getSkillsByResource({{$resource.ID}}, '{{$resource.Name}}', {{$mapOfTypes}});" data-dismiss="modal">
						<i class="material-icons" style="vertical-align: inherit;">trending_up</i>
					</button>
					<div class="mdl-tooltip" for="skillButton{{$resource.ID}}">
						Resource's skills	
					</div>	
					<button id="asignButton{{$resource.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" ng-click="link('/projects/resources/assignation')" onclick="getAssignationsByResource({{$resource.ID}},'{{$resource.Name}}'+' '+'{{$resource.LastName}}');" data-dismiss="modal">
						<i class="material-icons" style="vertical-align: inherit;">assignment_ind</i>
					</button>
					<div class="mdl-tooltip" for="asignButton{{$resource.ID}}">
						Asign to projects	
					</div>	
					<button id="typeButton{{$resource.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="getTypesByResource({{$resource.ID}}, '{{$resource.Name}}');" data-dismiss="modal">
						<i class="material-icons" style="vertical-align: inherit;">style</i>
					</button>
					<div class="mdl-tooltip" for="typeButton{{$resource.ID}}">
						Resource's types	
					</div>	
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
	              	<select id="resourceRank" class="style-input" style="width: 174px; border-radius: 8px;"><option value="E1">E1</option><option value="E2">E2</option><option value="E3">E3</option><option value="E4">E4</option><option value="PM">PM</option></select>
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
				<li>The trainings will lose this resource assignment.</li>
				<li>The projects will lose this resource assignment as leader.</li>
	      	</div>
	      	<div class="modal-footer" style="text-align:center;">
		        <button type="button" id="resourceDelete" class="btn btn-default" onclick="deleteResource()" data-dismiss="modal">Yes</button>
		        <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
	      	</div>
	    </div>
	</div>
</div>