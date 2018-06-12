<script>
	$(document).ready(function(){
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-menu'));
		getmdlSelect.init(".getmdl-select");
		$('#viewResources').DataTable({
			"columns":[
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				{"searchable":false}
			]
		});
		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		sendTitle("Resources");
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/resources',{});
		});
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOptionIcon').html("add");
		$('#buttonOptionTooltip').html("Add new resource");		
		$('#buttonOption').attr("onclick","configureCreateModal()");
		
		var dialog = document.querySelector('#resourceModal');
		dialog.querySelector('#cancelDialogButton')
		    .addEventListener('click', function() {
		      dialog.close();	
    	});
		
		var dialogConfirm = document.querySelector('#confirmModal');
		dialogConfirm.querySelector('#cancelConfirmButton')
		    .addEventListener('click', function() {
		      dialogConfirm.close();	
    	});
		/*
		$("#resourceEmail").keyup(function(){

	        var email = $("#resourceEmail").val();
	
	        if(email != 0)
	        {
	            if(isValidEmailAddress(email))
	            {
	                $("#resourceEmail").css({
	                    "border-color": "lightgreen"
	                });
	            } else {
	                $("#resourceEmail").css({
	                    "border-color": "crimson"
	                });
	            }
	        } else {
	            $("#resourceEmail").css({
	                "border-color": "crimson"
	            });         
	        }
	
	    });*/
	});

	
	configureCreateModal = function(){
		
		$("#resourceID").val(null);
		$("#resourceName").val(null);
		$("#resourceLastName").val(null);
		$("#resourceEmail").val(null);
		$("#resourceRank").val(null);
		$("#resourceRankLabel").val(null);
		$("#resourceActiveCheckbox").removeClass('is-checked');
		$("#resourceVisaUS").val(null);
		
		$("#modalResourceTitle").html("Create Resource");
		$("#resourceUpdate").css("display", "none");
		$("#resourceCreate").css("display", "inline-block");
		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-selectfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		$('.mdl-textfield>input').each(function(param){
			if($(this)[0].id == "resourceName" || $(this)[0].id == "resourceLastName" || $(this)[0].id == "resourceEmail"){
				$(this).parent().addClass('is-invalid');
			}
			$(this).parent().removeClass('is-dirty');
		});
		var dialog = document.querySelector('#resourceModal');
		dialog.showModal();
	}
	
	configureUpdateModal = function(pID, pName, pLastName, pEmail, pRank, pActive, pVisaUS){
		
		$("#resourceID").val(pID);
		$("#resourceName").val(pName);
		$("#resourceLastName").val(pLastName);
		$("#resourceEmail").val(pEmail);
		var rank = document.getElementById("select"+pRank);
		var att = document.createAttribute("data-selected");
		att.value = "true";
		rank.setAttributeNode(att); 
		//$("#resourceRank").val(pRank);
		//$("#resourceRankLabel").val(pRank);
		if(pActive){
			$("#resourceActive").addClass('is-checked');
			$("#resourceActiveCheckbox").prop('checked', pActive);
		}else{
			$("#resourceActive").removeClass('is-checked');
			$("#resourceActiveCheckbox").prop('checked', pActive);
		}
		$("#resourceVisaUS").val(pVisaUS);
		
		$("#modalResourceTitle").html("Update Resource");
		$("#resourceCreate").css("display", "none");
		$("#resourceUpdate").css("display", "inline-block");
		
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
		
		var dialog = document.querySelector('#resourceModal');
		dialog.showModal();
	}
	
	configureDeleteModal = function(pID, pName, pLastName){
		$("#resourceID").val(pID);
		$("#nameDelete").html(pName + " " + pLastName);
		
		var dialog = document.querySelector('#confirmModal');
		dialog.showModal();
	}

	createResource = function(){
		if (document.getElementById("formCreateUpdate").checkValidity()) {
			var settings = {
				method: 'POST',
				url: '/resources/create',
				headers: {
					'Content-Type': undefined
				},
				data: { 
					"Name": $('#resourceName').val(),
					"LastName": $('#resourceLastName').val(),
					"Email": $('#resourceEmail').val(),
					"Photo": 'test',
					"EngineerRange": $('#resourceRank').val(),
					"Enabled": $('#resourceActiveCheckbox').is(":checked"),
					"VisaUS": $('#resourceVisaUS').val()
				}
			}
			$.ajax(settings).done(function (response) {
				validationError(response);
				reload('/resources', {});
			});
		}
	}
	
	updateResource = function(){
		if (document.getElementById("formCreateUpdate").checkValidity()) {
			var settings = {
				method: 'POST',
				url: '/resources/update',
				headers: {
					'Content-Type': undefined
				},
				data: { 
					"ID": $('#resourceID').val(),
					"Name": $('#resourceName').val(),
					"LastName": $('#resourceLastName').val(),
					"Email": $('#resourceEmail').val(),
					"Photo": 'test',
					"EngineerRange": $('#resourceRank').val(),
					"Enabled": $('#resourceActiveCheckbox').is(":checked"),
					"VisaUS": $('#resourceVisaUS').val()
				}
			}
			$.ajax(settings).done(function (response) {
				validationError(response);
				reload('/resources', {});
			});
		}
	}
	
	read = function(){
		var settings = {
			method: 'POST',
			url: '/resources/read',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#resourceName').val(),
			}
		}
		$.ajax(settings).done(function (response) {
		});
	}
	
	deleteResource = function(){
		var settings = {
			method: 'POST',
			url: '/resources/delete',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#resourceID').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/resources', {});
		});
	}
	
	getSkillsByResource = function(resourceID, resourceName, mapTypesResource){
		var settings = {
			method: 'POST',
			url: '/resources/skills',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": resourceID,
				"ResourceName": resourceName,
				"MapTypesResource" : JSON.stringify(mapTypesResource)
			}
		}
		$.ajax(settings).done(function (response) {
		  $("#content").html(response);
		});
	}
	
	getAssignationsByResource = function(resourceID, resourceName){
		var settings = {
			method: 'POST',
			url: '/projects/resources/assignation',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ResourceId": resourceID,
				"ResourceName": resourceName
			}
		}
		$.ajax(settings).done(function (response) {
		  $("#content").html(response);
		});
	}
		
</script>
<div>
	<table id="viewResources" class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp">
		<thead>
			<tr>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Name</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Last Name</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Profile(s)</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Email</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Engineer Rank</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Visa US</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Enabled</th>
				<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Options</th>
			</tr>
		</thead>
		<tbody>
			{{$typesResource := .TypesResource}}
		 	{{range $key, $resource := .Resources}}
			<tr>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$resource.Name}}</td>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$resource.LastName}}</td>
				<td style="vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">
				{{$mapOfTypes := index $typesResource $resource.ID}}
				<ul style="margin-bottom: auto;">
				{{range $key, $type := $mapOfTypes}}
					<li>{{$type}}</li>
				{{end}}
				</ul>
				</td>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$resource.Email}}</td>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$resource.EngineerRange}}</td>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{if $resource.VisaUS}} {{$resource.VisaUS}} {{end}}</td>
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric"><input type="checkbox" {{if $resource.Enabled}}checked{{end}} class="mdl-checkbox mdl-checkbox__input" disabled></td>
				<td style="vertical-align: inherit;text-align: center;" class="mdl-data-table__cell--non-numeric">
					<button id="editButton{{$resource.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" data-toggle="modal" data-target="#resourceModal" onclick="configureUpdateModal({{$resource.ID}},'{{$resource.Name}}','{{$resource.LastName}}','{{$resource.Email}}','{{$resource.EngineerRange}}',{{$resource.Enabled}},{{$resource.VisaUS}})" data-dismiss="modal">
						<i class="material-icons" style="vertical-align: inherit;">mode_edit</i>
					</button>
					<div class="mdl-tooltip" for="editButton{{$resource.ID}}">
						Edit resource	
					</div>	
					<button id="deleteButton{{$resource.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick='configureDeleteModal("{{$resource.ID}}", "{{$resource.Name}}", "{{$resource.LastName}}")'>
						<i class="material-icons" style="vertical-align: inherit;">delete</i>
					</button>
					<div class="mdl-tooltip" for="deleteButton{{$resource.ID}}">
						Delete resource	
					</div>	
					<button id="skillButton{{$resource.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" ng-click="link('/resources/skills')" onclick="getSkillsByResource({{$resource.ID}}, '{{$resource.Name}}', {{$mapOfTypes}});" data-dismiss="modal">
						<i class="material-icons" style="vertical-align: inherit;">trending_up</i>
					</button>
					<div class="mdl-tooltip" for="skillButton{{$resource.ID}}">
						Resource's skills	
					</div>	
					<button id="asignButton{{$resource.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" ng-click="link('/projects/resources/assignation')" onclick="getAssignationsByResource({{$resource.ID}},'{{$resource.Name}}'+' '+'{{$resource.LastName}}');" data-dismiss="modal">
						<i class="material-icons" style="vertical-align: inherit;">assignment_ind</i>
					</button>
					<div class="mdl-tooltip" for="asignButton{{$resource.ID}}">
						Asign to projects	
					</div>	
					<button id="typeButton{{$resource.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="getTypesByResource({{$resource.ID}}, '{{$resource.Name}}');" data-dismiss="modal">
						<i class="material-icons" style="vertical-align: inherit;">style</i>
					</button>
					<div class="mdl-tooltip" for="typeButton{{$resource.ID}}">
						Resource's types	
					</div>	
				</td>
			</tr>
			{{end}}	
		</tbody>
	</table>
</div>

<!-- Modal -->
<dialog class="mdl-dialog" id="resourceModal">
	<!-- Modal content-->        
    <h4 id="modalResourceTitle" class="mdl-dialog__title"></h4>
	<div class="mdl-dialog__content">
		<form id="formCreateUpdate" action="#">		
		    <input type="hidden" id="resourceID">
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
			  <input class="mdl-textfield__input" type="text" id="resourceName" required>
			  <label class="mdl-textfield__label" for="resourceName">Name...</label>
			</div>	
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
			  <input class="mdl-textfield__input" type="text" id="resourceLastName" required>
			  <label class="mdl-textfield__label" for="resourceLastName">Last Name...</label>
			</div>	
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
				<input class="mdl-textfield__input" type="text" pattern="[a-zA-Z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$" id="resourceEmail" required>
				<label class="mdl-textfield__label" for="resourceEmail">Email...</label>
				<span class="mdl-textfield__error">Input is not a email!</span>
			</div>	
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label getmdl-select">
		        <input type="text" value="" class="mdl-textfield__input" id="resourceRankLabel" readonly>
		        <input type="hidden" value="" name="resourceRankLabel" id="resourceRank">
		        <i class="mdl-icon-toggle__label material-icons">keyboard_arrow_down</i>
		        <label for="resourceRankLabel" class="mdl-textfield__label">Enginer Rank...</label>
		        <ul for="resourceRankLabel" class="mdl-menu mdl-menu--bottom-left mdl-js-menu">
					<li class="mdl-menu__item" data-val="E1" id="selectE1">E1</li>
					<li class="mdl-menu__item" data-val="E2" id="selectE2">E2</li>
					<li class="mdl-menu__item" data-val="E3" id="selectE3">E3</li>
					<li class="mdl-menu__item" data-val="E4" id="selectE4">E4</li>
					<li class="mdl-menu__item" data-val="PM" id="selectPM">PM</li>
		        </ul>
		    </div>
		</form>
		<hr>
		<form action="#">		
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
			  <input class="mdl-textfield__input" type="text" id="resourceVisaUS">
			  <label class="mdl-textfield__label" for="resourceVisaUS">Visa US...</label>
			</div>
		</form>
		<form action="#">						
			<label id="resourceActive" class="mdl-switch mdl-js-switch mdl-js-ripple-effect" for="resourceActiveCheckbox">
			    <input type="checkbox" id="resourceActiveCheckbox" class="mdl-switch__input">
			    <span class="mdl-switch__label">Active</span>
			</label>
		</form>
	</div>
  	<div class="mdl-dialog__actions">
		<button type="button" id="resourceCreate" class="mdl-button" onclick="createResource()" data-dismiss="modal">Create</button>
		<button type="button" id="resourceUpdate" class="mdl-button" onclick="updateResource()" data-dismiss="modal">Update</button>
      	<button id="cancelDialogButton" type="button" class="mdl-button close" data-dismiss="modal">Cancel</button>
    </div>   
</dialog>
<dialog class="mdl-dialog" id="confirmModal">
	<h4 class="mdl-dialog__title">Delete Confirmation</h4>
    <div class="mdl-dialog__content">
		Are you sure you want to remove <b id="nameDelete"></b> from resources?
		<br>
		<li>The projects will lose this resource assignment.</li>
		<li>The skills will lose this resource assignment.</li>
		<li>The trainings will lose this resource assignment.</li>
		<li>The projects will lose this resource assignment as leader.</li>
	</div>
	<div class="mdl-dialog__actions">
		<button type="button" id="resourceDelete" class="mdl-button" onclick="deleteResource()" data-dismiss="modal">Yes</button>
	    <button id="cancelConfirmButton" type="button" class="mdl-button close" data-dismiss="modal">No</button>
    </div> 
</dialog>
