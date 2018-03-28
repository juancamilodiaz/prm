<script>
	$(document).ready(function(){
		$('#viewResourceInProjects').DataTable({
			"columns":[
				null,
				null,
				null,
				null,
				null,
				{"searchable":false}
			],
			"dom": '<"col-sm-2"<"toolbar">><"col-sm-4"f><"col-sm-6"l><rtip>',
			initComplete: function(){
		      $("div.toolbar").html('<button id="multiDelete" disabled data-toggle="modal" data-target="#confirmUnassignModal" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="' + "$('#resourceID').val({{.ResourceId}}); $('#nameDelete').html('the marked elements')" + '" data-dismiss="modal"> <i class="material-icons" style="vertical-align: inherit;">delete_sweep</i> </button><div class="mdl-tooltip" for="multiDelete">Remove selected assigns</div>');     
		   	}
		});
		$('#titlePag').html("{{.Title}}");
		$('#backButton').css("display", "inline-block");
		$('#backButtonIcon').html("arrow_back");
		$('#backButtonTooltip').html("Back to resources");
		$('#backButton').prop('onclick',null).off('click');
		$('#backButton').click(function(){
			reload('/resources',{});
		});
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/projects/resources/assignation',{
				"ResourceId": {{.ResourceId}}
			});
		});
		
		$('#resourceDateStartProject, #resourceDateEndProject, #resourceUpdateDateStartProject, #resourceUpdateDateEndProject, #createHoursPerDay').change(function(){
	    	var startDateCreate = new Date($("#resourceDateStartProject").val());
			var endDateCreate = new Date($("#resourceDateEndProject").val());
	
			$("#resourceDateEndProject").attr("min", $("#resourceDateStartProject").val());
			$("#resourceHoursProject").val(workingHoursBetweenDates(startDateCreate, endDateCreate, $("#createHoursPerDay").val(), $("#checkHoursPerDay").is(":checked")));
			
			var startDateUpdate = new Date($("#resourceUpdateDateStartProject").val());
			var endDateUpdate = new Date($("#resourceUpdateDateEndProject").val());
	
			$("#resourceUpdateDateHoursProject").val(workingHoursBetweenDates(startDateUpdate, endDateUpdate, $("#createHoursPerDay").val(), $("#checkHoursPerDay").is(":checked")));
			$('#resourceUpdateDateEndProject').attr("min", $("#resourceUpdateDateStartProject").val());
		});
		
		$('#checkHoursPerDay').change(function() {
			if ($('#checkHoursPerDay').is(":checked")) {
				$('#resourceHoursProject').attr("disabled", "disabled");
				$('#createHoursPerDay').removeAttr("disabled");
			} else {
				$('#createHoursPerDay').attr("disabled", "disabled");
				$('#createHoursPerDay').val("8");
				$('#resourceHoursProject').removeAttr("disabled");
			}
		});

		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOptionIcon').html("add");
		$('#buttonOptionTooltip').html("Add new assign to project");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#resourceProjectModal");
		$('#buttonOption').attr("onclick","$('#resourceProjectId').val({{.ResourceId}});getProjects();configureShowCreateModal()");
	});
	
	var listToDelete = [];
	$(document).unbind('change');
	$(document).on('change', '.checkToDelete', function() {
		if(this.checked) {
			listToDelete.push(this.value);
		} else {
			var index = listToDelete.indexOf(this.value);
			if (index > -1){
				listToDelete.splice(index,1);
			}
		}
		if (listToDelete.length > 0){
			$('#multiDelete').removeAttr("disabled");
		} else {
			$('#multiDelete').attr("disabled", "disabled");			
		}
	});
	
	unassignResource = function(){
		var settings = {
			method: 'POST',
			url: '/projects/resources/unassign',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#resourceProjectIDDelete').val(),
				"IDs": listToDelete.toString()
			}
		}
		$.ajax(settings).done(function (response) {
		  reload('/projects/resources/assignation', {"ResourceId": $('#resourceID').val(), "ResourceName": "{{.Title}}"});
		});
	}
	
	configureShowCreateModal = function(){
		$("#resourceDateStartProject").val(getDateToday());
		$("#resourceDateEndProject").val(getDateToday());
		$("#resourceDateEndProject").attr("min", $("#resourceDateStartProject").val());
	}
	
	configureShowUpdateModal = function(pStartDate, pEndDate, pHours){
		
		$("#resourceUpdateDateStartProject").val(pStartDate);
		$("#resourceUpdateDateEndProject").val(pEndDate);
		$("#resourceUpdateDateEndProject").attr("min", $("#resourceUpdateDateStartProject").val());
		
		$("#resourceUpdateDateHoursProject").val(pHours);
		$("#modalTitle").html("Update Assign Resource");
		$("#resourceCreate").css("display", "none");
		$("#resourceUpdate").css("display", "inline-block");
	}
	
	setResourceToProject = function(ID, resourceId, projectId, startDate, endDate, hours, isToCreate, hoursPerDay, isHoursPerDay){
		var settings = {
			method: 'POST',
			url: '/projects/setresource',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": ID,
				"ProjectId": projectId,
				"ResourceId": resourceId,
				"StartDate": startDate,
				"EndDate": endDate,
				"Hours": hours,
				"HoursPerDay": hoursPerDay,
				"IsHoursPerDay": isHoursPerDay,
				"IsToCreate": isToCreate
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/projects/resources/assignation', {"ResourceId": resourceId});
		});
	}
	
	getProjects = function(){
		var settings = {
			method: 'POST',
			url: '/projects',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"Template": "select",				
			}
		}
		$.ajax(settings).done(function (response) {
		  $('#projectNames').html(response);
		});
	}
</script>

<table id="viewResourceInProjects" class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp">
	<thead>
		<tr>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">To Delete</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Project Name</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Start Date</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">End Date</th>
			<th class="mdl-data-table__cell--numeric" style="text-align:center;">Hours</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $resourceToProject := .ResourcesToProjects}}
		<tr>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric"><input type="checkbox" value="{{$resourceToProject.ID}}" class="checkToDelete"></td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$resourceToProject.ProjectName}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{dateformat $resourceToProject.StartDate "2006-01-02"}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{dateformat $resourceToProject.EndDate "2006-01-02"}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--numeric">{{$resourceToProject.Hours}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">
				<button id="updateAssignButton{{$resourceToProject.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" data-toggle="modal" data-target="#resourceProjectUpdateModal" onclick='$("#resourceProjectUpdateName").val("{{$resourceToProject.ResourceName}}");$("#resourceProjectUpdateId").val({{$resourceToProject.ResourceId}});$("#projectUpdateId").val({{$resourceToProject.ProjectId}});configureShowUpdateModal({{dateformat $resourceToProject.StartDate "2006-01-02"}}, {{dateformat $resourceToProject.EndDate "2006-01-02"}}, {{$resourceToProject.Hours}});$("#resourceProjectIDUpdate").val({{$resourceToProject.ID}});' data-dismiss="modal">
					<i class="material-icons" style="vertical-align: inherit;">mode_edit</i>
				</button>
				<div class="mdl-tooltip" for="updateAssignButton{{$resourceToProject.ID}}">
					Update assign to project	
				</div>
				<button id="deleteButton{{$resourceToProject.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" data-toggle="modal" data-target="#confirmUnassignModal" onclick="$('#nameDelete').html('{{$resourceToProject.ProjectName}}');$('#resourceProjectIDDelete').val({{$resourceToProject.ID}});$('#projectID').val({{$resourceToProject.ProjectId}});$('#resourceID').val({{$resourceToProject.ResourceId}})" data-dismiss="modal">
					<i class="material-icons" style="vertical-align: inherit;">delete</i>
				</button>
				<div class="mdl-tooltip" for="deleteButton{{$resourceToProject.ID}}">
					Remove type from project	
				</div>		
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>

<!-- Modal -->
	<div class="modal fade" id="resourceProjectModal" role="dialog">
  		<div class="modal-dialog">
    		<!-- Modal content-->
    		<div class="modal-content">
      			<div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal">&times;</button>
			        <h4 id="modalResourceProjectTitle" class="modal-title">Set New Assignment</h4>
			    </div>
		    	<div class="modal-body">
					<input type="hidden" id="resourceProjectId">
        			<div class="row-box col-sm-12" style="padding-bottom: 1%;">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="ProjectName"> Project Name </label>
          					<div class="col-sm-8">
          						<select id="projectNames" style="inline-size: 174px; border-radius: 8px;">
								</select>
    						</div>
          				</div>
        			</div>
        			<div class="row-box col-sm-12" style="padding-bottom: 1%;">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="StartDate"> Start Date </label> 
             				<div class="col-sm-8">
              					<input type="date" id="resourceDateStartProject" style="inline-size: 174px; border-radius: 8px;">
        					</div>
          				</div>
        			</div>
					<div class="row-box col-sm-12" style="padding-bottom: 1%;">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="EndDate"> End Date </label> 
             				<div class="col-sm-8">
              					<input type="date" id="resourceDateEndProject" style="inline-size: 174px; border-radius: 8px;">
        					</div>
          				</div>
        			</div>
					<div class="row-box col-sm-12" style="padding-bottom: 1%;">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="Hours"> Total Hours </label> 
             				<div class="col-sm-8">
              					<input type="number" id="resourceHoursProject" value="8" style="border-radius: 8px;">
        					</div>
          				</div>
        			</div>
					<div class="row-box col-sm-12" style="padding-bottom: 1%;">
			        	<div class="form-group form-group-sm">
			        		<label class="control-label col-sm-4 translatable" data-i18n="activeHoursPerDay"> Activate Hours Per Day </label> 
			              <div class="col-sm-8">
			              	<input type="checkbox" id="checkHoursPerDay"><br/>
			              </div>    
			          </div>
			        </div>
					<div class="row-box col-sm-12" style="padding-bottom: 1%;">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="HoursPerDay"> Hours Per Day </label> 
             				<div class="col-sm-8">
              					<input type="number" id="createHoursPerDay" value="8" disabled style="border-radius: 8px;">
        					</div>
          				</div>
        			</div>
      			</div>
      			<div class="modal-footer">
			        <button type="button" id="resourceProjectCreate" class="btn btn-default" onclick="setResourceToProject(0, $('#resourceProjectId').val(), $('#projectNames').val(), $('#resourceDateStartProject').val(), $('#resourceDateEndProject').val(), $('#resourceHoursProject').val(), true, $('#createHoursPerDay').val(), $('#checkHoursPerDay').is(':checked'))" data-dismiss="modal">Set</button>
			        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
			    </div>
    		</div>    
  		</div>
	</div>
	
	<div class="modal fade" id="resourceProjectUpdateModal" role="dialog">
  		<div class="modal-dialog">
    		<!-- Modal content-->
    		<div class="modal-content">
      			<div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal">&times;</button>
			        <h4 id="modalUpdateResourceProjectTitle" class="modal-title">Update Assign Resource</h4>
			    </div>
		    	<div class="modal-body">
					<input type="hidden" id="resourceProjectUpdateId">
        			<input type="hidden" id="projectUpdateId">
					<input type="hidden" id="resourceProjectIDUpdate">					
					<div class="row-box col-sm-12" style="padding-bottom: 1%;">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="ResourceName"> Resource Name </label>
          					<div class="col-sm-8">
								<input type="text" id="resourceProjectUpdateName" readonly style="border-radius: 8px;">
    						</div>
          				</div>
        			</div>
        			<div class="row-box col-sm-12" style="padding-bottom: 1%;">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="StartDate"> Start Date </label> 
             				<div class="col-sm-8">
              					<input type="date" id="resourceUpdateDateStartProject" style="inline-size: 174px; border-radius: 8px;">
        					</div>
          				</div>
        			</div>
					<div class="row-box col-sm-12" style="padding-bottom: 1%;">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="EndDate"> End Date </label> 
             				<div class="col-sm-8">
              					<input type="date" id="resourceUpdateDateEndProject" style="inline-size: 174px; border-radius: 8px;">
        					</div>
          				</div>
        			</div>
					<div class="row-box col-sm-12" style="padding-bottom: 1%;">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="Hours"> Hours </label> 
             				<div class="col-sm-8">
              					<input type="number" id="resourceUpdateDateHoursProject" style="border-radius: 8px;">
        					</div>
          				</div>
        			</div>
      			</div>
      			<div class="modal-footer">
			        <button type="button" id="resourceProjectCreate" class="btn btn-default" onclick="setResourceToProject($('#resourceProjectIDUpdate').val(), $('#resourceProjectUpdateId').val(), $('#projectUpdateId').val(), $('#resourceUpdateDateStartProject').val(), $('#resourceUpdateDateEndProject').val(), $('#resourceUpdateDateHoursProject').val(), false, 0, false)" data-dismiss="modal">Set</button>
			        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
			    </div>
    		</div>    
  		</div>
	</div>

	<div class="modal fade" id="confirmUnassignModal" role="dialog">
		<div class="modal-dialog">
	    <!-- Modal content-->
	    	<div class="modal-content">
	      		<div class="modal-header">
	        		<button type="button" class="close" data-dismiss="modal">&times;</button>
	        		<h4 class="modal-title">Unassign Confirmation</h4>
	      		</div>
	      		<div class="modal-body">
					<input type="hidden" id="resourceProjectIDDelete">
	        		<input type="hidden" id="projectID">
					<input type="hidden" id="resourceID">
						Are you sure that you want to unassign <b>{{.Title}}</b> from <b id="nameDelete"></b> project?
	      		</div>
				<div class="modal-footer" style="text-align:center;">
					<button type="button" id="resourceUnassign" class="btn btn-default" onclick="unassignResource()" data-dismiss="modal">Yes</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">No</button>
				</div>
			</div>
		</div>
	</div>