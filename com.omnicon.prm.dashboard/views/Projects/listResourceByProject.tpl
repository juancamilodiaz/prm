<script>
	$(document).ready(function(){
		$('#viewResourceInProject').DataTable({
			"columns":[
				null,
				null,
				null,
				null,
				null,
				{"searchable":false}
			]
		});
		$('#titlePag').html("{{.Title}}");
		$('#backButton').css("display", "inline-block");
		$('#backButton').html("Projects");
		$('#backButton').prop('onclick',null).off('click');
		$('#backButton').click(function(){
			reload('/projects',{});
		}); 
		$('#datePicker').css("display", "none");
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/projects/resources',{
				"ProjectId": {{.ProjectId}},
				"ProjectName": "{{.Title}}"
			});
		}); 
		
		$('#resourceDateStartProject, #resourceDateEndProject, #resourceUpdateDateStartProject, #resourceUpdateDateEndProject').change(function(){
	    	var startDateCreate = new Date($("#resourceDateStartProject").val());
			var endDateCreate = new Date($("#resourceDateEndProject").val());
	
			$("#resourceHoursProject").val(workingHoursBetweenDates(startDateCreate, endDateCreate));
			
			var startDateUpdate = new Date($("#resourceUpdateDateStartProject").val());
			var endDateUpdate = new Date($("#resourceUpdateDateEndProject").val());
	
			$("#resourceUpdateDateHoursProject").val(workingHoursBetweenDates(startDateUpdate, endDateUpdate));
		});
	});
	
	unassignResource = function(){
		var settings = {
			method: 'POST',
			url: '/projects/resources/unassign',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"resourceID": $('#resourceID').val(),
				"projectID": $('#projectID').val()
			}
		}
		$.ajax(settings).done(function (response) {
		  reload('/projects/resources', {"ProjectId": $('#projectID').val(),"ProjectName": "{{.Title}}"})
		});
	}
	
	configureShowModal = function(pID, pName){
		
		$("#showResourceID").val(pID);
		$("#showResourceName").val(pName);
		/*$("#resourceLastName").val(pLastName);
		$("#resourceEmail").val(pEmail);
		$("#resourceRank").val(pRank);
		$("#resourceActive").prop('checked', pActive);
		*/
		$("#modalTitle").html("Show Resource Information");
	}
	
	configureShowCreateModal = function(){
		$("#resourceDateStartProject").val(getDateToday());
		$("#resourceDateEndProject").val(getDateToday());
	}
	
	configureShowUpdateModal = function(pStartDate, pEndDate, pHours, pLead){
		
		$("#resourceUpdateDateStartProject").val(pStartDate);
		$("#resourceUpdateDateEndProject").val(pEndDate);
		$("#resourceUpdateDateHoursProject").val(pHours);
		$("#resourceUpdateLead").prop('checked', pLead);
		
		$("#modalTitle").html("Update Assign Resource");
		$("#resourceCreate").css("display", "none");
		$("#resourceUpdate").css("display", "inline-block");
	}
	
	setResourceToProject = function(resourceId, projectId, startDate, endDate, hours, lead){
		var settings = {
			method: 'POST',
			url: '/projects/setresource',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ProjectId": projectId,
				"ResourceId": resourceId,
				"StartDate": startDate,
				"EndDate": endDate,
				"Hours": hours,
				"Lead": lead
			}
		}
		$.ajax(settings).done(function (response) {
		  reload('/projects/resources', {"ProjectId": projectId,"ProjectName": "{{.Title}}"})
		});
	}
	
	getResources = function(){
		var settings = {
			method: 'POST',
			url: '/resources',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"Template": "select",				
			}
		}
		$.ajax(settings).done(function (response) {
		  $('#resourceNameProject').html(response);
		});
	}
	
	getResource = function(pResourceId){
		var settings = {
			method: 'POST',
			url: '/resources/read',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": pResourceId,				
			}
		}
		$.ajax(settings).done(function (response) {
		  $('#resourceInfo').html(response);
		  $('#showInfoResourceModal').modal("show");
		});		
	}
</script>
<table id="viewResourceInProject" class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>Resource Name</th>
			<th>Start Date</th>
			<th>End Date</th>
			<th>Hours</th>
			<th>Lead</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $resourceToProject := .ResourcesToProjects}}
		<tr>
			<td>{{$resourceToProject.ResourceName}}</td>
			<td>{{dateformat $resourceToProject.StartDate "2006-01-02"}}</td>
			<td>{{dateformat $resourceToProject.EndDate "2006-01-02"}}</td>
			<td>{{$resourceToProject.Hours}}</td>
			<td><input type="checkbox" {{if $resourceToProject.Lead}}checked{{end}} disabled></td>
			<td>
				<button data-toggle="modal" data-target="#confirmUnassignModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$resourceToProject.ResourceName}}');$('#resourceID').val({{$resourceToProject.ResourceId}});$('#projectID').val({{$resourceToProject.ProjectId}});" data-dismiss="modal">Unassign of project</button>
				<button data-toggle="modal" data-target="#resourceProjectUpdateModal" class="buttonTable button2" onclick='$("#resourceProjectUpdateName").val("{{$resourceToProject.ResourceName}}");$("#resourceProjectUpdateId").val({{$resourceToProject.ResourceId}});$("#projectUpdateId").val({{$resourceToProject.ProjectId}});configureShowUpdateModal({{dateformat $resourceToProject.StartDate "2006-01-02"}}, {{dateformat $resourceToProject.EndDate "2006-01-02"}}, {{$resourceToProject.Hours}}, {{$resourceToProject.Lead}})' data-dismiss="modal">Update assign</button>
				<button data-toggle="modal" class="buttonTable button2" onclick='configureShowModal({{$resourceToProject.ResourceId}}, "{{$resourceToProject.ResourceName}}");getResource({{$resourceToProject.ResourceId}})' data-dismiss="modal">Resource Info.</button>
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>
<div style="text-align:center;">
	<button class="button button2" data-toggle="modal" data-target="#resourceProjectModal" onclick="$('#resourceProjectId').val({{.ProjectId}});getResources();configureShowCreateModal()">Set New Resource</button>
</div>
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
          						<select id="resourceNameProject">
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
			        <button type="button" id="resourceProjectCreate" class="btn btn-default" onclick="setResourceToProject($('#resourceNameProject').val(), $('#resourceProjectId').val(), $('#resourceDateStartProject').val(), $('#resourceDateEndProject').val(), $('#resourceHoursProject').val(), $('#resourceLead').is(':checked'))" data-dismiss="modal">Set</button>
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
			        <button type="button" id="resourceProjectCreate" class="btn btn-default" onclick="setResourceToProject($('#resourceProjectUpdateId').val(), $('#projectUpdateId').val(), $('#resourceUpdateDateStartProject').val(), $('#resourceUpdateDateEndProject').val(), $('#resourceUpdateDateHoursProject').val(), $('#resourceUpdateLead').is(':checked'))" data-dismiss="modal">Set</button>
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
					<input type="hidden" id="resourceID">
	        		<input type="hidden" id="projectID">
						Are you sure that you want to unassign <b id="nameDelete"></b> from <b>{{.Title}}</b> project?
	      		</div>
				<div class="modal-footer" style="text-align:center;">
					<button type="button" id="resourceUnassign" class="btn btn-default" onclick="unassignResource()" data-dismiss="modal">Yes</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">No</button>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="showInfoResourceModal" role="dialog">
	   <div class="modal-dialog">
		  <!-- Modal content-->
		  <div class="modal-content">
			 <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 id="modalShowTitle" class="modal-title">Resource Information</h4>
			 </div>
			 <div class="modal-body" id="resourceInfo">
				<input type="hidden" id="showResourceID">				
			 </div>
			 <div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">OK</button>
			 </div>
		  </div>
	   </div>
	</div>