<script>
	$(document).ready(function(){
		$("#projectStartDate").val(getDateToday());
		$("#projectEndDate").val(getDateToday());
			
		$('#backButton').css("display", "inline-block");
		$('#backButton').html("Go to projects");
		$('#backButton').prop('onclick',null).off('click');
		$('#backButton').click(function(){
			reload('/projects',{});
		}); 
		$('#titlePag').html("Simulator");
		$('#datePicker').css("display", "none");
		$('#refreshButton').css("display", "none");
				
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOption').html("Save Project");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("onclick","createProject();");
		
		
		var prjStartDate = formatDate({{.StartDate}});
		var prjEndDate = formatDate({{.EndDate}});
		$('#dates').text("Date From: "+ prjStartDate + "  -  Date To: " + prjEndDate);
		
		$('#skillsActive').prop('checked', false);
		$('#projectTypeSimulator').prop('disabled', true);
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
		var values = "";
		if ($('#projectTypeSimulator').val() != null) {
			for (i =0; i<$('#projectTypeSimulator').val().length; i++){
				if (values != ""){
					values = values + ",";
				}	
				values = values + $('#projectTypeSimulator').val()[i];
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
			}
		}
		$.ajax(settings).done(function (response) {
		  $("#listResourceAble").html(response);		
		});
	}
	
	$('#skillsActive').click(function(){
		$("#projectTypeSimulator").prop('disabled', !this.checked);
	});
	

</script>
<div class="col-sm-12" style="padding: unset;">
	<div class="col-sm-4" style="padding: unset;">
		<div class="col-sm-12" id="simulator" style="margin: 2%;padding: 2%;border-style: outset;border-radius: 8px;">
		    <!-- Modal content-->
		      <div>
		        <input type="hidden" id="projectID">
		        <div class="col-sm-12" style="padding-bottom: 1%;">
		        	<div class="col-sm-7 form-group form-group-sm">
		        		<label class="translatable" data-i18n="Operation Center" style="padding:1px"> Operation Center </label>
		          	</div>
					<div class="col-sm-5" style="padding-right:1px;">
	              		<input type="text" id="projectOperationCenter" style="border-radius: 8px;width: -webkit-fill-available;">
	        		</div>
		        </div>
		        <div class="col-sm-12" style="padding-bottom: 1%;">
		        	<div class="col-sm-7 form-group form-group-sm">
		        		<label class="translatable" data-i18n="Work Order" style="padding:1px"> Work Order </label>
		          	</div>
					<div class="col-sm-5" style="padding-right:1px;">
	              		<input type="number" id="projectWorkOrder" style="border-radius: 8px;width: -webkit-fill-available;">
	        		</div>
		        </div>
		        <div class="col-sm-12" style="padding-bottom: 1%;">
		        	<div class="col-sm-7 form-group form-group-sm">
		        		<label class="translatable" data-i18n="Name" style="padding:1px"> Name </label>
		          	</div>
					<div class="col-sm-5" style="padding-right:1px;">
	              		<input type="text" id="projectName" style="border-radius: 8px;width: -webkit-fill-available;">
	        		</div>
		        </div>
		        <div class="col-sm-12" style="padding-bottom: 1%;">
		        	<div class="col-sm-7 form-group form-group-sm">
	        			<label class="translatable" data-i18n="Start Date" style="padding:1px"> Start Date </label> 
		          	</div>
					<div class="col-sm-5" style="padding-right:1px;">
	              		<input type="date" id="projectStartDate" style="inline-size: 174px; border-radius: 8px;width: -webkit-fill-available;">
	        		</div>
		        </div>
		        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
		        	<div class="col-sm-7 form-group form-group-sm">
		        		<label class="translatable" data-i18n="End Date" style="padding:1px"> End Date </label> 
		          	</div>
					<div class="col-sm-5" style="padding-right:1px;">
	              		<input type="date" id="projectEndDate" style="inline-size: 174px; border-radius: 8px;width: -webkit-fill-available;">
	        		</div>
		        </div>
				<div class="col-sm-12" style="padding-bottom: 1%;">
		        	<div class="col-sm-7 form-group form-group-sm">
		        		<label class="translatable" data-i18n="Active" style="padding:1px"> Active </label>  
		          	</div>
					<div class="col-sm-5" style="padding-right:1px">
		              	<input type="checkbox" id="projectActive" style="width: -webkit-fill-available;"><br/>
		            </div>   
		        </div>
				<div class="row-box col-sm-12" style="padding-bottom: 1%;">
		        	<div class="col-sm-7 form-group form-group-sm">
		        		<label class="translatable" data-i18n="Enable skill filter" style="padding:1px">Enable skill filter</label> 
  		          	</div>
					<div class="col-sm-5" style="padding-right:1px">
	              		<input type="checkbox" id="skillsActive" style="width: -webkit-fill-available;"><br/>
	              	</div>  
		        </div>
				<div class="row-box col-sm-12" style="padding-bottom: 1%;">
		        	<div id="divProjectType" class="col-sm-7 form-group form-group-sm">
		        		<label class="translatable"  data-i18n="Types" style="padding:1px"> Types </label> 
		          	</div>
					<div class="col-sm-5" style="padding-right:1px">
		             	<select  id="projectTypeSimulator" multiple style="width: 135px; border-radius: 8px;">
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
	</div>
	<div id="listResourceAble" class="col-sm-8">
		
	</div>
</div>