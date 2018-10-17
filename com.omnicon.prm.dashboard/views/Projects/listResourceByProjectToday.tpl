<script>
	var MyProject = {};
	$(document).ready(function(){
		$('.tooltipped').tooltip();
		$('.modal-trigger').leanModal();
		
		$('.viewResourcesPerProject').DataTable({			
			"iDisplayLength": 20,
			"bLengthChange": false,
			"searching": false

		});
		
		$('.datepicker').pickadate({
			selectMonths: true,
			selectYears: 15,
			format: 'yyyy-mm-dd',
			formatSubmit: 'yyyy-mm-dd'
		});

		MyProject.table = $('#viewResourcesPerProjectUnassign').DataTable({		
			"iDisplayLength": 20,
			"bLengthChange": false,
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
			responsive: true,
			"pageLength": 50,
			"searching": true,
			"paging": false,
		});	

		var time = new Date();
		var mm = time.getMonth() + 1; // getMonth() is zero-based
		var dd = time.getDate()
		var date =  [time.getFullYear(),
				(mm>9 ? '' : '0') + mm,
				(dd>9 ? '' : '0') + dd
				].join('-');
		
		data = { 
				"StartDate": date,
				"EndDate": date
			}
		//reload('/projects/resources/today', data);
		$('#dateFrom').val(date)
		$('#dateTo').val(date)

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
				if($(this).hasClass('fa-caret-square-down')){
					$(this).removeClass('fa-caret-square-down');
					$(this).addClass('fa-caret-square-right');
				}
				else{
					$(this).removeClass('fa-caret-square-right');
					$(this).addClass('fa-caret-square-down');
				}
			}
		);
		sendTitle("Home");
	});

	catchID = function (ID) {
		if($(".icon"+ID).hasClass('fa-caret-square-down')){
			$(".icon"+ID).removeClass('fa-caret-square-down');
			$(".icon"+ID).addClass('fa-caret-square-right');
		}
		else{
			$(".icon"+ID).removeClass('fa-caret-square-right');
			$(".icon"+ID).addClass('fa-caret-square-down');
		}
	}
	
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

setResourceToProject = function(resourceId, projectId, startDate, endDate, estimatedHours, hoursPerDay, isHoursPerDay){
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
	$("#setResourceModal").openModal()
	//$("#setResourceModal").modal("show");
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
<!--
<div id="datePicker" class="pull-right" style="input-field col s12 inline">

	<label for="dateFrom">Start Date:</label>
	<input id="dateFrom" type="date"  class="datepicker">
	<label for="dateTo">End Date:</label>
	<input id="dateTo" type="date"   class="datepicker">
	<button id="filterByDateRange" class="buttonHeader button2">Filter</button>
	<a id="filterByDateRange" class="btn green waves-effect waves-light"  data-dismiss="modal">Filter</button>        

</div>-->

<div class="container">
<div class="row ">
	<div class="col s12 offset-l6 marginCard">
		<div class="col m2">
			<div class="input-field">
				<label for="dateFrom" class="active">Start Date:</label>
				<input id="dateFrom" type="date" class="datepicker">
			</div>
		</div>
		<div class="col m2">
			<div class="input-field">
				<label for="dateTo" class="active">End Date:</label>
				<input id="dateTo" type="date"   class="datepicker">
			</div>
		</div>
		<div class="col m1">
		<div class="input-field">
			<a id="filterByDateRange" class="btn blue waves-effect waves-light"><i class="mdi-action-search"></i></a>       
		</div>
		</div>
	</div>
</div>

<tr id="tempResource" style="display:none"></tr>
</div>

<var id="projectIDInput"></var>
<var id="resourceIDInput"></var>
	<div class="container">
	<div class="row">
	<div class="marginCard">
	<h4 class="modal-title">Project Summaries</h4>
	
		<div class="col s12 m9 l3">
			<div class="panel-group" >
				<div class="panel panel-default">
					<div id="resources" class="panel-body">
					<div class="card-panel" style="background-color: #f9f9f9;">
						<table id="viewResourcesHome" class="display" cellspacing="0" width="90%">
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
		</div>
		<div class="col-sm-9" style="overflow-y: auto;height: -webkit-fill-available;">
			<div class="panel-group">
	    		<div id="projects" class="panel">
					{{$projectsLoop := .Projects}}
					{{$resourcesProject := .ResourcesToProjects}}
					{{range $key, $project := $projectsLoop}}	
						<div class="card-panel" style="background-color: #f9f9f9;">
							<div class="col-sm-6" style="padding-bottom: 15px;">	
								<div id="panel-df-project{{$key}}" class="panel panel-default">
									<div id="project{{$key}}" class="panel-heading" style="padding-bottom: 15px;">

											{{$project.OperationCenter}}-{{$project.WorkOrder}} {{$project.Name}}
											<div style="display:inline;float:right;">
												{{dateformat $project.StartDate "2006-01-02"}} to {{dateformat $project.EndDate "2006-01-02"}} 
											</div>
									</div>
			 						 
									<div id="collapse{{$key}}" class="panel-body panel-collapse collapse in" style="padding:0;height: auto;max-height: 221px;" ondrop="drop(event,'{{$project.ID}}', this)" ondragover="allowDrop(event)">
										<table id="viewResourcesPerProject{{$project.ID}}" class="display viewResourcesPerProject" cellspacing="0" width="100%">
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
														
														<td style="text-align: -webkit-center;">
															<a class="modal-trigger tooltipped" data-position="top" data-tooltip="Delete" href="#confirmDeleteModal" onclick="$('#ID').val('{{$resProj.ID}}'); $('#projectID').val('{{$resProj.ProjectId}}'); $('#resourceID').val('{{$resProj.ResourceId}}'); $('body').data('buttonX', this); $('#resourceName').html('{{$resProj.ResourceName}}'); $('#projectName').html('{{$resProj.ProjectName}}')"><i class="mdi-action-delete"></i></a>														
															<!--<img style="padding:0px;" data-toggle="modal" data-target="#confirmDeleteModal" data-dismiss="modal" class="btn button3" src="/static/img/rubbish-bin.png" onclick="$('#ID').val('{{$resProj.ID}}'); $('#projectID').val('{{$resProj.ProjectId}}'); $('#resourceID').val('{{$resProj.ResourceId}}'); $('body').data('buttonX', this); $('#resourceName').html('{{$resProj.ResourceName}}'); $('#projectName').html('{{$resProj.ProjectName}}')">-->
															</td>
													</tr>
													{{end}}
												{{end}}
											</tbody>
										</table>										
									</div>
								</div>														
							</div>
						</div>
					{{end}}
				</div>
			</div>
		</div>
	</div>
	
	<div class="row">
		<div class="col s12">											
			<div id="panel-df-projectUnassign" class="panel panel-default">
				<div id="unassign" class="panel-heading">
					<h5>Available hours per resource</h5>
				</div>
				<div id="collapseUnassign">
					<table id="viewResourcesPerProjectUnassign" class="display" cellspacing="0" width="100%" >
						<thead id="availabilityTableHead">
							<th>Resource Name</th>
							<th>Hours</th>
						</thead>
						<tbody id="unassignBody">
							{{$availBreakdown := .AvailBreakdownPerRange}}
							{{range $index, $resource := .Resources}}
								{{if $availBreakdown}}
									{{$avail := index $availBreakdown $resource.ID}}
									{{if $avail}}
										{{if gt $avail.TotalHours 0.0}}
											<tr draggable=false>
												<td style="cursor: pointer; background-position-x: 1%;font-size:11px;;" onclick="showDetails($(this),{{$avail.ListOfRange}});catchID({{$resource.ID}})"><i class="icon{{$resource.ID}}  fas fa-caret-square-down" style="vertical-align: middle; margin-right: 10px;"></i>{{$resource.Name}} {{$resource.LastName}}</td>
												<td>{{$avail.TotalHours}}</td>
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
<div class="modal" id="setResourceModal">
    <div class="modal-content">
        <h5>Assign dates to the resource</h5><br>   
        <div class="input-field col s12">
			<label> Start Date </label>
			<input type="date" id="resourceStartDate" class="datepicker">
        </div>
        <div class="input-field col s12">
        	<label> End Date </label> 
            <input type="date" id="resourceEndDate" class="datepicker">
        
        </div>
        <div class="input-field col s12">
	       	<label class="active"> Total Hours </label> 
	        <input type="number" id="estimatedHours" value="8" class="validate">
		</div>
		<div class="input-field col s12">
        	<label class="active"> Activate Hours Per Day </label> 
            <input type="checkbox" id="checkHoursPerDay" ><br/>         
        </div>
		<div class="input-field col s12">
			<label class="active"> Hours Per Day </label> 
   			<input type="number" id="createHoursPerDay" value="8" disabled class="validate">
		</div>
	</div>
	<div class="modal-footer">
	<a id="setResource" class="btn green waves-effect waves-light  modal-action modal-close"  onclick="setResourceToProjectExc();" data-dismiss="modal">Create</button>        
	<a class="btn waves-effect waves-light red modal-action modal-close">Cancel</a>
	</div>
</div>

<div class="modal" id="confirmDeleteModal">
    <div class="modal-content">
       <!-- <button type="button" class="close" data-dismiss="modal" onclick="getResourcesByProjectWithFilterDate();">&times;</button>-->
        <h4>Delete Confirmation</h4>
		<input type="hidden" id="ID">
        Are you sure you want to remove <b id="resourceName"></b> from project <b id="projectName"></b>?
      </div>
      <div class="modal-footer" style="text-align:center;">
	    <a id="resourceProjectDelete" class="btn green waves-effect waves-light  modal-action modal-close" onclick="unassignResource($('#ID').val(), $('body').data('buttonX'));getResourcesByProjectWithFilterDate();" data-dismiss="modal" style="margin-left:5px;">Delete</button>        
        <!--<button type="button" id="resourceProjectDelete" class="btn btn-default" onclick="unassignResource($('#ID').val(), $('body').data('buttonX'));getResourcesByProjectWithFilterDate();" data-dismiss="modal">Yes</button>-->
        <a class="btn waves-effect waves-light red modal-action modal-close">Cancel</a>
      </div>
    </div>
  </div>
</div>
</div>