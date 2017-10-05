<option value="">Please select an option</option>
{{range $key, $project := .Projects}}
	<option value={{$project.ID}}>{{$project.Name}}</option>
{{end}}	