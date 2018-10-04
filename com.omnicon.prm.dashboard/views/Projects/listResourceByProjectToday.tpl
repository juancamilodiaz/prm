<script>
	var MyProject = {};
	$(document).ready(function(){

		MyProject.table = $('#viewResourcesPerProjectUnassign').DataTable({
			"columns": [
				{"className":'details-control',"searchable":true},
				null
	        ],
			"columnDefs": [ {
			      "targets": [1],
			      "orderable": true
			    } ],
			responsive: true,
			"pageLength": 50,
			"searching": true,
			"paging": true,
		});
		
		$('#viewResourcesPerProjectUnassign tbody').on('click', 'td.details-control', function(){
			
		});
		
		$('#viewResourcesHome').DataTable({
			"columns": [
				{"width": "100%"}
	        ],
			scrollY: 370,
			responsive: true,
			"pageLength": 50,
			"searching": true,
			"paging": false,
		});	
				
		$('#backButton').css("display", "none");	
		$('#datePicker').css("display", "inline-block");	
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			var time = new Date();
			var mm = time.getMonth() + 1; // getMonth() is zero-based
			var dd = time.getDate();
	        var date =  [time.getFullYear(),
		          (mm>9 ? '' : '0') + mm,
		          (dd>9 ? '' : '0') + dd
		         ].join('-');
		  	data = { 
					"StartDate": date,
					"EndDate": date
				}
			reload('/projects/resources/today', data);
			$('#dateFrom').val(date)
			$('#dateTo').val(date)
		});
		$('#filterByDateRange').prop('onclick',null).off('click');
		$('#filterByDateRange').click(function(){
		  	data = { 
					"StartDate": $('#dateFrom').val(),
					"EndDate": $('#dateTo').val()
				}
			reload('/projects/resources/today', data);
		});
		
		$('#viewResourcesHome_filter').parent().removeClass("col-md-6");
		$('#viewResourcesHome_filter').parent().css("width","100%");
		$('#viewResourcesHome_filter>label').css("width","100%");
		
		//collapse button event
		$(".btnCollapse").click(
			function(){
				if($(this).hasClass('collapsed')){
					$(this).removeClass('glyphicon-collapse-down');
					$(this).addClass('glyphicon-collapse-up');
				}
				else{
					$(this).removeClass('glyphicon-collapse-up');
					$(this).addClass('glyphicon-collapse-down');
				}
			}
		);
		sendTitle("Home");
	});
	
	unassignResource = function(ID, obj){
		var settings = {
			method: 'POST',
			url: '/projects/resources/unassign',
			headers: {
				'Content-Type': undefined
			},
			data: {
				"ID": ID
			}
		}
		
		//Call the service to delete resource in the project
		$.ajax(settings).done(function (response) {			
		});
	}
	
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
	
	configureCreateModal = function(){
		$("#resourceStartDate").val($('#dateFrom').val());
		$("#resourceEndDate").val($('#dateTo').val());
	}
	
	sleep = function(milliseconds) {
	  var start = new Date().getTime();
	  for (var i = 0; i < 1e7; i++) {
	    if ((new Date().getTime() - start) > milliseconds){
	      break;
	    }
	  }
	}
	
	function showDetails(pObjBody, pListOfRange) {
        var tr = pObjBody.closest('tr');
        var row = MyProject.table.row( tr );
 
        if ( row.child.isShown() ) {
            // This row is already open - close it
            row.child.hide();
            tr.removeClass('shown');
        }
        else {
            // Open this row
            row.child( format(pListOfRange) ).show();
            tr.addClass('shown');
        }
    }
	
	/* Formatting function for row details - modify as you need */
	function format ( d ) {
	    // `d` is the original data object for the row
		var insert = '';
		for (index = 0; index < d.length; index++) {
			insert += '<td class="col-sm-5" style="font-size:12px;text-align: -webkit-center;">'+d[index].StartDate+'</td>'+
	            '<td class="col-sm-5" style="font-size:12px;text-align: -webkit-center;">'+d[index].EndDate+'</td>'+
				'<td class="col-sm-2" style="font-size:12px;text-align: -webkit-center;">'+d[index].Hours+'</td>'+	            
	        '</tr>';
		}
	    return '<table border="0" style="width: 100%;margin-left: 6px;" class="table table-striped table-bordered  dataTable">'+insert+'</table>';
	}

	$('#resourceEndDate, #resourceStartDate, #createHoursPerDay').change(function(){
    	var startDate = new Date($("#resourceStartDate").val());
		var endDate = new Date($("#resourceEndDate").val());

		$("#estimatedHours").val(workingHoursBetweenDates(startDate, endDate, $("#createHoursPerDay").val(), $("#checkHoursPerDay").is(":checked")));
	});
	
	$('#checkHoursPerDay').change(function() {
		if ($('#checkHoursPerDay').is(":checked")) {
			$('#estimatedHours').attr("disabled", "disabled");
			$('#createHoursPerDay').removeAttr("disabled");
		} else {
			$('#createHoursPerDay').attr("disabled", "disabled");
			$('#createHoursPerDay').val("8");
			$('#estimatedHours').removeAttr("disabled");
		}
	});

</script>

<script>

var evento;

getDateToday = function(resourceId, projectId, startDate, endDate, estimatedHours, hoursPerDay, isHoursPerDay){
	var settings = {
		method: 'POST',
		url: '/projects/setresource',
		headers: {
			'Content-Type': undefined
		},
		data: { 
			"ProjectId": parseInt(projectId),
			"ResourceId": parseInt(resourceId),
			"StartDate": startDate,
			"EndDate": endDate,
			"Hours": estimatedHours,
			"HoursPerDay": hoursPerDay,
			"IsHoursPerDay" : isHoursPerDay,
			"IsToCreate": true
		}
	}
	$.ajax(settings).done(function (response) {
	  validationError(response);
	  getResourcesByProjectWithFilterDate();
	});
}

getResourcesByProjectWithFilterDate = function(){
		dateFrom = $('#dateFrom').val();
		dateTo = $('#dateTo').val();
		
	  	data = { 
				"StartDate": dateFrom,
				"EndDate": dateTo
			}
		sleep(500)
		reload('/projects/resources/today', data);
	}

function allowDrop(ev) {
	ev.preventDefault();
	ev.dataTransfer.dropEffect = "copy";
}

function drag(ev, resourceID) {
	
	ev.dataTransfer.dropEffect = "copy";
    ev.dataTransfer.setData("text", ev.target.id);
	ev.dataTransfer.setData("resourceID", resourceID);
}

function drop(ev, projectID, obj) {
	ev.preventDefault();
	ev.dataTransfer.dropEffect = "copy";
	
	
	var rId = ev.dataTransfer.getData("resourceID");
	var pId = projectID;
	//var isValid = true;
	var pName = "";
	var rName = "";
	/*{{range $rindex, $resProj := .ResourcesToProjects}}
		if (projectID == {{$resProj.ProjectId}} && rId == {{$resProj.ResourceId}}){
			isValid = false;
		}
	{{end}}*/
	
	//if (isValid){
		
	var resourceName;
	{{range $index, $resource := .Resources}}
		if (rId == {{$resource.ID}}){
			resourceName = {{$resource.Name}} + " " + {{$resource.LastName}};
		}
	{{end}}
	
	var projectName;
	{{range $index, $project := .Projects}}
		if (pId == {{$project.ID}}){
			projectName = {{$project.Name}};
		}
	{{end}}

	var data = ev.dataTransfer.getData("text");
	data = document.getElementById(data).cloneNode(true);
	
	evento = obj;
	data.setAttribute("draggable", "false");
	data.innerHTML='<tr><td id="res'+rId+'" style="font-size:11px;cursor:no-drop;margin:0 0 0px;">'+resourceName+'</td><td style="font-size:11px;">10-12-2017</td><td style="font-size:11px;">11-12-2017</td><td style="font-size:11px;">8</td><td><img style="padding:0px" data-toggle="modal" data-target="#confirmDeleteModal" data-dismiss="modal" class="btn" src="/static/img/rubbish-bin.png" onclick="(\'#projectID\').val('+pId+');$(\'#resourceID\').val('+rId+'); $(\'body\').data(\'buttonX\', this); $(\'#resourceName\').html('+resourceName+');$(\'#projectName\').html('+projectName+')></td></tr>';
	//Mapped in temporal to show modal
	$("#tempResource").html(data);
	
	configureCreateModal();
	$("#setResourceModal").modal("show");
	$("#resourceIDInput").val(ev.dataTransfer.getData("resourceID"));
	$("#projectIDInput").val(projectID);
	//}
}

function setResourceToProjectExc(){
	$(evento).append($("#tempResource").html());
	$("#tempResource").html("")	
	setResourceToProject($("#resourceIDInput").val(), $("#projectIDInput").val(), $("#resourceStartDate").val(), $("#resourceEndDate").val(), $("#estimatedHours").val(), $("#createHoursPerDay").val(), $("#checkHoursPerDay").is(":checked"));
}
</script>


<tr id="tempResource" style="display:none"></tr>
</div>

<var id="projectIDInput"></var>
<var id="resourceIDInput"></var>

	<div class="row">
		<div class="col s3">
			<div class="panel-group" >
				<div class="panel panel-default">
					<div id="resources" class="panel-body">
						<table id="viewResourcesHome" class="table table-striped table-bordered pull-left">
							<thead>
								<th style="text-align: -webkit-center;">Resources</th>
							</thead>
							<tbody>
								{{range $key, $resource := .Resources}}
									<tr><td id="drag{{$key}}" draggable="true" ondragstart="drag(event,'{{$resource.ID}}')" style="cursor:-webkit-grab;" class="sorting_1 button3">{{$resource.Name}} {{$resource.LastName}}</td></tr>
								{{end}}	
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="col s9" style="overflow-y: auto;height: -webkit-fill-available;">
			<div class="panel-group">
	    		<div id="projects" class="panel">
					{{$projectsLoop := .Projects}}
					{{$resourcesProject := .ResourcesToProjects}}
					{{range $key, $project := $projectsLoop}}	
					 	<div class="col-sm-6" style="padding-bottom: 10px;">	
							<div id="panel-df-project{{$key}}" class="panel panel-default">
								<div id="project{{$key}}" class="panel-heading">
									{{$project.OperationCenter}}-{{$project.WorkOrder}} {{$project.Name}}
									<div class="pull-right">
										{{dateformat $project.StartDate "2006-01-02"}} to {{dateformat $project.EndDate "2006-01-02"}} 
										<button id="collapseButton{{$key}}" class="btnCollapse glyphicon glyphicon-collapse-up" data-toggle="collapse" href="#collapse{{$key}}" style="border:none;border-radius:4px;"></button>
									</div>
								</div>
								<div id="collapse{{$key}}" class="panel-body panel-collapse collapse in" style="padding:0;height: auto;max-height: 221px; overflow-y: auto;" ondrop="drop(event,'{{$project.ID}}', this)" ondragover="allowDrop(event)">
									<table id="viewResourcesPerProject{{$project.ID}}" class="table table-striped table-bordered">
										<thead>
											<th style="font-size:12px;text-align: -webkit-center;">Name</th>
											<th style="font-size:12px;text-align: -webkit-center;">Start date</th>
											<th style="font-size:12px;text-align: -webkit-center;">End date</th>
											<th style="font-size:12px;text-align: -webkit-center;">Hours</th>
											<th style="font-size:12px;text-align: -webkit-center;">Options</th>
										</thead>
										<tbody>
											{{range $keyR, $resProj := $resourcesProject}}
												{{if eq  $resProj.ProjectId $project.ID}}
												<tr draggable ="false">
													<td id="res{{$keyR}}" style="font-size:11px;text-align: -webkit-center;margin:0 0 0px;">{{$resProj.ResourceName}}</td> 
													<td style="font-size:11px;text-align: -webkit-center;">{{dateformat $resProj.StartDate "2006-01-02"}}</td>
													<td style="font-size:11px;text-align: -webkit-center;">{{dateformat $resProj.EndDate "2006-01-02"}}</td>
													<td style="font-size:11px;text-align: -webkit-center;">{{$resProj.Hours}}</td>
													
													<td style="text-align: -webkit-center;"><img style="padding:0px;" data-toggle="modal" data-target="#confirmDeleteModal" data-dismiss="modal" class="btn button3" src="/static/img/rubbish-bin.png" onclick="$('#ID').val('{{$resProj.ID}}'); $('#projectID').val('{{$resProj.ProjectId}}'); $('#resourceID').val('{{$resProj.ResourceId}}'); $('body').data('buttonX', this); $('#resourceName').html('{{$resProj.ResourceName}}'); $('#projectName').html('{{$resProj.ProjectName}}')"></td>
												</tr>
												{{end}}
											{{end}}
										</tbody>
									</table>										
								</div>
							</div>														
						</div>
					{{end}}
				</div>
			</div>
		</div>
	</div>
	
	<div class="row">
		<div class="col s9" style="padding-bottom: 10px;">											
			<div id="panel-df-projectUnassign" class="panel panel-default">
				<div id="unassign" class="panel-heading">
					Available hours per resource
					<div class="pull-right">
						<button id="collapseButtonUnassign" class="btnCollapse" data-toggle="collapse" href="#collapseUnassign" style="border:none;border-radius:4px;"></button>
					</div>
				</div>
				<div id="collapseUnassign" class="panel-body panel-collapse collapse in" style="padding:0;height: auto;max-height: 221px;">
					<table id="viewResourcesPerProjectUnassign" class="table table-striped table-bordered">
						<thead id="availabilityTableHead">
							<th style="font-size:12px;text-align: -webkit-center;" class="col-sm-10">Resource Name</th>
							<th style="font-size:12px;text-align: -webkit-center;" class="col-sm-1">Hours</th>
						</thead>
						<tbody id="unassignBody">
							{{$availBreakdown := .AvailBreakdownPerRange}}
							{{range $index, $resource := .Resources}}
								{{if $availBreakdown}}
									{{$avail := index $availBreakdown $resource.ID}}
									{{if $avail}}
										{{if gt $avail.TotalHours 0.0}}
											<tr draggable=false>
												<td style="background-position-x: 1%;font-size:11px;text-align: -webkit-center;margin:0 0 0px;" onclick="showDetails($(this),{{$avail.ListOfRange}})">{{$resource.Name}} {{$resource.LastName}}</td>
												<td style="font-size:11px;text-align: -webkit-center;">{{$avail.TotalHours}}</td>
											</tr>
										{{end}}
									{{end}}	
								{{end}}
							{{end}}
						</tbody>
					</table>										
				</div>
			</div>														
		</div>
	</div>
	
<!-- Modal -->
<div class="modal fade" id="setResourceModal" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 id="modalTitle" class="modal-title">Assign dates to the resource</h4>
      </div>
      <div class="modal-body">
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Start Date"> Start Date </label> 
              <div class="col-sm-8">
              	<input type="date" id="resourceStartDate" style="width: 174px; border-radius: 8px;">
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="End Date"> End Date </label> 
              <div class="col-sm-8">
              	<input type="date" id="resourceEndDate" style="width: 174px; border-radius: 8px;">
        		</div>
          </div>
        </div>
      		<div class="row-box col-sm-12" style="padding-bottom: 1%;">
	       	<div class="form-group form-group-sm">
	       		<label class="control-label col-sm-4 translatable" data-i18n="Hours"> Total Hours </label> 
	             	<div class="col-sm-6">
	             		<input type="number" id="estimatedHours" value="8" style="border-radius: 8px;">
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
        <button type="button" id="setResource" class="btn btn-default" onclick="setResourceToProjectExc();" data-dismiss="modal">Create</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
      </div>
    </div>    
  </div>
</div>

<div class="modal fade" id="confirmDeleteModal" role="dialog">
<div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" onclick="getResourcesByProjectWithFilterDate();">&times;</button>
        <h4 class="modal-title">Delete Confirmation</h4>
      </div>
      <div class="modal-body">
		<input type="hidden" id="ID">
        Are you sure you want to remove <b id="resourceName"></b> from project <b id="projectName"></b>?
      </div>
      <div class="modal-footer" style="text-align:center;">
        <button type="button" id="resourceProjectDelete" class="btn btn-default" onclick="unassignResource($('#ID').val(), $('body').data('buttonX'));getResourcesByProjectWithFilterDate();" data-dismiss="modal">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>