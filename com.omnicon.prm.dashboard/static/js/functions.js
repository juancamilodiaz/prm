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

function getSkillsByType(TypeId, projectName){
	var settings = {
		method: 'POST',
		url: '/types/skills',
		headers: {
			'Content-Type': undefined
		},
		data: { 
			"ID": TypeId,
			"Description": projectName
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

function unassignProjectType(projectId, typeId){
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
	  $("#content").html(response);
		reload('/projects/types', {
			"ID": projectId
		});
	});
}

function unassignTypeSkills(typeId, typeSkillId){
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
	  $("#content").html(response);
		reload('/types/skills', {
			"ID": typeId
		});
	});
}


function addSkillToType(typeId, skillId){
	var settings = {
		method: 'POST',
		url: '/types/setskill',
		headers: {
			'Content-Type': undefined
		},
		data: { 
			"TypeId": typeId,
			"SkillId": skillId.split("-")[0],
			"Name": skillId.split("-")[1]
		}
	}
	$.ajax(settings).done(function (response) {
		validationError(response);
		reload('/types/skills', {
			"ID": typeId
		});
	});
}

function addTypeToProject(projectId, typeId){
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
			"ID": projectId
		});
	});
}