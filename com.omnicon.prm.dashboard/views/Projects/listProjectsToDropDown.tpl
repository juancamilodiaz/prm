{{range $key, $project := .Projects}}
	<li id="{{$project.ID}}" class="mdl-menu__item" data-val="{{$project.ID}}">{{$project.Name}}</li>
{{end}}	