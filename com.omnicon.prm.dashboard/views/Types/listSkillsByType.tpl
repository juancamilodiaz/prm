<script src="/static/js/chartjs/Chart.min.js" > </script>
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
			"lengthMenu": [[8, 16, 32, -1], [8, 16, 32, "All"]],
			"columns":[
				null,
				null,
				{"searchable":false}
			]
		});
		
		$('#titlePag').html("{{.Title}}");
		$('#backButton').css("display", "inline-block");
		$('#backButtonIcon').html("arrow_back");
		$('#backButtonTooltip').html("Back to types");
		$('#backButton').prop('onclick',null).off('click');
		$('#backButton').click(function(){
			reload('/types',{});
		}); 
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/types/skills',{
				"ID": {{.TypeID}},
				"Description": "{{.Title}}"
			});
		});
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOptionIcon').html("add");
		$('#buttonOptionTooltip').html("Add new skill to type");
		$('#buttonOption').attr("onclick", "configureCreateTypeModal();");	
		
		{{if not .TypeSkills}}
			$('#chartjs-wrapper').css("display", "none");
		{{end}}	
		
		var dialogSkillTypes = document.querySelector('#loadSkillModal');
		dialogSkillTypes.querySelector('#cancelSkillDialogButton')
		    .addEventListener('click', function() {
		      dialogSkillTypes.close();	
    	});
		
		var dialogSkillToTypeDelete = document.querySelector('#confirmUnassignModal');
		dialogSkillToTypeDelete.querySelector('#cancelSkillDeleteToTypeDialogButton')
		    .addEventListener('click', function() {
		      dialogSkillToTypeDelete.close();	
    	});
		
	});
	
	configureCreateTypeModal = function(){
		$("#skillToUpdate").val("");
		$("#applyToUpdate").css("display", "none");
		$("#divSkillType").css("display", "inline-block");
		$("#typeValueSkill").val("");
		
		$("#skillId").removeAttr("disabled", "disabled");
				
		$("#modalTitleType").html("Create Skill to Type");
		
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
		
		var dialog = document.querySelector('#loadSkillModal');
		dialog.showModal();
	}
	
	configureUpdateTypeModal = function(pSkillId, pValue){
		$("#divSkillType").css("display", "none");
		$("#applyToUpdate").css("display", "inline-block");
		var skillName = "";
		skillName = pSkillId.split("-")[1];
		$("#skillToUpdate").val(skillName);
		$("#skillIdToUpdate").val(pSkillId);
		$("#skillToUpdate").attr("disabled", "disabled");
		$("#typeValueSkill").val(pValue);
		
		$("#modalTitleType").html("Update Skill to Type");
				
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
		
		var dialog = document.querySelector('#loadSkillModal');
		dialog.showModal();
	}
	
	configureDeleteModal = function(){
		
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
<div class="col-sm-12">
	<div class="col-sm-6">
		<table id="viewSkillsByType" class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp">
			<thead>
				<tr>
					<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Skill</th>
					<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Value</th>
					<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Options</th>
				</tr>
			</thead>
			<tbody>
			 	{{range $key, $typeSkill := .TypeSkills}}
				<tr>
					<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$typeSkill.Name}}</td>
					<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--numeric">{{$typeSkill.Value}}</td>
					<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">
						<button id="editButton{{$typeSkill.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="configureUpdateTypeModal('{{$typeSkill.SkillId}}-{{$typeSkill.Name}}',{{$typeSkill.Value}})" data-dismiss="modal">
							<i class="material-icons" style="vertical-align: inherit;">mode_edit</i>
						</button>
						<div class="mdl-tooltip" for="editButton{{$typeSkill.ID}}">
							Edit skill	
						</div>	
						<button id="deleteButton{{$typeSkill.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="$('#nameDelete').html('{{$typeSkill.Name}}');$('#typeSkillId').val({{$typeSkill.ID}});configureDeleteModal()" data-dismiss="modal">
							<i class="material-icons" style="vertical-align: inherit;">delete</i>
						</button>
						<div class="mdl-tooltip" for="deleteButton{{$typeSkill.ID}}">
							Delete skill	
						</div>	
					</td>
				</tr>
				{{end}}	
			</tbody>
		</table>
	</div>
	<div class="col-sm-6">
		<p>
		   <div class="chart-container" id="chartjs-wrapper">
				<canvas id="chartjs-3" >
				</canvas>
				
				
				<script>new Chart(document.getElementById("chartjs-3"),
					{"type":"radar",
						"data": {
							"labels": {{.SkillsName}},
								"datasets":[
									{"label":"{{.Title}}","data":{{.SkillsValue}},"fill":true,"backgroundColor":"rgba(54, 162, 235, 0.2)","borderColor":"rgb(54, 162, 235)","pointBackgroundColor":"rgb(54, 162, 235)","pointBorderColor":"#fff","pointHoverBackgroundColor":"#fff","pointHoverBorderColor":"rgb(255, 99, 132)"},
								]
							},
						"options": {
							"elements": {
								"line":{"tension":0,"borderWidth":3}
							},
							"scale": {
						        "display": true,
								"ticks": {
									"max": 100,
									"min": 0,
									"beginAtZero":true,
									"stepSize": 20	
								}				
						    },
							legend: {
								display:false
							}
						}
					
					});
				</script>
			</div>
		</p>
	</div>
</div>

<dialog class="mdl-dialog" id="confirmUnassignModal">
	<h4 class="mdl-dialog__title">Unassign Confirmation</h4>
	<div class="mdl-dialog__content">
		<input type="hidden" id="typeSkillId">
		Are you sure that you want to unassign <b id="nameDelete"></b> from Types?
	</div>
	<div class="mdl-dialog__actions">
		<button type="button" id="skillDelete" class="mdl-button" onclick="unassignTypeSkills({{.TypeID}}, $('#typeSkillId').val(), {{.Title}})" data-dismiss="modal">Yes</button>
		<button id="cancelSkillDeleteToTypeDialogButton" type="button" class="mdl-button close" data-dismiss="modal">No</button>
    </div>
</dialog>


<!-- Modal -->
<dialog class="mdl-dialog" id="loadSkillModal">
	<h4 id="modalTitleType" class="mdl-dialog__title"></h4>
	<form id="formCreateUpdate" action="#">
		<div class="mdl-dialog__content">	
			<div id="divSkillType" class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label getmdl-select">
		        <input type="text" value="" class="mdl-textfield__input" id="skillId" readonly>
		        <input type="hidden" value="" name="skillId" required>
		        <i class="mdl-icon-toggle__label material-icons">keyboard_arrow_down</i>
		        <label for="skillId" class="mdl-textfield__label">Skill...</label>
		        <ul id="skillIdList" for="skillId" class="mdl-menu mdl-menu--bottom-left mdl-js-menu">
		        	{{range $key, $skill := .Skills}}
					<li id="{{$skill.ID}}-{{$skill.Name}}" class="mdl-menu__item" data-val="{{$skill.ID}}-{{$skill.Name}}">{{$skill.Name}}</li>
					{{end}}
				</ul>
		    </div>
			<div id="applyToUpdate" class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
			  	<input type="hidden" id="skillIdToUpdate" required>
				<input class="mdl-textfield__input" type="text" id="skillToUpdate" required>
			  	<label class="mdl-textfield__label" for="skillToUpdate">Skill...</label>
			</div>		
			<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
				<input class="mdl-textfield__input" type="text" pattern="(100|([1-9][0-9])|[1-9])" id="typeValueSkill" required>
				<label class="mdl-textfield__label" for="typeValueSkill">Value...</label>
				<span class="mdl-textfield__error">Input is not a number or exceed the limit!</span>
			</div>				
		</div>
		<div class="mdl-dialog__actions">
			<button type="button" id="addSkill" class="mdl-button" onclick="addSkillToType({{.TypeID}},$('#skillId').val(),$('#typeValueSkill').val(), {{.Title}}, $('#skillIdToUpdate').val(), $('#applyToUpdate')[0].style['display'] == 'inline-block')">Set</button>
	      	<button type="button" id="cancelSkillDialogButton" class="mdl-button close" data-dismiss="modal">Cancel</button>
	    </div>  
	</form>
</dialog>