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
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-menu'));
		getmdlSelect.init(".getmdl-select");

		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/trainings/resources',{});
		});
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOptionIcon').html("add");
		$('#buttonOptionTooltip').html("Add new session training");
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
		
		var dialogTraining = document.querySelector('#trainingModal');
		dialogTraining.querySelector('#cancelTrainingDialogButton')
		    .addEventListener('click', function() {
		      dialogTraining.close();	
    	});
		
		var dialogCancelTraining = document.querySelector('#confirmModal');
		dialogCancelTraining.querySelector('#cancelTrainingResourceDelete')
		    .addEventListener('click', function() {
		      dialogCancelTraining.close();	
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
			$(pObjBody).children('i').html('arrow_drop_down');
			//$(pObjBody).children('span').removeClass('glyphicon-expand');
        }
        else {
            // Open this row
            row.child( format(tDetails) ).show();
            tr.addClass('shown');
			$(pObjBody).children('i').html('arrow_drop_up');
			//$(pObjBody).children('span').removeClass('glyphicon-collapse-down');
        }
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-selectfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		getmdlSelect.init(".getmdl-select");
	}
	/* Formatting function for row details - modify as you need */
	function format ( d ) {
		/*componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-selectfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		getmdlSelect.init(".getmdl-select");*/
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
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;"><button id="updateTrainingResource" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="'+
					"$('#trainingResourceID').val(" + d[index].ID + ");" + 
					"$('#trainingStartDate').val('" + d[index].StartDate.substring(0, 10) + "');"+
					"$('#trainingEndDate').val('" + d[index].EndDate.substring(0, 10) + "');"+
					"$('#duration').val(" + d[index].Duration + ");"+
					"$('#progress').val(" + d[index].Progress + ");"+
					"$('#testResult').val(" + d[index].TestResult + ");"+
					"$('#resultStatus').val('" + d[index].ResultStatus + "');"+					
				'"><i class="material-icons" style="vertical-align: inherit;">mode_edit</i></button><div class="mdl-tooltip" for="updateTrainingResource">Edit record</div><button id="deleteTrainingResource" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="'+
					"$('#trainingResourceID').val("+ d[index].ID + ");" +
					"$('#nameDelete').html('"+ d[index].TrainingName + "')" +
				'"><i class="material-icons" style="vertical-align: inherit;">delete</i></button><div class="mdl-tooltip" for="deleteTrainingResource">Delete record</div></td>'+	            
	        '</tr>';
		}
	    return '<table border="0" style="width: 100%;margin-left: 6px;" class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp"><thead><tr><th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Resource Name</th><th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Training Name</th><th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Start Date</th><th class="mdl-data-table__cell--non-numeric" style="text-align:center;">End Date</th><th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Duration</th><th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Progress</th><th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Test Result</th><th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Result Status</th><th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Options</th></tr></thead>'+insert+'</table>';
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
		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-selectfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		getmdlSelect.init(".getmdl-select");
		$('.mdl-textfield>input').each(function(param){if($(this).val() != ""){$(this).parent().addClass('is-dirty');$(this).parent().removeClass('is-invalid')}})
		
		var dialog = document.querySelector('#trainingModal');
		dialog.showModal();		
	}
	
	$(document).on('click','#updateTrainingResource',function(){
		$('#modalTrainingTitle').html('Update Resource Training');
		$('#inputCreateResourcesValue').hide();
		$('#inputCreateTypeValue').hide();
		$('#inputCreateSkillValue').hide();
		$('#inputCreateTrainingValue').hide();
		$('#trainingCreate').hide();
		$('#trainingUpdate').show();
		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-selectfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		getmdlSelect.init(".getmdl-select");
		
		$('.mdl-textfield>input').each(function(param){
			if($(this).val() != ""){
				$(this).parent().addClass('is-dirty');
				$(this).parent().removeClass('is-invalid');
			}
			if($(this).val() == "" && $(this).prop("required")){
				$(this).parent().removeClass('is-dirty');
				$(this).parent().addClass('is-invalid');
			}
		});
		
		var dialogUpdate = document.querySelector('#trainingModal');
		dialogUpdate.showModal();	
	});
	
	$(document).on('click','#deleteTrainingResource',function(){
		var dialogDelete = document.querySelector('#confirmModal');
		dialogDelete.showModal();	
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
		var typeValue;
		$('#createTypeValueList').children().each(
			function(param){
				if(this.classList.length >1 && this.classList[1] == "selected"){
					typeValue = this.getAttribute("data-val");
				}
			});
			
		$('#createSkillValueList').html('');
        {{range $index, $typeSkill := .TypesSkills}}
			if ({{$typeSkill.TypeId}} == typeValue) {
        		$('#createSkillValueList').append('<li id="skill{{$typeSkill.SkillId}}" class="mdl-menu__item" data-val="{{$typeSkill.SkillId}}">{{$typeSkill.Name}}</li>');
			}
        {{end}}
		
		var type = document.getElementById("type"+typeValue);
		var att = document.createAttribute("data-selected");
		att.value = "true";
		if(type != null) {
			type.setAttributeNode(att);
			getmdlSelect.init("#inputCreateSkillValue");
		}
		
	});
	
	$('#createSkillValue').change(function() {
		var typeValue;
		var skillValue;
		$('#createTypeValueList').children().each(
			function(param){
				if(this.classList.length >1 && this.classList[1] == "selected"){
					typeValue = this.getAttribute("data-val");
				}
			});
		$('#createSkillValueList').children().each(
			function(param){
				if(this.classList.length >1 && this.classList[1] == "selected"){
					skillValue = this.getAttribute("data-val");
				}
			});
		$('#createTrainingValueList').html('');
        {{range $index, $training := .Trainings}}
			if ({{$training.TypeId}} == typeValue &&
				{{$training.SkillId}} == skillValue) {
        		$('#createTrainingValueList').append('<li id="{{$training.ID}}" class="mdl-menu__item" data-val="{{$training.ID}}">{{$training.Name}}</li>');
			}
        {{end}}
		
		var type = document.getElementById("type"+typeValue);
		var skill = document.getElementById("skill"+skillValue);
		console.log("skillValue " + skillValue);
		
		
		/*if(type != null) {
			var attType = document.createAttribute("data-selected");
			attType.value = "true";
			type.setAttributeNode(attType);
			getmdlSelect.init("#inputCreateSkillValue");
		}*/
		if(skill != null) {
			var attSkill = document.createAttribute("data-selected");
			attSkill.value = "true";
			skill.setAttributeNode(attSkill);
			getmdlSelect.init("#inputCreateTrainingValue");
		}	
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
		
		$('#objectPdf').attr('data', doc.output('datauristring'));
		var dialogPDF = document.querySelector('#showDocument');
		dialogPDF.showModal();
	}

	var dialogPDF = document.querySelector('#showDocument');
	dialogPDF.querySelector('#cancelPDFButton')
	    .addEventListener('click', function() {
	      dialogPDF.close();	
   	});
</script>


<div class="row">
	<div class="col-sm-5">		
		<button class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" data-toggle="collapse" data-target="#filters">
			<i class="material-icons" style="vertical-align: inherit;">tune</i>
		</button>
	</div>
	<div class="col-sm-5">
	</div>
	<div class="col-sm-2">
		<button class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" id="download-pdf" onclick="downloadPDF()" >
			<i class="material-icons" style="vertical-align: inherit;">picture_as_pdf</i>
		</button>
		<div class="mdl-tooltip" for="download-pdf">Preview PDF</div>
	</div>
</div>
	

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
	<table id="viewTraining" class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp" width="100%">
		<thead>
			<tr>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Type Name</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Training Name</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Start Date</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">End Date</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Duration</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Progress</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Test Result</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Result Status</th>
			</tr>
		</thead>
		<tbody id="detailBody">
		 	{{range $key, $tResource := .TResources}}
			<tr>
				<td style="background-position-x: 1%;text-align: -webkit-center;margin:0 0 0px;vertical-align: inherit;" onclick="showDetails($(this), {{$tResource.TrainingResources}})"><i class="material-icons pull-left">arrow_drop_down</i>{{$tResource.TypeName}}</td>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$tResource.SkillName}}</td>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{dateformat $tResource.StartDate "2006-01-02"}}</td>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{dateformat $tResource.EndDate "2006-01-02"}}</td>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$tResource.Duration}} d.</td>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$tResource.Progress}}</td>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$tResource.TestResult}}</td>
				<td style="padding: unset;text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">
					<table style="border: 1px solid black;border-collapse: collapse;text-align: center;width: -webkit-fill-available;">
						<tr style="border: 1px solid black;">
							{{range $key, $result := $tResource.ResultStatus}}
								<th class="mdl-data-table__cell--non-numeric style-color-{{$result.Key}}" style="border: 1px solid #DDDDDD; padding: 3px;text-align: -webkit-center;">{{$result.Key}}</th>
							{{end}}
						</tr>
						<tr style="border: 1px solid black;">
							{{range $key, $result := $tResource.ResultStatus}}
								<td style="border: 1px solid #DDDDDD;text-align: center; padding: 3px;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$result.Value}}</td>
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
<dialog class="mdl-dialog" id="trainingModal">
	<h4 id="modalTrainingTitle" class="mdl-dialog__title"></h4>
	<div class="mdl-dialog__content">
		<input type="hidden" id="trainingResourceID">
		<form id="formCreateUpdate" action="#">
			<div id="inputCreateResourcesValue" class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label getmdl-select">
		        <input type="text" value="" class="mdl-textfield__input" id="createResourcesValue" readonly required>
		        <input type="hidden" value="" name="createResourcesValue" id="realCreateResourcesValue">
		        <i class="mdl-icon-toggle__label material-icons">keyboard_arrow_down</i>
		        <label for="createResourcesValue" class="mdl-textfield__label">Resource...</label>
		        <ul id="createResourcesValueList" for="createResourcesValue" class="mdl-menu mdl-menu--bottom-left mdl-js-menu">
		        	{{range $index, $resource := .Resources}}
					<li id="resource{{$resource.ID}}" class="mdl-menu__item" data-val="{{$resource.ID}}">{{$resource.Name}} {{$resource.LastName}}</li>
		        	{{end}}
				</ul>
		    </div>
			<div id="inputCreateTypeValue" class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label getmdl-select">
		        <input type="text" value="" class="mdl-textfield__input" id="createTypeValue" readonly required>
		        <input type="hidden" value="" name="createTypeValue" id="realCreateTypeValue">
		        <i class="mdl-icon-toggle__label material-icons">keyboard_arrow_down</i>
		        <label for="createTypeValue" class="mdl-textfield__label">Type...</label>
		        <ul id="createTypeValueList" for="createTypeValue" class="mdl-menu mdl-menu--bottom-left mdl-js-menu">
		        	{{range $index, $type := .Types}}
					<li id="type{{$type.ID}}" class="mdl-menu__item" data-val="{{$type.ID}}">{{$type.Name}}</li>
		        	{{end}}
				</ul>
		    </div>
			<div id="inputCreateSkillValue" class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label getmdl-select">
		        <input type="text" value="" class="mdl-textfield__input" id="createSkillValue" readonly required>
		        <input type="hidden" value="" name="createSkillValue" id="realSkillValue">
		        <i class="mdl-icon-toggle__label material-icons">keyboard_arrow_down</i>
		        <label for="createSkillValue" class="mdl-textfield__label">Skill...</label>
		        <ul id="createSkillValueList" for="createSkillValue" class="mdl-menu mdl-menu--bottom-left mdl-js-menu">
		        	
				</ul>
		    </div>
			<div id="inputCreateTrainingValue" class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label getmdl-select">
		        <input type="text" value="" class="mdl-textfield__input" id="createTrainingValue" readonly required>
		        <input type="hidden" value="" name="createTrainingValue" id="realCreateTrainingValue">
		        <i class="mdl-icon-toggle__label material-icons">keyboard_arrow_down</i>
		        <label for="createTrainingValue" class="mdl-textfield__label">Training...</label>
		        <ul id="createTrainingValueList" for="createTrainingValue" class="mdl-menu mdl-menu--bottom-left mdl-js-menu">
		        	
				</ul>
		    </div>
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
			  <input class="mdl-textfield__input" type="date" id="trainingStartDate" required>
			  <label class="mdl-textfield__label" for="trainingStartDate">Start Date...</label>
			</div>		
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
			  <input class="mdl-textfield__input" type="date" id="trainingEndDate" required>
			  <label class="mdl-textfield__label" for="trainingEndDate">End Date...</label>
			</div>
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
				<input class="mdl-textfield__input" type="text" pattern="-?[0-9]*(\.[0-9]+)?" id="duration">
				<label class="mdl-textfield__label" for="duration">Duration...</label>
				<span class="mdl-textfield__error">Input is not a number!</span>
			</div>
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
				<input class="mdl-textfield__input" type="text" pattern="-?[0-9]*(\.[0-9]+)?" id="progress">
				<label class="mdl-textfield__label" for="progress">Progress...</label>
				<span class="mdl-textfield__error">Input is not a number!</span>
			</div>
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
				<input class="mdl-textfield__input" type="text" pattern="-?[0-9]*(\.[0-9]+)?" id="testResult">
				<label class="mdl-textfield__label" for="testResult">Test Result...</label>
				<span class="mdl-textfield__error">Input is not a number!</span>
			</div>
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
			  <input class="mdl-textfield__input" type="text" id="resultStatus" value="Pending" required>
			  <label class="mdl-textfield__label" for="resultStatus">Result Status...</label>
			</div>	
		</form>
	</div>
	<div class="mdl-dialog__actions">
		<button type="button" id="trainingCreate" class="mdl-button" onclick="setTrainingToResource();$('#trainingResourceID').val(0)" data-dismiss="modal">Create</button>
		<button type="button" id="trainingUpdate" class="mdl-button" onclick="setTrainingToResource()" data-dismiss="modal">Update</button>
      	<button id="cancelTrainingDialogButton" type="button" class="mdl-button close" data-dismiss="modal">Cancel</button>
    </div>
</dialog>

<dialog class="mdl-dialog" id="confirmModal">
	<h4 id="modalDeleteTrainingTitle" class="mdl-dialog__title">Delete Confirmation</h4>
	<div class="mdl-dialog__content">
		Are you sure you want to remove <b id="nameDelete"></b> from trainings?
		<br>
		<li>The resource will lose this training assignment.</li>	
	</div>
	<div class="mdl-dialog__actions">
	 	<button type="button" id="trainingResourceDelete" class="mdl-button" onclick="deleteTrainingResource()" data-dismiss="modal">Yes</button>
		<button type="button" id="cancelTrainingResourceDelete" class="mdl-button close" data-dismiss="modal">No</button>
   </div>
</dialog>

<dialog class="mdl-dialog" id="showDocument" style="width: 95%;height: 90%;">
	<h4 class="mdl-dialog__title">Preview Trainings</h4>
	<!-- Modal content-->
	<div class="mdl-dialog__content" style="height: 85%">
		<object id="objectPdf" type="application/pdf" width="100%" height="100%">			   
		</object>
    </div>
	<div class="mdl-dialog__actions">
		<button id="cancelPDFButton" type="button" class="mdl-button close" data-dismiss="modal">Close</button>
    </div>
</dialog>