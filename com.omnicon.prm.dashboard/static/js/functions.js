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


function addSkillToType(typeId, skillId, value, typeName){
	var settings = {
		method: 'POST',
		url: '/types/setskill',
		headers: {
			'Content-Type': undefined
		},
		data: { 
			"TypeId": typeId,
			"SkillId": skillId.split("-")[0],
			"Name": skillId.split("-")[1],
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