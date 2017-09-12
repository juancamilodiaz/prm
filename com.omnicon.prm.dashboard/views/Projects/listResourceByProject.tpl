<script>
	$(document).ready(function(){
		$('#viewResourceInProject').DataTable({

		});
		$('#titlePag').html("{{.Title}}");
		$('#backButton').css("display", "inline-block");
		$('#backButton').html("Projects");
		$('#backButton').prop('onclick',null).off('click');
		$('#backButton').click(function(){
			reload('/projects',{});
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
		console.log(settings);
		$.ajax(settings).done(function (response) {
		  reload('/projects/resources', {"ID": $('#projectID').val(),"ProjectName": "{{.Title}}"})
		});
	}
	
	configureShowModal = function(pID, pName){
		
		$("#resourceID").val(pID);
		$("#resourceName").val(pName);
		$("#resourceLastName").val(pLastName);
		$("#resourceEmail").val(pEmail);
		$("#resourceRank").val(pRank);
		$("#resourceActive").prop('checked', pActive);
		
		$("#modalTitle").html("Update Resource");
		$("#resourceCreate").css("display", "none");
		$("#resourceUpdate").css("display", "inline-block");
	}
	
	setResourceToProject = function(resourceId, projectId, startDate, endDate){
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
				"Lead": $('#resourceLead').is(":checked")
			}
		}
		console.log(settings);
		$.ajax(settings).done(function (response) {
		  reload('/projects/resources', {"ProjectId": projectId,"ProjectName": "{{.Title}}"})
		});
	}
</script>
<table id="viewResourceInProject" class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>Resource Name</th>
			<th>Start Date</th>
			<th>End Date</th>
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
			<td>{{$resourceToProject.Lead}}</td>
			<td>
				<button data-toggle="modal" data-target="#confirmUnassignModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$resourceToProject.ResourceName}}');$('#resourceID').val({{$resourceToProject.ResourceId}});$('#projectID').val({{$resourceToProject.ProjectId}});" data-dismiss="modal">Unassign of project</button>
				<button data-toggle="modal" data-target="#confirmModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$resourceToProject.ResourceId}}');$('#projectID').val({{$resourceToProject.ProjectId}});" data-dismiss="modal" disabled>Update assign</button>
				<button data-toggle="modal" date-target="#showInfoResourceModal" class="buttonTable button2" onclick="configureShowModal({{$resourceToProject.ResourceId}}, '{{$resourceToProject.ResourceName}}');" data-dismiss="modal" disabled>More Info.</button>
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>
<div style="text-align:center;">
	<button class="button button2" data-toggle="modal" data-target="#resourceProjectModal" onclick="configureCreateModal();$('#resourceProjectId').val({{.ProjectId}})">Set New Resource</button>
</div>
<!-- Modal -->
	<div class="modal fade" id="resourceProjectModal" role="dialog">
  		<div class="modal-dialog">
    		<!-- Modal content-->
    		<div class="modal-content">
      			<div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal">&times;</button>
			        <h4 id="modalResourceProjectTitle" class="modal-title"></h4>
			    </div>
		    	<div class="modal-body">
					<input type="hidden" id="resourceProjectId">
        			<div class="row-box col-sm-12">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="ResourceName"> Resource Name </label>
          					<div class="col-sm-8">
          						<select id="resourceNameProject">
									<option value="">Please select an option</option>
									<option value=23>Anderson</option>
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
			        		<label class="control-label col-sm-4 translatable" data-i18n="Lead"> Lead </label> 
			              <div class="col-sm-8">
			              	<input type="checkbox" id="resourceLead"><br/>
			              </div>    
			          </div>
			        </div>
      			</div>
      			<div class="modal-footer">
			        <button type="button" id="resourceProjectCreate" class="btn btn-default" onclick="setResourceToProject($('#resourceNameProject').val(), $('#resourceProjectId').val(), $('#resourceDateStartProject').val(), $('#resourceDateEndProject').val())" data-dismiss="modal">Set</button>
			        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
			    </div>
    		</div>    
  		</div>
	</div>

	<div class="modal fase" id="confirmUnassignModal" role="dialog">
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
	<div class="modal fase" id="showInfoResourceModal" role="dialog">
		<div class="modal-dialog">
	    <!-- Modal content-->
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal">&times;</button>
	        <h4 id="modalTitle" class="modal-title">Resource Information</h4>
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
</div>
</div>