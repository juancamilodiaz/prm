<script>
	$(document).ready(function(){
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-menu'));
		getmdlSelect.init(".getmdl-select");
		
		$('#viewSkillsByType').DataTable({
			"columns":[
				null,
				{"searchable":false}
			]
		});
		$('#refreshButton').css("display", "none");

		$('#titlePag').html("{{.Title}}");
		$('#backButton').css("display", "inline-block");
		$('#backButtonIcon').html("arrow_back");
		$('#backButtonTooltip').html("Back to projects");
		$('#backButton').prop('onclick',null).off('click');
		$('#backButton').click(function(){
			reload('/projects',{});
		});
		
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			getTypesByProject({{.ProjectID}}, '{{.Title}}');
		}); 
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOptionIcon').html("add");
		$('#buttonOptionTooltip').html("Add new type to project");
		$('#buttonOption').prop('onclick',null).off('click');
		$('#buttonOption').attr("onclick","configureAddTypeModal()");
		
		var dialogLoadTypes = document.querySelector('#loadTypesModal');
		dialogLoadTypes.querySelector('#cancelLoadTypesDialogButton')
		    .addEventListener('click', function() {
		      dialogLoadTypes.close();	
    	});
		
		var dialogUnassignTypes = document.querySelector('#confirmUnassignModal');
		dialogUnassignTypes.querySelector('#cancelUnassignDialogButton')
		    .addEventListener('click', function() {
		      dialogUnassignTypes.close();	
    	});
	});
	
	configureAddTypeModal = function(){		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		getmdlSelect.init(".getmdl-select");
		
		var dialog = document.querySelector('#loadTypesModal');
		dialog.showModal();
	}
	
	configureUnassignTypeModal = function(){		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		getmdlSelect.init(".getmdl-select");
		
		var dialog = document.querySelector('#confirmUnassignModal');
		dialog.showModal();
	}
</script>

<table id="viewSkillsByType" class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp">
	<thead>
		<tr>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Type</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $projectType := .ProjectTypes}}
		<tr>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$projectType.Name}}</td>
			<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">
				<button id="deleteButton{{$projectType.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="$('#projectIDToDelete').val({{$projectType.ProjectId}});$('#typeIDToDelete').val({{$projectType.TypeId}});$('#nameDelete').html({{$projectType.Name}});configureUnassignTypeModal();" data-dismiss="modal">
					<i class="material-icons" style="vertical-align: inherit;">delete</i>
				</button>
				<div class="mdl-tooltip" for="deleteButton{{$projectType.ID}}">
					Remove type from project	
				</div>	
			</td>
		</tr>
		{{end}}
	</tbody>
</table>

<dialog class="mdl-dialog" id="loadTypesModal">
	<h4 id="modalResourceProjectTitle" class="mdl-dialog__title">Add Type</h4>
	<div class="mdl-dialog__content">
		<form id="formCreateUpdate" action="#">
			<input type="hidden" id="typeeID">
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label getmdl-select">
		        <input type="text" value="" class="mdl-textfield__input" id="typeID" readonly>
		        <input type="hidden" value="" name="typeID" id="realTypeID">
		        <i class="mdl-icon-toggle__label material-icons">keyboard_arrow_down</i>
		        <label for="typeID" class="mdl-textfield__label">Types...</label>
		        <ul id="typeIDList" for="typeID" class="mdl-menu mdl-menu--bottom-left mdl-js-menu">
		        	{{range $key, $type := .Types}}
					<li id="{{$type.ID}}" class="mdl-menu__item" data-val="{{$type.ID}}">{{$type.Name}}</li>
		        	{{end}}
				</ul>
		    </div>
		</from>
	</div>
	<div class="mdl-dialog__actions">
		<button type="button" id="typeCreate" class="mdl-button" onclick="addTypeToProject({{.ProjectID}}, $('#typeID').val(), {{.Title}})" data-dismiss="modal">Add</button>
      	<button id="cancelLoadTypesDialogButton" type="button" class="mdl-button close" data-dismiss="modal">Cancel</button>
    </div>
</dialog>

<dialog class="mdl-dialog" id="confirmUnassignModal">
	<h4 id="modalResourceProjectTitle" class="mdl-dialog__title">Unassign Confirmation</h4>
	<div class="mdl-dialog__content">
		<input type="hidden" id="projectIDToDelete">
		<input type="hidden" id="typeIDToDelete">        		
		Are you sure that you want to unassign <b id="nameDelete"></b> from <b>{{.Title}}</b> project?	
	</div>
	<div class="mdl-dialog__actions">
		<button type="button" id="resourceUnassign" class="mdl-button" onclick="unassignProjectType($('#projectIDToDelete').val(),$('#typeIDToDelete').val(),{{.Title}})" data-dismiss="modal">Yes</button>
      	<button id="cancelUnassignDialogButton" type="button" class="mdl-button close" data-dismiss="modal">No</button>
    </div>
</dialog>