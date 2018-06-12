{{range $key, $resource := .Resources}}
	<li id="{{$resource.ID}}" class="mdl-menu__item" data-val="{{$resource.ID}}">{{$resource.Name}} {{$resource.LastName}}</li>
{{end}}	