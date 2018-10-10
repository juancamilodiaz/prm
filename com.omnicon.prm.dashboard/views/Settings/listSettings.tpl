<script>
	$(document).ready(function(){
		$('.tooltipped').tooltip();
		$('.modal-trigger').leanModal();
		$('#viewSettings').DataTable({		
			"iDisplayLength": 20,
			"bLengthChange": false,
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
<div class="container">
	<h5>Settings</h5>
	<table id="viewSettings" class="display" cellspacing="0" width="100%" >
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
					{{if or (eq $setting.Name "ValidEmails") (eq $setting.Name "SuperUsers") }}
						<i class="mdi-image-remove-red-eye"></i>
					{{else}}
						<a class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit"  href="#settingModal" onclick="configureUpdateModal({{$setting.ID}},'{{$setting.Name}}', '{{$setting.Value}}', '{{$setting.Type}}')"><i class="mdi-editor-mode-edit small"></i></a>					
					{{end}}
				</td>
			</tr>
			{{end}}	
		</tbody>
	</table>
</div>

<!-- Modal -->
<div class="modal" id="settingModal">
    <div class="modal-content">        
        <h5>Assign dates to the resource</h5>  
        <input type="hidden" id="settingID">
		<input type="hidden" id="settingType">
		
		<div class="input-field col s12">
			<label class="active"> Name </label>              
			<input type="text" id="settingName" disabled class="validate">
		</div>
		<div class="input-field col s12">
			<label class="active"> Value </label>             
			<input type="text" id="settingValue" class="validate">
		</div>        
    </div>
    <div class="modal-footer">
	  	<a id="settingUpdate"  class="btn waves-effect waves-light green modal-action modal-close" onclick="updateSetting()">Update</a>
       	<a class="btn waves-effect waves-light red modal-action modal-close">Cancel</a>
    </div>


</div>