<option value="">Please select an option</option>
{{range $key, $skill := .Skills}}
	<option value={{$skill.ID}}>{{$skill.Name}}</option>
{{end}}	