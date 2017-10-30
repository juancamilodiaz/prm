<script src="/static/js/chartjs/Chart.min.js">
</script>

<script>
	var Training = {};
	$(document).ready(function(){
		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/trainings/resources',{});
		});
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOption').html("New Resource Training");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#trainingModal");
		$('#buttonOption').attr("onclick","configureCreateModal()");
		
		Training.table = $('#viewTraining').DataTable({
			"columns": [
				{"className":'details-control',"searchable":true},
				null,
				null,
				null,
				null,
				null,
				null
	        ],
			"columnDefs": [ {
		      "targets": [0],
		      "orderable": true
		    } ],
			responsive: true,
			"pageLength": 50,
			"searching": true,
			"paging": true,
		});
	});
	
	$('#viewTraining tbody').on('click', 'td.details-control', function(){
			
	});
	
	function showDetails(pObjBody, tDetails) {
		var tr = pObjBody.closest('tr');
        var row = Training.table.row( tr );
 
        if ( row.child.isShown() ) {
            // This row is already open - close it
            row.child.hide();
            tr.removeClass('shown');
        }
        else {
            // Open this row
            row.child( format(tDetails) ).show();
            tr.addClass('shown');
        }
	}
	/* Formatting function for row details - modify as you need */
	function format ( d ) {
	    // `d` is the original data object for the row
		var insert = '';
		for (index = 0; index < d.length; index++) {
			insert += '<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].TrainingName+'</td>'+
	            '<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].StartDate.substring(0, 10)+'</td>'+
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].EndDate.substring(0, 10)+'</td>'+	            
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].Duration+ ' h.' + '</td>'+	            
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].Progress+'</td>'+	            
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].TestResult+'</td>'+	            
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].ResultStatus+'</td>'+
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;"><a id="updateTrainingResource"><span class="glyphicon glyphicon-edit"></span></a><a id="deleteTrainingResource" onclick="'+"$('#trainingResourceID').val("+ d[index].ID + ");" +"$('#nameDelete').html('"+ d[index].TrainingName + "'" +')"> <span class="glyphicon glyphicon-trash"></span></a></td>'+	            
	        '</tr>';
		}
	    return '<table border="0" style="width: 100%;margin-left: 6px;" class="table table-striped table-bordered  dataTable">'+insert+'</table>';
	}
	
	$(document).on('click','#updateTrainingResource',function(){
    	console.log("Click on update");
	});
	
	$(document).on('click','#deleteTrainingResource',function(){
    	$('#confirmModal').modal('show');;
	});
	
	function deleteTrainingResource(){
		var settings = {
			method: 'POST',
			url: '/trainings/deletetraining',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#trainingResourceID').val()
			}
		}
		$.ajax(settings).done(function (response) {
		  validationError(response);
		  reload('/trainings/resources', {});
		});
	}
	
	google.charts.load('current', {'packages':['gantt']});
    google.charts.setOnLoadCallback(drawChart);
		
	function drawChart() {
		var data = new google.visualization.DataTable();
		
		data.addColumn('string', 'Training ID');
		data.addColumn('string', 'Training Name');
		data.addColumn('date', 'Start Date');
		data.addColumn('date', 'End Date');
		data.addColumn('number', 'Duration');
		data.addColumn('number', 'Percent Complete');
      	data.addColumn('string', 'Dependencies');
		
		data.addRows([
		{{range $xx, $training := .TResources}}
				[{{$training.SkillName}}, {{$training.SkillName}}, new Date({{$training.StartDate}}), new Date({{$training.EndDate}}), 0, {{$training.Progress}},""],
		{{end}}
		]);
		var options = {
	    	height: 375
	    };

      	var chart = new google.visualization.Gantt(document.getElementById('chart_div'));
      	chart.draw(data, options);
	}
	
	$('#createTypeValue').change(function() {
		$('#createSkillValue').html('<option id="">Skill...</option>');
        {{range $index, $typeSkill := .TypesSkills}}
			if ({{$typeSkill.TypeId}} == $('#createTypeValue option:selected').attr('id')) {
        		$('#createSkillValue').append('<option id="{{$typeSkill.SkillId}}">{{$typeSkill.Name}}</option>');
			}
        {{end}}
	});
	
	$('#createTypeValue, #createSkillValue').change(function() {
		$('#createTrainingValue').html('<option id="">Training...</option>');
        {{range $index, $training := .Trainings}}
			if ({{$training.TypeId}} == $('#createTypeValue option:selected').attr('id') &&
				{{$training.SkillId}} == $('#createSkillValue option:selected').attr('id')) {
        		$('#createTrainingValue').append('<option id="{{$training.ID}}">{{$training.Name}}</option>');
			}
        {{end}}
	});
	
	configureCreateModal = function(){
		
	}
	
	setTrainingToResource = function(){
		var settings = {
			method: 'POST',
			url: '/trainings/settraining',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ResourceId": $('#createResourcesValue option:selected').attr('id'),
				"TrainingId": $('#createTrainingValue option:selected').attr('id'),
				"StartDate": $('#trainingStartDate').val(),
				"EndDate": $('#trainingEndDate').val(),
				"Duration": $('#duration').val(),
				"Progress": $('#progress').val(),
				"TestResult": $('#testResult').val(),
				"ResultStatus": $('#resultStatus option:selected').attr('id')
			}
		}
		$.ajax(settings).done(function (response) {
		  validationError(response);
		  reload('/trainings/resources', {});
		});
	}
	
	$('#trainingStartDate').change(function(){
		$('#trainingEndDate').attr("min", $("#trainingStartDate").val());
	});
	
	$('#trainingStartDate, #trainingEndDate').change(function(){
    	var startDate = new Date($("#trainingStartDate").val());
		var endDate = new Date($("#trainingEndDate").val());

		$("#duration").val(workingHoursBetweenDates(startDate, endDate, 0, false));
	});
	
	$('#progress, #testResult').change(function(){
		if ($('#progress').val() < 100) {
			$('#resultStatus').val("Pending");
		} else if ($('#progress').val() == 100) {
			if ($('#testResult').val() >= 70) {
				$('#resultStatus').val("Passed");
			} else {
				$('#resultStatus').val("Failed");
			}
		}
	});
	
	function updateTraining(){
		
	}
	
	searchTrainingResources = function(){
		var resourceID = $('#resourcesValue option:selected').attr('id');
		var typeID = $('#typeValue option:selected').attr('id');
		var settings = {
			method: 'POST',
			url: '/trainings/resources',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ResourceId": resourceID,
				"TypeID": typeID
			}
		}
		$.ajax(settings).done(function (response) {
			$("#content").html(response);
			$("#filters").collapse("show");
			$("#resourcesValue option[id="+resourceID+"]").attr("selected", "selected");
			$("#typeValue option[id="+typeID+"]").attr("selected", "selected");
		});
	}

</script>

<button class="buttonHeader button2" data-toggle="collapse" data-target="#filters">
<span class="glyphicon glyphicon-filter"></span> Filter 
</button>
<div id="filters" class="collapse">
   <div class="row">
      <div class="col-md-4">
         <div class="form-group">
            <label for="resourcesValue">Resources list:</label>
            <select class="form-control" id="resourcesValue">
               <option id="0">All resources</option>
               {{range $index, $resource := .Resources}}
               <option id="{{$resource.ID}}">{{$resource.Name}} {{$resource.LastName}}</option>
               {{end}}
            </select>
         </div>
      </div>
      <div class="col-md-4">
         <div class="form-group">
            <label for="typeValue">Training list:</label>
            <select class="form-control" id="typeValue">
               <option id="0">All training</option>
               {{range $index, $type := .Types}}
               <option id="{{$type.ID}}">{{$type.Name}}</option>
               {{end}}
            </select>
         </div>
      </div>
      <div class="col-md-4">
         <div class="form-group">
			<br>
			<button class="buttonHeader button2" onclick="searchTrainingResources()">
			<span class="glyphicon glyphicon-search"></span> Search 
			</button>
         </div>
      </div>
   </div>
</div>
<div class="col-sm-12" id="tableInfo">
   <br>
   <br>
	<table id="viewTraining" class="table table-striped table-bordered">
		<thead>
			<tr>
				<th>Training Name</th>
				<th>Start Date</th>
				<th>End Date</th>
				<th>Duration</th>
				<th>Progress</th>
				<th>Test Result</th>
				<th>Result Status</th>
			</tr>
		</thead>
		<tbody id="detailBody">
		 	{{range $key, $tResource := .TResources}}
			<tr>
				<td style="background-position-x: 1%;font-size:11px;text-align: -webkit-center;margin:0 0 0px;" onclick="showDetails($(this), {{$tResource.TrainingResources}})">{{$tResource.SkillName}}</td>
				<td>{{dateformat $tResource.StartDate "2006-01-02"}}</td>
				<td>{{dateformat $tResource.EndDate "2006-01-02"}}</td>
				<td>{{$tResource.Duration}} d.</td>
				<td>{{$tResource.Progress}}</td>
				<td>{{$tResource.TestResult}}</td>
				<td>{{$tResource.ResultStatus}}</td>
			</tr>
			{{end}}
		</tbody>
	</table>
	
	
</div>


<div class="col-sm-12">
	<div class="col-sm-6">
		<p>
		   	<div class="chart-container" id="chartjs-wrapper">
				<canvas id="chartjs">
				</canvas>
			
				<script>
					new Chart(document.getElementById("chartjs"),
					{	"type": "pie",
						"data": {
							"labels": {{.TStatus}},
							"datasets": [{ 
								"data": {{.TValues}},
								"backgroundColor":["rgb(255, 99, 132)","rgb(54, 162, 235)"]
								
							}]						
						}
						
					});
				</script>
		
			</div>
		</p>
	</div>
	<div id="chart_div" class="col-sm-6">
	</div>
</div>

<!-- Modal -->
<div class="modal fade" id="trainingModal" role="dialog">
   <div class="modal-dialog">
      <!-- Modal content-->
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 id="modalTrainingTitle" class="modal-title">Create Resource Training</h4>
         </div>
         <div class="modal-body">
            <input type="hidden" id="trainingResourceID">
            <div class="row-box col-sm-12" style="padding-bottom: 1%;">
               <div class="form-group form-group-sm">
                  <label class="control-label col-sm-4 translatable" data-i18n="Select Resource"> Select Resource </label>
                  <div class="col-sm-8">
		            <select id="createResourcesValue" style="width: 174px; border-radius: 8px;">
		               <option id="">Resource...</option>
		               {{range $index, $resource := .Resources}}
		               <option id="{{$resource.ID}}">{{$resource.Name}} {{$resource.LastName}}</option>
		               {{end}}
		            </select>
                  </div>
               </div>
            </div>
            <div class="row-box col-sm-12" style="padding-bottom: 1%;">
               <div class="form-group form-group-sm">
                  <label class="control-label col-sm-4 translatable" data-i18n="Select Type"> Select Type </label>
                  <div class="col-sm-8">
		            <select id="createTypeValue" style="width: 174px; border-radius: 8px;">
		               <option id="">Type...</option>
		               {{range $index, $type := .Types}}
		               <option id="{{$type.ID}}">{{$type.Name}}</option>
		               {{end}}
		            </select>
                  </div>
               </div>
            </div>
            <div class="row-box col-sm-12" style="padding-bottom: 1%;">
               <div class="form-group form-group-sm">
                  <label class="control-label col-sm-4 translatable" data-i18n="Select Skill"> Select Skill </label>
                  <div class="col-sm-8">
		            <select id="createSkillValue" style="width: 174px; border-radius: 8px;">
		               <option id="">Skill...</option>
		            </select>
                  </div>
               </div>
            </div>
            <div class="row-box col-sm-12" style="padding-bottom: 1%;">
               <div class="form-group form-group-sm">
                  <label class="control-label col-sm-4 translatable" data-i18n="Select Training"> Select Training </label>
                  <div class="col-sm-8">
		            <select id="createTrainingValue" style="width: 174px; border-radius: 8px;">
		               <option id="">Training...</option>
		            </select>
                  </div>
               </div>
            </div>
	        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div class="form-group form-group-sm">
	        		<label class="control-label col-sm-4 translatable" data-i18n="Start Date"> Start Date </label> 
	              <div class="col-sm-8">
	              	<input type="date" id="trainingStartDate" style="inline-size: 174px; border-radius: 8px;">
	        		</div>
	          </div>
	        </div>
	        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div class="form-group form-group-sm">
	        		<label class="control-label col-sm-4 translatable" data-i18n="End Date"> End Date </label> 
	              <div class="col-sm-8">
	              	<input type="date" id="trainingEndDate" style="inline-size: 174px; border-radius: 8px;">
	        		</div>
	          </div>
	        </div>
			<div class="row-box col-sm-12" style="padding-bottom: 1%;">
				<div class="form-group form-group-sm">
					<label class="control-label col-sm-4 translatable" data-i18n="Duration"> Duration (hrs) </label> 
					<div class="col-sm-8">
						<input type="number" id="duration" value="0" style="border-radius: 8px;">
					</div>
				</div>
			</div>
			<div class="row-box col-sm-12" style="padding-bottom: 1%;">
				<div class="form-group form-group-sm">
					<label class="control-label col-sm-4 translatable" data-i18n="Progress"> Progress </label> 
					<div class="col-sm-8">
						<input type="number" id="progress" value="0" style="border-radius: 8px;">
					</div>
				</div>
			</div>
			<div class="row-box col-sm-12" style="padding-bottom: 1%;">
				<div class="form-group form-group-sm">
					<label class="control-label col-sm-4 translatable" data-i18n="Test Result"> Test Result </label> 
					<div class="col-sm-8">
						<input type="number" id="testResult" value="0" style="border-radius: 8px;">
					</div>
				</div>
			</div>
            <div class="row-box col-sm-12" style="padding-bottom: 1%;">
               <div class="form-group form-group-sm">
                  <label class="control-label col-sm-4 translatable" data-i18n="Results Status"> Results Status </label>
                  <div class="col-sm-8">
					<input type="text" id="resultStatus" disabled style="width: 174px; border-radius: 8px;" value="Pending">
                  </div>
               </div>
            </div>
         </div>
         <div class="modal-footer">
            <button type="button" id="trainingCreate" class="btn btn-default" onclick="setTrainingToResource()" data-dismiss="modal">Create</button>
            <button type="button" id="trainingUpdate" class="btn btn-default" onclick="updateTraining()" data-dismiss="modal">Update</button>
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
        Are you sure you want to remove <b id="nameDelete"></b> from trainings?
		<br>
		<li>The resource will lose this training assignment.</li>
      </div>
      <div class="modal-footer" style="text-align:center;">
        <button type="button" id="trainingResourceDelete" class="btn btn-default" onclick="deleteTrainingResource()" data-dismiss="modal">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>