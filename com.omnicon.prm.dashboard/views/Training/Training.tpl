
<script>
	var Training = {};
	var chart;
	var data;
	var options;
	
	function repaint() {
		chart.draw(data, options);
	}
	document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.modal');
    var instances = M.Modal.init(elems, options);
  });

		
	$(document).ready(function(){
		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		$('select').material_select();
		$('.modal-trigger').leanModal();
		$('.tooltipped').tooltip();
		$('.datepicker').pickadate({
			selectMonths: true,
			selectYears: 15,
			format: 'yyyy-mm-dd',
			formatSubmit: 'yyyy-mm-dd',
			container: 'body'
		});
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/trainings/resources',{});
		});
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "trainingModal");
		$('#buttonOption').attr("onclick","configureCreateModal()");
		
		Training.table = $('#viewTraining').DataTable({
			"iDisplayLength": 20,
			"bLengthChange": false,
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
			$(pObjBody).children('span').addClass('fa-caret-square-right');
			$(pObjBody).children('span').removeClass('fa-caret-square-remove');
        }
        else {
            // Open this row
            row.child( format(tDetails) ).show();
            tr.addClass('shown');
			$(pObjBody).children('span').addClass('fa-caret-square-down');
			$(pObjBody).children('span').removeClass('fa-caret-square-right');
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
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;"><a id="updateTrainingResource" class="tooltipped" data-tooltip="Update"  onclick="'+
					"$('#trainingResourceID').val(" + d[index].ID + ");" + 
					"$('#trainingStartDate').val('" + d[index].StartDate.substring(0, 10) + "');"+
					"$('#trainingEndDate').val('" + d[index].EndDate.substring(0, 10) + "');"+
					"$('#duration').val(" + d[index].Duration + ");"+
					"$('#progress').val(" + d[index].Progress + ");"+
					"$('#testResult').val(" + d[index].TestResult + ");"+
					"$('#resultStatus').val('" + d[index].ResultStatus + "');"+					
				'"><span class="mdi-editor-mode-edit small"></span></a><a id="deleteTrainingResource" class="tooltipped" data-tooltip="Delete" onclick="'+
					"$('#trainingResourceID').val("+ d[index].ID + ");" +
					"$('#nameDelete').html('"+ d[index].TrainingName + "')" +
				'"> <span class="mdi-action-delete small"></span></a></td>'+	            
	        '</tr>';
		}
	    return '<table border="0" style="width: 100%;margin-left: 6px;" class="centered highlight"><thead><tr><th>Resource Name</th><th>Training Name</th><th>Start Date</th><th>End Date</th><th>Duration</th><th>Progress</th><th>Test Result</th><th>Result Status</th><th>Options</th></tr></thead>'+insert+'</table>';
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
		$('.modal-trigger').leanModal();
		$("#trainingModal").openModal()
		$('#inputCreateResourcesValue').hide();
		$('#inputCreateTypeValue').hide();
		$('#inputCreateSkillValue').hide();
		$('#inputCreateTrainingValue').hide();
		$('#trainingCreate').hide();
		$('#trainingUpdate').show();
	});
	
	$(document).on('click','#deleteTrainingResource',function(){
		$('.modal-trigger').leanModal();
		$("#confirmModal").openModal()
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
			//$("#filters").collapse("show");
			$("#resourcesValue option[id="+resourceID+"]").attr("selected", "selected");
			$("#typeValue option[id="+typeID+"]").attr("selected", "selected");
			$("#titleSearch").html($("#resourcesValue").val() + " ("+ $("#typeValue").val()+")");
		});
	}

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
		$('#createSkillValue').material_select();
	});
	
	$('#createTypeValue, #createSkillValue').change(function() {
		$('#createTrainingValue').html('<option id="">Training...</option>');
        {{range $index, $training := .Trainings}}
			if ({{$training.TypeId}} == $('#createTypeValue option:selected').attr('id') &&
				{{$training.SkillId}} == $('#createSkillValue option:selected').attr('id')) {
        		$('#createTrainingValue').append('<option id="{{$training.ID}}">{{$training.Name}}</option>');
			}
        {{end}}
		$('#createTrainingValue').material_select();
	});
		
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
	

	//donwload pdf from original canvas
	downloadPDF = function() {
	  var canvas = document.querySelector('#chartjs');
		//creates image
		var canvasImg = canvas.toDataURL("image/jpg", 1.0);
	  
		//creates PDF from img
		var doc = new jsPDF('landscape', 'mm', 'letter');
		doc.setProperties({
			title: $('#resourcesValue').val()
		});
		doc.setFontSize(20);
		doc.text("Summary " + $('#resourcesValue').val() + "'s trainings", 139.5, 20, 'center' );

		doc.addImage(canvasImg, 'JPEG', 107, 30, 65, 65);
		
		doc.setFontSize(14);
		
		var index = 0;
		{{range $key, $tResource := .TResources}}
		
			var columns = ["Type Name",	"Training Name", "Start Date", "End Date", "Duration", "Progress", "Test Result"];
			var rows = [			
					["{{$tResource.TypeName}}", 
					"{{$tResource.SkillName}}", 
					"{{dateformat $tResource.StartDate "2006-01-02"}}", 
					"{{dateformat $tResource.EndDate "2006-01-02"}}", 
					"{{$tResource.Duration}}" + " d.", 
					{{$tResource.Progress}}, 
					{{$tResource.TestResult}}]			
			];
			
			var first = doc.autoTable.previous;		
			var finalY = 90;		
			if (index != 0){
				finalY = first.finalY;
			}
			index++;
			doc.autoTable(columns, rows, {
				startY: finalY + 10,
				margin: {right: 63}
			});
			
			var columnsRes = [];
			var rowsRes = [];
			var row = [];
			{{range $key, $result := $tResource.ResultStatus}}
				columnsRes.push("{{$result.Key}}");
				row.push("{{$result.Value}}");
			{{end}}
			rowsRes.push(row);
			doc.autoTable(columnsRes, rowsRes, {
				theme: 'grid',
				startY: finalY + 10,
				headerStyles: {fillColor: [41, 128, 186]},
				tableWidth: 'wrap',
				margin: {left: 218}
			});
			
			first = doc.autoTable.previous;
			
			var columnsInt = ["Resource Name", "Training Name", "Start Date", "End Date", "Duration", "Progress", "Test Result", "Result Status"];
			var rowsInt = [
			{{range $key, $trainingResource := $tResource.TrainingResources}}
				["{{$trainingResource.ResourceName}}",
				"{{$trainingResource.TrainingName}}",
				"{{dateformat $trainingResource.StartDate "2006-01-02"}}",
				"{{dateformat $trainingResource.EndDate "2006-01-02"}}",
				"{{$trainingResource.Duration}}" + " h.",
				{{$trainingResource.Progress}},
				{{$trainingResource.TestResult}},
				"{{$trainingResource.ResultStatus}}"],
			{{end}}
			];
			
			doc.autoTable(columnsInt, rowsInt, {
				startY: first.finalY + 5,
				theme: 'grid'
			});
			first = doc.autoTable.previous;
		
		{{end}}
		doc.save('datauristring');
		//$('#objectPdf').attr('data', doc.output('datauristring'));
		//$('.modal-trigger').leanModal();
		//$("#showDocument").openModal()
	}
	
</script>


<div class="row">
	<div class="col s12   marginCard">
		<div id="pry_add">
			<h4 id="titlePag">Trainings</h4>
			<a id="refreshButton" class="btn-floating btn-large waves-effect waves-light blue  tooltipped" data-tooltip= "Refresh"  ><i class="mdi-navigation-refresh large"></i></a>
			<a id="buttonOption" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Create Resource Training"><i class="mdi-action-note-add large"></i></a>
			<a class='btn-floating btn-large waves-effect waves-light blue tooltipped' data-position="top" data-tooltip="Download PDF"  id="download-pdf" onclick="downloadPDF()" ><i class="fas fa-file-pdf"></i></a>
		</div>
	</div>
</div>	

<div id="filters" class="container marginCard">
   <div class="row">
      <div class="col m4">
         <div class="input-field">
            <label class= "active"  for="resourcesValue">Resources list:</label>
            <select  id="resourcesValue">
               <option id="0">All resources</option>
               {{range $index, $resource := .Resources}}
               <option id="{{$resource.ID}}">{{$resource.Name}} {{$resource.LastName}}</option>
               {{end}}
            </select>
         </div>
      </div>
      <div class="col m4">
         <div class="input-field">
            <label class= "active" for="typeValue">Training list:</label>
            <select  id="typeValue">
               <option id="0">All trainings</option>
               {{range $index, $type := .Types}}
               <option id="{{$type.ID}}">{{$type.Name}}</option>
               {{end}}
            </select>
         </div>
      </div>
      <div class="col m4">
         <div class="input-field">
			<a class='waves-effect waves-light btn  tooltipped' data-position="top" data-tooltip="Search"  onclick="searchTrainingResources()"><i class="mdi-action-search"></i></a>
		
         </div>
      </div>
   </div>
</div>

<div class="col s12 container" id="tableInfo" style="background-color: #F5F5F5;">
	<h5 id="titleSearch">All resources (All trainings)</h5>
	<table id="viewTraining" class="display TableConfig responsive-table " cellspacing="0" width="100%">
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
				<td style="background-position-x: 1%;text-align: -webkit-center;margin:0 0 0px;" onclick="showDetails($(this), {{$tResource.TrainingResources}})"><span class="fas fa-caret-square-right" style="margin-top: 5px;float:left;"></span>{{$tResource.TypeName}}</td>
				<td>{{$tResource.SkillName}}</td>
				<td>{{dateformat $tResource.StartDate "2006-01-02"}}</td>
				<td>{{dateformat $tResource.EndDate "2006-01-02"}}</td>
				<td>{{$tResource.Duration}} d.</td>
				<td>{{$tResource.Progress}}</td>
				<td>{{$tResource.TestResult}}</td>
				<td style="padding: unset;">
					<table class="display TableConfig " cellspacing="0" width="100%">
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

<div class="row">
<div class="col s12" style="margin-top:10px;">
	<div class="col s12 m6 l4">
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
								"backgroundColor":["rgb(0, 128, 0)","rgb(255, 0, 0)","rgb(255, 165, 0)"]
								
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
	<div id="chart_div" class="col s12 m6 l8">
	</div>
</div>
</div>
<div id="content"></div>


<!-- Materialize Modal Update -->
	<div id="trainingModal" class="modal " style="overflow: visible;" >
			<div class="modal-content">
				<h5 id="modalTrainingTitle" class="modal-title"></h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="trainingResourceID">
				<div class="input-field row">	
					<!-- Select -->
					<div class="input-field col s12 m5 l5" id= "inputCreateResourcesValue">
						<label  class= "active">Select Resource</label>
						<select id="createResourcesValue" style="width: 174px; border-radius: 8px;">
							<option id="">Resource...</option>
							{{range $index, $resource := .Resources}}
							<option id="{{$resource.ID}}">{{$resource.Name}} {{$resource.LastName}}</option>
							{{end}}
						</select>	
					</div>
					<!-- Close Select -->

					<!-- Select -->
					<div class="input-field col s12 m5 l5" id="inputCreateTypeValue">
						<label  class= "active">Select Type</label>
						<select id="createTypeValue" style="width: 174px; border-radius: 8px;">
							<option id="">Type...</option>
							{{range $index, $type := .Types}}
								<option id="{{$type.ID}}">{{$type.Name}}</option>
							{{end}}
		            	</select>	
					</div>
					<!-- Close Select -->

					<!-- Select -->
					<div class="input-field col s12 m5 l5" id="inputCreateSkillValue">
						<label  class= "active">Select Skill</label>
						<select id="createSkillValue" style="width: 174px; border-radius: 8px;">
		               		<option id="">Skill...</option>
		           		</select>	
					</div>
					<!-- Close Select -->

					<!-- Select -->
					<div class="input-field col s12 m5 l5" id="inputCreateTrainingValue">
						<label  class= "active">Select Training</label>
						<select id="createTrainingValue" style="width: 174px; border-radius: 8px;">
							<option id="">Training...</option>
						</select>	
					</div>
					<!-- Close Select -->

					<!-- Input -->
					<div class="input-field col s12 m5 l5">
						<label class="active">Start Date</label>
						<input type="date" id="trainingStartDate" class="datepicker">
					</div>
					<!-- /Input -->

					<!-- Input -->
					<div class="input-field col s12 m5 l5">
						<label class="active">End Date</label>
						<input type="date" id="trainingEndDate" class="datepicker">
					</div>
					<!-- /Input -->

					<!-- Input -->
					<div class="input-field col s12 m5 l5">
						<input id="duration" type="number"  value= 0 class="validate">
						<label class= "active" for="duration" >Duration (hrs)</label>
					</div>
					<!-- /Input -->

					<!-- Input -->
					<div class="input-field col s12 m5 l5">
						<input id="progress" type="number" value= 0 class="validate">
						<label class= "active" for="progress"  >Progress</label>
					</div>
					<!-- /Input -->

					<!-- Input -->
					<div class="input-field col s12 m5 l5">
						<input id="testResult" type="number"  value= 0 class="validate">
						<label class= "active" for="testResult"  >Test Result</label>
					</div>
					<!-- /Input -->

					<!-- Input -->
					<div class="input-field col s12 m7 l7">
						<input id="resultStatus" type="text" disabled  class="validate">
						<label class= "active" for="resultStatus" >Result Status</label>
					</div>
					<!-- /Input -->
				</div>
			</div>
			<div class="modal-footer">
				<a id="trainingCreate" onclick="setTrainingToResource();$('#trainingResourceID').val(0)" class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close" >Create</a>
				<a id="trainingUpdate" onclick="setTrainingToResource()" class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close"  >Update</a>
       		 	<a class="btn red white-text waves-effect waves-light btn-flat modal-action modal-close">Cancel</a>
			</div>
	</div>
    
<!-- Modal Update -->



<!-- Modal1 -->
<!--<div class="modal fade" id="trainingModal" role="dialog">
   <div class="modal-dialog">
       Modal content
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
</div>-->

<!-- /Modal1 -->


<!-- Materialize Modal Delete -->
<div id="confirmModal" class="modal" >
			<div class="modal-content">
				<h5 id="modalTitle" class="modal-title">Delete Confirmation</h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="skillID">
				Are you sure you want to remove <b id="nameDelete"></b> from trainings?
				<br>
				<li>The resource will lose this training assignment.</li>
			</div>
			<div class="modal-footer">
				<a onclick="deleteTrainingResource()" class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close" >Yes</a>
        		<a class="btn red white-text waves-effect waves-light btn-flat modal-action modal-close">No</a>
			</div>
</div>

<!-- Modal delete close -->



<div id="showDocument" class="modal" >
			<div class="modal-content">
				<h5 id="modalTitle" class="modal-title">Preview Skills</h5>
				<div class="divider CardTable"></div>
					<object id="objectPdf" type="application/pdf" width="100%" height="100%">
					</object>
			</div>
			<div class="modal-footer">
        		<a class="btn red white-text waves-effect waves-light btn-flat modal-action modal-close">Close</a>

			</div>
</div>