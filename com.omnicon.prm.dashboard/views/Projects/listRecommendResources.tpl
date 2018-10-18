<script>
	$(document).ready(function(){
		$('.tooltipped').tooltip();
		$('.modal-trigger').leanModal();
		
		$('select').material_select();
		$('.datepicker').pickadate({
			selectMonths: true,
			selectYears: 15,
			format: 'yyyy-mm-dd',
			formatSubmit: 'yyyy-mm-dd',
			container: 'body'
		});
			
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
	function formatDate(valDate) {
  	var monthNames = [
	    "January", "February", "March",
	    "April", "May", "June", "July",
	    "August", "September", "October",
	    "November", "December"
	  ];
	
	var dateFrom = valDate.split("T");
	var from = dateFrom[0].split("-");
	var f = new Date(from[0], from[1] - 1, from[2]);

	var day = f.getDate();
	var monthIndex = f.getMonth();
	var year = f.getFullYear();
	
	return day + ' ' + monthNames[monthIndex] + ' ' + year;
}

		$("#projectStartDate").val(getDateToday());
		$("#projectEndDate").val(getDateToday());
			
		$('#backButton').css("display", "inline-block");
		$('#backButton').prop('onclick',null).off('click');
		$('#backButton').click(function(){
			reload('/projects',{});
		}); 
		$('#titlePag').html("Simulator");
		$('#datePicker').css("display", "none");
		$('#refreshButton').css("display", "none");
				
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("onclick","createProject();");
		
		
		var prjStartDate = formatDate(getDateToday());
		var prjEndDate = formatDate(getDateToday());
		$('#dates').text("Date From: "+ prjStartDate + "  -  Date To: " + prjEndDate);
		
		$('#skillsActive').prop('checked', false);
		//$('#projectTypeSimulator').prop('disabled', true);
		$('#projectHoursActive').prop('checked', false);
		//$('#projectHours').prop('disabled', true);
		//$('#personNumber').prop('disabled', true);
		
		$('#projectStartDate').change(function(){
			$('#projectEndDate').attr("min", $("#projectStartDate").val());
		});
	});

	$("#simulate").submit(function(e){

		getResourcesByProjectAvail();
		return false;
	});
				
	configureShowCreateModal = function(){
		$("#resourceDateStartProject").val(getDateToday());
		$("#resourceDateEndProject").val(getDateToday());
		$("#resourceDateEndProject").attr("min", $("#resourceDateStartProject").val());
	}
	
	createProject = function(){
		var settings = {
			method: 'POST',
			url: '/projects/create',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"OperationCenter": $('#projectOperationCenter').val(),
				"WorkOrder": $('#projectWorkOrder').val(),
				"Name": $('#projectName').val(),
				"StartDate": $('#projectStartDate').val(),
				"EndDate": $('#projectEndDate').val(),
				"Enabled": $('#projectActive').is(":checked")
			}
		}
		$.ajax(settings).done(function (response) {
		  validationError(response);
		  reload('/projects', {})
		});
	}
		
	getResourcesByProjectAvail = function(){ 
		dateFrom = $('#projectStartDate').val();
		dateTo = $('#projectEndDate').val();
		skillsActive = $('#skillsActive').is(":checked");
		hoursActive = $('#projectHoursActive').is(":checked");
		hours = $('#projectHours').val();
		numberOfResources = $('#personNumber').val();
		var values = "";
		if ($('#projectTypeSimulator').val() != null) {
			for (i =0; i<$('#projectTypeSimulator').val().length; i++){
				if (values != ""){
					values = values + ",";
				}	
				values = values + $('#projectTypeSimulator').val()[i];
				$('select').material_select();
			}
		}

		var settings = {
			method: 'POST',
		url: '/projects/recommendation',
		headers: {
			'Content-Type': undefined
		},
	  	data : { 
	
				"StartDate": dateFrom,
				"EndDate": dateTo,
				"Types": values,
				"SkillsActive": skillsActive,
				"HoursActive" : hoursActive,
				"Hours": hours,
				"NumberOfResources": numberOfResources,
			}
		}
		$.ajax(settings).done(function (response) {
		  $("#listResourceAble").html(response);		
		});
	}
	
	$('#skillsActive').click(function(){
		$("#projectTypeSimulator").prop('disabled', !this.checked);
		$('select').material_select();
	});
	
	$('#projectHoursActive').click(function(){
		$("#projectHours").prop('disabled', !this.checked);
		$("#projectHours").prop('required', this.checked);
		$("#personNumber").prop('disabled', !this.checked);
		$("#personNumber").prop('required', this.checked);
		$("#projectStartDate").prop('disabled', this.checked);
		$("#projectStartDate").prop('required', this.checked);
		$("#projectEndDate").prop('disabled', this.checked);
		$("#projectEndDate").prop('required', this.checked);

	});
	
</script>
<div class="container">
	<div class="row">
		<div class="col s12 marginCard ">
			<div id="pry_add">
				<h4 id="titlePag"></h4>
				<a id="backButton" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Go To Projects"  ><i class="mdi-navigation-arrow-back large"></i></a>
				<a id="buttonOption" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Save Project"><i class="mdi-action-note-add large"></i></a>
			</div>

			<div class="col s12 m5 l4">
				<div class="card-panel">
					<form id="simulate">
					<div class="row formSimulate">
						<div class="input-field col s12">
						<input id="projectOperationCenter" type="text">
						<label for="projectOperationCenter" class="active">Operation Center </label>
						</div>
					</div>
					<div class="row formSimulate">
						<div class="input-field col s12">
						<input id="projectWorkOrder" type="number">
						<label for="projectWorkOrder" class="active">Work Order</label>
						</div>
					</div>
					<div class="row formSimulate">
						<div class="input-field col s12">
						<input id="projectName" type="text" required="" aria-required="true">
						<label for="projectName" class="active">Name</label>
						</div>
					</div>
					<div class="row formSimulate">
						<div class="input-field col s12">
							<label class="active"> Start Date </label>
							<input type="date" id="projectStartDate" class="datepicker" required>
						</div>
					</div>
					<div class="row formSimulate">
						<div class="input-field col s12">
							<label class="active"> End Date </label> 
							<input type="date" id="projectEndDate" class="datepicker" required>
						
						</div>
					</div>
					
					<div class="row formSimulate">
						<div class="switch" style="text-align: right;">
							Switch time picker:
							<label>
								<input id="projectHoursActive" type="checkbox">
								<span class="lever"></span>
							</label>
						</div>
						<div class="input-field col s12">
							<input id="projectHours" type="number" disabled>
							<label class="active" for="projectHours">Hours</label>
						</div>
					</div>
					<div class="row formSimulate">
						<div class="input-field col s12">
						<input id="personNumber" type="number" disabled>
						<label class="active" for="personNumber">Number of resources</label>
						</div>
					</div>
					<div class="row formSimulate">
						<div class="col s12">
							<div class="switch">
								<div class="input-field"><label class = "active">Active:</label></div>
								<label>
								<input id="projectActive" style="text-align: right;" type="checkbox">
								<span class="lever switch"></span>
								</label>
							</div>
						</div>
					</div>
						
			<div class="row formSimulate" style ="margin-top: 1rem">
				<div class="switch" style="text-align: right;">
					Enable Types
					<label>
						<input id="skillsActive" type="checkbox">
						<span class="lever"></span>
					</label>
				</div>
				<div class="input-field col s12">
					<label for="projectTypeSimulator" class="active">Types</label>
					<select  id="projectTypeSimulator" style="height: 100px;" disabled>
						<option value="" selected disabled>Select Type</option>
						{{range $key, $types := .Types}}
							<option value={{$types.ID}}>{{$types.Name}}</option>
						{{end}}	
					</select>
				</div>

			</div>
			<div class="row formSimulate">
				<div class="input-field col s12">
				<button type="submit" class="btn waves-effect waves-light green">Simulate</button>
				</div>
			</div>
			</form>
		</div>
	</div>

	<div id="listResourceAble" class="col s12 m7 l8"></div>
	</div>

<!--
	<div class="col s12 m12 l12">
			<div id="simulator" class="col s6 m6 l6">
				<div>
					<input type="hidden" id="projectID">
					<div class="col s6 m6 l6" style="padding-bottom: 1%;">
						<div class="col s6">
							<label class="translatable" data-i18n="Operation Center" style="padding:1px"> Operation Center </label>
						</div>
						<div class="col s6">
							<input type="text" id="projectOperationCenter" style="border-radius: 8px;width: -webkit-fill-available;">
						</div>
					</div>
					<div class="col s6 m6 l6" style="padding-bottom: 1%;">
						<div class="cols7 form-group form-group-sm">
							<label class="translatable" data-i18n="Work Order" style="padding:1px"> Work Order </label>
						</div>
						<div class="col-sm-5" style="padding-right:1px;">
							<input type="number" id="projectWorkOrder" style="border-radius: 8px;width: -webkit-fill-available;">
						</div>
					</div>
					<div class="col-sm-12" style="padding-bottom: 1%;">
						<div class="cols7 form-group form-group-sm">
							<label class="translatable" data-i18n="Name" style="padding:1px"> Name </label>
						</div>
						<div class="col-sm-5" style="padding-right:1px;">
							<input type="text" id="projectName" style="border-radius: 8px;width: -webkit-fill-available;">
						</div>
					</div>
					<div class="col-sm-12" style="padding-bottom: 1%;">
						<div class="cols7 form-group form-group-sm">
							<label class="translatable" data-i18n="Start Date" style="padding:1px"> Start Date </label> 
						</div>
						<div class="col-sm-5" style="padding-right:1px;">
							<input type="date" id="projectStartDate" style="inline-size: 174px; border-radius: 8px;width: -webkit-fill-available;">
						</div>
					</div>
					<div class="row-box col-sm-12" style="padding-bottom: 1%;">
						<div class="cols7 form-group form-group-sm">
							<label class="translatable" data-i18n="End Date" style="padding:1px"> End Date </label> 
						</div>
						<div class="col-sm-5" style="padding-right:1px;">
							<input type="date" id="projectEndDate" style="inline-size: 174px; border-radius: 8px;width: -webkit-fill-available;">
						</div>
					</div>
					<div class="col-sm-12" style="padding-bottom: 1%;">
						<div class="col-sm-6 form-group form-group-sm">
							<label class="translatable" data-i18n="Hours" style="padding:1px"> Hours </label>
						</div>
						<div class="col-sm-1" style="padding-right:1px">
							<input type="checkbox" id="projectHoursActive" style="width: -webkit-fill-available;"><br/>
						</div>
						<div class="col-sm-5" style="padding-right:1px;">
							<input type="number" id="projectHours" style="border-radius: 8px;width: -webkit-fill-available;">
						</div>
					</div>					
					<div class="col-sm-12" style="padding-bottom: 1%;">
						<div class="cols7 form-group form-group-sm">
							<label class="translatable" data-i18n="Number of resources" style="padding:1px"> Number of resources </label>
						</div>
						<div class="col-sm-5" style="padding-right:1px;">
							<input type="number" id="personNumber" style="border-radius: 8px;width: -webkit-fill-available;" value="1">
						</div>
					</div>
					<div class="col-sm-12" style="padding-bottom: 1%;">
						<div class="cols7 form-group form-group-sm">
							<label class="translatable" data-i18n="Active" style="padding:1px"> Active </label>  
						</div>
						<div class="col-sm-5" style="padding-right:1px">
							<input type="checkbox" id="projectActive" style="width: -webkit-fill-available;"><br/>
						</div>   
					</div>
					<div class="row-box col-sm-12" style="padding-bottom: 1%;">
						<div id="divProjectType" class="col-sm-6 form-group form-group-sm">
							<label class="translatable"  data-i18n="Types" style="padding:1px"> Types </label> 
						</div>
						<div class="col-sm-1" style="padding-right:1px">
							<input type="checkbox" id="skillsActive" style="width: -webkit-fill-available;"><br/>
						</div>
						<div class="col-sm-5" style="padding-right:1px">
							<select  id="projectTypeSimulator" multiple style="width: -webkit-fill-available; border-radius: 8px;">
								{{range $key, $types := .Types}}
									<option value={{$types.ID}}>{{$types.Name}}</option>
								{{end}}	
							</select>
						</div>    
					</div>
				</div>
				<div style="text-align: center;">
					<button type="button" id="btnSimulate" class="btn btn-default" onclick="getResourcesByProjectAvail();">Simulate</button>
				</div>
			</div>	

			-->	
		 	
