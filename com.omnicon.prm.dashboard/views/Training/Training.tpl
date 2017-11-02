<script src="/static/js/chartjs/Chart.min.js">
</script>
<script src="/static/js/chartjs/Chart.PieceLabel.js" > </script>

<script>
	var Training = {};
	var chart;
	var data;
	var options;
	
	function repaint() {
		chart.draw(data, options);
	}
		
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
		$( window ).resize(
			function() {
				if (data.getNumberOfRows() > 0){
					repaint();
				}
			}
		);
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
			$(pObjBody).children('span').addClass('glyphicon-collapse-down');
			$(pObjBody).children('span').removeClass('glyphicon-expand');
        }
        else {
            // Open this row
            row.child( format(tDetails) ).show();
            tr.addClass('shown');
			$(pObjBody).children('span').addClass('glyphicon-expand');
			$(pObjBody).children('span').removeClass('glyphicon-collapse-down');
        }
	}
	/* Formatting function for row details - modify as you need */
	function format ( d ) {
	    // `d` is the original data object for the row
		var insert = '';
		for (index = 0; index < d.length; index++) {
			insert += '<td class="col-sm-2" style="font-size:12px;text-align: -webkit-center;">'+d[index].ResourceName+'</td>'+
				'<td class="col-sm-2" style="font-size:12px;text-align: -webkit-center;">'+d[index].TrainingName+'</td>'+
	            '<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].StartDate.substring(0, 10)+'</td>'+
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].EndDate.substring(0, 10)+'</td>'+	            
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].Duration+ ' h.' + '</td>'+	            
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].Progress+'</td>'+	            
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].TestResult+'</td>'+	            
				'<td class="col-sm-2" style="font-size:12px;text-align: -webkit-center;">'+d[index].ResultStatus+'</td>'+
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;"><a id="updateTrainingResource" onclick="'+
					"$('#trainingResourceID').val(" + d[index].ID + ");" + 
					"$('#trainingStartDate').val('" + d[index].StartDate.substring(0, 10) + "');"+
					"$('#trainingEndDate').val('" + d[index].EndDate.substring(0, 10) + "');"+
					"$('#duration').val(" + d[index].Duration + ");"+
					"$('#progress').val(" + d[index].Progress + ");"+
					"$('#testResult').val(" + d[index].TestResult + ");"+
					"$('#resultStatus').val('" + d[index].ResultStatus + "');"+					
				'"><span class="glyphicon glyphicon-edit"></span></a><a id="deleteTrainingResource" onclick="'+
					"$('#trainingResourceID').val("+ d[index].ID + ");" +
					"$('#nameDelete').html('"+ d[index].TrainingName + "')" +
				'"> <span class="glyphicon glyphicon-trash"></span></a></td>'+	            
	        '</tr>';
		}
	    return '<table border="0" style="width: 100%;margin-left: 6px;" class="table table-striped table-bordered  dataTable"><thead><tr><th>Resource Name</th><th>Training Name</th><th>Start Date</th><th>End Date</th><th>Duration</th><th>Progress</th><th>Test Result</th><th>Result Status</th><th>Options</th></tr></thead>'+insert+'</table>';
	}
	
	configureCreateModal = function(){
		$('#modalTrainingTitle').html('Create Resource Training');
		$('#inputCreateResourcesValue').show();
		$('#inputCreateTypeValue').show();
		$('#inputCreateSkillValue').show();
		$('#inputCreateTrainingValue').show();
		$('#trainingCreate').show();
		$('#trainingUpdate').hide();
		$('#trainingStartDate').val(null);
		$('#trainingEndDate').val(null);
		$('#duration').val(null);
		$('#progress').val(null);
		$('#testResult').val(null);
	}
	
	$(document).on('click','#updateTrainingResource',function(){
		$('#modalTrainingTitle').html('Update Resource Training');
    	$('#trainingModal').modal('show');
		$('#inputCreateResourcesValue').hide();
		$('#inputCreateTypeValue').hide();
		$('#inputCreateSkillValue').hide();
		$('#inputCreateTrainingValue').hide();
		$('#trainingCreate').hide();
		$('#trainingUpdate').show();
	});
	
	$(document).on('click','#deleteTrainingResource',function(){
    	$('#confirmModal').modal('show');
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
		  searchTrainingResources();
		  //reload('/trainings/resources', {});
		});
	}
	
	google.charts.load('current', {'packages':['gantt']});
    google.charts.setOnLoadCallback(drawChart);
		
	function drawChart() {
		data = new google.visualization.DataTable();
		
		data.addColumn('string', 'Training ID');
		data.addColumn('string', 'Training Name');
		data.addColumn('date', 'Start Date');
		data.addColumn('date', 'End Date');
		data.addColumn('number', 'Duration');
		data.addColumn('number', 'Percent Complete');
      	data.addColumn('string', 'Dependencies');
		
		data.addRows([
		{{range $xx, $training := .TResources}}
				[{{$training.SkillName}}, {{$training.SkillName}}, parseDate({{$training.StartDate}}), parseDate({{$training.EndDate}}), 0, {{$training.Progress}},""],
		{{end}}
		]);
		
		if (data.getNumberOfRows() > 0) {
			options = {
		    	height: 375
		    };
	
	      	chart = new google.visualization.Gantt(document.getElementById('chart_div'));
	      	chart.draw(data, options);
		}
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
	
	setTrainingToResource = function(){
		var settings = {
			method: 'POST',
			url: '/trainings/settraining',
			headers: {
				'Content-Type': undefined
			},
			data: {
				"ID": $('#trainingResourceID').val(),
				"ResourceId": $('#createResourcesValue option:selected').attr('id'),
				"TrainingId": $('#createTrainingValue option:selected').attr('id'),
				"StartDate": $('#trainingStartDate').val(),
				"EndDate": $('#trainingEndDate').val(),
				"Duration": $('#duration').val(),
				"Progress": $('#progress').val(),
				"TestResult": $('#testResult').val(),
				"ResultStatus": $('#resultStatus').val()
			}
		}
		$.ajax(settings).done(function (response) {
		  validationError(response);
		  searchTrainingResources();
		  //reload('/trainings/resources', {});
		});
	}
	
	$('#trainingStartDate').change(function(){
		$('#trainingEndDate').attr("min", $("#trainingStartDate").val());
	});
	
	// parse a date in yyyy-mm-dd format
	function parseDate(input) {
	  var parts = input.match(/(\d+)/g);
	  // new Date(year, month [, date [, hours[, minutes[, seconds[, ms]]]]])
	  return new Date(parts[0], parts[1]-1, parts[2]); // months are 0-based
	}
	
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
			$("#titleSearch").html($("#resourcesValue").val() + " ("+ $("#typeValue").val()+")");
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
               <option id="0">All trainings</option>
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

<div class="col-sm-12" id="tableInfo" style="background-color: #F5F5F5;">
	<h3 id="titleSearch">All resources (All trainings)</h3>
	<table id="viewTraining" class="table table-striped table-bordered dt-responsive nowrap" width="100%">
		<thead>
			<tr>
				<th>Type Name</th>
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
				<td style="background-position-x: 1%;text-align: -webkit-center;margin:0 0 0px;" onclick="showDetails($(this), {{$tResource.TrainingResources}})"><span class="glyphicon glyphicon-collapse-down" style="float:left;"></span>{{$tResource.TypeName}}</td>
				<td>{{$tResource.SkillName}}</td>
				<td>{{dateformat $tResource.StartDate "2006-01-02"}}</td>
				<td>{{dateformat $tResource.EndDate "2006-01-02"}}</td>
				<td>{{$tResource.Duration}} d.</td>
				<td>{{$tResource.Progress}}</td>
				<td>{{$tResource.TestResult}}</td>
				<td style="padding: unset;">
					<table style="border: 1px solid black;border-collapse: collapse;text-align: center;width: -webkit-fill-available;">
						<tr style="border: 1px solid black;">
							{{range $key, $result := $tResource.ResultStatus}}
								<th class="style-color-{{$result.Key}}" style="border: 1px solid #DDDDDD; padding: 3px;text-align: -webkit-center;">{{$result.Key}}</th>
							{{end}}
						</tr>
						<tr style="border: 1px solid black;">
							{{range $key, $result := $tResource.ResultStatus}}
								<td style="border: 1px solid #DDDDDD;text-align: center; padding: 3px;">{{$result.Value}}</td>
							{{end}}
						</tr>
					</table>
				</td>
			</tr>
			{{end}}
		</tbody>
	</table>
	
	
</div>


<div class="col-sm-12" style="margin-top:10px;">
	<div class="col-sm-6">
		<p>
		   	<div class="chart-container" id="chartjs-wrapper">
				<canvas id="chartjs">
				</canvas>
			
				<script>
					chart2=new Chart(document.getElementById("chartjs"),
					{	"type": "pie",
						"data": {
							"labels": {{.TStatus}},
							"datasets": [{ 
								"data": {{.TValues}},
								"backgroundColor":["rgb(54, 162, 235)","rgb(255, 99, 132)","rgb(75, 192, 192)"]
								
							}]						
						},
						options: {
						  pieceLabel: {
						    render: 'percentage',
						    fontColor: ['white', 'white', 'white'],
						    precision: 2
						  }
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
            <h4 id="modalTrainingTitle" class="modal-title"></h4>
         </div>
         <div class="modal-body">
            <input type="hidden" id="trainingResourceID">
            <div class="row-box col-sm-12" style="padding-bottom: 1%;" id="inputCreateResourcesValue">
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
            <div class="row-box col-sm-12" style="padding-bottom: 1%;" id="inputCreateTypeValue">
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
            <div class="row-box col-sm-12" style="padding-bottom: 1%;" id="inputCreateSkillValue">
               <div class="form-group form-group-sm">
                  <label class="control-label col-sm-4 translatable" data-i18n="Select Skill"> Select Skill </label>
                  <div class="col-sm-8">
		            <select id="createSkillValue" style="width: 174px; border-radius: 8px;">
		               <option id="">Skill...</option>
		            </select>
                  </div>
               </div>
            </div>
            <div class="row-box col-sm-12" style="padding-bottom: 1%;" id="inputCreateTrainingValue">
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
            <button type="button" id="trainingCreate" class="btn btn-default" onclick="setTrainingToResource();$('#trainingResourceID').val(0)" data-dismiss="modal">Create</button>
            <button type="button" id="trainingUpdate" class="btn btn-default" onclick="setTrainingToResource()" data-dismiss="modal">Update</button>
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