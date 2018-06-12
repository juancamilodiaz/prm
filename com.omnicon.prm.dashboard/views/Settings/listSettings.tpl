<script>
	$(document).ready(function(){
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-menu'));
		getmdlSelect.init(".getmdl-select");
		
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
		
		var dialogSettingConfirm = document.querySelector('#settingModal');
		dialogSettingConfirm.querySelector('#cancelSettingDialogButton')
		    .addEventListener('click', function() {
		      dialogSettingConfirm.close();	
    	});
	});
	
	configureUpdateModal = function(pID, pName, pValue, pType){
		
		$("#settingID").val(pID);
		$("#settingName").val(pName);
		$("#settingValue").val(pValue);
		$("#settingType").val(pType);
		
		$("#modalTitle").html("Update Setting");
		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
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
		
		var dialog = document.querySelector('#settingModal');
		dialog.showModal();
	}

	updateSetting = function(){
		if (document.getElementById("formUpdateSetting").checkValidity()) {
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
	}
</script>
<div>
<table id="viewSettings" class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp">
	<thead>
		<tr>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Name</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Value</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Description</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $setting := .Settings}}
		<tr>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$setting.Name}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">				
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
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$setting.Description}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">
				{{if or (eq $setting.Name "ValidEmails") (eq $setting.Name "SuperUsers") }}
					<i class="material-icons" style="vertical-align: inherit;">visibility</i>
				{{else}}
					<button id="updateSettingClick" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="configureUpdateModal({{$setting.ID}},'{{$setting.Name}}', '{{$setting.Value}}', '{{$setting.Type}}')" data-dismiss="modal">
						<i class="material-icons" style="vertical-align: inherit;">mode_edit</i>
					</button>
					<div class="mdl-tooltip" for="updateSettingClick">
						Edit property	
					</div>	
				{{end}}
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>

</div>

<!-- Modal -->
<dialog class="mdl-dialog" id="settingModal">
	<h4 id="modalTitle" class="mdl-dialog__title">Update Setting</h4>
	<div class="mdl-dialog__content">
		<input type="hidden" id="settingID">
		<input type="hidden" id="settingType">	
		<form id="formUpdateSetting" action="#">			
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
			  <input class="mdl-textfield__input" type="text" id="settingName" disabled required>
			  <label class="mdl-textfield__label" for="settingName">Name...</label>
			</div>	
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
				<input class="mdl-textfield__input" type="text" pattern="(100|([1-9][0-9])|[1-9]|([1-9][0-9].[0-9])|([0-9].[0-9]))" id="settingValue" required>
				<label class="mdl-textfield__label" for="settingValue">Value...</label>
				<span class="mdl-textfield__error">Input is not a number or exceed the limit!</span>
			</div>
		</form>
	</div>
	<div class="mdl-dialog__actions">
		<button type="button" id="settingUpdate" class="mdl-button" onclick="updateSetting()" data-dismiss="modal">Update</button>
      	<button id="cancelSettingDialogButton" type="button" class="mdl-button close" data-dismiss="modal">Cancel</button>
    </div>
</dialog>