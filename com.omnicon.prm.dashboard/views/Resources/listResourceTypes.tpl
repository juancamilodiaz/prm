<script>
	$(document).ready(function(){
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-menu'));
		getmdlSelect.init(".getmdl-select");
		$('#viewSkillsResourceByType').DataTable({
			"columns":[
				null,
				{"searchable":false}
			]
		});
		$('#refreshButton').css("display", "none");

		$('#titlePag').html("{{.Title}}");
		$('#backButton').css("display", "inline-block");
		$('#backButtonIcon').html("arrow_back");
		$('#backButtonTooltip').html("Back to resources");
		$('#backButton').prop('onclick',null).off('click');
		$('#backButton').click(function(){
			reload('/resources',{});
		});
		
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			getTypesByResource({{.ResourceID}}, '{{.Title}}');
		}); 
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOptionIcon').html("add");
		$('#buttonOptionTooltip').html("Add new type to resource");
		$('#buttonOption').attr("onclick","configureLoadTypesResourceModal()");
		
		var dialogLoadTypesResourceModal = document.querySelector('#loadTypesResourceModal');
		dialogLoadTypesResourceModal.querySelector('#cancelTypeDialogButton')
		    .addEventListener('click', function() {
		      dialogLoadTypesResourceModal.close();	
    	});
		
		var dialogUnassignTypeConfirm = document.querySelector('#confirmUnassignModal');
		dialogUnassignTypeConfirm.querySelector('#cancelUnassignDialogButton')
		    .addEventListener('click', function() {
		      dialogUnassignTypeConfirm.close();	
    	});
	});
	
	configureLoadTypesResourceModal = function(){	
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-menu'));
		getmdlSelect.init(".getmdl-select");	
		var dialog = document.querySelector('#loadTypesResourceModal');
		dialog.showModal();
	}
	
	configureUnassignTypeModal = function(){	
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-menu'));
		getmdlSelect.init(".getmdl-select");	
		var dialog = document.querySelector('#confirmUnassignModal');
		dialog.showModal();
	}
</script>

<table id="viewSkillsResourceByType" class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp">
	<thead>
		<tr>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Type</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $resourceType := .ResourceTypes}}
		<tr>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$resourceType.Name}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">
				<button id="deleteButton" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="$('#resourceIDToDelete').val({{$resourceType.ResourceId}});$('#typeIDToDelete').val({{$resourceType.TypeId}});$('#nameDelete').html({{$resourceType.Name}});configureUnassignTypeModal()">
					<i class="material-icons" style="vertical-align: inherit;">delete</i>
				</button>
				<div class="mdl-tooltip" for="deleteButton">
					Delete type	
				</div>	
			</td>
		</tr>
		{{end}}
	</tbody>
</table>

<dialog class="mdl-dialog" id="loadTypesResourceModal">
	<h4 id="modalTitle" class="mdl-dialog__title">Add Type</h4>
	<!-- Modal content-->
	<div class="mdl-dialog__content">
		<form id="formCreateUpdate" action="#">		
			<input type="hidden" id="typeeID">
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label getmdl-select">
		        <input type="text" value="" class="mdl-textfield__input" id="typeID" readonly>
		        <input type="hidden" value="" name="typeID" required>
		        <i class="mdl-icon-toggle__label material-icons">keyboard_arrow_down</i>
		        <label for="typeID" class="mdl-textfield__label">Types...</label>
		        <ul id="typeIDList" for="typeID" class="mdl-menu mdl-menu--bottom-left mdl-js-menu">
					{{range $key, $type := .Types}}
					<li id="{{$type.ID}}" class="mdl-menu__item" data-val="{{$type.ID}}">{{$type.Name}}</li>
					{{end}}
		        </ul>
		    </div>	
		</form>  
	</div>
	<div class="mdl-dialog__actions">
		<button type="button" id="typeCreate" class="mdl-button" onclick="addTypeToResource({{.ResourceID}}, $('#typeID').val(), {{.Title}})">Add</button>
      	<button type="button" id="cancelTypeDialogButton" class="mdl-button close" data-dismiss="modal">Cancel</button>
    </div>	
</dialog>

<dialog class="mdl-dialog" id="confirmUnassignModal">
	<h4 id="modalTitle" class="mdl-dialog__title">Unassign Confirmation</h4>
	<!-- Modal content-->
	<div class="mdl-dialog__content">    
		<input type="hidden" id="resourceIDToDelete">
		<input type="hidden" id="typeIDToDelete">        		
		Are you sure that you want to unassign <b id="nameDelete"></b> from <b>{{.Title}}</b> resource?
	</div>
	<div class="mdl-dialog__actions">
		<button type="button" id="resourceUnassign" class="mdl-button" onclick="unassignResourceType($('#resourceIDToDelete').val(),$('#typeIDToDelete').val(),{{.Title}})">Yes</button>
      	<button type="button" id="cancelUnassignDialogButton" class="mdl-button close" data-dismiss="modal">No</button>
    </div>	
</dialog>