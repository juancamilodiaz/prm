<script>
	$(document).ready(function(){
		$('#viewSettings').DataTable({
			"columns":[
				null,
				null,
				null,
				{"searchable":false}
			]
		});
		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		sendTitle("Settings");
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/settings',{});
		});
		
		$('#buttonOption').css("display", "none");
	});
	
	configureUpdateModal = function(pID, pName, pValue, pType){
		
		if (pType == "string") {
			$("#settingValue").prop('type', 'text');
		} else {
			$("#settingValue").prop('type', 'number');
		}
		
		$("#settingID").val(pID);
		$("#settingName").val(pName);
		$("#settingValue").val(pValue);
		$("#settingType").val(pType);
		
		$("#modalTitle").html("Update Setting");
	}

	updateSetting = function(){
		var settings = {
			method: 'POST',
			url: '/settings/update',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#settingID').val(),
				"Value": $('#settingValue').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/settings', {});
		});
	}
	
	$(document).on('click','#updateSettingClick',function(){
    	$('#settingModal').modal('show');
	});
</script>
<div>
<table id="viewSettings" class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>Name</th>
			<th>Value</th>
			<th>Description</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $setting := .Settings}}
		<tr>
			<td>{{$setting.Name}}</td>
			<td>				
				{{$list := splitEmail $setting.Value}}
				{{$lenlist := len $list}}
				{{if eq $lenlist 1}}
					{{index $list 0}}
				{{else}}
				<ul>
					{{range $key, $element := splitEmail $setting.Value}}
						<li>
						{{$element}}
						</li>
					{{end}}
				</ul>
				{{end}}				
			</td>
			<td>{{$setting.Description}}</td>
			<td>
				{{if eq $setting.Name "ValidEmails"}}
					<span class="glyphicon glyphicon-eye-open" ></span>
				{{else}}
					<a><span id="updateSettingClick" class="glyphicon glyphicon-edit" onclick="configureUpdateModal({{$setting.ID}},'{{$setting.Name}}', '{{$setting.Value}}', '{{$setting.Type}}')"></span></a>
					<!--button class="buttonTable button2" data-toggle="modal" data-target="#settingModal" onclick="configureUpdateModal({{$setting.ID}},'{{$setting.Name}}', '{{$setting.Value}}', '{{$setting.Type}}')" data-dismiss="modal">Update</button-->
				{{end}}
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>

</div>

<!-- Modal -->
<div class="modal fade" id="settingModal" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 id="modalTitle" class="modal-title">Update Setting</h4>
      </div>
      <div class="modal-body">
        <input type="hidden" id="settingID">
		<input type="hidden" id="settingType">
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Name"> Name </label>
              <div class="col-sm-8">
              	<input type="text" id="settingName" style="border-radius: 8px;" disabled>
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Value"> Value </label>
              <div class="col-sm-8">
              	<input type="text" id="settingValue" style="border-radius: 8px;">
        		</div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" id="settingUpdate" class="btn btn-default" onclick="updateSetting()" data-dismiss="modal">Update</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
      </div>
    </div>    
  </div>
</div>