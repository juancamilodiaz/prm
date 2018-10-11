<script>
	$(document).ready(function(){		
		$('.modal-trigger').leanModal();
		$('.tooltipped').tooltip();
		$('select').material_select();


		function formatDate(valDate) {
			var monthNames = [
				"January", "February", "March",
				"April", "May", "June", "July",
				"August", "September", "October",
				"November", "December"
			];
			
			var dateFrom = valDate.split("T");
			var from = dateFrom[0].split("-");
			var f = new Date(from[0], from[1] - 1, from[2]);

			var day = f.getDate();
			var monthIndex = f.getMonth();
			var year = f.getFullYear();
			
			return day + ' ' + monthNames[monthIndex] + ' ' + year;
		}


		$('#viewResourceInProject').DataTable({
			"iDisplayLength": 20,
			"bLengthChange": false,
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
		      $("div.toolbar").html('<a id="multiDelete" class="btn-floating btn-large disabled modal-trigger tooltipped" data-position="top" data-tooltip="Unassign All" href="#confirmUnassignModal" data-dismiss="modal" onclick="' + "$('#projectID').val({{.ProjectId}}); $('#nameDelete').html('the marked elements')" + '" ><i class="mdi-action-delete"></i></a>');     
		   	  $('.modal-trigger').leanModal();
			 } 
		});
		$('#titlePag').html("{{.Title}}");
		$('#backButton').css("display", "inline-block");
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
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("href", "#resourceProjectModal");
		$('#buttonOption').attr("onclick","$('#resourceProjectId').val({{.ProjectId}});getResources();configureShowCreateModal()");
		
		
		var prjStartDate = formatDate({{.StartDate}});
		var prjEndDate = formatDate({{.EndDate}});
		$('#dates').text("Date From: "+ prjStartDate + "  -  Date To: " + prjEndDate);

		$('.datepicker').pickadate({
			selectMonths: true,
			selectYears: 15,
			format: 'yyyy-mm-dd',
			showButtonPanel: false,
			formatSubmit: 'yyyy-mm-dd',
			container: 'body'
		});
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
			$('#multiDelete').removeClass("disabled");
		} else {
			$('#multiDelete').addClass("disabled");			
		}
	});

	getDateToday = function(){	
		var time = new Date();
		var mm = time.getMonth() + 1; // getMonth() is zero-based
		var dd = time.getDate();
        var date =  [time.getFullYear(),
	          (mm>9 ? '' : '0') + mm,
	          (dd>9 ? '' : '0') + dd
	         ].join('-');
		return date;
	}
	
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
		  $('select').material_select();
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
		 // $('#showInfoResourceModal').modal("show");
		});		
	}
</script>

<div class="container" style="padding:15px;">
	<div class="row">
		<div class="col s12   marginCard">
			<div id="pry_add">
				<h4 id="titlePag"></h4>
				<a id="backButton" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Back"  ><i class="mdi-navigation-arrow-back large"></i></a>
				<a id="refreshButton" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Refresh"  ><i class="mdi-navigation-refresh large"></i></a>
				<a id="buttonOption" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Set New Resource"><i class="mdi-action-note-add large"></i></a>
			</div>
		</div>

<div class="col s12 marginCard"><p class="pull-right" style="padding-right: 0%;"> <label type="text" id="dates" \></p></div>
</div>
<table id="viewResourceInProject" class="display" cellspacing="0" width="100%">
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
			<td><p><input id="{{$resourceToProject.ID}}" class="checkToDelete" type="checkbox" value="{{$resourceToProject.ID}}" /><label for="{{$resourceToProject.ID}}" ><span></span></label></p></td>
			<td>{{$resourceToProject.ResourceName}}</td>
			<td>{{dateformat $resourceToProject.StartDate "2006-01-02"}}</td>
			<td>{{dateformat $resourceToProject.EndDate "2006-01-02"}}</td>
			<td>{{$resourceToProject.Hours}}</td>
			<td>
				<a class="modal-trigger tooltipped" data-position="top" data-tooltip="Update assign" href="#resourceProjectUpdateModal" onclick='$("#resourceProjectUpdateName").val("{{$resourceToProject.ResourceName}}");$("#resourceProjectUpdateId").val({{$resourceToProject.ResourceId}});$("#projectUpdateId").val({{$resourceToProject.ProjectId}});configureShowUpdateModal({{dateformat $resourceToProject.StartDate "2006-01-02"}}, {{dateformat $resourceToProject.EndDate "2006-01-02"}}, {{$resourceToProject.Hours}});$("#resourceProjectIDUpdate").val({{$resourceToProject.ID}});' > <i class="mdi-editor-mode-edit"></i></a>
				<a class="modal-trigger tooltipped" data-position="top" data-tooltip="Resource Info" href="#showInfoResourceModal" onclick='configureShowModal({{$resourceToProject.ResourceId}}, "{{$resourceToProject.ResourceName}}");getResource({{$resourceToProject.ResourceId}})' > <i class="mdi-action-assignment-late"></i></a>
				<a class="modal-trigger tooltipped" data-position="top" data-tooltip="Unassign" href="#confirmUnassignModal" onclick="$('#nameDelete').html('{{$resourceToProject.ResourceName}}');$('#resourceProjectIDDelete').val({{$resourceToProject.ID}});$('#projectID').val({{$resourceToProject.ProjectId}});" > <i class="mdi-action-delete"></i></a>

				<!--<button data-toggle="modal" data-target="#confirmUnassignModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$resourceToProject.ResourceName}}');$('#resourceProjectIDDelete').val({{$resourceToProject.ID}});$('#projectID').val({{$resourceToProject.ProjectId}});" data-dismiss="modal">Unassign</button>
				<button data-toggle="modal" data-target="#resourceProjectUpdateModal" class="buttonTable button2" onclick='$("#resourceProjectUpdateName").val("{{$resourceToProject.ResourceName}}");$("#resourceProjectUpdateId").val({{$resourceToProject.ResourceId}});$("#projectUpdateId").val({{$resourceToProject.ProjectId}});configureShowUpdateModal({{dateformat $resourceToProject.StartDate "2006-01-02"}}, {{dateformat $resourceToProject.EndDate "2006-01-02"}}, {{$resourceToProject.Hours}});$("#resourceProjectIDUpdate").val({{$resourceToProject.ID}});' data-dismiss="modal">Update assign</button>
				<button data-toggle="modal" class="buttonTable button2" onclick='configureShowModal({{$resourceToProject.ResourceId}}, "{{$resourceToProject.ResourceName}}");getResource({{$resourceToProject.ResourceId}})' data-dismiss="modal">Resource Info.</button>-->
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>
</div>



<!-- Materialize Modal Update -->
	<div id="resourceProjectModal" class="modal " style = "overflow:visible" >
			<div class="modal-content">
				<h5 id="modalResourceProjectTitle" class="modal-title">Set New Resource</h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="resourceProjectId">
				<div class="row">	
					<!-- Select -->
					<div class="input-field col s12 ">
						<label for="resourceNameProject"  class= "active">Resource Name</label>
						<select id="resourceNameProject" style="inline-size: 174px; border-radius: 8px;"></select>	
					</div>
					<!-- Close Select -->
					<div class="input-field col s12 m6 ">
						<label for="resourceDateStartProject" class="active">Start Date:</label>
						<input id="resourceDateStartProject" type="date" class="datepicker">
					</div>

					<div class="input-field col s12 m6 ">
						<label for="resourceDateEndProject" class="active">End Date:</label>
						<input id="resourceDateEndProject" type="date" class="datepicker">
					</div>
					<div class="input-field col s12 m6">
						<input id="resourceHoursProject" type="number"  class="validate">
						<label  for="resourceHoursProject"  class="active">Total Hours</label>
					</div>
					<div class="input-field col s12 m6">
						<p>
							<input id="checkHoursPerDay" type="checkbox" />
							<label for="checkHoursPerDay" ><span>Activate Hours Per Day</span></label>
						</p>
					</div>
					<div class="input-field col s12 m7 l7">
						<input id="createHoursPerDay" type="number"  class="validate">
						<label  for="createHoursPerDay"  class="active">Hours Per Day</label>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<a id="resourceProjectCreate" onclick="setResourceToProject(0, $('#resourceNameProject').val(), $('#resourceProjectId').val(), $('#resourceDateStartProject').val(), $('#resourceDateEndProject').val(), $('#resourceHoursProject').val(), true, $('#createHoursPerDay').val(), $('#checkHoursPerDay').is(':checked'))" class="waves-effect waves-green btn-flat modal-action modal-close" >Set</a>
       		 	<a class="waves-effect waves-red btn-flat modal-action modal-close">Cancel</a>
			</div>
	</div>





<!-- Modal content
	<div class="modal fade" id="resourceProjectModal" role="dialog">
  		<div class="modal-dialog">
    		
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
	</div>-->


		<!-- Materialize Modal Update -->
	<div id="resourceProjectUpdateModal" class="modal " style = "overflow:visible" >
			<div class="modal-content">
				<h5 id="modalUpdateResourceProjectTitle" class="modal-title">Update Assign Resource</h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="resourceProjectUpdateId">
				<input type="hidden" id="projectUpdateId">
				<input type="hidden" id="resourceProjectIDUpdate">	
				<div class="input-field row">	
					<div class="input-field col s12">
						<input id="resourceProjectUpdateName" type="text"  class="validate">
						<label  for="resourceProjectUpdateName"  class="active">Resource Name</label>
					</div>

					<div class="input-field col s12 m6 ">
						<label for="resourceUpdateDateStartProject" class="active">Start Date:</label>
						<input id="resourceUpdateDateStartProject" type="date" class="datepicker">
					</div>

					<div class="input-field col s12 m6 ">
						<label for="resourceUpdateDateEndProject" class="active">End Date:</label>
						<input id="resourceUpdateDateEndProject" type="date" class="datepicker">
					</div>
					
					<div class="input-field col s12 m7 l7">
						<input id="resourceUpdateDateHoursProject" type="number"  class="validate">
						<label  for="resourceUpdateDateHoursProject"  class="active">Hours</label>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<a id="resourceProjectCreate" onclick="setResourceToProject($('#resourceProjectIDUpdate').val(), $('#resourceProjectUpdateId').val(), $('#projectUpdateId').val(), $('#resourceUpdateDateStartProject').val(), $('#resourceUpdateDateEndProject').val(), $('#resourceUpdateDateHoursProject').val(), false, 0, false)" class="waves-effect waves-green btn-flat modal-action modal-close" >Set</a>
       		 	<a class="waves-effect waves-red btn-flat modal-action modal-close">Cancel</a>
			</div>
	</div>
    
	
<!--
	<div class="modal" id="resourceProjectUpdateModal">
    		<div class="modal-content">
			        <h5 id="modalUpdateResourceProjectTitle" class="modal-title">Update Assign Resource</h5>
					<div class="divider"></div><br> 
					<input type="hidden" id="resourceProjectUpdateId">
        			<input type="hidden" id="projectUpdateId">
					<input type="hidden" id="resourceProjectIDUpdate">				
					<div class="input-field col s12 m5 l5">
						<label class="active"> Resource Name </label>
						<input type="text" id="resourceProjectUpdateName" readonly >						
        			</div>
        			<div class="input-field col s12 m5 l5">
						<label class="active"> Start Date </label> 
						<input type="date" id="resourceUpdateDateStartProject">
        			</div>
					<div class="input-field col s12 m5 l5">
        				<label class="active"> End Date </label> 
             			<input type="date" id="resourceUpdateDateEndProject">        				
        			</div>
					<div class="input-field col s12 m5 l5">
        				<label class="active"> Hours </label>
              			<input type="number" id="resourceUpdateDateHoursProject">
        			</div>
      			</div>
      			<div class="modal-footer">
			        <a id="resourceProjectCreate" class="waves-effect waves-green btn-flat modal-action modal-close" onclick="setResourceToProject($('#resourceProjectIDUpdate').val(), $('#resourceProjectUpdateId').val(), $('#projectUpdateId').val(), $('#resourceUpdateDateStartProject').val(), $('#resourceUpdateDateEndProject').val(), $('#resourceUpdateDateHoursProject').val(), false, 0, false)">Set</button>
			        <a class="waves-effect waves-red btn-flat modal-action modal-close">Cancel</a>
			    </div>
    		</div>    
  		</div>
	</div>

-->


<!-- Materialize Modal Unassign -->
<div id="confirmUnassignModal" class="modal" >
			<div class="modal-content">
				<h5  class="modal-title">Unassign Confirmation</h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="resourceProjectIDDelete">
				<input type="hidden" id="projectID">
				Are you sure that you want to unassign <b id="nameDelete"></b> from <b>{{.Title}}</b> project?
			</div>
			<div class="modal-footer">
				<a id="resourceUnassign"  onclick="unassignResource()" class="waves-effect waves-green btn-flat modal-action modal-close" >Yes</a>
        		<a class="waves-effect waves-red btn-flat modal-action modal-close">No</a>
			</div>
</div>

<!-- Modal Unassign close 


	<div class="modal" id="confirmUnassignModal">
	    	<div class="modal-content">
	        	<h5 class="modal-title">Unassign Confirmation</h5>	  	  
				<div class="divider"></div>	      		
				<input type="hidden" id="resourceProjectIDDelete">
				<input type="hidden" id="projectID">
					Are you sure that you want to unassign <b id="nameDelete"></b> from <b>{{.Title}}</b> project?
	      		</div>
				<div class="modal-footer" style="text-align:center;">
					<a id="resourceUnassign" class="waves-effect waves-green btn-flat modal-action modal-close" onclick="unassignResource()" >Confirm</a>
					<a class="waves-effect waves-red btn-flat modal-action modal-close">Cancel</a>
				</div>
			</div>
		</div>
	</div>
-->

	<div class="modal" id="showInfoResourceModal">
		  <div class="modal-content">
				<h5 id="modalShowTitle" class="modal-title">Resource Information</h5>
				<div class="divider"></div> <br>
			 </div>
			 <div class="modal-body" id="resourceInfo">
				<input type="hidden" id="showResourceID">				
			 </div>
			 <div class="modal-footer">
				<a  type="button" class="waves-effect waves-green btn-flat modal-action modal-close" >OK</button>
			 </div>
		  </div>
	   </div>
	</div>