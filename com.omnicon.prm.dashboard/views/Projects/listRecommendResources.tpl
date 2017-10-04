<script>
	$(document).ready(function(){
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
		var values = "";
		for (i =0; i<$('#projectTypeSimulator').val().length; i++){
			if (values != ""){
				values = values + ",";
			}	
			values = values + $('#projectTypeSimulator').val()[i];
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
			}
		}
		$.ajax(settings).done(function (response) {
		  $("#listResourceAble").html(response);		
		});
	}
</script>
<div class="col-sm-12">
	<div class="col-sm-4">
	</div>
	<div class="col-sm-4" id="simulator" style="margin: 2%;padding: 2%;border-style: outset;border-radius: 8px;">
	    <!-- Modal content-->
	      <div>
	        <input type="hidden" id="projectID">
	        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div class="form-group form-group-sm">
	        		<label class="col-sm-4 translatable" data-i18n="Name" style="padding:1px"> Name </label>
	              <div class="col-sm-8" style="padding-right:1px;">
	              	<input type="text" id="projectName" style="border-radius: 8px;">
	        		</div>
	          </div>
	        </div>
	        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div class="form-group form-group-sm">
	        		<label class="col-sm-4 translatable" data-i18n="Start Date" style="padding:1px"> Start Date </label> 
	              <div class="col-sm-8" style="padding-right:1px;">
	              	<input type="date" id="projectStartDate" style="inline-size: 174px; border-radius: 8px;">
	        		</div>
	          </div>
	        </div>
	        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div class="form-group form-group-sm">
	        		<label class="col-sm-4 translatable" data-i18n="End Date" style="padding:1px"> End Date </label> 
	              <div class="col-sm-8" style="padding-right:1px;">
	              	<input type="date" id="projectEndDate" style="inline-size: 174px; border-radius: 8px;">
	        		</div>
	          </div>
	        </div>
			<div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div id="divProjectType" class="form-group form-group-sm">
	        		<label class="col-sm-4 translatable"  data-i18n="Types" style="padding:1px"> Types </label> 
	             	<div class="col-sm-8" style="padding-right:1px">
		             	<select  id="projectTypeSimulator" multiple style="width: 174px; border-radius: 8px;">
							{{range $key, $types := .Types}}
								<option value={{$types.ID}}>{{$types.ID}} {{$types.Name}}</option>
							{{end}}	
						</select>
	              	</div>    
	          	</div>
	        </div>
	        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div class="form-group form-group-sm">
	        		<label class="col-sm-4 translatable" data-i18n="Active" style="padding:1px"> Active </label> 
	              <div class="col-sm-8" style="padding-right:1px">
	              	<input type="checkbox" id="projectActive"><br/>
	              </div>    
	          </div>
	        </div>
	      </div>
	      <div style="text-align: center;">
	        <button type="button" id="btnSimulate" class="btn btn-default" onclick="getResourcesByProjectAvail();">Simulate</button>
	      </div>
	</div>
	<div class="col-sm-4">
	</div>
</div>
<div id="listResourceAble" class="col-sm-12">
	
</div>