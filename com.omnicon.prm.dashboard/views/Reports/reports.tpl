<script>
	$(document).ready(function () {
		$('#datePicker').css("display", "none");
		$('#refreshButton').css("display", "none");
		$('#backButton').css("display", "none");
		$('#buttonOption').css("display", "none");
	});
	
	reportProjectAssign = function () {
		var settings = {
			method: 'POST',
			url: '/reports/projectassign',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ProjectId": $('#projectsValue option:selected').attr("id"),
				"ResourceId": $('#resourcesValue option:selected').attr("id"),
				"StartDate": $('#dateFromValue').val(),
				"EndDate": $('#dateToValue').val()
			}
		}
		$.ajax(settings).done(function (response) {
			$('#reports').html(response);
		});
	}
	
	reportResourceAssign = function () {
		var settings = {
			method: 'POST',
			url: '/reports/resourceassign',
			headers: {
				'Content-Type': undefined
			},
			data: {
				"ProjectId": $('#projectsValue option:selected').attr("id"),
				"ResourceId": $('#resourcesValue option:selected').attr("id"),
				"StartDate": $('#dateFromValue').val(),
				"EndDate": $('#dateToValue').val()
			}
		}
		$.ajax(settings).done(function (response) {
			$('#reports').html(response);
		});
	}
	
	reportMatrixAssign = function () {
		var settings = {
			method: 'POST',
			url: '/reports/matrixassign',
			headers: {
				'Content-Type': undefined
			},
			data: {
				"ProjectId": $('#projectsValue option:selected').attr("id"),
				"ResourceId": $('#resourcesValue option:selected').attr("id"),
				"StartDate": $('#dateFromValue').val(),
				"EndDate": $('#dateToValue').val()
			}
		}
		$.ajax(settings).done(function (response) {
			$('#reports').html(response);
		});
	}
</script>

<button class="buttonHeader button2" data-toggle="collapse" data-target="#filters">
<span class="glyphicon glyphicon-filter"></span> Filter 
</button>
<div id="filters" class="collapse">
   <div class="row">
      <div class="col-md-6">
         <div class="form-group">
            <label for="projectsValue">Projects list:</label>
            <select class="form-control" id="projectsValue">
               <option id="">All projects</option>
               {{range $index, $project := .Projects}}
               <option id="{{$project.ID}}">{{$project.OperationCenter}}-{{$project.WorkOrder}} {{$project.Name}}</option>
               {{end}}
            </select>
         </div>
         <div class="form-group">
            <label for="resourcesValue">Resources list:</label>
            <select class="form-control" id="resourcesValue">
               <option id="">All resources</option>
               {{range $index, $resource := .Resources}}
               <option id="{{$resource.ID}}">{{$resource.Name}} {{$resource.LastName}}</option>
               {{end}}
            </select>
         </div>
      </div>
      <div class="col-md-6">
         <div class="form-group">
            <label for="dateFromValue">Date From:</label>
            <input type="date" class="form-control" id="dateFromValue">
         </div>
         <div class="form-group">
            <label for="dateToValue">Date To:</label>
            <input type="date" class="form-control" id="dateToValue">
         </div>
      </div>
   </div>
</div>
<div>
   <br>
   <br>
   <table id="viewProjects" class="table table-striped table-bordered">
      <thead>
         <tr>
            <th>Report Name</th>
            <th>Options</th>
         </tr>
      </thead>
      <tbody>
         <tr>
            <td>Project Assign</td>
            <td><button data-toggle="modal" data-target="#viewReport" class="buttonTable button2" id="projectAssign" onclick="reportProjectAssign();$('#titleReport').html('Report Projects Assign');" data-dismiss="modal">Generate</button></td>
         </tr>
         <tr>
            <td>Resource Assign</td>
            <td><button data-toggle="modal" data-target="#viewReport" class="buttonTable button2" id="resourceAssign" onclick="reportResourceAssign();$('#titleReport').html('Report Resources Assign');" data-dismiss="modal">Generate</button></td>
         </tr>
         <tr>
            <td>Matrix Assign</td>
            <td><button data-toggle="modal" data-target="#viewReport" class="buttonTable button2" id="matrixAssign" onclick="reportMatrixAssign();$('#titleReport').html('Report Matrix Assign');" data-dismiss="modal">Generate</button></td>
         </tr>
      </tbody>
   </table>
   <br>
</div>
<div class="modal fade" id="viewReport" role="dialog" style="border-radius:8px">
   <div class="modal-dialog" style="width: 95%;height: 90%;padding: 0;">
      <!-- Modal content-->
      <div class="modal-content" style="height: 100%;">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 id="titleReport" class="modal-title"></h4>
         </div>
         <div class="modal-body" style="height: 80%">
            <div id="reports" style="height: 100%;">
            </div>
            <div class="modal-footer">
               <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
            </div>
         </div>
      </div>
   </div>
</div>