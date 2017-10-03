<script>
	$(document).ready(function(){
		$('#viewResourceInProjects').DataTable({
			"columns":[
				null,
				null,
				null,
				null,
				{"searchable":false}
			]
		});
		$('#titlePag').html("{{.Title}}");
		$('#backButton').css("display", "inline-block");
		$('#backButton').html("Resources");
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
		
		$('#resourceDateStartProject, #resourceDateEndProject, #resourceUpdateDateStartProject, #resourceUpdateDateEndProject').change(function(){
	    	var startDateCreate = new Date($("#resourceDateStartProject").val());
			var endDateCreate = new Date($("#resourceDateEndProject").val());
	
			$("#resourceDateEndProject").attr("min", $("#resourceDateStartProject").val());
			$("#resourceHoursProject").val(workingHoursBetweenDates(startDateCreate, endDateCreate));
			
			var startDateUpdate = new Date($("#resourceUpdateDateStartProject").val());
			var endDateUpdate = new Date($("#resourceUpdateDateEndProject").val());
	
			$("#resourceUpdateDateHoursProject").val(workingHoursBetweenDates(startDateUpdate, endDateUpdate));
			$('#resourceUpdateDateEndProject').attr("min", $("#resourceUpdateDateStartProject").val());
		});

		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOption').html("Set New Project");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#resourceProjectModal");
		$('#buttonOption').attr("onclick","$('#resourceProjectId').val({{.ResourceId}});getProjects();configureShowCreateModal()");
	});
	
	unassignResource = function(){
		var settings = {
			method: 'POST',
			url: '/projects/resources/unassign',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#resourceProjectIDDelete').val()
			}
		}
		$.ajax(settings).done(function (response) {
		  reload('/projects/resources/assignation', {"ResourceId": $('#resourceID').val()});
		});
	}
	
	configureShowCreateModal = function(){
		$("#resourceDateStartProject").val(getDateToday());
		$("#resourceDateEndProject").val(getDateToday());
		$("#resourceDateEndProject").attr("min", $("#resourceDateStartProject").val());
	}
	
	configureShowUpdateModal = function(pStartDate, pEndDate, pHours, pLead){
		
		$("#resourceUpdateDateStartProject").val(pStartDate);
		$("#resourceUpdateDateEndProject").val(pEndDate);
		$("#resourceUpdateDateEndProject").attr("min", $("#resourceUpdateDateStartProject").val());
		
		$("#resourceUpdateDateHoursProject").val(pHours);		
		$("#resourceUpdateLead").prop('checked', pLead);		
		$("#modalTitle").html("Update Assign Resource");
		$("#resourceCreate").css("display", "none");
		$("#resourceUpdate").css("display", "inline-block");
	}
	
	setResourceToProject = function(ID, resourceId, projectId, startDate, endDate, hours, lead, isToCreate){
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
				"Lead": lead,
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

<table id="viewResourceInProjects" class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>Project Name</th>
			<th>Start Date</th>
			<th>End Date</th>
			<th>Hours</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $resourceToProject := .ResourcesToProjects}}
		<tr>
			<td>{{$resourceToProject.ProjectName}}</td>
			<td>{{dateformat $resourceToProject.StartDate "2006-01-02"}}</td>
			<td>{{dateformat $resourceToProject.EndDate "2006-01-02"}}</td>
			<td>{{$resourceToProject.Hours}}</td>
			<td>
				<button data-toggle="modal" data-target="#confirmUnassignModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$resourceToProject.ProjectName}}');$('#resourceProjectIDDelete').val({{$resourceToProject.ID}});$('#projectID').val({{$resourceToProject.ProjectId}});;$('#resourceID').val({{$resourceToProject.ResourceId}})" data-dismiss="modal">Unassign</button>
				<button data-toggle="modal" data-target="#resourceProjectUpdateModal" class="buttonTable button2" onclick='$("#resourceProjectUpdateName").val("{{$resourceToProject.ResourceName}}");$("#resourceProjectUpdateId").val({{$resourceToProject.ResourceId}});$("#projectUpdateId").val({{$resourceToProject.ProjectId}});configureShowUpdateModal({{dateformat $resourceToProject.StartDate "2006-01-02"}}, {{dateformat $resourceToProject.EndDate "2006-01-02"}}, {{$resourceToProject.Hours}}, {{$resourceToProject.Lead}});$("#resourceProjectIDUpdate").val({{$resourceToProject.ID}});' data-dismiss="modal">Update assign</button>
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
			        <h4 id="modalResourceProjectTitle" class="modal-title">Set New Resource</h4>
			    </div>
		    	<div class="modal-body">
					<input type="hidden" id="resourceProjectId">
        			<div class="row-box col-sm-12">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="ResourceName"> Resource Name </label>
          					<div class="col-sm-8">
          						<select id="projectNames">
								</select>
    						</div>
          				</div>
        			</div>
        			<div class="row-box col-sm-12">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="StartDate"> Start Date </label> 
             				<div class="col-sm-8">
              					<input type="date" id="resourceDateStartProject">
        					</div>
          				</div>
        			</div>
					<div class="row-box col-sm-12">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="EndDate"> End Date </label> 
             				<div class="col-sm-8">
              					<input type="date" id="resourceDateEndProject">
        					</div>
          				</div>
        			</div>
					<div class="row-box col-sm-12">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="Hours"> Hours </label> 
             				<div class="col-sm-8">
              					<input type="number" id="resourceHoursProject" value="8">
        					</div>
          				</div>
        			</div>
					<div class="row-box col-sm-12">
			        	<div class="form-group form-group-sm">
			        		<label class="control-label col-sm-4 translatable" data-i18n="Lead"> Lead </label> 
			              <div class="col-sm-8">
			              	<input type="checkbox" id="resourceLead"><br/>
			              </div>    
			          </div>
			        </div>
      			</div>
      			<div class="modal-footer">
			        <button type="button" id="resourceProjectCreate" class="btn btn-default" onclick="setResourceToProject(0, $('#resourceProjectId').val(), $('#projectNames').val(), $('#resourceDateStartProject').val(), $('#resourceDateEndProject').val(), $('#resourceHoursProject').val(), $('#resourceLead').is(':checked'), true)" data-dismiss="modal">Set</button>
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
					<div class="row-box col-sm-12">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="ResourceName"> Resource Name </label>
          					<div class="col-sm-8">
								<input type="text" id="resourceProjectUpdateName" readonly>
    						</div>
          				</div>
        			</div>
        			<div class="row-box col-sm-12">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="StartDate"> Start Date </label> 
             				<div class="col-sm-8">
              					<input type="date" id="resourceUpdateDateStartProject">
        					</div>
          				</div>
        			</div>
					<div class="row-box col-sm-12">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="EndDate"> End Date </label> 
             				<div class="col-sm-8">
              					<input type="date" id="resourceUpdateDateEndProject">
        					</div>
          				</div>
        			</div>
					<div class="row-box col-sm-12">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="Hours"> Hours </label> 
             				<div class="col-sm-8">
              					<input type="number" id="resourceUpdateDateHoursProject">
        					</div>
          				</div>
        			</div>
					<div class="row-box col-sm-12">
			        	<div class="form-group form-group-sm">
			        		<label class="control-label col-sm-4 translatable" data-i18n="Lead"> Lead </label> 
			              <div class="col-sm-8">
			              	<input type="checkbox" id="resourceUpdateLead"><br/>
			              </div>    
			          </div>
			        </div>
      			</div>
      			<div class="modal-footer">
			        <button type="button" id="resourceProjectCreate" class="btn btn-default" onclick="setResourceToProject($('#resourceProjectIDUpdate').val(), $('#resourceProjectUpdateId').val(), $('#projectUpdateId').val(), $('#resourceUpdateDateStartProject').val(), $('#resourceUpdateDateEndProject').val(), $('#resourceUpdateDateHoursProject').val(), $('#resourceUpdateLead').is(':checked'), false)" data-dismiss="modal">Set</button>
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