<script>
	$(document).ready(function(){
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-menu'));
		getmdlSelect.init(".getmdl-select");
		
		$('#viewTypes').DataTable({
			"columns":[
				null,
				null,
				{"searchable":false}
			],
			"bInfo": false,
			"bPaginate": false,
        	"bFilter": false
		});
		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		sendTitle("Types");
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/types',{});
		});
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOptionIcon').html("add");
		$('#buttonOptionTooltip').html("Add new type");
		$('#buttonOption').attr("onclick","configureCreateModal()");
		
		$('#typesValue').on('change', function(){
			var row = "";
			var value ="";
			$('#typesValueList').children().each(
				function(param){
					if(this.classList.length >1 && this.classList[1] == "selected"){
						value = this.getAttribute("data-val");
					}
				});
			if (value == ""){
				{{range $key, $types := .Types}}
					row += '<tr>' +
						'<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$types.Name}}</td>' +
						'<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$types.ApplyTo}}</td>' +
						'<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">' +
							'<button id="editButton{{$types.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="'+ "configureUpdateModal({{$types.ID}},'{{$types.Name}}','{{$types.ApplyTo}}')" +'" data-dismiss="modal"><i class="material-icons" style="vertical-align: inherit;">mode_edit</i></button><div class="mdl-tooltip" for="editButton{{$types.ID}}">Edit type</div>' +
							'<button id="deleteButton{{$types.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="'+"configureDeleteModal({{$types.ID}},'{{$types.Name}}')" + '" data-dismiss="modal"><i class="material-icons" style="vertical-align: inherit;">delete</i></button><div class="mdl-tooltip" for="deleteButton{{$types.ID}}">Delete type</div>' +
							'<button id="skillsButton{{$types.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="' + "getSkillsByType({{$types.ID}}, '{{$types.Name}}');" + '" data-dismiss="modal"><i class="material-icons" style="vertical-align: inherit;">trending_up</i></button><div class="mdl-tooltip" for="skillsButton{{$types.ID}}">Type\'s skil</div>' +
						'</td>' +
					'</tr>'	
				{{end}}	
			}else {	
				{{range $key, $types := .Types}}
						if(value == {{$types.ApplyTo}}){
							row += '<tr>' +
								'<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$types.Name}}</td>' +
								'<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$types.ApplyTo}}</td>' +
								'<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">' +
									'<button id="editButton{{$types.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="'+ "configureUpdateModal({{$types.ID}},'{{$types.Name}}','{{$types.ApplyTo}}')" +'" data-dismiss="modal"><i class="material-icons" style="vertical-align: inherit;">mode_edit</i></button><div class="mdl-tooltip" for="editButton{{$types.ID}}">Edit type</div>' +
									'<button id="deleteButton{{$types.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="'+ "configureDeleteModal({{$types.ID}},'{{$types.Name}}')" +'" data-dismiss="modal"><i class="material-icons" style="vertical-align: inherit;">delete</i></button><div class="mdl-tooltip" for="deleteButton{{$types.ID}}">Delete type</div>' +
									'<button id="skillsButton{{$types.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="' + "getSkillsByType({{$types.ID}}, '{{$types.Name}}');" + '" data-dismiss="modal"><i class="material-icons" style="vertical-align: inherit;">trending_up</i></button><div class="mdl-tooltip" for="skillsButton{{$types.ID}}">Type\'s skil</div>' +
								'</td>' +
							'</tr>'	
						}				
						
				{{end}}						
			}
			
			$('#viewTypes tbody').html(row);
			componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
			componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
			componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
			componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
			componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
			componentHandler.upgradeElements(document.getElementsByClassName('mdl-menu'));
			//getmdlSelect.init(".getmdl-select");
		});	
		
		$('#typesValue').trigger('change');
		
		var dialogTypes = document.querySelector('#typeModal');
		dialogTypes.querySelector('#cancelTypeDialogButton')
		    .addEventListener('click', function() {
		      dialogTypes.close();	
    	});
		
		var dialogTypesDelete = document.querySelector('#confirmModal');
		dialogTypesDelete.querySelector('#cancelDeleteTypeDialogButton')
		    .addEventListener('click', function() {
		      dialogTypesDelete.close();	
    	});
	});
	
	configureCreateModal = function(){
		
		$("#typeID").val(null);
		$("#typeName").val(null);
		$("#typesTo").val(null);
		$("#typesTo").attr("disabled", false);
		
		$("#modalTitle").html("Create Type");
		$("#applyToCreate").css("display", "inline-block");
		$("#applyToUpdate").css("display", "none");
		$("#typeUpdate").css("display", "none");
		$("#typeCreate").css("display", "inline-block");
		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		getmdlSelect.init(".getmdl-select");
		
		$('.mdl-textfield>input').each(function(param){
			$(this).parent().addClass('is-invalid');
			$(this).parent().removeClass('is-dirty');
		});
		
		var dialog = document.querySelector('#typeModal');
		dialog.showModal();
	}
	
	configureUpdateModal = function(pID, pName, pTypeTo){
		
		$("#typeID").val(pID);
		$("#typeName").val(pName);
		
		$("#typeToUpdate").val(pTypeTo);		
		$("#typeToUpdate").attr("disabled", "disabled");
		
		
		$("#modalTitle").html("Update Type");
		$("#applyToCreate").css("display", "none");
		$("#applyToUpdate").css("display", "inline-block");
		$("#typeCreate").css("display", "none");
		$("#typeUpdate").css("display", "inline-block");
		
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
		
		var dialog = document.querySelector('#typeModal');
		dialog.showModal();
	}
	
	configureDeleteModal = function(pTypeId, pTypeName){
		$("#nameDelete").html(pTypeName);
		$("#typeID").val(pTypeId);
				
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		getmdlSelect.init(".getmdl-select");
		
		var dialog = document.querySelector('#confirmModal');
		dialog.showModal();
	}

	createType = function(){
		if (document.getElementById("formCreateUpdate").checkValidity() && document.getElementById("formCreate").checkValidity()) {
			var applyTo;
			$('#typesToList').children().each(
				function(param){
					if(this.classList.length >1 && this.classList[1] == "selected"){
						applyTo = this.getAttribute("data-val");
					}
				}
			);
			var settings = {
				method: 'POST',
				url: '/types/create',
				headers: {
					'Content-Type': undefined
				},
				data: { 
					"Name": $('#typeName').val(),
					"ApplyTo": applyTo
				}
			}
			$.ajax(settings).done(function (response) {
				validationError(response);
				reload('/types', {});
			});
		}
	}
	
	updateType = function(){
		if (document.getElementById("formCreateUpdate").checkValidity() && document.getElementById("formUpdate").checkValidity()) {
			var settings = {
				method: 'POST',
				url: '/types/update',
				headers: {
					'Content-Type': undefined
				},
				data: { 
					"ID": $('#typeID').val(),
					"Name": $('#typeName').val(),
					"ApplyTo": $('#typeToUpdate').val()
				}
			}
			$.ajax(settings).done(function (response) {
				validationError(response);
				reload('/types', {});
			});
		}
	}
	
	read = function(){
		var settings = {
			method: 'POST',
			url: '/types/read',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#typeName').val(),
			}
		}
		$.ajax(settings).done(function (response) {
		});
	}
	
	deleteType = function(){
		var settings = {
			method: 'POST',
			url: '/types/delete',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#typeID').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/types', {});
		});
	}
	
</script>
<button class="mdl-button" data-toggle="collapse" data-target="#filters">
	<i class="material-icons">tune</i>
</button>
<div id="filters" class="collapse" style="max-height: 70px;">
  	<div class="row">
      	<div class="col-md-12">
			<div id="divSkillType" class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label getmdl-select">
		        <input type="text" value="" class="mdl-textfield__input" id="typesValue" readonly>
		        <input type="hidden" value="" name="typesValue">
		        <i class="mdl-icon-toggle__label material-icons">keyboard_arrow_down</i>
		        <label for="typesValue" class="mdl-textfield__label">Types to...</label>
		        <ul id="typesValueList" for="typesValue" class="mdl-menu mdl-menu--bottom-left mdl-js-menu">
					<li id="allTypes" class="mdl-menu__item" data-val="" data-selected="true">All types</li>
		        	{{range $index, $applyTo := .ListApplyTo}}
					<li id="{{$applyTo}}" class="mdl-menu__item" data-val="{{$applyTo}}">{{$applyTo}}</li>
					{{end}}
				</ul>
		    </div>
      	</div>
  	</div>
</div>
<div>
<table id="viewTypes" class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp">
	<thead>
		<tr>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Name</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Apply To</th>
			<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Options</th>
		</tr>
	</thead>
	<tbody>
	 		
	</tbody>
</table>

</div>

<!-- Modal -->
<dialog class="mdl-dialog" id="typeModal">
	<h4 id="modalTitle" class="mdl-dialog__title"></h4>
	<div class="mdl-dialog__content">
		<form id="formCreateUpdate" action="#">
			<input type="hidden" id="typeID">
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
			  <input class="mdl-textfield__input" type="text" id="typeName" required>
			  <label class="mdl-textfield__label" for="typeName">Name...</label>
			</div>	
		</form>
		<form id="formCreate" action="#">
			<div id="applyToCreate" class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label getmdl-select">
		        <input type="text" value="" class="mdl-textfield__input" id="typesTo" readonly required>
		        <input type="hidden" value="" name="typesTo" id="realTypesTo">
		        <i class="mdl-icon-toggle__label material-icons">keyboard_arrow_down</i>
		        <label for="typesTo" class="mdl-textfield__label">Apply To...</label>
		        <ul id="typesToList" for="typesTo" class="mdl-menu mdl-menu--bottom-left mdl-js-menu">
		        	{{range $index, $applyTo := .ListApplyTo}}
					<li id="select{{$applyTo}}" class="mdl-menu__item" data-val="{{$applyTo}}">{{$applyTo}}</li>
		        	{{end}}
				</ul>
		    </div>
		</form>
		<form id="formUpdate" action="#">
			<div id="applyToUpdate" class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
			  <input class="mdl-textfield__input" type="text" id="typeToUpdate" required>
			  <label class="mdl-textfield__label" for="typeToUpdate">Apply To...</label>
			</div>	
		</form>
	</div>
	<div class="mdl-dialog__actions">
		<button type="button" id="typeCreate" class="mdl-button" onclick="createType()" data-dismiss="modal">Create</button>
		<button type="button" id="typeUpdate" class="mdl-button" onclick="updateType()" data-dismiss="modal">Update</button>
      	<button id="cancelTypeDialogButton" type="button" class="mdl-button close" data-dismiss="modal">Cancel</button>
    </div>
</dialog>

<dialog class="mdl-dialog" id="confirmModal">
	<h4 class="mdl-dialog__title">Delete Confirmation</h4>
	<div class="mdl-dialog__content">	
		Are you sure you want to remove <b id="nameDelete"></b> from types?
		<br>
		<li>The projects will lose this type assignment.</li>
		<li>The skills will lose this type assignment.</li>
		<li>The training and the training's assignations will lose this skill assignment and they will be eliminated.</li>
	</div>
	<div class="mdl-dialog__actions">
		<button type="button" id="typeDelete" class="mdl-button" onclick="deleteType()" data-dismiss="modal">Yes</button>
		<button id="cancelDeleteTypeDialogButton" type="button" class="mdl-button close" data-dismiss="modal">No</button>
    </div>
</dialog>