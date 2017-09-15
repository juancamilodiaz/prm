<script>
	$(document).ready(function(){
		$('#viewResourcesHome').DataTable({			
			"lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
			scrollY: 370
		});					
				
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
		});
		sendTitle("Home");
		
	});
	
	unassignResource = function(projectID, resourceID, obj){
		var settings = {
			method: 'POST',
			url: '/projects/resources/unassign',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"resourceID": resourceID,
				"projectID": projectID
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
		$("#resourceStartDate").val(getDateToday());
		$("#resourceEndDate").val(getDateToday());
	}
	
	getResourcesByProjectToday = function(){
		var date = getDateToday();
		
	  	data = { 
				"StartDate": date,
				"EndDate": date
			}
		sleep(500)
		reload('/projects/resources/today', data);
	}
	
	sleep = function(milliseconds) {
	  var start = new Date().getTime();
	  for (var i = 0; i < 1e7; i++) {
	    if ((new Date().getTime() - start) > milliseconds){
	      break;
	    }
	  }
	}
	

	$('#resourceEndDate').change(function(){
    	var startDate = new Date($("#resourceStartDate").val());
		var endDate = new Date($("#resourceEndDate").val());

		$("#estimatedHours").val(workingHoursBetweenDates(startDate, endDate));
	});

</script>

<script>

var evento;

setResourceToProject = function(resourceId, projectId, startDate, endDate, estimatedHours){
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
			"Hours": estimatedHours
		}
	}
	$.ajax(settings).done(function (response) {
	  
	});
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
	var isValid = true;
	var pName = "";
	var rName = "";
	{{range $rindex, $resProj := .ResourcesToProjects}}
		if (projectID == {{$resProj.ProjectId}} && rId == {{$resProj.ResourceId}}){
			isValid = false;
		}
	{{end}}
	
	if (isValid){
		
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
		data.innerHTML='<tr><td id="res'+rId+'" style="font-size:11px;cursor:no-drop;margin:0 0 0px;">'+resourceName+'</td><td style="font-size:11px;">10-12-2017</td><td style="font-size:11px;">11-12-2017</td><td style="font-size:11px;">8</td><td><img style="padding:0px" data-toggle="modal" data-target="#confirmDeleteModal" data-dismiss="modal" class="btn" src="/img/rubbish-bin.png" onclick="(\'#projectID\').val('+pId+');$(\'#resourceID\').val('+rId+'); $(\'body\').data(\'buttonX\', this); $(\'#resourceName\').html('+resourceName+');$(\'#projectName\').html('+projectName+')></td></tr>';
		//Mapped in temporal to show modal
		$("#tempResource").html(data);
		configureCreateModal();
		$("#setResourceModal").modal("show");
		$("#resourceIDInput").val(ev.dataTransfer.getData("resourceID"));
		$("#projectIDInput").val(projectID);
	}
}

function setResourceToProjectExc(){
	$(evento).append($("#tempResource").html());
	$("#tempResource").html("")	
	setResourceToProject($("#resourceIDInput").val(), $("#projectIDInput").val(), $("#resourceStartDate").val(), $("#resourceEndDate").val(), $("#estimatedHours").val());
}

</script>


<tr id="tempResource" style="display:none"></tr>
</div>

<var id="projectIDInput"></var>
<var id="resourceIDInput"></var>

	<div class="row">
		<div class="col-sm-3">
			<div class="panel-group" >
				<div class="panel panel-default">
					<div class="panel-heading">Resources</div>
					<div id="resources" class="panel-body">
						<table id="viewResourcesHome" class="table table-striped table-bordered">
							<thead>
								<th>Name</th>
							</thead>
							<tbody>
								{{range $key, $resource := .Resources}}
									<tr><td id="drag{{$key}}" draggable="true" ondragstart="drag(event,'{{$resource.ID}}')" style="cursor:-webkit-grab" class="sorting_1 button3">{{$resource.Name}} {{$resource.LastName}}</td></tr>
								{{end}}	
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="col-sm-9" style="overflow-y: auto;">
			<div class="panel-group">
	    		<div id="projects" class="panel">
					{{$projectsLoop := .Projects}}
					{{$resourcesProject := .ResourcesToProjects}}
					{{range $key, $project := $projectsLoop}}	
					 	<div class="col-sm-6" style="padding-bottom: 10px;">											
							<div id="panel-df-project{{$key}}" class="panel panel-default">
								<div id="project{{$key}}" class="panel-heading">
									{{$project.Name}}
								</div>
								<div class="panel-body" style="padding:0;height: 200px; overflow-y: auto;" ondrop="drop(event,'{{$project.ID}}', this)" ondragover="allowDrop(event)">
									<table id="viewResourcesPerProject{{$project.ID}}" class="table table-striped table-bordered">
										<thead>
											<th style="font-size:12px;">Name</th>
											<th style="font-size:12px;">Start date</th>
											<th style="font-size:12px;">End date</th>
											<th style="font-size:12px;">Hrs</th>
											<th style="font-size:12px;">Options</th>
										</thead>
										<tbody>
											{{range $keyR, $resProj := $resourcesProject}}
												{{if eq  $resProj.ProjectId $project.ID}}
												<tr draggable ="false">
													<td id="res{{$keyR}}" style="font-size:11px;margin:0 0 0px;">{{$resProj.ResourceName}}</td> 
													<td style="font-size:11px;">{{dateformat $resProj.StartDate "2006-01-02"}}</td>
													<td style="font-size:11px;">{{dateformat $resProj.EndDate "2006-01-02"}}</td>
													<td style="font-size:11px;">{{$resProj.Hours}}</td>
													<td><img style="padding:0px" data-toggle="modal" data-target="#confirmDeleteModal" data-dismiss="modal" class="btn" src="/img/rubbish-bin.png" onclick="$('#projectID').val('{{$resProj.ProjectId}}'); $('#resourceID').val('{{$resProj.ResourceId}}'); $('body').data('buttonX', this); $('#resourceName').html('{{$resProj.ResourceName}}'); $('#projectName').html('{{$resProj.ProjectName}}')"></td>
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
		<div class="row-box col-sm-12">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Hours"> Hours </label> 
              <div class="col-sm-6">
              	<input type="number" id="estimatedHours" value="8">
        		</div>
         	</div>
        </div>
	
        <div class="row-box col-sm-12">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Start Date"> Start Date </label> 
              <div class="col-sm-8">
              	<input type="date" id="resourceStartDate">
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="End Date"> End Date </label> 
              <div class="col-sm-8">
              	<input type="date" id="resourceEndDate">
        		</div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" id="setResource" class="btn btn-default" onclick="setResourceToProjectExc();getResourcesByProjectToday();" data-dismiss="modal">Create</button>
        <button type="button" class="btn btn-default" data-dismiss="modal" onclick="getResourcesByProjectToday();">Cancel</button>
      </div>
    </div>    
  </div>
</div>

<div class="modal fade" id="confirmDeleteModal" role="dialog">
<div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" onclick="getResourcesByProjectToday();">&times;</button>
        <h4 class="modal-title">Delete Confirmation</h4>
      </div>
      <div class="modal-body">
		<input type="hidden" id="projectID">
		<input type="hidden" id="resourceID">
        Are you sure  yow want to remove <b id="resourceName"></b> from project <b id="projectName"></b>?
      </div>
      <div class="modal-footer" style="text-align:center;">
        <button type="button" id="resourceProjectDelete" class="btn btn-default" onclick="unassignResource($('#projectID').val(),$('#resourceID').val(), $('body').data('buttonX'));getResourcesByProjectToday();" data-dismiss="modal">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal" onclick="getResourcesByProjectToday();">No</button>
      </div>
    </div>
  </div>
</div>