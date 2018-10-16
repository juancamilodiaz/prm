<script src="/static/js/chartjs/Chart.min.js" > </script>
<script>
	$(document).ready(function(){
		$('.modal-trigger').leanModal();
		$('.tooltipped').tooltip();
		$('select').material_select();
		$('#viewSkillsByType').DataTable({
			"iDisplayLength": 20,
			"bLengthChange": false,
			"lengthMenu": [[8, 16, 32, -1], [8, 16, 32, "All"]],
			"columns":[
				null,
				null,
				{"searchable":false}
			]
		});
		
		$('#titlePag').html("{{.Title}}");
		$('#backButton').css("display", "inline-block");
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
		$('#buttonOption').attr("href", "#loadSkillModal");
		$('#buttonOption').attr("onclick", "configureCreateTypeModal();");	
		
		{{if not .TypeSkills}}
			$('#chartjs-wrapper').css("display", "none");
		{{end}}	
		
	});
	
	configureCreateTypeModal = function(){
		$("#skillId").removeAttr("disabled", "disabled");
		$("#skillId option:selected").val("");
		$("#skillId option:selected").text("Please select an option");
		$("#typeValueSkill").val("1");
		
		$("#modalTitleType").html("Create Skill to Type");
	}
	
	configureUpdateTypeModal = function(pSkillId, pValue){
		$("#skillId option:selected").val(pSkillId);
		$("#skillId option:selected").text(pSkillId.split("-")[1]);
		$("#skillId").attr("disabled", "disabled");
		$("#typeValueSkill").val(pValue);
		
		$("#modalTitleType").html("Update Skill to Type");
	}
	
</script>
<div class ="container">
	<div class="row">
		<div class="col s12   marginCard">
			<div id="pry_add">
				<h4 id="titlePag"></h4>
				<a id="backButton" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Back"  ><i class="mdi-navigation-arrow-back large"></i></a>
				<a id="refreshButton" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Refresh"  ><i class="mdi-navigation-refresh large"></i></a>
				<a id="buttonOption" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Create Type"><i class="mdi-action-note-add large"></i></a>
			</div>
		</div>	
		<div class="col s12 m6 l7 ">
			<table id="viewSkillsByType" class="display TableConfig " cellspacing="0" width="100%">
				<thead>
					<tr>
						<th>Skill</th>
						<th>Value</th>
						<th>Options</th>
					</tr>
				</thead>
				<tbody>
					{{range $key, $typeSkill := .TypeSkills}}
					<tr>
						<td>{{$typeSkill.Name}}</td>
						<td>{{$typeSkill.Value}}</td>
						<td>
							<a class='modal-trigger tooltipped' data-position="top" data-tooltip="Update"  href="#loadSkillModal"  onclick="configureUpdateModal({{$typeSkill.SkillId}}-{{$typeSkill.Name}}',{{$typeSkill.Value}}')"><i class="mdi-editor-mode-edit"></i></a>	
							<a class='modal-trigger tooltipped' data-position="top" data-tooltip="Unassign"  href="#confirmUnassignModal"  onclick="$('#nameDelete').html('{{$typeSkill.Name}}');$('#typeSkillId').val({{$typeSkill.ID}});" data-dismiss="modal"><i class="mdi-content-remove-circle"></i></a>	
						</td>
					</tr>
					{{end}}	
				</tbody>
			</table>
		</div>
		<div class="col s12 m6 l4 offset-l1">
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
</div>



<!-- Materialize Modal Unassign -->
<div id="confirmUnassignModal" class="modal" >
			<div class="modal-content">
				<h5  class="modal-title">Unassign Confirmation</h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="typeSkillId">
				Are you sure that you want to unassign <b id="nameDelete"></b> from Types?
				<br>
				<li>The projects will lose this type assignment.</li>
				<li>The skills will lose this type assignment.</li>
				<li>The training and the training's assignations will lose this skill assignment and they will be eliminated.</li>
			</div>
			<div class="modal-footer">
				<a onclick="unassignTypeSkills({{.TypeID}}, $('#typeSkillId').val(), {{.Title}})" class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close" >Yes</a>
        		<a class="btn red white-text waves-effect waves-light btn-flat modal-action modal-close">No</a>
			</div>
</div>

<!-- Modal Unassign close -->

<!-- Materialize Modal Update -->
	<div id="loadSkillModal" class="modal " style = "overflow:visible" >
			<div class="modal-content">
				<h5 id="modalTitleType" class="modal-title"> </h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="typeID">
				<div class="input-field row">	
					<!-- Select -->
					<div class="input-field col s12 m5 l5">
						<label  class= "active">Skill</label>
						<select  id="skillId" style="width: 174px; border-radius: 8px;">
							<option value="">Please select an option</option>
							{{range $key, $skill := .Skills}}
								<option value="{{$skill.ID}}-{{$skill.Name}}">{{$skill.Name}}</option>
							{{end}}
						</select>	
					</div>
					<!-- Close Select -->
					<div class="col s12 m7 l7">
						<input id="typeValueSkill" type="number"  min="1" max="100" value="1" class="validate">
						<label  for="typeName"  class="active">Value</label>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<a id="addSkill" onclick="addSkillToType({{.TypeID}},$('#skillId').val(),$('#typeValueSkill').val(), {{.Title}})" class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close" >Ok</a>
       		 	<a class="btn red white-text waves-effect waves-light btn-flat modal-action modal-close">Cancel</a>
			</div>
	</div>
    
<!-- Modal Update -->

