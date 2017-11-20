<script>
	$(document).ready(function () {
		$('#viewProductivity').DataTable({
			"columns": [
				null,
				null,
				null,
				null,
				{
					"searchable": false
				}
			],
			"paging": false
		});
		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		sendTitle("Productivity Report");
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick', null).off('click');
		$('#refreshButton').click(function () {
			reload('/productivity', {});
		});
	
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOption').html("New Task");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#taskModal");
		$('#buttonOption').attr("onclick", "configureCreateModal()");
		
		// only show the option if already exist a search
		if ({{.ProjectID}} == ""){
			$('#buttonOption').css("display", "none");
		}
	});
	
	configureCreateModal = function () {
	
		$("#taskID").val(null);
		$("#taskName").val(null);
		$("#taskScheduled").val(null);
		$("#taskProgress").val(null);
	
		$("#modalTitle").html("Create Task");
		$("#taskCreate").css("display", "inline-block");
		$("#taskUpdate").css("display", "none");
	}
	
	configureUpdateModal = function (pID, pName, pScheduled, pProgress) {
	
		$("#taskID").val(pID);
		$("#taskName").val(pName);
		$("#taskScheduled").val(pScheduled);
		$("#taskProgress").val(pProgress);
	
		$("#modalTitle").html("Update Task");
		$("#taskCreate").css("display", "none");
		$("#taskUpdate").css("display", "inline-block");
	}
	
	createTask = function () {
		var settings = {
			method: 'POST',
			url: '/productivity/createtask',
			headers: {
				'Content-Type': undefined
			},
			data: {
				"ProjectID": {{.ProjectID}},
				"Name": $('#taskName').val(),
				"Scheduled": $('#taskScheduled').val(),
				"Progress": $('#taskProgress').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			searchProductivityReport({{.ProjectID}});
		});
	}
	
	updateTask = function () {
		var settings = {
			method: 'POST',
			url: '/productivity/updatetask',
			headers: {
				'Content-Type': undefined
			},
			data: {
				"ID": $('#taskID').val(),
				"Name": $('#taskName').val(),
				"Scheduled": $('#taskScheduled').val(),
				"Progress": $('#taskProgress').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			searchProductivityReport({{.ProjectID}});
		});
	}
	
	deleteTask = function () {
		var settings = {
			method: 'POST',
			url: '/productivity/deletetask',
			headers: {
				'Content-Type': undefined
			},
			data: {
				"ID": $('#taskID').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			searchProductivityReport({{.ProjectID}});
		});
	}
	
	searchProductivityReport = function(pProjectID){
		var projectID = $('#projectValue option:selected').attr('id');
		if (pProjectID != null){
			projectID = pProjectID;
		}		
		var settings = {
			method: 'POST',
			url: '/productivity',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ProjectID": projectID
			}
		}
		$.ajax(settings).done(function (response) {
			$("#content").html(response);
			$("#filters").collapse("hide");
			$("#projectValue option[id="+projectID+"]").attr("selected", "selected");
			$("#titleSearch").html($("#projectValue").val());
		});
	}
	
	$(document).on('click','#updateTask',function(){
    	$('#taskModal').modal('show');
	});
	
	$(document).on('click','#deleteTask',function(){
    	$('#confirmModal').modal('show');
	});
</script>

<div class="row">
	<div class="col-sm-5">
		<button class="buttonHeader button2" data-toggle="collapse" data-target="#filters">
			<span class="glyphicon glyphicon-filter"></span> Filter 
		</button>
	</div>
	<div class="col-sm-5">
	</div>
	<div class="col-sm-2">
		<!--button class="buttonHeader button2" id="download-pdf" onclick="downloadPDF()" >Download PDF</button-->
	</div>
</div>

<div id="filters" class="collapse">
	<div class="row">
		<div class="col-md-6">
			<div class="form-group">
			<label for="projectValue">Projects list:</label>
				<select class="form-control" id="projectValue">
					<option id="0">Select a project...</option>
					{{range $index, $project := .Projects}}
					<option id="{{$project.ID}}">{{$project.Name}}</option>
					{{end}}
				</select>
			</div>
		</div>
		<div class="col-md-6">
			<div class="form-group">
				<br>
				<button class="buttonHeader button2" onclick="searchProductivityReport()">
				<span class="glyphicon glyphicon-search"></span> Search 
				</button>
			</div>
		</div>
	</div>
</div>

<div>
	<h3 id="titleSearch"></h3>
   <table id="viewProductivity" class="table table-striped table-bordered">
      <thead>
         <tr>
            <th>Task</th>
            <th>Total Execute</th>
            <th>Scheduled</th>
			<th>Progress</th>
            <th>Options</th>
         </tr>
      </thead>
      <tbody>
         {{range $key, $productivityTask := .ProductivityTasks}}
         <tr>
            <td>{{$productivityTask.Name}}</td>
            <td>{{$productivityTask.TotalExecute}}</td>
            <td>{{$productivityTask.Scheduled}}</td>
			<td>{{$productivityTask.Progress}}%</td>
            <td>
				<a id="updateTask" onclick="configureUpdateModal({{$productivityTask.ID}},'{{$productivityTask.Name}}',{{$productivityTask.Scheduled}},{{$productivityTask.Progress}})"> <span class="glyphicon glyphicon-edit"></span></a>
				<a id="deleteTask" onclick="$('#taskID').val({{$productivityTask.ID}})"> <span class="glyphicon glyphicon-trash"></span></a>
            </td>
         </tr>
         {{end}}
      </tbody>
   </table>
</div>
<!-- Modal -->
<div class="modal fade" id="taskModal" role="dialog">
   <div class="modal-dialog">
      <!-- Modal content-->
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 id="modalTitle" class="modal-title"></h4>
         </div>
         <div class="modal-body">
            <input type="hidden" id="taskID">
            <div class="row-box col-sm-12" style="padding-bottom: 1%;">
               <div class="form-group form-group-sm">
                  <label class="control-label col-sm-4 translatable" data-i18n="Name"> Name </label>
                  <div class="col-sm-8">
                     <input type="text" id="taskName" style="border-radius: 8px;">
                  </div>
               </div>
            </div>
            <div class="row-box col-sm-12" style="padding-bottom: 1%;">
               <div class="form-group form-group-sm">
                  <label class="control-label col-sm-4 translatable" data-i18n="Scheduled"> Scheduled </label>
                  <div class="col-sm-8">
                     <input type="number" id="taskScheduled" style="border-radius: 8px;" min="0">
                  </div>
               </div>
            </div>
            <div class="row-box col-sm-12" style="padding-bottom: 1%;">
               <div class="form-group form-group-sm">
                  <label class="control-label col-sm-4 translatable" data-i18n="Progress"> Progress </label>
                  <div class="col-sm-8">
                     <input type="number" id="taskProgress" style="border-radius: 8px;" min="0" max="100">
                  </div>
               </div>
            </div>
         </div>
         <div class="modal-footer">
            <button type="button" id="taskCreate" class="btn btn-default" onclick="createTask()" data-dismiss="modal">Create</button>
            <button type="button" id="taskUpdate" class="btn btn-default" onclick="updateTask()" data-dismiss="modal">Update</button>
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
            Are you sure you want to delete the task <b id="nameDelete"></b> from report?
            <br>
            <li>The resources will lose the reported times.</li>
         </div>
         <div class="modal-footer" style="text-align:center;">
            <button type="button" id="taskDelete" class="btn btn-default" onclick="deleteTask()" data-dismiss="modal">Yes</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
         </div>
      </div>
   </div>
</div>