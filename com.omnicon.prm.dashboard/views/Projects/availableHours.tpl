<thead id="availabilityTableHead">
	<th style="text-align:center;" class="mdl-data-table__cell--non-numeric col-sm-3">Resource Name</th>
	<th style="text-align:center;" class="mdl-data-table__cell--non-numeric col-sm-1">Monday</th>
	<th style="text-align:center;" class="mdl-data-table__cell--non-numeric col-sm-1">Tuesday</th>
	<th style="text-align:center;" class="mdl-data-table__cell--non-numeric col-sm-1">Wednesday</th>
	<th style="text-align:center;" class="mdl-data-table__cell--non-numeric col-sm-1">Thursday</th>
	<th style="text-align:center;" class="mdl-data-table__cell--non-numeric col-sm-1">Friday</th>
</thead>
<tbody id="unassignBody">
	{{$availBreakdown := .AvailBreakdown}}
	{{$dates := .Dates}}
	{{range $index, $resource := .Resources}}
	<tr draggable=false>
		{{range $rID, $mapAvail := $availBreakdown}}
			{{if eq $resource.ID $rID}}
				<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--non-numeric">{{$resource.Name}} {{$resource.LastName}}</td>
				{{range $index, $date := $dates}}
					{{$availDay := index $mapAvail $date}}
					{{if $availDay}}
						<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--numeric">{{$availDay}}</td>
					{{else}}
						<td style="text-align: -webkit-center;vertical-align: inherit;" class="mdl-data-table__cell--numeric"></td>
					{{end}}
				{{end}}
			{{end}}
		{{end}}
	</tr>
	{{end}}
</tbody>