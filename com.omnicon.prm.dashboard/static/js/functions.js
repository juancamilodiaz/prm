function getSkills(){
	var settings = {
		method: 'POST',
		url: '/skills',
		headers: {
			'Content-Type': undefined
		},
		data: {
		}
	}
	$.ajax(settings).done(function (response) {
	  $("#content").html(response);
	});
}

function getSkillsByType(TypeId, typeName){
	var settings = {
		method: 'POST',
		url: '/types/skills',
		headers: {
			'Content-Type': undefined
		},
		data: { 
			"ID": TypeId,
			"Name": typeName,
			"Description": typeName
		}
	}
	$.ajax(settings).done(function (response) {
	  $("#content").html(response);
	});
}

function getTypesByProject(projectId, description){
	var settings = {
		method: 'POST',
		url: '/projects/types',
		headers: {
			'Content-Type': undefined
		},
		data: { 
			"ID": projectId,
			"Description": description
		}
	}
	$.ajax(settings).done(function (response) {
	  $("#content").html(response);
	});
}

function unassignProjectType(projectId, typeId, description){
	var settings = {
		method: 'POST',
		url: '/projects/types/unassign',
		headers: {
			'Content-Type': undefined
		},
		data: { 
			"ProjectId": projectId,
			"TypeId": typeId
		}
	}
	$.ajax(settings).done(function (response) {
		validationError(response);
		reload('/projects/types', {
			"ID": projectId,
			"Description": description
		});
	});
}

function unassignTypeSkills(typeId, typeSkillId, description){
	var settings = {
		method: 'POST',
		url: '/types/skills/unassign',
		headers: {
			'Content-Type': undefined
		},
		data: { 
			"ID": typeSkillId
		}
	}
	$.ajax(settings).done(function (response) {
	  	validationError(response);
		reload('/types/skills', {
			"ID": typeId,
			"Description": description
		});
	});
}


function addSkillToType(typeId, skillId, value, typeName, skillIdUpdate, isUpdate){
	
	componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
	componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
	componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
	componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
	componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
	getmdlSelect.init(".getmdl-select");
	
	
	$('#skillIdList').children().each(
		function(param){
			if(this.classList.length >1 && this.classList[1] == "selected"){
				skillId = this.getAttribute("data-val");
			}
		});
	
	var skillIdMain = skillId.split("-")[0];
	var skillIdName = skillId.split("-")[1];
	if (isUpdate){
		skillIdMain = skillIdUpdate.split("-")[0];
		skillIdName = skillIdUpdate.split("-")[1];
	}
	var settings = {
		method: 'POST',
		url: '/types/setskill',
		headers: {
			'Content-Type': undefined
		},
		data: { 
			"TypeId": typeId,
			"SkillId": skillIdMain,
			"Name": skillIdName,
			"Value": value
		}
	}
	$.ajax(settings).done(function (response) {
		validationError(response);
		reload('/types/skills', {
			"ID": typeId,
			"Name": typeName,
			"Description" : typeName
		});
	});
}

function addTypeToProject(projectId, typeId, description){
	
	$('#typeIDList').children().each(
		function(param){
			if(this.classList.length >1 && this.classList[1] == "selected"){
				typeId = this.getAttribute("data-val");
			}
		}
	);
		
	var settings = {
		method: 'POST',
		url: '/projects/settype',
		headers: {
			'Content-Type': undefined
		},
		data: {
			"ProjectId": projectId,
			"TypeId": typeId
		}
	}
	$.ajax(settings).done(function (response) {
		validationError(response);
		reload('/projects/types', {
			"ID": projectId,
			"Description": description
		});
	});
}

function getTypesByResource(resourceId, description){	
	var settings = {
		method: 'POST',
		url: '/resources/types',
		headers: {
			'Content-Type': undefined
		},
		data: { 
			"ID": resourceId,
			"Description": description
		}
	}
	$.ajax(settings).done(function (response) {
	  $("#content").html(response);
	});
}

function unassignResourceType(resourceId, typeId, description){
	var settings = {
		method: 'POST',
		url: '/resources/types/unassign',
		headers: {
			'Content-Type': undefined
		},
		data: { 
			"ResourceId": resourceId,
			"TypeId": typeId
		}
	}
	$.ajax(settings).done(function (response) {
		validationError(response);
		reload('/resources/types', {
			"ID": resourceId,
			"Description": description
		});
	});
}

function addTypeToResource(resourceId, typeId, description){
	$('#typeIDList').children().each(
		function(param){
			if(this.classList.length >1 && this.classList[1] == "selected"){
				typeId = this.getAttribute("data-val");
			}
		}
	);
	var settings = {
		method: 'POST',
		url: '/resources/settype',
		headers: {
			'Content-Type': undefined
		},
		data: {
			"ResourceId": resourceId,
			"TypeId": typeId
		}
	}
	$.ajax(settings).done(function (response) {
		validationError(response);
		reload('/resources/types', {
			"ID": resourceId,
			"Description": description
		});
	});
}