<script>
	var editor; 
	$(document).ready(function(){
		
		editor = new $.fn.dataTable.Editor( {
	        table: "#viewProjectsForecast",
			idSrc: 'id',
	        fields: [ {
	                label: "Business Unit:",
	                name: "business_unit"
	            }, {
	                label: "Region:",
	                name: "region"
	            }, {
	                label: "Project ID:",
	                name: "id"
	            }, {
	                label: "Project Type:",
	                name: "types"
	            }, {
	                label: "Project Name:",
	                name: "name"
	            }, {
	                label: "Description:",
	                name: "description"
	            }, {
	                label: "Start date:",
	                name: "start_date",
	                type: "datetime"
	            }, {
	                label: "End date:",
	                name: "end_date",
	                type: "datetime"
	            }, {
	                label: "No. Of Sites:",
	                name: "number_sites"
	            }, {
	                label: "No. Of Process:",
	                name: "number_process_per_site"
	            }, {
	                label: "MOM Resources",
	                name: "mom_resources"
	            }, {
	                label: "DEV Resources",
	                name: "dev_resources"
	            }, {
	                label: "Total Resources",
	                name: "total_resources"
	            }, {
	                label: "Estimate Cost:",
	                name: "estimate_cost"
	            }, {
	                label: "Billing date:",
	                name: "billing_date",
	                type: "datetime"
	            }, {
	                label: "Status:",
	                name: "status"
	            }, {
	                label: "Options:",
	                name: "options"
	            }
	        ]
	    } );
		
		// Activate an inline edit on click of a table cell
	    $('#viewProjectsForecast').on( 'click', 'tbody td:not(:first-child)', function (e) {
	        editor.inline( this, 'id' );
	    } );
		
		var oTable = $('#viewProjectsForecast').DataTable( {
	        dom: "Bfrtip",
	        order: [[ 1, 'asc' ]],
	        columns: [
	            {name: 'BusinessUnit', "orderable": false, "className":'editable'},
				{name: 'Region', "orderable": false, "className":'editable'},
				{name: 'ID', "orderable": false},
				{name: 'Types', "orderable": false, "className":'editable'},
				{name: 'Name', "orderable": false, "className":'editable'},
				{name: 'Description', "orderable": false, "className":'editable'},
				{name: 'StartDate', "orderable": false, "className":'editable'},
				{name: 'EndDate', "orderable": false, "className":'editable'},
				{name: 'NumberSites', "orderable": false, "className":'editable'},
				{name: 'NumberProcessPerSite', "orderable": false, "className":'editable'},
				{name: 'MOMResources', "orderable": false, "className":'editable'},
				{name: 'DEVResources', "orderable": false, "className":'editable'},
				{name: 'TotalResources', "orderable": false},
				{name: 'EstimateCost', "orderable": false, "className":'editable'},
				{name: 'BillingDate', "orderable": false, "className":'editable'},
				{name: 'Status', "orderable": false, "className":'editable'},
				{name: 'Options', "searchable":false, "orderable": false}
	        ],
	        select: {
	            style:    'os',
	            selector: 'td:first-child'
	        }
	    } );
				
		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		$('#backButton').prop('onclick',null).off('click');
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/projectsForecast',{});
		});
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOption').html("New Forecast Project");
		//$('#buttonOption').attr("onclick","createForecastProject()");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#projectForecastModal");
		$('#buttonOption').attr("onclick","configureCreateModal()");
		
		sendTitle("Forecast Projects");
				
	});
	
	configureCreateModal = function(){
		
		$("#projectForecastID").val(null);
		$("#projectBusinessUnit").val(null);
		$("#projectForecastRegion").val(null);
		$("#projectForecastName").val(null);
		$("#projectForecastStartDate").val(null);		
		$("#projectForecastEndDate").val(null);
		
		$("#modalProjectForecastTitle").html("Create Forecast Project");
		$("#projectForecastUpdate").css("display", "none");
		$("#projectForecastCreate").css("display", "inline-block");
	}
	
	configureUpdateModal = function(pID, pOperationCenter, pWorkOrder, pName, pStartDate, pEndDate, pActive, pLeaderID){
		
		$("#projectID").val(pID);
		$("#projectOperationCenter").val(pOperationCenter);
		$("#projectWorkOrder").val(pWorkOrder);
		$("#projectName").val(pName);
		
		$("#projectStartDate").val(pStartDate);
		$("#projectEndDate").val(pEndDate);
		$("#projectEndDate").attr("min", pStartDate);
		$("#projectActive").prop('checked', pActive);
		
		$("#leaderID").val(0);
		if (pLeaderID != null) {
			$("#leaderID").val(pLeaderID);
		}
		$("#modalProjectTitle").html("Update Project");
		$("#projectCreate").css("display", "none");
		$("#projectUpdate").css("display", "inline-block");
		$("#divProjectType").css("display", "none");
	}
	
	createForecastProject = function(){
		var settings = {
			method: 'POST',
			url: '/projectsForecast/create',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"BusinessUnit": $('#projectBusinessUnit').val(),
				"Region": $('#projectForecastRegion').val(),
				"Name": $('#projectForecastName').val(),
				"StartDate": $('#projectForecastStartDate').val(),
				"EndDate": $('#projectForecastEndDate').val()
			}
		}
		$.ajax(settings).done(function (response) {
		  	var data = {
				"default":true
			}
			reload('/projectsForecast',data);
		});
	}
	
	read = function(){
		var settings = {
			method: 'POST',
			url: '/projects/read',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#projectName').val(),
			}
		}
		$.ajax(settings).done(function (response) {
		});
	}
	
	deleteForecastProject = function(){
		var settings = {
			method: 'POST',
			url: '/projectsForecast/delete',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#projectID').val()
			}
		}
		$.ajax(settings).done(function (response) {
		 	var data = {
				"default":true
			}
			reload('/projectsForecast',data);
		});
	}
	
	getResourcesByProject = function(projectID, projectName){
		var settings = {
			method: 'POST',
			url: '/projects/resources',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ProjectId": projectID,
				"ProjectName": projectName
			}
		}
		$.ajax(settings).done(function (response) {
		  $("#content").html(response);
		  $('.modal-backdrop').remove();
		});
	}
	
	find = function(tableRow) {
	  var $table = tableRow.closest('table');
	  var query = "Project ID";
	  var result = tableRow.find('td').filter(function() {
	     return $table.find('th').index($(this).index()).html() === query;
	  });
	  alert(result.html());
	}
	
	$(document).on('click','#deleteProjectForecast',function(){
    	$('#confirmModal').modal('show');
	});
	
	openCity = function(evt, cityName) {
	    // Declare all variables
	    var i, tabscontent, tablinks;
	
	    // Get all elements with class="tabcontent" and hide them
	    tabscontent = document.getElementsByClassName("tabscontent");
	    for (i = 0; i < tabscontent.length; i++) {
	        tabscontent[i].style.display = "none";
	    }
	
	    // Get all elements with class="tablinks" and remove the class "active"
	    tablinks = document.getElementsByClassName("tablinks");
	    for (i = 0; i < tablinks.length; i++) {
	        tablinks[i].className = tablinks[i].className.replace(" active", "");
	    }
	
	    // Show the current tab, and add an "active" class to the button that opened the tab
	    document.getElementById(cityName).style.display = "block";
	    evt.currentTarget.className += " active";
	}
	
	// Get the element with id="defaultOpen" and click on it
	{{if .Default}}
		document.getElementById("planningOpen").click();
	{{else}}
		document.getElementById("defaultOpen").click();
	{{end}}
</script>

<div>

	<div class="tabs">
		<button class="tablinks" onclick="openCity(event, 'Report')" id="defaultOpen">Report</button>
		<button class="tablinks" onclick="openCity(event, 'Planning')" id="planningOpen">Planning</button>
	</div>
	
	<div id="Report" class="tabscontent">
		HOLA
	</div>
	<div id="Planning" class="tabscontent">
		<table id="viewProjectsForecast" class="table table-striped table-bordered">
			<col style="width: 6%"/>
			<col style="width: 6%"/>
			<col style="width: 6%"/>
			<col style="width: 6%"/>
			<col style="width: 6%"/>
			<col style="width: 6%"/>
			<col style="width: 6%"/>
			<col style="width: 6%"/>
			<col style="width: 6%"/>
			<col style="width: 6%"/>
			<col style="width: 6%"/>
			<col style="width: 6%"/>
			<col style="width: 6%"/>
			<col style="width: 6%"/>
			<col style="width: 6%"/>
			<col style="width: 6%"/>
			<col style="width: 4%"/>
			<thead>
				<tr>
					<th>Business Unit</th>
					<th>Region</th>
					<th>Project ID</th>
					<th>Project Type</th>
					<th>Project Name</th>
					<th>Description</th>
					<th>Start Date</th>
					<th>End Date</th>
					<th>No. Of Sites</th>
					<th>No. Of Process</th>	
					<th>MOM Resources</th>
					<th>DEV Resources</th>
					<th>Total Resources</th>
					<th>Estimate Cost</th>	
					<th>Billing Date</th>
					<th>Status</th>
					<th>Options</th>			
				</tr>
			</thead>
			<tbody>
			 	{{range $key, $projectForecast := .ProjectsForecast}}
				<tr>
					<td>{{$projectForecast.BusinessUnit}}</td>
					<td>{{$projectForecast.Region}}</td>
					<td>{{$projectForecast.ID}}</td>
					<td>
					{{range $keyTypes, $type := $projectForecast.Types}}
						*{{$type.Name}} 
					{{end}}
					</td>
					<td>{{$projectForecast.Name}}</td>
					<td>{{$projectForecast.Description}}</td>
					<td>{{dateformat $projectForecast.StartDate "2006-01-02"}}</td>
					<td>{{dateformat $projectForecast.EndDate "2006-01-02"}}</td>
					<td>{{$projectForecast.NumberSites}}</td>
					<td>{{$projectForecast.NumberProcessPerSite}}</td>
					{{if eq (len $projectForecast.AssignResources) 0}}
						<td id ="MOMEngineers">0</td>
						<td id ="DEVEngineers">0</td>
					{{end}}
					{{range $keyAssigns, $assignResources := $projectForecast.AssignResources}}
						{{if eq (len $projectForecast.AssignResources) 1}}
							{{if eq "MOM Engineer" $assignResources.Name}}
								<td id ="MOMEngineers">{{$assignResources.NumberResources}}</td>
							{{else}}
								<td id ="MOMEngineers">0</td>
							{{end}}
						{{else}}
							{{if eq "MOM Engineer" $assignResources.Name}}
								<td id ="MOMEngineers">{{$assignResources.NumberResources}}</td>
							{{end}}
						{{end}}												
					{{end}}
					{{range $keyAssigns, $assignResources := $projectForecast.AssignResources}}
						{{if eq (len $projectForecast.AssignResources) 1}}
							{{if eq "Developer" $assignResources.Name}}
								<td id ="DEVEngineers">{{$assignResources.NumberResources}}</td>
							{{else}}
								<td id ="DEVEngineers">0</td>
							{{end}}
						{{else}}
							{{if eq "Developer" $assignResources.Name}}
								<td id ="DEVEngineers">{{$assignResources.NumberResources}}</td>
							{{end}}
						{{end}}
					{{end}}
					
					<td id ="totalEngineers">
					{{$projectForecast.TotalEngineers}}
					</td>
					<td>{{$projectForecast.EstimateCost}}</td>	
					<td>{{dateformat $projectForecast.BillingDate "2006-01-02"}}</td>
					<td>{{$projectForecast.Status}}</td>			
					<td>
						<a id="deleteProjectForecast" onclick="$('#nameDelete').html('{{$projectForecast.Name}}');$('#projectID').val({{$projectForecast.ID}});"> <span class="glyphicon glyphicon-trash"></span></a>
					</td>
				</tr>
				{{end}}	
			</tbody>
		</table>
	</div>

</div>

<!-- Modal -->
<div class="modal fade" id="projectForecastModal" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 id="modalProjectForecastTitle" class="modal-title"></h4>
      </div>
      <div class="modal-body">
        <input type="hidden" id="projectForecastID">
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Business Unit"> Business Unit </label>
              <div class="col-sm-8">
              	<input type="text" id="projectBusinessUnit" style="border-radius: 8px;">
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Region"> Region </label>
              <div class="col-sm-8">
              	<input type="text" id="projectForecastRegion" style="border-radius: 8px;">
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Project Name"> Project Name </label>
              <div class="col-sm-8">
              	<input type="text" id="projectForecastName" style="border-radius: 8px;">
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Start Date"> Start Date </label> 
              <div class="col-sm-8">
              	<input type="date" id="projectForecastStartDate" style="inline-size: 174px; border-radius: 8px;">
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="End Date"> End Date </label> 
              <div class="col-sm-8">
              	<input type="date" id="projectForecastEndDate" style="inline-size: 174px; border-radius: 8px;">
        		</div>
          </div>
        </div>
		<!--div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div id="divProjectType" class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Types"> Types </label> 
             	<div class="col-sm-8">
	             	<select  id="projectType" multiple style="width: 174px; border-radius: 8px;">
					{{range $key, $types := .Types}}
						<option value="{{$types.ID}}">{{$types.Name}}</option>
					{{end}}
					</select>
              	</div>    
          	</div>
        </div>
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Active"> Active </label> 
              <div class="col-sm-8">
              	<input type="checkbox" id="projectActive"><br/>
              </div>    
          </div>
        </div>
		<div class="row-box col-sm-12" style="padding-bottom: 1%;">
			<div id="divProjectType" class="form-group form-group-sm">
			<label class="control-label col-sm-4 translatable" data-i18n="Leader"> Leader </label> 
				<div class="col-sm-8">
					<select  id="leaderID" style="width: 174px; border-radius: 8px;">
					<option value="0">Without leader</option>
					{{range $key, $resource := .Resources}}
					<option value="{{$resource.ID}}">{{$resource.Name}} {{$resource.LastName}}</option>
					{{end}}
					</select>
				</div>    
			</div>
		</div-->
      </div>
      <div class="modal-footer">
        <button type="button" id="projectForecastCreate" class="btn btn-default" onclick="createForecastProject()" data-dismiss="modal">Create</button>
		<button type="button" id="projectForecastUpdate" class="btn btn-default" onclick="" data-dismiss="modal">Update</button>
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
        Are you sure you want to remove <b id="nameDelete"></b> from projects?
		<br>
		<li>The resources will lose this project assignment.</li>
		<li>The types will lose this project assignment.</li>
      </div>
      <div class="modal-footer" style="text-align:center;">
        <button type="button" id="projectDelete" class="btn btn-default" onclick="deleteForecastProject()" data-dismiss="modal">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>