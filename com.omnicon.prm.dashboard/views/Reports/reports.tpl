<script>
	$(document).ready(function () {
        $('.modal-trigger').leanModal();
		$('.tooltipped').tooltip();
		$('select').material_select();
		$('#datePicker').css("display", "none");
		$('#refreshButton').css("display", "none");
		$('#backButton').css("display", "none");
		$('#buttonOption').css("display", "none");

        $('.datepicker').pickadate({
			selectMonths: true,
			selectYears: 15,
			format: 'yyyy-mm-dd',
			formatSubmit: 'yyyy-mm-dd'
		});


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

<div id="filters" class="container">
   <div class="row">

    <div id="pry_add col s12" class= "marginCard" style = "margin-bottom: 1.5rem">
        <h4 >Reports</h4>
    </div>

      <div class="col s12 m6">

         <div class="input-field">
            <label class= "active" for="projectsValue">Projects list:</label>
            <select  id="projectsValue">
               <option id="">All projects</option>
               {{range $index, $project := .Projects}}
               <option id="{{$project.ID}}">{{$project.OperationCenter}}-{{$project.WorkOrder}} {{$project.Name}}</option>
               {{end}}
            </select>
         </div>

         <div class="input-field">
            <label class="active"> Date From: </label>
            <input type="date" id="dateFromValue" class="datepicker">
        </div>
      </div>

      <div class="col s12 m6">
        <div class="input-field">
            <label class= "active" for="resourcesValue">Resources list:</label>
            <select  id="resourcesValue">
                <option id="">All resources</option>
                {{range $index, $resource := .Resources}}
                <option id="{{$resource.ID}}">{{$resource.Name}} {{$resource.LastName}}</option>
                {{end}}
            </select>
         </div>

         <div class="input-field">
            <label class="active">Date To:</label>
            <input type="date" id="dateToValue" class="datepicker">
        </div>
      </div>
   </div>
</div>

<div class="row">
    <div class= "col s12 m10 offset-m1 marginCard">
    
    <table id="viewProjects" class="striped  highlight ">
        <thead>
            <tr>
                <th>Report Name</th>
                <th>Options</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Project Assign</td>
                
                <td><a class='modal-trigger tooltipped' id="projectAssign" data-position="top" data-tooltip="Generate"  href="#viewReport"  onclick="reportProjectAssign();$('#titleReport').html('Report Projects Assign');"><i class="mdi-action-description small"></i></a></td>
            </tr>
            <tr>
                <td>Resource Assign</td>
                <td><a class='modal-trigger tooltipped' id="resourceAssign" data-position="top" data-tooltip="Generate"  href="#viewReport"  onclick="reportResourceAssign();$('#titleReport').html('Report Resources Assign');"><i class="mdi-action-description small"></i></a></td>
            </tr>
            <!--tr>
                <td>Matrix Assign</td>
                <td><button data-toggle="modal" data-target="#viewReport" class="buttonTable button2" id="matrixAssign" onclick="reportMatrixAssign();$('#titleReport').html('Report Matrix Assign');" data-dismiss="modal">Generate</button></td>
            </tr-->
        </tbody>
    </table>
    </div>
</div>


<div id="viewReport" class="modal" >
    <div class="modal-content">
        <h5 id="titleReport" class="modal-title"></h5>
        <div class="divider CardTable"></div>
        <input type="hidden" id="skillID">
        <div id="reports" style="height: 100%;">
        </div>
    </div>
    <div class="modal-footer">
        <a class="waves-effect waves-red btn-flat modal-action modal-close">Cancel</a>
    </div>
</div>
