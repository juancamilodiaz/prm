{{range $key, $skill := .Skills}}
	<li id="select{{$skill.ID}}" class="mdl-menu__item" data-val="{{$skill.ID}}">{{$skill.Name}}</li>
{{end}}	