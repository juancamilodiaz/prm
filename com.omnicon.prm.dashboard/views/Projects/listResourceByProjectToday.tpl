<script>
	$(document).ready(function(){
			
		{{range $key, $resource := .Resources}}
			$("#resources").append('<p id="drag' + {{$key}} + '" draggable="true" ondragstart="drag(event,'+{{$resource.ID}}+')">'+ {{$resource.Name}} + ' '+ {{$resource.LastName}}+'</p>')
		{{end}}	
		
		{{$projectsLoop := .Projects}}
		{{$resourcesProject := .ResourcesToProjects}}
		{{range $key, $project := $projectsLoop}}
		 	$("#projects").append('<div class="panel panel-default">'+
			'<div id="project'+ {{$key}} + '" class="panel-heading">' + {{$project.Name}}+ '</div>'+
			'<div class="panel-body" ondrop="drop(event,'+ {{$project.ID}} +', this)" ondragover="allowDrop(event)">'
		{{range $keyR, $resProj := $resourcesProject}}
			{{if eq  $resProj.ProjectId $project.ID}}
				+'<p id="res'  + {{$keyR}} + '">'+ {{$resProj.ResourceName}} 
				+'<a class="btn" onclick="unassignResource('+{{$resProj.ProjectId}}+','+ {{$resProj.ResourceId}}+', this)">x</a>'
				+'</p>'
			{{end}}
		{{end}}
			+'</div>'+'</div>');
		{{end}}
		
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
		$.ajax(settings).done(function (response) {
			$(obj).parent().remove();
		});
	}
	

		

</script>

<script>

var evento;

setResourceToProject = function(resourceId, projectId, startDate, endDate){
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
			"EndDate": endDate
		}
	}
	console.log(settings);
	$.ajax(settings).done(function (response) {
	  
	});
}

function allowDrop(ev) {
    ev.preventDefault();
}

function drag(ev, resourceID) {
    ev.dataTransfer.setData("text", ev.target.id);
	ev.dataTransfer.setData("resourceID", resourceID);
}

function drop(ev, projectID, obj) {
	ev.preventDefault();
	var data = ev.dataTransfer.getData("text");
	
	evento = obj;
	document.getElementById(data).setAttribute("draggable", "false");
	document.getElementById(data).innerHTML+="<a class='btn' onclick='unassignResource("+projectID+','+ ev.dataTransfer.getData("resourceID") +","+"this"+")'>x</a>";
	$("#tempResource").html(document.getElementById(data));
	
	$("#setResourceModal").modal("show");
	$("#resourceIDInput").val(ev.dataTransfer.getData("resourceID"));
	$("#projectIDInput").val(projectID);
}

function setResourceToProjectExc(){
	$(evento).append($("#tempResource").html());
	$("#tempResource").html("")	
	setResourceToProject($("#resourceIDInput").val(), $("#projectIDInput").val(), $("#resourceStartDate").val(), $("#resourceEndDate").val());
}

</script>

<div id="tempResource" style="display:none">

</div>

<var id="projectIDInput"></var>
<var id="resourceIDInput"></var>

	<div class="row">
		<div class="col-sm-2">
			<div class="panel-group" >
				<div class="panel panel-default">
					<div class="panel-heading">Resources</div>
					<div id="resources" class="panel-body"></div>
				</div>
			</div>
		</div>
		<div class="col-sm-3">
			<div class="panel-group">
	    		<div id="projects" class="panel"></div>
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
        <button type="button" id="setResource" class="btn btn-default" onclick="setResourceToProjectExc()" data-dismiss="modal">Create</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
      </div>
    </div>
    
  </div>
</div>
