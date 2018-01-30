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
			],
			"dom": '<"col-sm-2"<"toolbar">><"col-sm-4"f><"col-sm-6"l><rtip>',
			initComplete: function(){
		      $("div.toolbar").html('<button id="multiDelete" disabled data-toggle="modal" data-target="#confirmUnassignModal" class="buttonTable button2" onclick="' + "$('#projectID').val({{.ProjectId}}); $('#nameDelete').html('the marked elements')" + '" data-dismiss="modal"> Delete </button>');     
		   	} 
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
		$('#buttonOption').html("Set New Resource");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#resourceProjectModal");
		$('#buttonOption').attr("onclick","$('#resourceProjectId').val({{.ProjectId}});getResources();configureShowCreateModal()");
		
		
		var prjStartDate = formatDate({{.StartDate}});
		var prjEndDate = formatDate({{.EndDate}});
		$('#dates').text("Date From: "+ prjStartDate + "  -  Date To: " + prjEndDate);
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

<div class="col-sm-12" style="padding: 1%;">
<div class="row">
<p class="pull-right" style="padding-right: 0%;"> <label type="text" id="dates"/></p>
</div>
<table id="viewResourceInProject" class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>To Delete</th>
			<th>Resource Name</th>
			<th>Start Date</th>
			<th>End Date</th>
			<th>Hours</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $resourceToProject := .ResourcesToProjects}}
		<tr>
			<td><input type="checkbox" value="{{$resourceToProject.ID}}" class="checkToDelete"></td>
			<td>{{$resourceToProject.ResourceName}}</td>
			<td>{{dateformat $resourceToProject.StartDate "2006-01-02"}}</td>
			<td>{{dateformat $resourceToProject.EndDate "2006-01-02"}}</td>
			<td>{{$resourceToProject.Hours}}</td>
			<td>
				<button data-toggle="modal" data-target="#confirmUnassignModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$resourceToProject.ResourceName}}');$('#resourceProjectIDDelete').val({{$resourceToProject.ID}});$('#projectID').val({{$resourceToProject.ProjectId}});" data-dismiss="modal">Unassign</button>
				<button data-toggle="modal" data-target="#resourceProjectUpdateModal" class="buttonTable button2" onclick='$("#resourceProjectUpdateName").val("{{$resourceToProject.ResourceName}}");$("#resourceProjectUpdateId").val({{$resourceToProject.ResourceId}});$("#projectUpdateId").val({{$resourceToProject.ProjectId}});configureShowUpdateModal({{dateformat $resourceToProject.StartDate "2006-01-02"}}, {{dateformat $resourceToProject.EndDate "2006-01-02"}}, {{$resourceToProject.Hours}});$("#resourceProjectIDUpdate").val({{$resourceToProject.ID}});' data-dismiss="modal">Update assign</button>
				<button data-toggle="modal" class="buttonTable button2" onclick='configureShowModal({{$resourceToProject.ResourceId}}, "{{$resourceToProject.ResourceName}}");getResource({{$resourceToProject.ResourceId}})' data-dismiss="modal">Resource Info.</button>
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>
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
        			<div class="row-box col-sm-12" style="padding-bottom: 1%;">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="ResourceName"> Resource Name </label>
          					<div class="col-sm-8">
          						<select id="resourceNameProject" style="width: 174px; border-radius: 8px;">
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
			        <button type="button" id="resourceProjectCreate" class="btn btn-default" onclick="setResourceToProject(0, $('#resourceNameProject').val(), $('#resourceProjectId').val(), $('#resourceDateStartProject').val(), $('#resourceDateEndProject').val(), $('#resourceHoursProject').val(), true, $('#createHoursPerDay').val(), $('#checkHoursPerDay').is(':checked'))" data-dismiss="modal">Set</button>
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