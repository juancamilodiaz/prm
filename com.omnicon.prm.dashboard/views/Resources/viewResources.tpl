<script>
	$(document).ready(function(){
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-menu'));
		getmdlSelect.init(".getmdl-select");
	});
</script>
<input type="hidden" id="showResourceID">
{{range $key, $resource := .Resources}}
	<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
		<input class="mdl-textfield__input" type="text" id="showResourceName" value="{{$resource.Name}}" required disabled>
		<label class="mdl-textfield__label" for="showResourceName">Name...</label>
	</div>
	<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
		<input class="mdl-textfield__input" type="text" id="showResourceLastName" value="{{$resource.LastName}}" required disabled>
		<label class="mdl-textfield__label" for="showResourceLastName">Last Name...</label>
	</div>
	<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
		<input class="mdl-textfield__input" type="text" pattern="[a-zA-Z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$" id="showResourceEmail" value="{{$resource.Email}}"  required>
		<label class="mdl-textfield__label" for="showResourceEmail">Email...</label>
		<span class="mdl-textfield__error">Input is not a email!</span>
	</div>
	<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
		<input class="mdl-textfield__input" type="text" id="showResourceRank" value="{{$resource.EngineerRange}}" required disabled>
		<label class="mdl-textfield__label" for="showResourceRank">Enginer Rank...</label>
	</div>
	<label id="showResourceActive" class="mdl-switch mdl-js-switch mdl-js-ripple-effect" for="showResourceActiveCheckbox">
	    <input type="checkbox" id="showResourceActiveCheckbox" class="mdl-switch__input"{{if $resource.Enabled}}checked{{end}} disabled>
	    <span class="mdl-switch__label">Active</span>
	</label>
{{end}}
